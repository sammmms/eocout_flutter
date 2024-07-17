import 'package:eocout_flutter/bloc/booking/booking_bloc.dart';
import 'package:eocout_flutter/components/my_error_component.dart';
import 'package:eocout_flutter/components/my_no_data_component.dart';
import 'package:eocout_flutter/features/transaction_eo/widget/transaction_card.dart';
import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/utils/booking_filter.dart';
import 'package:eocout_flutter/utils/status_util.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EventOrganizerTransactionPage extends StatefulWidget {
  const EventOrganizerTransactionPage({super.key});

  @override
  State<EventOrganizerTransactionPage> createState() =>
      _EventOrganizerTransactionPageState();
}

class _EventOrganizerTransactionPageState
    extends State<EventOrganizerTransactionPage> {
  final _filterStream = BehaviorSubject<BookingFilter>.seeded(BookingFilter());
  final _bookingBloc = BookingBloc();

  @override
  void initState() {
    _filterStream.listen((filter) {
      _bookingBloc.getBookingRequest(bookingFilter: filter);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text("Status Pemesanan"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFilterButton(
                    label: "Pesanan Baru",
                    svgAsset: "assets/svg/order_new_icon.svg",
                    onTap: () {
                      _filterStream.add(BookingFilter(status: Status.pending));
                    },
                  ),
                  _buildFilterButton(
                    label: "Diproses",
                    svgAsset: "assets/svg/order_process_icon.svg",
                    onTap: () {
                      _filterStream
                          .add(BookingFilter(status: Status.confirmed));
                    },
                  ),
                  _buildFilterButton(
                    label: "Selesai",
                    svgAsset: "assets/svg/order_done_icon.svg",
                    onTap: () {
                      _filterStream
                          .add(BookingFilter(status: Status.completed));
                    },
                  ),
                  _buildFilterButton(
                    label: "Dibatalkan",
                    svgAsset: "assets/svg/order_cancel_icon.svg",
                    onTap: () {
                      _filterStream
                          .add(BookingFilter(status: Status.cancelled));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Info Pembayaran",
                style: textTheme.headlineSmall,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: _bookingBloc.controller,
                  builder: (context, snapshot) {
                    bool isLoading =
                        snapshot.data?.isLoading ?? false || !snapshot.hasData;

                    bool hasError = snapshot.data?.hasError ?? false;

                    if (hasError) {
                      return MyErrorComponent(onRefresh: () {
                        _bookingBloc.getBookingRequest(
                            bookingFilter: _filterStream.valueOrNull);
                      });
                    }

                    List<BookingData> bookingDataList =
                        snapshot.data?.bookings ??
                            List.generate(7, (_) => BookingData.dummy());

                    if (bookingDataList.isEmpty) {
                      return const Center(
                          child: MyNoDataComponent(
                        label: "Tidak ada pesanan saat ini",
                      ));
                    }

                    return Skeletonizer(
                      enabled: isLoading,
                      child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          itemCount: bookingDataList.length,
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                              ),
                          itemBuilder: (context, index) {
                            BookingData bookingData = bookingDataList[index];
                            return TransactionCard(
                              bookingData: bookingData,
                              onButtonPressed: () {},
                            );
                          }),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required String svgAsset,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF141E46),
              borderRadius: BorderRadius.circular(15),
            ),
            child: SvgPicture.asset(
              svgAsset,
              width: 30,
              height: 30,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
