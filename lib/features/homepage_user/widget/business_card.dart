import 'package:eocout_flutter/models/business_data.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class BusinessCard extends StatelessWidget {
  final BusinessData businessData;
  const BusinessCard({super.key, required this.businessData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: businessData.images.firstOrNull != null
                  ? AspectRatio(
                      aspectRatio: 1,
                      child: Image.memory(
                        businessData.images.firstOrNull!.readAsBytesSync(),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        "assets/images/placeholder.png",
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(businessData.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headlineSmall),
                  Text(
                    businessData.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 30,
                    child: OutlinedButton(
                        onPressed: () {}, child: const Text("Lihat Detail")),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
