import 'package:eocout_flutter/features/service_detail/service_detail_page.dart';
import 'package:eocout_flutter/models/service_data.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class EOBusinessCarouselItem extends StatelessWidget {
  final ServiceData serviceData;
  const EOBusinessCarouselItem({super.key, required this.serviceData});

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
                      businessData: serviceData,
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
                child: serviceData.images.isEmpty
                    ? Image.asset(
                        "assets/images/placeholder.png",
                        width: double.infinity,
                      )
                    : Image.memory(
                        serviceData.images.first.readAsBytesSync(),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )),
            Container(
              color: Colors.black.withOpacity(0.2),
            ),
            Positioned(
              bottom: 20,
              child: Text(
                serviceData.name,
                style: textTheme.headlineMedium!.copyWith(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
