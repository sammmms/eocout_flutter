import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/utils/status_util.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingCard extends StatelessWidget {
  final BookingData bookingData;
  const BookingCard({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: bookingData.businessData.images.isNotEmpty
                      ? Image.file(
                          bookingData.businessData.images.first,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/placeholder.png',
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bookingData.businessData.name,
                        style: textTheme.headlineSmall),
                    Text(DateFormat('dd MMMM yyyy')
                        .format(bookingData.bookingDate))
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
                NumberFormat.currency(
                        locale: 'id', symbol: 'Rp', decimalDigits: 0)
                    .format(bookingData.businessData.price),
                style: textTheme.headlineLarge),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: bookingData.status == Status.confirmed
                        ? colorScheme.primary
                        : colorScheme.secondary,
                  ),
                  onPressed:
                      bookingData.status == Status.confirmed ? () {} : null,
                  child: bookingData.status == Status.confirmed
                      ? const Text("Lakukan Pembayaran")
                      : const Text("Menunggu Konfirmasi Penjual")),
            ),
          ],
        ));
  }
}
