import 'package:flutter/material.dart';

class MyReviewStar extends StatelessWidget {
  final int rating;
  final int? ratingCount;
  const MyReviewStar({super.key, required this.rating, this.ratingCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < rating ? Icons.star_rounded : Icons.star_border_rounded,
            color: const Color(0xffFFC107),
          );
        }),
        if (ratingCount != null) ...[
          const SizedBox(width: 5),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              "($ratingCount)",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          )
        ]
      ],
    );
  }
}
