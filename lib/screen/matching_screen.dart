import 'package:flutter/material.dart';
import 'package:organ/config/color_constants.dart';
import 'package:organ/controller/base/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

//매칭 화면
class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MatchingState();
}

class _MatchingState extends State<MatchingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> preparingList = [];
  List<dynamic> completedList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchMatchingList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 매칭 리스트 데이터 불러오기
  Future<void> fetchMatchingList() async {
    setState(() => isLoading = true);
    try {
      // API 호출 예시 (실제 API에 맞게 수정 필요)
      SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('userId') ?? 0;

      Controller(
        modelName: 'OrganMatching',
        modelId: 'organ_matching',
      ).findAll({'APP_MEMBER_ORGAN_IDENTIFICATION_CODE': userId}).then((res) {
        res['result']['rows'].forEach((element) {
          if (element['ACCEPT_YN'] == 'ACCEPT') {
            setState(() {
              completedList.add(element);
            });
          } else {
            setState(() {
              preparingList.add(element);
            });
          }
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('데이터 로딩 중 오류가 발생했습니다')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> acceptMatching(String matchingId) async {
    try {
      await Controller(
        modelName: 'OrganMatching',
        modelId: 'organ_matching',
      ).update({
        'ORGAN_MATCHING_IDENTIFICATION_CODE': matchingId,
        'ACCEPT_YN': 'ACCEPT',
      });

      setState(() {
        // 수락된 항목을 preparingList에서 찾아서 completedList로 이동
        final item = preparingList.firstWhere(
          (element) =>
              element['ORGAN_MATCHING_IDENTIFICATION_CODE'].toString() ==
              matchingId,
        );
        preparingList.remove(item);
        completedList.add(item);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('매칭 수락 완료')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('매칭 수락 중 오류가 발생했습니다')));
      // 오류 발생 시 전체 리스트 다시 불러오기
      fetchMatchingList();
    }
  }

  Future<void> rejectMatching(String matchingId) async {
    try {
      await Controller(
        modelName: 'OrganMatching',
        modelId: 'organ_matching',
      ).delete({'ORGAN_MATCHING_IDENTIFICATION_CODE': matchingId});

      setState(() {
        // 거절된 항목을 preparingList에서 제거
        preparingList.removeWhere(
          (element) =>
              element['ORGAN_MATCHING_IDENTIFICATION_CODE'].toString() ==
              matchingId,
        );
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('매칭 거절 완료')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('매칭 거절 중 오류가 발생했습니다')));
      // 오류 발생 시 전체 리스트 다시 불러오기
      fetchMatchingList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: ColorConstants.bgWhite,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                child: Text(
                  '매칭준비',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  '매칭완료',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            labelColor: ColorConstants.btnPrimary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: ColorConstants.btnPrimary,
            indicatorWeight: 3,
          ),
        ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                  controller: _tabController,
                  children: [_buildPreparingList(), _buildCompletedList()],
                ),
      ),
    );
  }

  Widget _buildPreparingList() {
    return preparingList.isEmpty
        ? const Center(
          child: Text(
            '매칭 준비중인 항목이 없습니다',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: preparingList.length,
          itemBuilder: (context, index) {
            final item = preparingList[index];
            return GestureDetector(
              onTap: () => _showDetailDialog(item),
              child: Card(
                color: Colors.white,
                margin: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item['COMPANY_NAME']}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '대표자: ${item['REPRESENTATIVE_NAME']}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed:
                                () => acceptMatching(
                                  item['ORGAN_MATCHING_IDENTIFICATION_CODE']
                                      .toString(),
                                ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.btnPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              '수락',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed:
                                () => rejectMatching(
                                  item['ORGAN_MATCHING_IDENTIFICATION_CODE']
                                      .toString(),
                                ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              '거절',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
  }

  Widget _buildCompletedList() {
    return completedList.isEmpty
        ? const Center(child: Text('매칭 완료된 항목이 없습니다'))
        : ListView.builder(
          itemCount: completedList.length,
          itemBuilder: (context, index) {
            final item = completedList[index];
            return GestureDetector(
              onTap: () => _showDetailDialog(item),
              child: Card(
                color: Colors.white,
                margin: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item['COMPANY_NAME']}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '대표자: ${item['REPRESENTATIVE_NAME']}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
  }

  void _showDetailDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${item['COMPANY_NAME']}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '한줄 소개',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${item['INTRODUCE'] ?? "소개글이 없습니다"}',
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    '닫기',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
