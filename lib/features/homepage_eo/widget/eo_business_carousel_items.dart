import 'package:eocout_flutter/features/service_detail/service_detail_page.dart';
import 'package:eocout_flutter/models/business_data.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class EOBusinessCarouselItem extends StatelessWidget {
  final BusinessData business;
  const EOBusinessCarouselItem({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (context) => SafeArea(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: ServiceDetailPage(
                      businessData: business,
                    ),
                  ),
                ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
                width: double.infinity,
                height: 400,
                child: business.images.isEmpty
                    ? Image.asset(
                        "assets/images/placeholder.png",
                        width: double.infinity,
                      )
                    : Image.memory(
                        business.images.first.readAsBytesSync(),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )),
            Container(
              color: Colors.black.withOpacity(0.2),
            ),
            Positioned(
              bottom: 20,
              child: Text(
                business.name,
                style: textTheme.headlineMedium!.copyWith(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
