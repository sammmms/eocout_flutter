import 'package:eocout_flutter/bloc/booking/booking_bloc.dart';
import 'package:eocout_flutter/bloc/booking/booking_state.dart';
import 'package:eocout_flutter/components/my_error_component.dart';
import 'package:eocout_flutter/components/my_no_data_component.dart';
import 'package:eocout_flutter/features/transaction_user/widget/booking_card.dart';
import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/utils/booking_filter.dart';
import 'package:eocout_flutter/utils/status_util.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

            bookings.sort((a, b) => StatusUtil.compare(a.status, b.status));

            return Skeletonizer(
              enabled: isLoading,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    if (widget.bookingFilter.isCompletePayment &&
                        bookings.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Card(
                          color: colorScheme.primary.withOpacity(0.6),
                          elevation: 0,
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Text(
                                  "Anda dapat mengulas setelah penjual menyelesaikan pesanan Anda.",
                                  style: TextStyle(color: Colors.white),
                                )),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                    ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 80),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: bookings.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          BookingData booking = bookings[index];
                          return Provider<BookingBloc>.value(
                              value: _bookingBloc,
                              child: BookingCard(bookingData: booking));
                        }),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
