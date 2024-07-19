import 'package:eocout_flutter/components/my_avatar_loader.dart';
import 'package:eocout_flutter/components/my_review_star.dart';
import 'package:eocout_flutter/models/review_data.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyReviewCard extends StatelessWidget {
  final ReviewData review;
  const MyReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MyAvatarLoader(user: review.user),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          review.user.fullname.isNotEmpty
                              ? review.user.fullname
                              : review.user.username,
                          style: textTheme.headlineSmall),
                      Text(
                        DateFormat("dd MMMM yyyy").format(review.createdAt),
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            MyReviewStar(rating: review.rating),
            if (review.comment.isNotEmpty) ...[
              const SizedBox(
                height: 10,
              ),
              Text(review.comment, style: textTheme.bodyMedium),
            ]
          ],
        ),
      ),
    );
  }
}
