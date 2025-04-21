import 'package:flutter/material.dart';
import 'package:organ/config/color_constants.dart';
import 'package:organ/controller/base/controller.dart';
import 'package:organ/widgets/full_width_btn.dart';
import 'package:organ/widgets/text_field_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BussinessInfoScreen extends StatefulWidget {
  const BussinessInfoScreen({super.key});

  @override
  State<BussinessInfoScreen> createState() => _BussinessInfoScreenState();
}

class _BussinessInfoScreenState extends State<BussinessInfoScreen> {
  late String companyName = '',
      representativeName = '',
      phoneNumber = '',
      email = '',
      introduction = '';

  void save() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;

    await Controller(modelName: 'OrganBusiness', modelId: 'organ_business')
        .create({
          'APP_MEMBER_ORGAN_IDENTIFICATION_CODE': userId,
          'COMPANY_NAME': companyName,
          'REPRESENTATIVE_NAME': representativeName,
          'PHONE_NUMBER': phoneNumber,
          'EMAIL': email,
          'BUSINESS_ITEM_INTRODUCTION': introduction,
        })
        .then((res) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('저장 완료')));
          Navigator.pushNamed(context, '/home');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text(
                '기업 정보 입력하기',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('기업명'),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      hintText: '기업명을 입력해주세요.',
                      onChanged: (text) => companyName = text,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text('대표자'),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      hintText: '대표자 이름을 입력해주세요.',
                      onChanged: (text) => representativeName = text,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('대표자 휴대전화번호 ( - 없이 입력)'),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      hintText: '대표자 휴대전화번호를 입력해주세요.',
                      onChanged: (text) => phoneNumber = text,
                      textType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('대표자 이메일'),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      hintText: '대표자 이메일을 입력해주세요.',
                      onChanged: (text) => email = text,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('주력 사업 아이템 소개'),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      hintText: '예) 온라인 메신저 플랫폼',
                      onChanged: (text) => introduction = text,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              FullWidthBtn(
                type: 'Elevated',
                title: const Text(
                  '저장',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                margin: EdgeInsets.zero,
                color: ColorConstants.btnPrimary,
                onPressed: () {
                  save();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
