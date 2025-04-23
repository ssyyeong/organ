import 'package:flutter/material.dart';
import 'package:organ/config/color_constants.dart';
import 'package:organ/widgets/full_width_btn.dart';
import 'package:organ/widgets/text_form_field_widget.dart';
import 'package:organ/controller/custom/controller_custom.dart';
import 'package:shared_preferences/shared_preferences.dart';

//로그인 메인 화면
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();
  late String _id = '', _password = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> login() async {
    await ControllerCustom(
      modelName: 'AppMemberOrgan',
      modelId: 'app_member_organ',
    ).signIn({'ID': _id, 'PASSWORD': _password}).then((res) async {
      if (!mounted) return;
      if (res['result'] == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('아이디 또는 비밀번호가 틀렸습니다.')));
      } else {
        if (res['result']['user']['CREATED_AT'] ==
            res['result']['user']['UPDATED_AT']) {
          if (!mounted) return;
          Navigator.pushNamed(context, '/changePassword');
        } else {
          SharedPreferences prefs;
          prefs = await SharedPreferences.getInstance();
          await prefs.setInt(
            'userId',
            res['result']['user']['APP_MEMBER_ORGAN_IDENTIFICATION_CODE'],
          );
          if (!mounted) return;
          Navigator.pushNamed(context, '/home');
        }
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 200),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 120,
                      width: 120,
                    ),
                    const SizedBox(height: 30),
                    Form(
                      key: _key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //이메일 입력 폼
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: TextFormFieldWidget(
                              type: 'id',
                              onSaved: (id) => _id = id as String,
                            ),
                          ),
                          //비밀번호 입력 폼
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 15),
                            child: TextFormFieldWidget(
                              type: 'password',
                              onSaved:
                                  (password) => _password = password as String,
                            ),
                          ),
                          FullWidthBtn(
                            type: 'Elevated',
                            title: const Text(
                              '로그인',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            margin: EdgeInsets.zero,
                            color: ColorConstants.btnPrimary,
                            onPressed:
                                () => {
                                  //유효성 검사
                                  if (_key.currentState!.validate())
                                    {_key.currentState!.save(), login()},
                                },
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
      ),
    );
  }
}
