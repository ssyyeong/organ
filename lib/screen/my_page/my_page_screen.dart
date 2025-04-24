import 'package:flutter/material.dart';
import 'package:organ/config/color_constants.dart';
import 'package:organ/controller/base/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

//마이페이지 화면
class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MyPageState();
}

class _MyPageState extends State<MyPageScreen> {
  Map<String, dynamic>? businessInfo;

  @override
  void initState() {
    super.initState();
    fetchMyPageData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 매칭 리스트 데이터 불러오기
  Future<void> fetchMyPageData() async {
    try {
      SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('userId') ?? 0;

      Controller(
        modelName: 'OrganBusiness',
        modelId: 'organ_business',
      ).findAll({'APP_MEMBER_ORGAN_IDENTIFICATION_CODE': userId}).then((res) {
        if (res['result']['rows'].isNotEmpty) {
          setState(() {
            businessInfo = res['result']['rows'][0];
          });
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('데이터 로딩 중 오류가 발생했습니다')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: ColorConstants.bgWhite,
        appBar: AppBar(
          title: const Text(
            '마이페이지',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 프로필 섹션
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '기업 정보',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (businessInfo != null) ...[
                      _buildInfoItem('기업명', businessInfo!['COMPANY_NAME']),
                      _buildInfoItem(
                        '대표자',
                        businessInfo!['REPRESENTATIVE_NAME'],
                      ),
                      _buildInfoItem('휴대전화', businessInfo!['PHONE_NUMBER']),
                      _buildInfoItem('이메일', businessInfo!['EMAIL']),
                    ] else
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
              // 구분선 추가
              Container(height: 8, color: ColorConstants.bgWhite),
              // 사업 정보 섹션
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '사업 정보',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (businessInfo != null) ...[
                      _buildInfoItem(
                        '사업 아이템',
                        businessInfo!['BUSINESS_ITEM_INTRODUCTION'],
                      ),
                      _buildInfoItem(
                        '법인설립여부',
                        businessInfo!['IS_CORPORATION'] == 'Y' ? '설립' : '미설립',
                      ),
                      _buildInfoItem(
                        '설립연도/월',
                        businessInfo!['FORMATION_DATE'] != null
                            ? businessInfo!['FORMATION_DATE']
                                .toString()
                                .substring(0, 10)
                            : '-',
                      ),
                      _buildInfoItem(
                        '직전년도 매출액',
                        businessInfo!['PREVIOUS_YEAR_SALES_AMOUNT'],
                      ),
                    ] else
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Color(0xFF666666)),
          ),
          Flexible(
            child: Text(
              value ?? '-',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
