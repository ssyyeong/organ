import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:organ/config/color_constants.dart';
import 'package:organ/controller/base/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

//미팅일지 화면
class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MeetingState();
}

class _MeetingState extends State<MeetingScreen> {
  List<dynamic> meetingList = [];
  int userId = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await getUserId();
    await fetchMeetingList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getUserId() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0;
  }

  // 미팅일지 리스트 데이터 불러오기
  Future<void> fetchMeetingList() async {
    setState(() => isLoading = true);
    try {
      Controller(
        modelName: 'OrganMeeting',
        modelId: 'organ_meeting',
      ).findAll({}).then((res) {
        setState(() {
          meetingList = res['result']['rows'];
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

  // 미팅일지 상세 모달 표시
  void _showMeetingDetailModal(Map<String, dynamic> meeting) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '미팅일지 상세',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF666666)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailItem(
                          '미팅일시',
                          meeting['MEETING_DATE']?.toString().substring(
                                0,
                                10,
                              ) ??
                              '',
                        ),
                        _buildDetailItem(
                          '담당자',
                          meeting['RESPONSIBLE_PERSON'] ?? '',
                        ),
                        _buildDetailItem(
                          '사업화단계',
                          meeting['BUSINESS_PHASE'] ?? '',
                        ),
                        _buildDetailItem(
                          '미팅내용',
                          meeting['MEETING_CONTENT'] ?? '',
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '진단 항목 점수',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildDiagnosticScoreItem(
                                '팀구성 및 역량',
                                int.tryParse(
                                      meeting['DIAGNOSTIC_ITEM_SCORE1']
                                              ?.toString() ??
                                          '0',
                                    ) ??
                                    0,
                              ),
                              _buildDiagnosticScoreItem(
                                '수요 및 시장이해',
                                int.tryParse(
                                      meeting['DIAGNOSTIC_ITEM_SCORE2']
                                              ?.toString() ??
                                          '0',
                                    ) ??
                                    0,
                              ),
                              _buildDiagnosticScoreItem(
                                '사업모델',
                                int.tryParse(
                                      meeting['DIAGNOSTIC_ITEM_SCORE3']
                                              ?.toString() ??
                                          '0',
                                    ) ??
                                    0,
                              ),
                              _buildDiagnosticScoreItem(
                                '판매/영업채널',
                                int.tryParse(
                                      meeting['DIAGNOSTIC_ITEM_SCORE4']
                                              ?.toString() ??
                                          '0',
                                    ) ??
                                    0,
                              ),
                              _buildDiagnosticScoreItem(
                                '재무계획',
                                int.tryParse(
                                      meeting['DIAGNOSTIC_ITEM_SCORE5']
                                              ?.toString() ??
                                          '0',
                                    ) ??
                                    0,
                              ),
                              _buildDiagnosticScoreItem(
                                '성장전략',
                                int.tryParse(
                                      meeting['DIAGNOSTIC_ITEM_SCORE6']
                                              ?.toString() ??
                                          '0',
                                    ) ??
                                    0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticScoreItem(String title, int score) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
          Row(
            children: [
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const Text(
                ' / 10',
                style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
              ),
            ],
          ),
        ],
      ),
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
          title: const Text(
            '미팅일지',
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : meetingList.isEmpty
                ? const Center(
                  child: Text(
                    '등록된 미팅일지가 없습니다',
                    style: TextStyle(color: Color(0xFF999999), fontSize: 16),
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: meetingList.length,
                  itemBuilder: (context, index) {
                    final item = meetingList[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Color(0xFFEEEEEE),
                          width: 1,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => _showMeetingDetailModal(item),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Color(0xFF666666),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${item['MEETING_DATE'].toString().substring(0, 10)} 미팅일지',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF333333),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.chevron_right,
                                color: Color(0xFF999999),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
