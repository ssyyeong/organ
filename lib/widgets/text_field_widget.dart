import 'package:organ/config/color_constants.dart';
import 'package:flutter/material.dart';

//텍스트 필드 위젯
class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.hintText, //textField 입력 전에 나오는 text
    required this.onChanged, //textField 입력 시 실행되는 함수
    this.hintColor,
    this.controller, //textField 입력 시 text를 저장하는 변수
    this.textType, // 키보드 입력 타입
    this.obscureText, //textField 입력 시 text를 숨길지 말지 결정하는 변수(password 입력 시 사용)
    this.isReadOnly,
  });

  final String hintText;
  final Color? hintColor;
  final Function(String text)? onChanged;
  final TextEditingController? controller;
  final TextInputType? textType;
  final bool? obscureText;
  final bool? isReadOnly;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: textType ?? TextInputType.text,
      onChanged: onChanged,
      obscureText: obscureText ?? false,
      readOnly: isReadOnly ?? false,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: hintColor ?? ColorConstants.textGray,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: ColorConstants.lightGray,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 15,
        ),
      ),
    );
  }
}
