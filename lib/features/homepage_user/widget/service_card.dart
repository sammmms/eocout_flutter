import 'package:eocout_flutter/components/my_review_star.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/service_detail/service_detail_page.dart';
import 'package:eocout_flutter/models/service_data.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final ServiceData serviceData;
  const ServiceCard({super.key, required this.serviceData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(context, ServiceDetailPage(businessData: serviceData),
            transition: TransitionType.slideInFromRight);
      },
      child: Card(
        child: SizedBox(
          height: 180,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: serviceData.images.firstOrNull != null
                          ? Image.memory(
                              serviceData.images.firstOrNull!.readAsBytesSync(),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "assets/images/placeholder.png",
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(serviceData.companyName,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.headlineSmall!
                                  .copyWith(fontWeight: FontWeight.w600)),
                          Text(serviceData.name,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleMedium!
                                  .copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  serviceData.description,
                  maxLines: 2,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium!.copyWith(color: Colors.grey),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyReviewStar(
                      rating: serviceData.averageRating.round(),
                      ratingCount: serviceData.ratingCount,
                    ),
                    SizedBox(
                      height: 40,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20)),
                          onPressed: () {
                            navigateTo(context,
                                ServiceDetailPage(businessData: serviceData),
                                transition: TransitionType.slideInFromRight);
                          },
                          child: const Text("Lihat Detail")),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
