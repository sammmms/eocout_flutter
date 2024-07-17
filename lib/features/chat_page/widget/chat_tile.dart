import 'package:eocout_flutter/components/my_avatar_loader.dart';
import 'package:eocout_flutter/models/chat_data.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/store.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    _checkHasRead();
    UserData withUser = widget.chatData.withUser;
    return ListTile(
        leading: MyAvatarLoader(
          user: withUser,
        ),
        title: Text(withUser.fullname.isNotEmpty
            ? withUser.fullname
            : withUser.username),
        subtitle: Text(widget.chatData.latestMessage),
        onTap: widget.onTap,
        trailing: !hasRead && widget.needUnread
            ? const CircleAvatar(
                radius: 5,
                backgroundColor: Colors.blue,
              )
            : null);
  }

  _checkHasRead() async {
    if (!widget.needUnread) {
      return;
    }
    String? lastRead = await Store.getLastRead(widget.chatData.conversationId);

    if (lastRead == null) {
      return;
    }

    if (DateTime.parse(lastRead)
        .isAfter(widget.chatData.latestMessageTimestamp)) {
      if (mounted) {
        setState(() {
          hasRead = true;
        });
      }
    }
  }
}
