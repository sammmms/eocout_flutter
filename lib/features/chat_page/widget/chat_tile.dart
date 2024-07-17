import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/chat_page/chat_detail_page.dart';
import 'package:eocout_flutter/models/chat_data.dart';
import 'package:eocout_flutter/utils/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ChatTile extends StatefulWidget {
  final ChatData chatData;
  final bool needUnread;

  const ChatTile({super.key, required this.chatData, this.needUnread = true});

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
    return ListTile(
        leading: CircleAvatar(
          backgroundImage: widget.chatData.withUser.profilePicture != null
              ? FileImage(widget.chatData.withUser.profilePicture!)
              : null,
          child: widget.chatData.withUser.profilePicture == null
              ? const Icon(Icons.person)
              : null,
        ),
        title: Text(widget.chatData.withUser.fullname),
        subtitle: Text(widget.chatData.latestMessage),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          navigateTo(
              context,
              ChatDetailPage(
                conversationId: widget.chatData.conversationId,
                withUser: widget.chatData.withUser,
              ),
              transition: TransitionType.slideInFromRight);
        },
        trailing: hasRead && widget.needUnread
            ? null
            : const CircleAvatar(
                radius: 5,
                backgroundColor: Colors.blue,
              ));
  }
}
