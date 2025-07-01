import 'package:flutter/material.dart';
import 'package:avo_ai_diet/feature/chat/cubit/chat_cubit.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/utility/init/service_locator.dart';
import 'package:avo_ai_diet/feature/chat/view/chat_view.dart'; // ChatView burada tanımlı olmalı

mixin ChatViewMixin on State<ChatView> {
  final List<ChatMessage> messages = [];
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late ChatCubit chatCubit;

  @override
  void initState() {
    super.initState();
    chatCubit = getIt<ChatCubit>();
    messages.add(
      const ChatMessage(
        text: ProjectStrings.avoHowCanIHelpText,
        isMe: false,
      ),
    );
    chatCubit.initialize(ProjectStrings.avoHowCanIHelpText);
  }

  Future<void> handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    textController.clear();
    setState(() {
      messages
        ..add(ChatMessage(text: text, isMe: true))
        ..add(const ChatMessage(text: '', isMe: false, isLoading: true));
    });
    scrollToBottom();

    try {
      await chatCubit.chatWithAi(text);
      setState(() {
        messages
          ..removeWhere((msg) => msg.isLoading)
          ..add(ChatMessage(text: chatCubit.state.response!, isMe: false));
      });
    } catch (e) {
      setState(() {
        messages
          ..removeWhere((msg) => msg.isLoading)
          ..add(ChatMessage(text: 'Üzgünüm bir hata oluştu: $e', isMe: false));
      });
    }
    scrollToBottom();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
