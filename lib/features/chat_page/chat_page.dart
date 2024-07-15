import 'package:eocout_flutter/bloc/chat/chat_bloc.dart';
import 'package:eocout_flutter/bloc/chat/chat_state.dart';
import 'package:eocout_flutter/components/my_no_data_component.dart';
import 'package:eocout_flutter/components/my_searchbar.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/chat_page/chat_detail_page.dart';
import 'package:eocout_flutter/models/chat_data.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatBloc bloc = ChatBloc();

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
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
            child: Column(
              children: [
                MySearchBar(
                  onChanged: (value) {},
                  label: "Search",
                  isRounded: true,
                ),
                const SizedBox(height: 20),
                StreamBuilder<ChatState>(
                  stream: bloc.stream,
                  builder: (context, snapshot) {
                    bool isLoading =
                        snapshot.data?.isLoading ?? false || !snapshot.hasData;

                    if (snapshot.data?.hasError ?? false) {
                      return const Center(child: Text("Terjadi kesalahan"));
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
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    chatData.withUser.profilePicture != null
                                        ? FileImage(
                                            chatData.withUser.profilePicture!)
                                        : null,
                                child: chatData.withUser.profilePicture == null
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                              title: Text(chatData.withUser.fullname),
                              subtitle: Text(chatData.latestMessage),
                              onTap: () {
                                navigateTo(
                                    context,
                                    ChatDetailPage(
                                      conversationId: chatData.conversationId,
                                    ),
                                    transition:
                                        TransitionType.slideInFromRight);
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
