import 'dart:io';

import 'package:eocout_flutter/bloc/booking/booking_bloc.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/payment_status_util.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;

class UserTransactionDetailPage extends StatefulWidget {
  final BookingData bookingData;
  const UserTransactionDetailPage({super.key, required this.bookingData});

  @override
  State<UserTransactionDetailPage> createState() =>
      _UserTransactionDetailPageState();
}

class _UserTransactionDetailPageState extends State<UserTransactionDetailPage> {
  final _bookingBloc = BookingBloc();
  final _screenshotController = ScreenshotController();

  @override
  void dispose() {
    _bookingBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BookingData bookingData = widget.bookingData;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text("Detail Transaksi"),
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: Container(
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
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _lottieBuilder(),
              const SizedBox(
                height: 20,
              ),
              _statusTextBuilder(),
              const SizedBox(
                height: 10,
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
                          bookingData.id.hashCode.toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                            NumberFormat.currency(locale: 'id', symbol: 'Rp')
                                .format(bookingData.businessData.price),
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
                        Text(bookingData.businessData.name),
                        const SizedBox(height: 5),
                        Text(
                            DateFormat('dd MMMM yyyy')
                                .format(bookingData.bookingDate),
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 5),
                        Text(bookingData.businessData.location)
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              OutlinedButton(
                onPressed: bookingData.paymentStatus == PaymentStatus.pending
                    ? _tryPayment
                    : _trySaving,
                child: bookingData.paymentStatus == PaymentStatus.pending
                    ? const Text("Bayar Sekarang")
                    : const Text("Download Detail"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _lottieBuilder() {
    return Lottie.asset(
        widget.bookingData.paymentStatus == PaymentStatus.pending
            ? "assets/lottie/pending_animation.json"
            : widget.bookingData.paymentStatus == PaymentStatus.completed
                ? "assets/lottie/success_animation.json"
                : "assets/lottie/failed_animation.json",
        height: 80,
        width: 80,
        repeat: false);
  }

  Widget _statusTextBuilder() {
    return Text(
      widget.bookingData.paymentStatus == PaymentStatus.pending
          ? "Menunggu Pembayaran"
          : widget.bookingData.paymentStatus == PaymentStatus.completed
              ? "Pembayaran Berhasil"
              : "Pembayaran Gagal",
      overflow: TextOverflow.ellipsis,
      style: textTheme.headlineMedium,
    );
  }

  void _tryPayment() async {
    var response = await _bookingBloc.paymentBooking(widget.bookingData.id);

    if (!mounted) return;
    if (response is AppError) {
      showMySnackBar(context, response.message, SnackbarStatus.error);
      return;
    }

    if (response is String) {
      Uri url = Uri.parse(response);

      if (kDebugMode) {
        print(response);
      }

      await launchUrl(url);
    }
  }

  void _trySaving() async {
    Uint8List? image = await _screenshotController.capture();

    if (image != null) {
      Directory? directory =
          await getDownloadsDirectory() ?? await getExternalStorageDirectory();

      var externalStorageStatus = await Permission.manageExternalStorage.status;
      var storageStatus = await Permission.storage.status;

      if (externalStorageStatus.isDenied && storageStatus.isDenied) {
        await Permission.manageExternalStorage.request();
        await Permission.storage.request();

        externalStorageStatus = await Permission.manageExternalStorage.status;
        storageStatus = await Permission.storage.status;

        if (externalStorageStatus.isDenied && storageStatus.isDenied) {
          if (!mounted) return;
          showMySnackBar(
              context, "Izin akses penyimpanan ditolak", SnackbarStatus.error);
          return;
        }
      }

      if (!mounted) return;

      if (directory == null) {
        showMySnackBar(context, "Gagal menyimpan gambar", SnackbarStatus.error);
        return;
      }

      File file = File(path.join(directory.path, "detail_transaksi.jpg"));

      final result = await ImageGallerySaver.saveImage(image,
          name: widget.bookingData.id.hashCode.toString());

      if (result['isSuccess'] != true) {
        if (!mounted) return;
        showMySnackBar(context, result['errorMessage'], SnackbarStatus.error);
      }

      await file.writeAsBytes(image);

      if (!mounted) return;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Berhasil"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.file(file),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Gambar berhasil disimpan di galeri",
                    style: textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("OK"))
              ],
            );
          });
    }
  }
}
