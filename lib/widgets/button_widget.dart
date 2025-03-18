import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  const ButtonWidget({
    super.key,
    required this.type,
    required this.text,
    required this.onPressed,
    this.style,
  });

  final String type;
  final Text text;
  final Function() onPressed;
  final ButtonStyle? style;

  @override
  State<StatefulWidget> createState() => _ButtonWidget();
}

class _ButtonWidget extends State<ButtonWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.type == 'Outlined')
        ? OutlinedButton(
            onPressed: widget.onPressed,
            style: widget.style,
            child: widget.text,
          )
        : (widget.type == 'Elevated')
            ? ElevatedButton(
                onPressed: widget.onPressed,
                style: widget.style,
                child: widget.text,
              )
            : TextButton(
                onPressed: widget.onPressed,
                style: widget.style,
                child: widget.text,
              );
  }
}
