import 'package:eocout_flutter/components/my_avatar_loader.dart';
import 'package:eocout_flutter/models/chat_data.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ChatTile extends StatefulWidget {
  final ChatData chatData;
  final bool needUnread;
  final Function() onTap;

  const ChatTile(
      {super.key,
      required this.chatData,
      this.needUnread = true,
      required this.onTap});

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  bool hasRead = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      ChatData chatData = widget.chatData;

      String? lastRead =
          await Store.getLastRead(widget.chatData.conversationId);

      if (lastRead == null) {
        return;
      }

      if (chatData.latestMessageTimestamp.isAfter(DateTime.parse(lastRead))) {
        setState(() {
          hasRead = false;
        });
      } else {
        setState(() {
          hasRead = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ChatData chatData = widget.chatData;
    UserData withUser = chatData.withUser;
    return ListTile(
        leading: MyAvatarLoader(
          user: withUser,
        ),
        title: Text(withUser.fullname.isNotEmpty
            ? withUser.fullname
            : withUser.username),
        subtitle: Text(chatData.latestMessage),
        onTap: widget.onTap,
        trailing: !hasRead && widget.needUnread
            ? const CircleAvatar(
                radius: 5,
                backgroundColor: Colors.blue,
              )
            : null);
  }
}
