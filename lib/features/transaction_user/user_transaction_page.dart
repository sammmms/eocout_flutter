import 'package:eocout_flutter/bloc/booking/booking_bloc.dart';
import 'package:eocout_flutter/bloc/booking/booking_state.dart';
import 'package:eocout_flutter/components/my_error_component.dart';
import 'package:eocout_flutter/components/my_no_data_component.dart';
import 'package:eocout_flutter/features/transaction_user/widget/booking_card.dart';
import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/utils/booking_filter.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserTransactionPage extends StatefulWidget {
  const UserTransactionPage({super.key});

  @override
  State<UserTransactionPage> createState() => _UserTransactionPageState();
}

class _UserTransactionPageState extends State<UserTransactionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BookingBloc _bookingBloc = BookingBloc();
  BookingFilter _bookingFilter = BookingFilter.pendingPayment();

  @override
  void initState() {
    // TODO : FILTER TOMORROW USING PASSING NEW PAGE SAJA, DECLARE INIT DISANA BIAR GAK TABRAKAN, DUA BOOKING BLOC JADINYA
    _bookingBloc.getAllBooking(filter: BookingFilter.pendingPayment());
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _bookingFilter = _tabController.index == 0
            ? BookingFilter.pendingPayment()
            : BookingFilter.completedPayment();

        _bookingBloc.getAllBooking(filter: _bookingFilter);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('Informasi Pembayaran'),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            dividerColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            tabs: const [
              Tab(
                text: 'Belum Dibayar',
              ),
              Tab(
                text: 'Sudah Dibayar',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildTransactionList(),
                _buildTransactionList(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return RefreshIndicator(
      onRefresh: () async {
        await _bookingBloc.getAllBooking(filter: _bookingFilter);
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
                  _bookingBloc.getAllBooking(filter: _bookingFilter);
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
