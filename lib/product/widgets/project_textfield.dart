import 'package:flutter/material.dart';

final class ProjectTextField extends StatelessWidget {
  const ProjectTextField({
    required this.controller,
    this.focusNode,
    super.key,
    this.hintText,
    this.labelText,
    this.helperText,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction = TextInputAction.next,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final bool obscureText;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      keyboardType: keyboardType,
      onChanged: onChanged,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      textInputAction: textInputAction,
      style: Theme.of(context).inputDecorationTheme.suffixStyle,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
