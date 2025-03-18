import 'package:organ/widgets/button_widget.dart';
import 'package:flutter/material.dart';

//full width 버튼 위젯
class FullWidthBtn extends StatelessWidget {
  const FullWidthBtn({
    super.key,
    required this.type, //버튼 타입
    required this.title, //버튼 title
    required this.onPressed, //버튼 클릭 시 실행 함수
    this.padding, //버튼 container padding
    this.margin, //버튼 container margin
    this.btnPadding, //버튼 padding
    this.color, //버튼 색상
    this.border, //버튼 테두리값
  });

  final String type;
  final Text title;
  final Function()? onPressed;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final EdgeInsets? btnPadding;
  final Color? color;
  final double? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      margin: margin ?? const EdgeInsets.only(bottom: 24),
      child: ButtonWidget(
        type: type,
        text: title,
        onPressed: () => onPressed!(),
        style: styleFrom(),
      ),
    );
  }

  ButtonStyle styleFrom() {
    if (type == 'O') {
      return OutlinedButton.styleFrom(
        elevation: 0,
        padding: btnPadding ?? const EdgeInsets.symmetric(vertical: 19),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(border ?? 10),
        ),
        backgroundColor: color ?? Colors.white,
      );
    } else if (type == 'E') {
      return ElevatedButton.styleFrom(
        elevation: 0,
        padding: btnPadding ?? const EdgeInsets.symmetric(vertical: 19),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(border ?? 10),
        ),
        backgroundColor: color ?? Colors.white,
      );
    } else {
      return TextButton.styleFrom(
        elevation: 0,
        padding: btnPadding ?? const EdgeInsets.symmetric(vertical: 19),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(border ?? 10),
        ),
        backgroundColor: color ?? Colors.white,
      );
    }
  }
}
