import 'dart:math';

import 'package:collection/collection.dart';
import 'package:eocout_flutter/bloc/chat/chat_bloc.dart';
import 'package:eocout_flutter/bloc/chat/detail_chat_state.dart';
import 'package:eocout_flutter/components/my_no_data_component.dart';
import 'package:eocout_flutter/features/chat_page/widget/chat_bubble.dart';
import 'package:eocout_flutter/models/chat_message_data.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatDetailPage extends StatefulWidget {
  final String? conversationId;
  final UserData? withUser;
  const ChatDetailPage({super.key, this.conversationId, this.withUser});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  late ChatBloc bloc;
  final TextEditingController _messageController = TextEditingController();
  UserData? withUser;
  String? conversationId;

  @override
  void initState() {
    bloc =
        widget.conversationId == null ? ChatBloc() : context.read<ChatBloc>();
    if (widget.conversationId != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        withUser = bloc.state?.chatList
            ?.firstWhereOrNull(
                (element) => element.conversationId == widget.conversationId)
            ?.withUser;

        await bloc.getChatMessageHistory(chatId: widget.conversationId!);

        conversationId = widget.conversationId;
        setState(() {});
      });
    } else {
      withUser = widget.withUser;
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        await bloc.getChatList();

        final chatList = bloc.state?.chatList;

        if (chatList != null) {
          final chat = chatList.firstWhereOrNull((element) =>
              element.withUser.username == widget.withUser!.username);

          // When chat is not found, create new chat
          if (chat != null) {
            bloc.getChatMessageHistory(chatId: chat.conversationId);
            conversationId = chat.conversationId;
          } else {
            bloc.createNewChat();
          }
        }
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: withUser?.profilePicture != null
                  ? FileImage(withUser!.profilePicture!)
                  : null,
              child: withUser?.profilePicture == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(withUser?.fullname ?? withUser?.username ?? ""),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (conversationId != null) {
            await bloc.getChatMessageHistory(chatId: conversationId!);
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
          child: StreamBuilder<DetailChatState>(
            stream: bloc.detailChatController,
            builder: (context, snapshot) {
              bool isLoading =
                  snapshot.data?.isLoading ?? false || !snapshot.hasData;

              bool hasError = snapshot.data?.hasError ?? false;

              if (hasError) {
                return const Center(
                  child: Text("Terjadi kesalahan"),
                );
              }

              List<ChatMessageData> chatMessageList =
                  snapshot.data?.chatMessageList ??
                      List.generate(
                          10,
                          (_) => Random().nextBool()
                              ? ChatMessageData.dummy()
                              : ChatMessageData.dummyReceived());

              if (chatMessageList.isEmpty) {
                return const MyNoDataComponent(
                  label: "Mulai mengirim pesan dengan Vendor!",
                );
              }

              return Skeletonizer(
                  enabled: isLoading,
                  child: ListView.builder(
                      itemCount: chatMessageList.length,
                      itemBuilder: (context, index) {
                        final chatMessageData = chatMessageList[index];
                        return ChatBubbleComponent(
                          chatMessageData: chatMessageData,
                          onResendMessage: () {
                            bloc.resendMessage(
                                withUser?.username ?? "", chatMessageData);
                          },
                        );
                      }));
            },
          ),
        ),
      ),
      bottomSheet: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    maxLines: 3,
                    minLines: 1,
                    decoration: const InputDecoration(
                      hintText: "Tulis pesan...",
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () async {
                    String text = _messageController.text;
                    _messageController.clear();
                    await bloc.sendMessage(
                        toUsername: withUser?.username ?? "", message: text);

                    if (conversationId == null) {
                      await bloc.getChatList();

                      final chatList = bloc.state?.chatList;

                      if (chatList != null) {
                        final chat = chatList.firstWhereOrNull((element) =>
                            element.withUser.username ==
                            widget.withUser!.username);

                        // When chat is not found, create new chat
                        if (chat != null) {
                          bloc.getChatMessageHistory(
                              chatId: chat.conversationId, needLoading: false);
                          conversationId = chat.conversationId;
                        }
                      }
                      setState(() {});
                    } else {
                      bloc.getChatMessageHistory(
                          chatId: conversationId!, needLoading: false);
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          )),
    );
  }
}
