// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:avo_ai_diet/product/constants/enum/app_radius.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// TODO:clean textfield
class ProjectTextField extends StatelessWidget {
  const ProjectTextField({
    required this.controller,
    required this.focusNode,
    super.key,
    this.hintText,
    this.labelText,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? hintText;
  final String? labelText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: TextStyle(
        fontSize: 16.sp,
        color: ProjectColors.forestGreen,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 16.sp,
        ),
        hintStyle: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 16.sp,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: AppRadius.circularSmall(),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.circularSmall(),
          borderSide: const BorderSide(
            color: ProjectColors.grey200,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.circularSmall(),
          borderSide: const BorderSide(
            color: ProjectColors.forestGreen,
            width: 1.5,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 16.h,
        ),
      ),
    );
  }
}
