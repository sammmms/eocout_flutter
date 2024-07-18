import 'package:eocout_flutter/bloc/booking/booking_bloc.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/transaction_detail_user/user_transaction_detail_page.dart';
import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/utils/status_util.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingCard extends StatefulWidget {
  final BookingData bookingData;
  const BookingCard({super.key, required this.bookingData});

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  final bloc = BookingBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

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
              blurRadius: 3,
              offset: Offset(0, 2),
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
                  child: widget.bookingData.businessData.images.isNotEmpty
                      ? Image.file(
                          widget.bookingData.businessData.images.first,
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
                      Text(widget.bookingData.businessData.name,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.headlineSmall),
                      Text(DateFormat('dd MMMM yyyy')
                          .format(widget.bookingData.bookingDate))
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
                    .format(widget.bookingData.businessData.price),
                style: textTheme.headlineLarge),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.bookingData.isComplete)
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.outline,
                      ),
                      onPressed: () {},
                      child: const Text("Ulas")),
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          widget.bookingData.status == Status.confirmed
                              ? colorScheme.primary
                              : colorScheme.secondary,
                    ),
                    onPressed: widget.bookingData.status == Status.pending
                        ? null
                        : () {
                            navigateTo(
                                context,
                                UserTransactionDetailPage(
                                    bookingData: widget.bookingData),
                                transition: TransitionType.slideInFromRight);
                          },
                    child: widget.bookingData.status == Status.confirmed
                        ? widget.bookingData.isPaid
                            ? const Text('Lihat Detail')
                            : const Text('Bayar Sekarang')
                        : const Text('Menunggu Konfirmasi')),
              ],
            )
          ],
        ));
  }
}
