import 'package:eocout_flutter/bloc/booking/booking_bloc.dart';
import 'package:eocout_flutter/components/my_confirmation_dialog.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/models/business_data.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/status_util.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayBookingCard extends StatefulWidget {
  final BookingData bookingData;
  const TodayBookingCard({super.key, required this.bookingData});

  @override
  State<TodayBookingCard> createState() => _TodayBookingCardState();
}

class _TodayBookingCardState extends State<TodayBookingCard> {
  final bloc = BookingBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserData userData = widget.bookingData.businessData.profile;
    BusinessData serviceData = widget.bookingData.businessData;
    return GestureDetector(
      onTap: widget.bookingData.status != Status.pending
          ? null
          : () async {
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

              if (confirmOrder == Confirmation.positive) {
                AppError? error =
                    await bloc.confirmBooking(bookingId: widget.bookingData.id);

                if (!context.mounted) return;

                if (error != null) {
                  showMySnackBar(context, error.message, SnackbarStatus.error);
                } else {
                  showMySnackBar(context, "Berhasil mengonfirmasi pesanan.",
                      SnackbarStatus.success);
                }
              }
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          userData.fullname.isNotEmpty
                              ? userData.fullname
                              : userData.username,
                          style: textTheme.headlineMedium,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      _buildStatusIcon()
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        serviceData.name,
                      )),
                      Expanded(
                        child: Text(
                            DateFormat('dd MMM yyyy')
                                .format(widget.bookingData.bookingDate),
                            textAlign: TextAlign.end),
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

  Widget _buildStatusIcon() {
    switch (widget.bookingData.status) {
      case Status.pending:
        return const Icon(
          Icons.pending_actions,
          color: Colors.amber,
        );
      case Status.confirmed:
        return Icon(
          Icons.check_circle,
          color: colorScheme.primary,
        );
      case Status.cancelled:
        return Icon(
          Icons.cancel,
          color: colorScheme.error,
        );
      default:
        return const Icon(Icons.pending_actions);
    }
  }
}
