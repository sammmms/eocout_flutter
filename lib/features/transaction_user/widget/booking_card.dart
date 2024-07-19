import 'package:eocout_flutter/bloc/booking/booking_bloc.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/create_review/create_review_page.dart';
import 'package:eocout_flutter/features/transaction_detail_user/user_transaction_detail_page.dart';
import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/booking_filter.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    bool isCancelled = widget.bookingData.isCancelled;
    bool isNotPaid = widget.bookingData.isNotPaid;
    bool isConfirmed = widget.bookingData.isConfirmed;
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.bookingData.businessData.companyName,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.headlineSmall),
                      Text(widget.bookingData.businessData.name,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(DateFormat('dd MMMM yyyy')
                .format(widget.bookingData.bookingDate)),
            const SizedBox(
              height: 5,
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
                      onPressed: () {
                        navigateTo(context,
                            CreateReviewPage(bookingData: widget.bookingData),
                            transition: TransitionType.slideInFromRight);
                      },
                      child: const Text("Ulas")),
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isCancelled
                          ? Colors.grey
                          : !isConfirmed
                              ? colorScheme.error
                              : colorScheme.primary,
                    ),
                    onPressed: isCancelled
                        ? null
                        : !isConfirmed
                            ? _cancelBooking
                            : () {
                                navigateTo(
                                    context,
                                    UserTransactionDetailPage(
                                        bookingData: widget.bookingData),
                                    transition:
                                        TransitionType.slideInFromRight);
                              },
                    child: isCancelled
                        ? const Text("Pesanan Dibatalkan")
                        : !isConfirmed
                            ? const Text("Batalkan Pesanan")
                            : isNotPaid
                                ? const Text("Bayar Sekarang")
                                : const Text("Lihat Detail"))
              ],
            )
          ],
        ));
  }

  void _cancelBooking() async {
    AppError? error =
        await bloc.cancelBooking(bookingId: widget.bookingData.id);

    if (!mounted) return;

    if (error != null) {
      showMySnackBar(context, error.message, SnackbarStatus.error);
      return;
    }

    showMySnackBar(context, 'Pemesanan dibatalkan', SnackbarStatus.success);

    Future.delayed(const Duration(seconds: 2), () {
      context
          .read<BookingBloc>()
          .getAllBooking(filter: BookingFilter.pendingPayment());
    });
  }
}
