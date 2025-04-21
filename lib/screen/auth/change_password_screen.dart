import 'package:flutter/material.dart';
import 'package:organ/config/color_constants.dart';
import 'package:organ/controller/base/controller.dart';
import 'package:organ/widgets/full_width_btn.dart';
import 'package:organ/widgets/text_form_field_widget.dart';

//비밀번호 변경 화면
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordScreen> {
  final _key = GlobalKey<FormState>();
  late String _password = '', _passwordCheck = '';

  @override
  void initState() {
    super.initState();
  }

  void changePassword() async {
    await Controller(
      modelName: 'AppMemberOrgan',
      modelId: 'app_member_organ',
    ).update({'PASSWORD': _password}).then((res) {
      if (res['result'] == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('비밀번호 변경 실패')));
      } else {
        Navigator.pushNamed(context, '/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) {
          //다른 곳을 터치하면 키보드가 사라지게 하기 위한 코드
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            //키보드가 올라와도 화면을 가리지 않게 하기 위한 코드
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SafeArea(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height, // 화면 전체 높이
                  child: Center(
                    // Center 위젯 추가
                    child: Form(
                      key: _key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //비밀번호 입력 폼
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: TextFormFieldWidget(
                              type: 'password',
                              onSaved:
                                  (password) => _password = password as String,
                            ),
                          ),
                          //비밀번호 재입력 폼
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 15),
                            child: TextFormFieldWidget(
                              type: 'rePassword',
                              onSaved:
                                  (password) =>
                                      _passwordCheck = password as String,
                            ),
                          ),
                          FullWidthBtn(
                            type: 'Elevated',
                            title: const Text(
                              '비밀번호 변경',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            margin: EdgeInsets.zero,
                            color: ColorConstants.btnPrimary,
                            onPressed: () {
                              //유효성 검사
                              if (_key.currentState!.validate()) {
                                _key.currentState!.save();
                                changePassword();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
