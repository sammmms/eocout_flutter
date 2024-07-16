import 'package:eocout_flutter/components/my_confirmation_dialog.dart';
import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/models/business_data.dart';
import 'package:eocout_flutter/models/profile_data.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayBookingCard extends StatelessWidget {
  final BookingData bookingData;
  const TodayBookingCard({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    UserData userData = bookingData.businessData.profile;
    BusinessData serviceData = bookingData.businessData;
    return GestureDetector(
      onTap: () async {
        Confirmation? confirmOrder = await showDialog(
            context: context,
            builder: (context) {
              return const MyConfirmationDialog(
                label: "Konfirmasi pesanan ini?",
                subLabel:
                    "Konfirmasi bahwa pesanan ini dapat dilakukan pada jadwal yang ditentukan?",
                positiveLabel: "Konfirmasi",
                negativeLabel: "Batalkan",
              );
            });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: userData.profilePicture != null
                  ? FileImage(userData.profilePicture!)
                  : null,
              child: userData.profilePicture == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData.fullname.isNotEmpty
                        ? userData.fullname
                        : userData.username,
                    style: textTheme.headlineMedium,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        serviceData.name,
                        textAlign: TextAlign.center,
                      )),
                      Expanded(
                        child: Text(
                            DateFormat('dd MMM yyyy')
                                .format(bookingData.bookingDate),
                            textAlign: TextAlign.center),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
