import 'package:eocout_flutter/components/my_avatar_loader.dart';
import 'package:eocout_flutter/models/notification_data.dart';
import 'package:eocout_flutter/utils/notification_type_util.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final NotificationData data;
  const NotificationCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.user != null)
            Row(
              children: [
                MyAvatarLoader(user: data.user!),
                const SizedBox(width: 10),
                Text(
                  data.user!.fullname,
                  style: textTheme.headlineMedium,
                ),
              ],
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                NotificationTypeUtil.iconOf(data.type),
                color: colorScheme.secondaryContainer,
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(data.content, style: textTheme.bodyMedium)),
            ],
          )
        ],
      ),
    );
  }
}
