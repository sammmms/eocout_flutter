import 'package:eocout_flutter/features/transaction_eo/widget/event_organizer_transaction_list.dart';
import 'package:eocout_flutter/utils/booking_filter.dart';
import 'package:eocout_flutter/utils/status_util.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rxdart/rxdart.dart';

class EventOrganizerTransactionPage extends StatefulWidget {
  const EventOrganizerTransactionPage({super.key});

  @override
  State<EventOrganizerTransactionPage> createState() =>
      _EventOrganizerTransactionPageState();
}

class _EventOrganizerTransactionPageState
    extends State<EventOrganizerTransactionPage> {
  final _filterStream = BehaviorSubject<BookingFilter>.seeded(
      BookingFilter(status: Status.pending));

  final PageController _pageController = PageController();

  @override
  void initState() {
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
                      _pageController.jumpToPage(0);
                    },
                  ),
                  _buildFilterButton(
                    label: "Diproses",
                    svgAsset: "assets/svg/order_process_icon.svg",
                    onTap: () {
                      _filterStream
                          .add(BookingFilter(status: Status.confirmed));
                      _pageController.jumpToPage(1);
                    },
                  ),
                  _buildFilterButton(
                    label: "Selesai",
                    svgAsset: "assets/svg/order_done_icon.svg",
                    onTap: () {
                      _filterStream
                          .add(BookingFilter(status: Status.completed));
                      _pageController.jumpToPage(2);
                    },
                  ),
                  _buildFilterButton(
                    label: "Dibatalkan",
                    svgAsset: "assets/svg/order_cancel_icon.svg",
                    onTap: () {
                      _filterStream
                          .add(BookingFilter(status: Status.cancelled));
                      _pageController.jumpToPage(3);
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
              child: StreamBuilder<BookingFilter>(
                  stream: _filterStream,
                  builder: (context, snapshot) {
                    final filter =
                        snapshot.data ?? BookingFilter(status: Status.pending);
                    return PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        EventOrganizerTransactionList(
                          filter: filter,
                        ),
                        EventOrganizerTransactionList(
                          filter: filter,
                        ),
                        EventOrganizerTransactionList(
                          filter: filter,
                        ),
                        EventOrganizerTransactionList(
                          filter: filter,
                        ),
                      ],
                    );
                  }),
            ),
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
