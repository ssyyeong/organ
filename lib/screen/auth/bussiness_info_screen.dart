import 'dart:io';

import 'package:flutter/material.dart';
import 'package:organ/config/color_constants.dart';
import 'package:organ/controller/custom/controller_custom.dart';
import 'package:organ/widgets/full_width_btn.dart';
import 'package:organ/widgets/text_field_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class BussinessInfoScreen extends StatefulWidget {
  const BussinessInfoScreen({super.key});

  @override
  State<BussinessInfoScreen> createState() => _BussinessInfoScreenState();
}

class _BussinessInfoScreenState extends State<BussinessInfoScreen> {
  String companyName = '';
  String representativeName = '';
  String phoneNumber = '';
  String email = '';
  String introduction = '';
  bool isCorporation = false;
  DateTime? formationDate;
  String? salesAmount;
  XFile? irDeckFile;
  String? emailError;

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void save() async {
    if (companyName == '' ||
        representativeName == '' ||
        phoneNumber == '' ||
        email == '' ||
        introduction == '' ||
        salesAmount == '' ||
        irDeckFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('필수 항목을 입력해주세요.')));
      return;
    }

    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;

    File file = File(irDeckFile?.path ?? '');
    await ControllerCustom(
          modelName: 'OrganBusiness',
          modelId: 'organ_business',
        )
        .irFileUpload({
          'APP_MEMBER_ORGAN_IDENTIFICATION_CODE': userId,
          'COMPANY_NAME': companyName,
          'REPRESENTATIVE_NAME': representativeName,
          'PHONE_NUMBER': phoneNumber,
          'EMAIL': email,
          'BUSINESS_ITEM_INTRODUCTION': introduction,
          'IS_CORPORATION': isCorporation ? 'Y' : 'N',
          'FORMATION_DATE':
              formationDate != null
                  ? '${formationDate?.year}-${formationDate?.month.toString().padLeft(2, '0')}-${formationDate?.day.toString().padLeft(2, '0')}'
                  : null,
          'PREVIOUS_YEAR_SALES_AMOUNT': salesAmount,
        }, file)
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
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('기업명'),
                        Text(' *', style: TextStyle(color: Colors.red)),
                      ],
                    ),
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
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('대표자'),
                        Text(' *', style: TextStyle(color: Colors.red)),
                      ],
                    ),
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
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('대표자 휴대전화번호 ( - 없이 입력)'),
                        Text(' *', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      hintText: '대표자 휴대전화번호를 입력해주세요.',
                      onChanged: (text) => phoneNumber = text,
                      textType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('대표자 이메일'),
                        Text(' *', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      hintText: '대표자 이메일을 입력해주세요.',
                      onChanged: (text) {
                        setState(() {
                          email = text;
                          if (text.isNotEmpty && !isValidEmail(text)) {
                            emailError = '올바른 이메일 형식을 입력해주세요.';
                          } else {
                            emailError = null;
                          }
                        });
                      },
                      errorText: emailError,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('주력 사업 아이템 소개'),
                        Text(' *', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      hintText: '예) 온라인 메신저 플랫폼',
                      onChanged: (text) => introduction = text,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('법인설립여부'),
                        Text(' *', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    SizedBox(height: 10),
                    ToggleButtons(
                      isSelected: [isCorporation, !isCorporation],
                      onPressed: (index) {
                        setState(() {
                          isCorporation = index == 0;
                        });
                      },
                      color: Colors.black54,
                      selectedColor: Colors.white,
                      fillColor: ColorConstants.btnPrimary,
                      borderColor: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                      constraints: const BoxConstraints(
                        minHeight: 40,
                        minWidth: 100,
                      ),
                      children: [Text('설립'), Text('미설립')],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('설립연도/월'),
                    SizedBox(height: 10),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: formationDate ?? DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            formationDate = selectedDate;
                          });
                        }
                      },
                      child: Text(
                        formationDate != null
                            ? '${formationDate?.year}-${formationDate?.month.toString().padLeft(2, '0')}-${formationDate?.day.toString().padLeft(2, '0')}'
                            : '날짜를 선택해주세요',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('직전년도 매출액'),
                        Text(' *', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    SizedBox(height: 10),
                    DropdownButton(
                      dropdownColor: Colors.white,
                      items: [
                        DropdownMenuItem(
                          value: '5천만원 이하',
                          child: Text('5천만원 이하'),
                        ),
                        DropdownMenuItem(
                          value: '5천만원~1억원',
                          child: Text('5천만원~1억원'),
                        ),
                        DropdownMenuItem(
                          value: '1억원~5억원',
                          child: Text('1억원~5억원'),
                        ),
                        DropdownMenuItem(
                          value: '5억원 이상',
                          child: Text('5억원 이상'),
                        ),
                      ],
                      value: salesAmount,
                      onChanged: (value) {
                        setState(() {
                          salesAmount = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('IR DECK 파일'),
                        Text(' *', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            irDeckFile?.name ?? '파일을 선택해주세요',
                            style: TextStyle(
                              color:
                                  irDeckFile == null
                                      ? Colors.grey
                                      : Colors.black,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                  type: FileType.any,
                                  allowMultiple: false,
                                  dialogTitle: '파일 선택',
                                  lockParentWindow: true,
                                );

                            if (result != null) {
                              setState(() {
                                irDeckFile = XFile(
                                  result.files.first.path ?? '',
                                );
                              });
                            }
                          },
                          child: Text('파일 선택'),
                        ),
                      ],
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
