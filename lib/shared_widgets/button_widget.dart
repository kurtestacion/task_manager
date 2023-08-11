import 'package:flutter/material.dart';

class StretchableButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const StretchableButton(
      {Key? key, required this.text, required this.onPressed, this.color})
      : super(key: key);

  @override
  _StretchableButtonState createState() => _StretchableButtonState();
}

class _StretchableButtonState extends State<StretchableButton> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ButtonTheme(
        minWidth: double.infinity,
        child: ElevatedButton(
          style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
            padding: const EdgeInsets.all(0.0),
          ),
          onPressed: widget.onPressed,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.blue.shade400, Colors.blue.shade700]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              constraints: const BoxConstraints(minHeight: 50.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.text,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20
                    // color: cpGreyDarkColor,
                    ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
