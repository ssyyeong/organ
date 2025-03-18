import 'package:organ/config/color_constants.dart';
import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    required this.type,
    required this.onSaved,
    this.hintText,
    this.password,
  });

  final String type;
  final String? hintText;
  final FormFieldSetter? onSaved;
  final String? password; //비밀번호 재입력시 확인 용도

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'id':
        return idInput();
      case 'email':
        return emailInput();
      case 'password':
        return passwordInput();
      case 'rePassword':
        return rePasswordInput();
      case 'nickName':
        return nickNameInput();
      default:
        return Container();
    }
  }

  Widget idInput() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (val) {
        if (val!.isEmpty) {
          return '아이디를 입력해주세요.';
        } else if (!RegExp(r"^[a-zA-Z0-9]+$").hasMatch(val)) {
          return '아이디 형식이 올바르지 않습니다.';
        } else {
          return null;
        }
      },
      onSaved: onSaved,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 15,
        ),
        hintText: hintText ?? '아이디를 입력해주세요.',
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ColorConstants.textGray,
        ),
        filled: true,
        fillColor: ColorConstants.lightGray,
      ),
    );
  }

  Widget emailInput() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (val) {
        if (val!.isEmpty) {
          return '이메일을 입력해주세요.';
        } else if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ).hasMatch(val)) {
          return '이메일 형식이 올바르지 않습니다.';
        } else {
          return null;
        }
      },
      onSaved: onSaved,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 15,
        ),
        hintText: hintText ?? '이메일을 입력해주세요.',
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ColorConstants.textGray,
        ),
        filled: true,
        fillColor: ColorConstants.lightGray,
      ),
    );
  }

  Widget passwordInput() {
    return TextFormField(
      obscureText: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (val) {
        if (val!.isEmpty) {
          return '비밀번호를 입력해주세요.(영문, 숫자 포함 8~12자)';
        } else if (!RegExp(
          r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%&*+-/=?^_`{|}~]*$',
        ).hasMatch(val)) {
          return '비밀번호는 영문과 숫자를 모두 포함해야 합니다.';
        } else if (val.length < 8 || val.length > 12) {
          return '비밀번호 길이가 맞지 않습니다.';
        } else {
          return null;
        }
      },
      onSaved: onSaved,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 15,
        ),
        hintText: '비밀번호를 입력해주세요.(영문, 숫자 포함 8~12자)',
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ColorConstants.textGray,
        ),
        filled: true,
        fillColor: ColorConstants.lightGray,
      ),
    );
  }

  Widget rePasswordInput() {
    return TextFormField(
      obscureText: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (val) {
        if (val!.isEmpty) {
          return '비밀번호를 입력해주세요.';
        } else {
          return null;
        }
      },
      onSaved: onSaved,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 15,
        ),
        hintText: '비밀번호를 재입력해주세요.',
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ColorConstants.textGray,
        ),
        filled: true,
        fillColor: ColorConstants.lightGray,
      ),
    );
  }

  Widget nickNameInput() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (val) {
        if (val!.isEmpty) {
          return '닉네임을 입력해주세요.';
        } else {
          return null;
        }
      },
      onSaved: onSaved,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 15,
        ),
        hintText: '닉네임을 입력해주세요.',
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ColorConstants.textGray,
        ),
        filled: true,
        fillColor: ColorConstants.lightGray,
      ),
    );
  }
}
