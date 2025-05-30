import 'package:avo_ai_diet/feature/chat/cubit/chat_cubit.dart';
import 'package:avo_ai_diet/feature/chat/state/chat_state.dart';
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

final class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatCubit _chatCubit;

  @override
  void initState() {
    super.initState();
    _chatCubit = getIt<ChatCubit>();
    // for starting message
    _messages.add(
      const _ChatMessage(
        text: ProjectStrings.avoHowCanIHelpText,
        isMe: false,
      ),
    );
    _chatCubit.initialize(ProjectStrings.avoHowCanIHelpText);
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    _textController.clear();
    setState(() {
      _messages
        ..add(_ChatMessage(text: text, isMe: true))
        ..add(const _ChatMessage(text: '', isMe: false, isLoading: true));
    });
    _scrollToBottom();

    try {
      await _chatCubit.chatWithAi(text);

      setState(() {
        _messages
          ..removeWhere((msg) => msg.isLoading)
          ..add(_ChatMessage(text: _chatCubit.state.response!, isMe: false));
      });
    } catch (e) {
      setState(() {
        _messages
          ..removeWhere((msg) => msg.isLoading)
          ..add(_ChatMessage(text: 'Üzgünüm bir hata oluştu: $e', isMe: false));
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        scrolledUnderElevation: 10,
        title: Row(
          children: [
            const Icon(Icons.eco, color: ProjectColors.darkGreen),
            const SizedBox(width: 8),
            Text(
              ProjectStrings.askToAvo,
              style: context.textTheme().titleLarge?.copyWith(
                    color: ProjectColors.darkGreen,
                  ),
            ),
          ],
        ),
        elevation: 1,
      ),
      body: BlocProvider(
        create: (context) => getIt<ChatCubit>(),
        child: BlocConsumer<ChatCubit, ChatState>(
          listener: (context, state) {
            if (state.response != null) {
              setState(() {
                _messages.add(_ChatMessage(text: state.response!, isMe: false));
              });
              _scrollToBottom();
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        itemCount: _messages.length,
                        cacheExtent: 500,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              if (index > 0) SizedBox(height: 10.h),
                              _messages[index],
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Container(
                  decoration: const BoxDecoration(
                    color: ProjectColors.white,
                  ),
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
              controller: _textController,
              onSubmitted: _handleSubmitted,
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
              onPressed: () => _handleSubmitted(_textController.text.trim()),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage extends StatelessWidget {
  const _ChatMessage({
    required this.text,
    required this.isMe,
    this.isLoading = false,
  });

  final String text;
  final bool isMe;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final favoritesCubit = context.read<FavoritesCubit>();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: const CircleAvatar(
                backgroundColor: ProjectColors.darkGreen,
                child: Icon(
                  Icons.eco,
                  color: ProjectColors.white,
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? ProjectColors.darkGreen : ProjectColors.white,
                borderRadius: AppRadius.circularSmall(),
                boxShadow: [
                  BoxShadow(
                    color: ProjectColors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    Lottie.asset(
                      JsonName.writing.path,
                      height: 35.h,
                      width: 35.w,
                    )
                  else
                    MarkdownBody(
                      data: text,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: isMe ? ProjectColors.white : ProjectColors.black,
                        ),
                        strong: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMe ? ProjectColors.white : ProjectColors.black,
                        ),
                        em: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: isMe ? ProjectColors.white : ProjectColors.black,
                        ),
                        listBullet: TextStyle(
                          color: isMe ? ProjectColors.white : ProjectColors.black,
                        ),
                      ),
                      selectable: true,
                    ),
                  if (!isLoading && !isMe) ...[
                    const SizedBox(height: 4),
                    BlocBuilder<FavoritesCubit, FavoritesState>(
                      builder: (context, state) {
                        final messageId = text.hashCode.toString();
                        final isFavorited = state.favorites?.any(
                              (favorite) => favorite.messageId == messageId,
                            ) ??
                            false;

                        return SizedBox(
                          height: 20,
                          width: 20,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              final now = DateTime.now();
                              final model = FavoriteMessageModel(
                                text,
                                DateFormat('d MMMM yyyy', 'tr_TR').format(now),
                                messageId,
                              );
                              favoritesCubit.toogleFavorite(model);
                            },
                            icon: Icon(
                              isFavorited ? Icons.favorite : Icons.favorite_border,
                              color: isFavorited ? ProjectColors.red : ProjectColors.grey,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
