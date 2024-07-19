import 'package:eocout_flutter/features/service_detail/service_detail_page.dart';
import 'package:eocout_flutter/models/service_data.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class EOServiceItem extends StatelessWidget {
  final ServiceData serviceData;
  const EOServiceItem({super.key, required this.serviceData});

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
        child: SizedBox(
          width: 250,
          child: Card(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: serviceData.images.isEmpty
                        ? Image.asset(
                            "assets/images/placeholder.png",
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: 150,
                            fit: BoxFit.cover,
                          )
                        : Image.memory(
                            serviceData.images.first.readAsBytesSync(),
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceData.name,
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(serviceData.location),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
