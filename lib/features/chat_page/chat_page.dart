import 'package:eocout_flutter/bloc/chat/chat_bloc.dart';
import 'package:eocout_flutter/bloc/chat/chat_state.dart';
import 'package:eocout_flutter/components/my_error_component.dart';
import 'package:eocout_flutter/components/my_no_data_component.dart';
import 'package:eocout_flutter/components/my_searchbar.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/chat_page/chat_detail_page.dart';
import 'package:eocout_flutter/features/chat_page/widget/chat_tile.dart';
import 'package:eocout_flutter/models/chat_data.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatBloc bloc = ChatBloc();
  final _searchStream = BehaviorSubject<String>.seeded("");

  @override
  void initState() {
    bloc.getChatList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pesan"),
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await bloc.getChatList();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
            child: Column(
              children: [
                MySearchBar(
                  onChanged: (value) {
                    _searchStream.add(value);
                  },
                  label: "Search",
                  isRounded: true,
                ),
                const SizedBox(height: 20),
                StreamBuilder(
                  stream: _searchStream.stream,
                  initialData: "",
                  builder: (context, searchSnapshot) =>
                      StreamBuilder<ChatState>(
                    stream: bloc.stream,
                    builder: (context, snapshot) {
                      bool isLoading = snapshot.data?.isLoading ??
                          false || !snapshot.hasData;

                      if (snapshot.data?.hasError ?? false) {
                        return MyErrorComponent(
                            onRefresh: () {
                              bloc.getChatList();
                            },
                            error: snapshot.data?.error);
                      }

                      List<ChatData> chatList = snapshot.data?.chatList ??
                          List.generate(10, (_) => ChatData.dummy());

                      if (chatList.isEmpty) {
                        return const Expanded(
                          child: MyNoDataComponent(
                            label: "Tidak ada pesan",
                          ),
                        );
                      }

                      chatList = chatList.where((element) {
                        return element.withUser.fullname
                            .toLowerCase()
                            .contains(searchSnapshot.data!.toLowerCase());
                      }).toList();

                      return Expanded(
                        child: Skeletonizer(
                          enabled: isLoading,
                          child: ListView.separated(
                            itemCount: chatList.length,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 0),
                            itemBuilder: (context, index) {
                              ChatData chatData = chatList[index];
                              return ChatTile(
                                onTap: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  await navigateTo(
                                      context,
                                      ChatDetailPage(
                                        conversationId: chatData.conversationId,
                                        withUser: chatData.withUser,
                                      ),
                                      transition:
                                          TransitionType.slideInFromRight);
                                  bloc.getChatList(needLoading: false);
                                },
                                chatData: chatData,
                                needUnread: !isLoading,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
