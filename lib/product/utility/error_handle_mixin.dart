import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/utility/exceptions/gemini_exception.dart';
import 'package:avo_ai_diet/product/widgets/project_toast_message.dart';
import 'package:flutter/material.dart';

// Error Handler Mixin for AI-related errors
mixin AiErrorHandlerMixin {
  void handleAiError(BuildContext context, Exception exception) {
    if (exception is GeminiException) {
      _showSmartToast(context, exception.message);
    } else {
      ProjectToastMessage.show(
        context,
        'Beklenmedik bir hata oluştu. Lütfen tekrar deneyin.',
        seconds: 3,
        backGroundColor: ProjectColors.accentCoral,
      );
    }
  }

  void _showSmartToast(BuildContext context, String message) {
    final lowerMessage = message.toLowerCase();

    // Internet error
    if (lowerMessage.contains('internet') || lowerMessage.contains('bağlantı')) {
      ProjectToastMessage.show(
        context,
        message,
        seconds: 4,
        backGroundColor: ProjectColors.accentCoral,
      );
      return;
    }

    // Quota/Limit error
    if (lowerMessage.contains('limit') || lowerMessage.contains('kapasite') || lowerMessage.contains('aşıldı')) {
      ProjectToastMessage.show(
        context,
        message,
        seconds: 5,
        backGroundColor: ProjectColors.sandyBrown,
      );
      return;
    }

    // Service unavailable
    if (lowerMessage.contains('geçici') || lowerMessage.contains('kullanılamıyor')) {
      ProjectToastMessage.show(
        context,
        message,
        seconds: 4,
        backGroundColor: ProjectColors.grey600,
      );
      return;
    }

    // Default error
    ProjectToastMessage.show(
      context,
      message,
      seconds: 4,
      backGroundColor: ProjectColors.accentCoral,
    );
  }

  void showAiSuccessToast(BuildContext context, String message) {
    ProjectToastMessage.show(
      context,
      message,
      backGroundColor: ProjectColors.greenRYB,
    );
  }
}
