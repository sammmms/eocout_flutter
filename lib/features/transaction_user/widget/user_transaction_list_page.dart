import 'package:eocout_flutter/bloc/booking/booking_bloc.dart';
import 'package:eocout_flutter/bloc/booking/booking_state.dart';
import 'package:eocout_flutter/components/my_error_component.dart';
import 'package:eocout_flutter/components/my_no_data_component.dart';
import 'package:eocout_flutter/features/transaction_user/widget/booking_card.dart';
import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/utils/booking_filter.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserTransactionListPage extends StatefulWidget {
  final BookingFilter bookingFilter;
  const UserTransactionListPage({super.key, required this.bookingFilter});

  @override
  State<UserTransactionListPage> createState() =>
      _UserTransactionListPageState();
}

class _UserTransactionListPageState extends State<UserTransactionListPage> {
  final BookingBloc _bookingBloc = BookingBloc();

  @override
  void initState() {
    _bookingBloc.getAllBooking(filter: widget.bookingFilter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _bookingBloc.getAllBooking(filter: widget.bookingFilter);
      },
      child: StreamBuilder<BookingState>(
          stream: _bookingBloc.stream,
          builder: (context, snapshot) {
            bool isLoading =
                snapshot.data?.isLoading ?? false || !snapshot.hasData;

            bool hasError = snapshot.data?.error != null ||
                (snapshot.data?.hasError ?? false);

            if (hasError) {
              return MyErrorComponent(
                onRefresh: () {
                  _bookingBloc.getAllBooking(filter: widget.bookingFilter);
                },
                error: snapshot.data?.error,
              );
            }

            List<BookingData> bookings = snapshot.data?.bookings ??
                List.generate(5, (_) => BookingData.dummy());

            if (bookings.isEmpty) {
              return const Center(
                child: MyNoDataComponent(
                  label: "Belum ada pesanan nih...",
                ),
              );
            }

            return Skeletonizer(
              enabled: isLoading,
              child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                  itemCount: bookings.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    BookingData booking = bookings[index];
                    return BookingCard(bookingData: booking);
                  }),
            );
          }),
    );
  }
}
