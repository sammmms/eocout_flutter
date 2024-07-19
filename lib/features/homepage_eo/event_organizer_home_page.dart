import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:eocout_flutter/bloc/balance/balance_bloc.dart';
import 'package:eocout_flutter/bloc/balance/balance_state.dart';
import 'package:eocout_flutter/bloc/booking/booking_bloc.dart';
import 'package:eocout_flutter/bloc/booking/booking_state.dart';
import 'package:eocout_flutter/bloc/category/category_bloc.dart';
import 'package:eocout_flutter/bloc/notification/notification_bloc.dart';
import 'package:eocout_flutter/bloc/service/service_bloc.dart';
import 'package:eocout_flutter/bloc/service/service_state.dart';
import 'package:eocout_flutter/components/my_confirmation_dialog.dart';
import 'package:eocout_flutter/components/my_error_component.dart';
import 'package:eocout_flutter/components/my_homepage_appbar.dart';
import 'package:eocout_flutter/components/my_loading_dialog.dart';
import 'package:eocout_flutter/components/my_no_data_component.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/features/homepage_eo/widget/balance_card.dart';
import 'package:eocout_flutter/features/homepage_eo/widget/eo_recommendation_carousel.dart';
import 'package:eocout_flutter/features/homepage_eo/widget/eo_service_item.dart';
import 'package:eocout_flutter/features/homepage_eo/widget/today_booking_card.dart';
import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/models/service_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/status_util.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EventOrganizerHomePage extends StatefulWidget {
  const EventOrganizerHomePage({super.key});

  @override
  State<EventOrganizerHomePage> createState() => _EventOrganizerHomePageState();
}

class _EventOrganizerHomePageState extends State<EventOrganizerHomePage> {
  final _categoryBloc = CategoryBloc();
  final _bookingBloc = BookingBloc();
  final _serviceBloc = ServiceBloc();
  final _balanceBloc = BalanceBloc();

  @override
  void initState() {
    _categoryBloc.getCategories();
    _bookingBloc.getBookingRequest();
    _serviceBloc.getOwnService();
    _balanceBloc.getBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await context.read<NotificationBloc>().fetchNotifications();
            await _categoryBloc.getCategories();
            await _bookingBloc.getBookingRequest();
            await _serviceBloc.getOwnService();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Provider<CategoryBloc>.value(
                    value: _categoryBloc, child: const MyHomepageAppBar()),
                const SizedBox(
                  height: 40,
                ),
                StreamBuilder<BalanceState>(
                    stream: _balanceBloc.stream,
                    builder: (context, snapshot) {
                      bool isLoading = snapshot.data?.isLoading ??
                          false || !snapshot.hasData;

                      bool hasError = snapshot.data?.hasError ?? false;
                      return Skeletonizer(
                          enabled: isLoading,
                          child: BalanceCard(
                            balance: snapshot.data?.currentBalance,
                            hasError: hasError,
                            onRefreshBalance: () => _balanceBloc.getBalance(),
                          ));
                    }),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pesanan Terbaru",
                      style: textTheme.headlineMedium,
                    ),
                    StreamBuilder<BookingState>(
                        stream: _bookingBloc.stream,
                        builder: (context, snapshot) {
                          List<BookingData> bookings =
                              snapshot.data?.bookings ?? [];

                          if (bookings.isEmpty || bookings.length <= 5) {
                            return const SizedBox();
                          }

                          return GestureDetector(
                            onTap: () {
                              context.read<PageController>().animateToPage(2,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Lihat Semua"),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                )
                              ],
                            ),
                          );
                        })
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder<BookingState>(
                    stream: _bookingBloc.stream,
                    builder: (context, snapshot) {
                      bool isLoading = snapshot.data?.isLoading ??
                          false || !snapshot.hasData;

                      bool hasError = snapshot.data?.hasError ?? false;

                      if (hasError) {
                        return MyErrorComponent(
                          onRefresh: () {
                            _bookingBloc.getBookingRequest();
                          },
                          error: snapshot.data?.error,
                        );
                      }

                      List<BookingData> bookings = snapshot.data?.bookings ??
                          List.generate(5, (_) => BookingData.dummy());

                      if (bookings.isEmpty) {
                        return const Center(
                            child: MyNoDataComponent(
                          label: "Tidak ada pesanan.",
                        ));
                      }

                      bookings.sort(
                        (a, b) => StatusUtil.compare(a.status, b.status),
                      );

                      return Skeletonizer(
                        enabled: isLoading,
                        child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                bookings.length > 5 ? 5 : bookings.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 10,
                                ),
                            itemBuilder: (context, index) {
                              BookingData booking = bookings[index];
                              return TodayBookingCard(
                                bookingData: booking,
                                onTap: () async {
                                  Confirmation? confirmOrder = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const MyConfirmationDialog(
                                          label: "Konfirmasi pesanan ini?",
                                          subLabel:
                                              "Konfirmasi bahwa pesanan ini dapat dilakukan pada jadwal yang ditentukan?",
                                          positiveLabel: "Konfirmasi",
                                          negativeLabel: "Batal",
                                        );
                                      });

                                  if (confirmOrder == Confirmation.positive) {
                                    if (!context.mounted) return;

                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const MyLoadingDialog());

                                    AppError? error = await _bookingBloc
                                        .confirmBooking(bookingId: booking.id);

                                    if (!context.mounted) return;

                                    Navigator.pop(context);

                                    if (error != null) {
                                      showMySnackBar(context, error.message,
                                          SnackbarStatus.error);
                                      return;
                                    }

                                    showMySnackBar(
                                        context,
                                        "Berhasil mengonfirmasi pesanan.",
                                        SnackbarStatus.success);

                                    _bookingBloc.getBookingRequest();
                                  }
                                },
                              );
                            }),
                      );
                    }),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Layanan Kamu",
                      style: textTheme.headlineMedium,
                    ),
                    StreamBuilder<ServiceState>(
                        stream: _serviceBloc.stream,
                        builder: (context, snapshot) {
                          List<ServiceData> businessData =
                              snapshot.data?.serviceData ?? [];

                          if (businessData.isEmpty ||
                              businessData.length <= 5) {
                            return const SizedBox();
                          }

                          return GestureDetector(
                            onTap: () {
                              // TODO : CREATE THAT
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Lihat Semua"),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                )
                              ],
                            ),
                          );
                        })
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<ServiceState>(
                    stream: _serviceBloc.stream,
                    builder: (context, snapshot) {
                      bool isLoading = snapshot.data?.isLoading ??
                          false || !snapshot.hasData;

                      bool hasError = snapshot.data?.hasError ?? false;

                      if (hasError) {
                        return MyErrorComponent(
                          onRefresh: () {
                            _serviceBloc.getOwnService();
                          },
                          error: snapshot.data?.error,
                        );
                      }

                      List<ServiceData> businessData =
                          snapshot.data?.serviceData ??
                              List.generate(5, (_) => ServiceData.dummy());

                      if (businessData.isEmpty) {
                        return const Center(
                            child: MyNoDataComponent(
                          label: "Tidak ada layanan.",
                        ));
                      }

                      return Skeletonizer(
                          enabled: isLoading,
                          child: CarouselSlider.builder(
                              itemCount: businessData.length > 5
                                  ? 5
                                  : businessData.length,
                              options: CarouselOptions(
                                  height: 250,
                                  padEnds: false,
                                  enableInfiniteScroll: false,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 5),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn),
                              itemBuilder: (context, index, __) {
                                ServiceData serviceData = businessData[index];
                                return EOServiceItem(
                                  serviceData: serviceData,
                                );
                              }));
                    }),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Pengumuman Mitra",
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                const EoRecommendationCarousel(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
