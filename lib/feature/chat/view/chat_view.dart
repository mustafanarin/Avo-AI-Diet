import 'package:avo_ai_diet/feature/chat/cubit/chat_cubit.dart';
import 'package:avo_ai_diet/feature/chat/state/chat_state.dart';
import 'package:avo_ai_diet/feature/chat/view/mixin/chat_view_mixin.dart';
import 'package:avo_ai_diet/feature/favorites/cubit/favorites_cubit.dart';
import 'package:avo_ai_diet/feature/favorites/state/favorites_state.dart';
import 'package:avo_ai_diet/product/cache/model/favorite_message/favorite_message_model.dart';
import 'package:avo_ai_diet/product/constants/enum/general/json_name.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_padding.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_radius.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/utility/extensions/json_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:avo_ai_diet/product/utility/init/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

part './widgets/app_bar.dart';
part './widgets/chat_message.dart';

final class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with ChatViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const _CustomAppbar(),
      body: BlocProvider(
        create: (context) => getIt<ChatCubit>(),
        child: BlocConsumer<ChatCubit, ChatState>(
          listener: (context, state) {
            if (state.response != null) {
              setState(() {
                messages.add(ChatMessage(text: state.response!, isMe: false));
              });
              scrollToBottom();
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
                        controller: scrollController,
                        itemCount: messages.length,
                        cacheExtent: 500,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              if (index > 0) SizedBox(height: 10.h),
                              messages[index],
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Container(
                  decoration: const BoxDecoration(color: ProjectColors.white),
                  child: _buildTextComposer(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: ProjectColors.grey200,
        borderRadius: AppRadius.circularMedium(),
      ),
      margin: AppPadding.smallAll(),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: textController,
              onSubmitted: handleSubmitted,
              maxLength: 150,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: ProjectStrings.writeMessage,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8),
                counterText: '',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: IconButton(
              icon: const Icon(Icons.send),
              color: ProjectColors.darkGreen,
              onPressed: () => handleSubmitted(textController.text.trim()),
            ),
          ),
        ],
      ),
    );
  }
}
