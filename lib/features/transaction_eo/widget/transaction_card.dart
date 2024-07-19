import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final BookingData bookingData;
  final Function() onButtonPressed;
  const TransactionCard(
      {super.key, required this.bookingData, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bookingData.businessData.name,
                          style: textTheme.headlineSmall),
                      Text(DateFormat('dd MMMM yyyy')
                          .format(bookingData.bookingDate))
                    ],
                  ),
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
                  onPressed: onButtonPressed,
                  child: const Text("Lihat Detail")),
            ),
          ],
        ),
      ),
    );
  }
}
