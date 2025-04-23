import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:organ/config/color_constants.dart';
import 'package:organ/controller/base/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

//프로그램 화면
class ProgramScreen extends StatefulWidget {
  const ProgramScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProgramState();
}

class _ProgramState extends State<ProgramScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> preparingList = [];
  List<dynamic> completedList = [];
  bool isLoading = true;
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeData();
  }

  Future<void> _initializeData() async {
    await getUserId();
    await fetchProgramList();
    await fetchAppliedProgramList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getUserId() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0;
  }

  // 프로그램 리스트 데이터 불러오기
  Future<void> fetchProgramList() async {
    setState(() => isLoading = true);
    try {
      Controller(
        modelName: 'OrganProgram',
        modelId: 'organ_program',
      ).findAll({}).then((res) {
        res['result']['rows'].forEach((element) {
          setState(() {
            preparingList.add(element);
          });
        });
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('데이터 로딩 중 오류가 발생했습니다')));
    }
    if (!mounted) return;
    setState(() => isLoading = false);
  }

  // 신청한 프로그램 리스트 데이터 불러오기
  Future<void> fetchAppliedProgramList() async {
    print(userId);
    setState(() => isLoading = true);
    try {
      Controller(
        modelName: 'OrganProgramApplication',
        modelId: 'organ_program_application',
      ).findAll({'APP_MEMBER_ORGAN_IDENTIFICATION_CODE': userId}).then((res) {
        print(res);
        res['result']['rows'].forEach((element) {
          setState(() {
            completedList.add(element);
          });
        });
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('데이터 로딩 중 오류가 발생했습니다')));
    }
    if (!mounted) return;
    setState(() => isLoading = false);
  }

  Future<void> applyProgram(String programId) async {
    try {
      await Controller(
        modelName: 'OrganProgramApplication',
        modelId: 'organ_program_application',
      ).create({
        'ORGAN_PROGRAM_IDENTIFICATION_CODE': programId,
        'APP_MEMBER_ORGAN_IDENTIFICATION_CODE': userId,
      });

      // 신청한 프로그램 목록만 새로고침
      await fetchAppliedProgramList();

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('프로그램 신청 완료')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('프로그램 신청 중 오류가 발생했습니다')));
    }
  }

  // 프로그램 신청 확인 모달
  void _showApplyConfirmationDialog(String programId, String programName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('프로그램 신청'),
          content: Text('$programName 프로그램을 신청하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                applyProgram(programId);
              },
              child: const Text('신청하기'),
            ),
          ],
        );
      },
    );
  }

  // 프로그램 상세 모달
  void _showProgramDetailModal(Map<String, dynamic> program) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '프로그램 상세',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorConstants.btnPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        program['OrganProgramCategory']['CATEGORY_NAME'],
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorConstants.btnPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      program['PROGRAM_NAME'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '프로그램 소개',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      program['INTRODUCE'] ?? '소개글이 없습니다.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '진행기간',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${program['START_DATE'].toString().substring(0, 10)} ~ ${program['END_DATE'].toString().substring(0, 10)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    if (program['IMAGE'] != null) ...[
                      const SizedBox(height: 16),
                      Image.network(
                        jsonDecode(program['IMAGE'])[0],
                        fit: BoxFit.cover,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
                  '신청가능한 프로그램',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  '신청한 프로그램',
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
            '신청가능한 프로그램이 없습니다',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: preparingList.length,
          itemBuilder: (context, index) {
            final item = preparingList[index];
            final isApplied = completedList.any(
              (completed) =>
                  completed['ORGAN_PROGRAM_IDENTIFICATION_CODE'] ==
                  item['ORGAN_PROGRAM_IDENTIFICATION_CODE'],
            );

            return GestureDetector(
              onTap: () {
                _showProgramDetailModal(item);
              },
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
                              '${item['OrganProgramCategory']['CATEGORY_NAME']}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${item['PROGRAM_NAME']}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '${item['START_DATE'].toString().substring(0, 10)} ~ ${item['END_DATE'].toString().substring(0, 10)}',
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
                                isApplied
                                    ? () => {}
                                    : () => _showApplyConfirmationDialog(
                                      item['ORGAN_PROGRAM_IDENTIFICATION_CODE']
                                          .toString(),
                                      item['PROGRAM_NAME'],
                                    ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isApplied
                                      ? Colors.grey
                                      : ColorConstants.btnPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              isApplied ? '신청완료' : '신청하기',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
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
        ? const Center(
          child: Text(
            '신청한 프로그램이 없습니다',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: completedList.length,
          itemBuilder: (context, index) {
            final item = completedList[index];
            return GestureDetector(
              onTap: () {
                _showProgramDetailModal(item['OrganProgram']);
              },
              child: Card(
                color: Colors.white,
                margin: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item['OrganProgram']['OrganProgramCategory']['CATEGORY_NAME']}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${item['OrganProgram']['PROGRAM_NAME']}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '${item['OrganProgram']['START_DATE'].toString().substring(0, 10)} ~ ${item['OrganProgram']['END_DATE'].toString().substring(0, 10)}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '신청일: ${item['CREATED_AT'].toString().substring(0, 10)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
  }
}
