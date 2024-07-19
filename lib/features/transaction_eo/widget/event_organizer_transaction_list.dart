import 'package:eocout_flutter/bloc/booking/booking_bloc.dart';
import 'package:eocout_flutter/components/my_error_component.dart';
import 'package:eocout_flutter/components/my_no_data_component.dart';
import 'package:eocout_flutter/features/transaction_eo/widget/transaction_card.dart';
import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/utils/booking_filter.dart';
import 'package:flutter/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EventOrganizerTransactionList extends StatefulWidget {
  final BookingFilter filter;
  const EventOrganizerTransactionList({super.key, required this.filter});

  @override
  State<EventOrganizerTransactionList> createState() =>
      _EventOrganizerTransactionListState();
}

class _EventOrganizerTransactionListState
    extends State<EventOrganizerTransactionList> {
  final _bookingBloc = BookingBloc();

  @override
  void initState() {
    _bookingBloc.getBookingRequest(bookingFilter: widget.filter);
    super.initState();
  }

  @override
  void dispose() {
    _bookingBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _bookingBloc.controller,
        builder: (context, snapshot) {
          bool isLoading =
              snapshot.data?.isLoading ?? false || !snapshot.hasData;

          bool hasError = snapshot.data?.hasError ?? false;

          if (hasError) {
            return MyErrorComponent(onRefresh: () {
              _bookingBloc.getBookingRequest(bookingFilter: widget.filter);
            });
          }

          List<BookingData> bookingDataList = snapshot.data?.bookings ??
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
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
        });
  }
}
