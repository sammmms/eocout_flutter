import 'package:eocout_flutter/models/chat_message_data.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ChatBubbleComponent extends StatelessWidget {
  final ChatMessageData chatMessageData;
  final Function() onResendMessage;
  const ChatBubbleComponent(
      {super.key,
      required this.chatMessageData,
      required this.onResendMessage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: chatMessageData.isMe
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              color: chatMessageData.hasError
                  ? colorScheme.error
                  : chatMessageData.isMe
                      ? colorScheme.primary
                      : const Color(0xFF141E46),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: chatMessageData.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  isToday(chatMessageData.createdAt)
                      ? DateFormat("HH:mm").format(chatMessageData.createdAt)
                      : DateFormat("dd MMM yyyy HH:mm")
                          .format(chatMessageData.createdAt),
                  style: TextStyle(
                    color: chatMessageData.isMe ? Colors.white : Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (chatMessageData.isLoading)
                      Lottie.asset("assets/lottie/loading_animation.json",
                          width: 30),
                    Text(
                      chatMessageData.content,
                      style: TextStyle(
                        color:
                            chatMessageData.isMe ? Colors.white : Colors.white,
                      ),
                    ),
                  ],
                ),
                if (chatMessageData.hasError) ...[
                  const SizedBox(height: 5),
                  Text("Gagal mengirim pesan",
                      style: textTheme.titleSmall!.copyWith(
                        color: Colors.grey.shade300,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                          onTap: onResendMessage,
                          child: Row(
                            children: [
                              Text("Kirim ulang",
                                  style: TextStyle(
                                      color: Colors.grey.shade300,
                                      fontSize: 12)),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.refresh,
                                color: Colors.grey.shade300,
                                size: 20,
                              ),
                            ],
                          )),
                    ],
                  ),
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return now.day == date.day &&
        now.month == date.month &&
        now.year == date.year;
  }
}
