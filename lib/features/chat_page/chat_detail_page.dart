import 'dart:math';

import 'package:collection/collection.dart';
import 'package:eocout_flutter/bloc/chat/chat_bloc.dart';
import 'package:eocout_flutter/bloc/chat/detail_chat_state.dart';
import 'package:eocout_flutter/components/my_avatar_loader.dart';
import 'package:eocout_flutter/components/my_error_component.dart';
import 'package:eocout_flutter/components/my_no_data_component.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/features/chat_page/widget/chat_bubble.dart';
import 'package:eocout_flutter/models/chat_message_data.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/store.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatDetailPage extends StatefulWidget {
  final String? conversationId;
  final UserData? withUser;
  const ChatDetailPage({super.key, this.conversationId, this.withUser});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final ChatBloc bloc = ChatBloc();
  final _withUser = BehaviorSubject<UserData>();
  final _scrollController = ScrollController();
  final _messageController = BehaviorSubject<String>.seeded("");
  final _messageTEC = TextEditingController();
  final _scrollSubject = BehaviorSubject<double>.seeded(0);
  String? conversationId;

  @override
  void initState() {
    _messageTEC.addListener(() {
      _messageController.add(_messageTEC.text);
    });

    _scrollSubject.debounceTime(Durations.short3).listen((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // If bringing conversation id from outside (from chat list)
      if (widget.conversationId != null) {
        await bloc.getChatMessageHistory(chatId: widget.conversationId!);

        UserData? user = widget.withUser ??
            bloc.state?.chatList
                ?.firstWhereOrNull((element) =>
                    element.conversationId == widget.conversationId)
                ?.withUser;

        if (!mounted) {
          return;
        }
        if (user == null) {
          showMySnackBar(context, "User not found", SnackbarStatus.error);
          return;
        }

        _withUser.add(user);

        conversationId = widget.conversationId;
      }
      // If bringing withUser from outside (from vendor event)
      else {
        _withUser.add(widget.withUser!);
        await bloc.getChatList();

        final chatList = bloc.state?.chatList;

        if (chatList != null) {
          final chat = chatList.firstWhereOrNull((element) =>
              element.withUser.username == widget.withUser!.username);

          // When chat is not found, create new chat
          if (chat != null) {
            await bloc.getChatMessageHistory(chatId: chat.conversationId);
            conversationId = chat.conversationId;
          } else {
            await bloc.createNewChat();
          }
        }
      }

      if (conversationId != null) {
        await _tryConnectingToChat();
      }

      if (_scrollController.hasClients) {
        Future.delayed(
            Durations.long1,
            () => _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent));
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    if (conversationId != null) {
      Store.saveLastRead(conversationId!);
    }
    bloc.dispose();
    _messageController.close();
    _messageTEC.removeListener(() {});
    _messageTEC.dispose();
    _scrollController.dispose();
    _scrollSubject.close();
    _withUser.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scrollSubject.add(MediaQuery.of(context).viewInsets.bottom);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: StreamBuilder<UserData>(
            stream: _withUser,
            builder: (context, snapshot) {
              bool isLoading = snapshot.data == null || !snapshot.hasData;

              UserData withUser = snapshot.data ?? UserData.dummy();
              return Skeletonizer(
                enabled: isLoading,
                child: Row(
                  children: [
                    MyAvatarLoader(user: withUser),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(withUser.fullname.isNotEmpty
                        ? withUser.fullname
                        : withUser.username),
                  ],
                ),
              );
            }),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: const PreferredSize(
            preferredSize: Size(100, 1),
            child: Divider(
              endIndent: 15,
              indent: 15,
            )),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (conversationId != null) {
            await bloc.getChatMessageHistory(chatId: conversationId!);
            if (bloc.channel == null) {
              _tryConnectingToChat();
            }
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
                return Center(
                  child: MyErrorComponent(
                    onRefresh: () {
                      if (conversationId != null) {
                        bloc.getChatMessageHistory(chatId: conversationId!);
                        if (bloc.channel == null) {
                          _tryConnectingToChat();
                        }
                      }
                    },
                    error: snapshot.data?.error,
                  ),
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
                return const Center(
                  child: MyNoDataComponent(
                    label: "Mulai mengirim pesan dengan Vendor!",
                  ),
                );
              }

              chatMessageList
                  .sort((a, b) => a.createdAt.compareTo(b.createdAt));

              return Skeletonizer(
                  enabled: isLoading,
                  child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(
                          top: 10,
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom + 10),
                      itemCount: chatMessageList.length,
                      itemBuilder: (context, index) {
                        final chatMessageData = chatMessageList[index];
                        return ChatBubbleComponent(
                          chatMessageData: chatMessageData,
                          onResendMessage: () async {
                            if (conversationId == null) {
                              return;
                            }
                            await bloc.resendMessage(
                                chatId: conversationId!,
                                chatMessageData: chatMessageData);
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
                    controller: _messageTEC,
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
                StreamBuilder<String>(
                    stream: _messageController,
                    initialData: "",
                    builder: (context, snapshot) {
                      String text = snapshot.data ?? "";
                      if (text.isEmpty) {
                        return const SizedBox();
                      }
                      return IconButton(
                        onPressed: () => _sendMessage(text),
                        icon: const Icon(Icons.send),
                      );
                    }),
              ],
            ),
          )),
    );
  }

  Future<void> _tryConnectingToChat() async {
    if (conversationId != null) {
      AppError? error = await bloc.connectToChat(conversationId!);

      if (!mounted) return;
      if (error != null) {
        showMySnackBar(context, error.message, SnackbarStatus.error);
      }
    }
  }

  void _sendMessage(
    String text,
  ) async {
    _messageTEC.clear();
    if (conversationId == null) {
      await bloc.sendNewMessage(
          toUsername: _withUser.valueOrNull?.username ?? "", content: text);
      await bloc.getChatList();
      final chatList = bloc.state?.chatList;
      if (chatList != null) {
        final chat = chatList.firstWhereOrNull((element) =>
            element.withUser.username == _withUser.valueOrNull?.username);
        if (chat != null) {
          await bloc.getChatMessageHistory(chatId: chat.conversationId);
          conversationId = chat.conversationId;
        }
      }

      if (conversationId != null) {
        await _tryConnectingToChat();
      }

      if (_scrollController.hasClients) {
        Future.delayed(
            Durations.long1,
            () => _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent));
      }
    } else {
      await bloc.sendMessage(chatId: conversationId!, content: text);
    }
    Future.delayed(
        Durations.short1,
        () => _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent));
  }
}
