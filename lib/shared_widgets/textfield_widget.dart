import 'package:flutter/material.dart';

Widget textFieldShared(
    {String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextEditingController? ctrler,
    bool? readOnly = false,
    GestureTapCallback? onTap,
    bool? isFloatingLabel = true,
    BoxConstraints? constraints,
    bool? isObscureText = false,
    bool? hasBottompadding = true,
    Color? fillColor,
    TextInputType? textInputAction,
    Function(String)? onChanged}) {
  return Padding(
    padding: EdgeInsets.only(bottom: hasBottompadding == true ? 10.0 : 0.0),
    child: TextFormField(
      onChanged: onChanged,
      textAlignVertical: TextAlignVertical.center,
      readOnly: readOnly == true,
      obscureText: isObscureText == true,
      controller: ctrler,
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      keyboardType: textInputAction ?? TextInputType.text,
      decoration: InputDecoration(
        constraints: constraints,
        isDense: true,
        isCollapsed: true,
        floatingLabelBehavior: isFloatingLabel == true
            ? FloatingLabelBehavior.always
            : FloatingLabelBehavior.never,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: Padding(
          padding: const EdgeInsets.all(0.0),
          child: suffixIcon,
        ),
        fillColor: fillColor,
        filled: fillColor != null,
      ),
    ),
  );
}
