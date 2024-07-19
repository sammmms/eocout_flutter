import 'package:eocout_flutter/bloc/booking/booking_bloc.dart';
import 'package:eocout_flutter/bloc/booking/booking_state.dart';
import 'package:eocout_flutter/components/my_loading_dialog.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class EventOrganizerTransactionDetailPage extends StatefulWidget {
  final BookingData bookingData;
  const EventOrganizerTransactionDetailPage(
      {super.key, required this.bookingData});

  @override
  State<EventOrganizerTransactionDetailPage> createState() =>
      _EventOrganizerTransactionDetailPageState();
}

class _EventOrganizerTransactionDetailPageState
    extends State<EventOrganizerTransactionDetailPage> {
  final BookingBloc _bookingBloc = BookingBloc();

  @override
  void dispose() {
    _bookingBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 80,
              ),
              Text(
                _statusText,
                style: textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ID Transaksi"),
                      SizedBox(height: 5),
                      Text("Harga"),
                    ],
                  )),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.bookingData.id.hashCode.toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                            NumberFormat.currency(locale: 'id', symbol: 'Rp')
                                .format(widget.bookingData.serviceData.price),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Detail Acara",
                      style: textTheme.titleMedium,
                    ),
                  ),
                  const Expanded(child: Divider())
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nama Acara"),
                      SizedBox(height: 5),
                      Text("Tanggal Acara"),
                      SizedBox(height: 5),
                      Text("Lokasi Acara")
                    ],
                  )),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(widget.bookingData.serviceData.name),
                        const SizedBox(height: 5),
                        Text(
                            DateFormat('dd MMMM yyyy')
                                .format(widget.bookingData.bookingDate),
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 5),
                        Text(widget.bookingData.serviceData.location)
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (widget.bookingData.isPending) ...[
                _actionButton(
                    label: "Tolak Pesanan",
                    onTap: _rejectBooking,
                    color: colorScheme.error),
                const SizedBox(height: 10),
                _actionButton(
                    label: "Konfirmasi Pesanan", onTap: _confirmBooking),
              ],
              if (widget.bookingData.isConfirmed)
                _actionButton(
                    label: "Selesaikan Pesanan", onTap: _completeBooking),
              if (widget.bookingData.isCompleted &&
                  widget.bookingData.isPendingPayment)
                _actionButton(
                    label: "Pesanan Belum Dibayar",
                    onTap: null,
                    color: colorScheme.error),
            ],
          ),
          Positioned(
              top: -80,
              child: SvgPicture.asset('assets/svg/transaction_icon.svg')),
        ],
      ),
    );
  }

  Widget _actionButton(
      {required String label, required VoidCallback? onTap, Color? color}) {
    return StreamBuilder<BookingState>(
        stream: _bookingBloc.stream,
        builder: (context, snapshot) {
          bool isLoading = snapshot.data?.isLoading ?? false;
          return SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: color,
              ),
              onPressed: isLoading ? null : onTap,
              child: Text(label),
            ),
          );
        });
  }

  String get _statusText {
    if (widget.bookingData.isPending) {
      return "Menunggu Konfirmasi";
    } else if (widget.bookingData.isCompleted) {
      return "Pesanan Telah Diselesaikan";
    } else if (widget.bookingData.isCancelled) {
      return "Pesanan Dibatalkan";
    } else if (widget.bookingData.isConfirmed &&
        widget.bookingData.isPendingPayment) {
      return "Menunggu Pembayaran";
    } else if (widget.bookingData.isConfirmed && widget.bookingData.isPaid) {
      return "Pesanan Telah Dibayar";
    } else {
      return "Status Tidak Diketahui";
    }
  }

  void _rejectBooking() async {
    showDialog(context: context, builder: (context) => const MyLoadingDialog());

    AppError? error =
        await _bookingBloc.rejectBooking(bookingId: widget.bookingData.id);

    if (!mounted) return;

    // Close the loading dialog
    Navigator.pop(context);

    // Close the bottom sheet
    Navigator.pop(context);

    if (error != null) {
      showMySnackBar(context, error.message, SnackbarStatus.error);
      return;
    }

    showMySnackBar(context, "Pesanan berhasil ditolak", SnackbarStatus.success);
  }

  void _completeBooking() async {
    showDialog(context: context, builder: (context) => const MyLoadingDialog());

    AppError? error =
        await _bookingBloc.completeBooking(bookingId: widget.bookingData.id);

    if (!mounted) return;

    // Close the loading dialog
    Navigator.pop(context);

    // Close the bottom sheet
    Navigator.pop(context);

    if (error != null) {
      showMySnackBar(context, error.message, SnackbarStatus.error);
      return;
    }

    showMySnackBar(
        context, "Pesanan berhasil diselesaikan", SnackbarStatus.success);
  }

  void _confirmBooking() async {
    showDialog(context: context, builder: (context) => const MyLoadingDialog());

    AppError? error =
        await _bookingBloc.confirmBooking(bookingId: widget.bookingData.id);

    if (!mounted) return;

    // Close the loading dialog
    Navigator.pop(context);

    // Close the bottom sheet
    Navigator.pop(context);

    if (error != null) {
      showMySnackBar(context, error.message, SnackbarStatus.error);
      return;
    }

    showMySnackBar(
        context, "Pesanan berhasil dikonfirmasi", SnackbarStatus.success);
  }
}
