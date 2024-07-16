import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:eocout_flutter/bloc/booking/booking_bloc.dart';
import 'package:eocout_flutter/bloc/booking/booking_state.dart';
import 'package:eocout_flutter/bloc/category/category_bloc.dart';
import 'package:eocout_flutter/bloc/service/service_bloc.dart';
import 'package:eocout_flutter/bloc/service/service_state.dart';
import 'package:eocout_flutter/components/my_error_component.dart';
import 'package:eocout_flutter/components/my_homepage_appbar.dart';
import 'package:eocout_flutter/components/my_no_data_component.dart';
import 'package:eocout_flutter/features/homepage_eo/widget/balance_card.dart';
import 'package:eocout_flutter/features/homepage_eo/widget/eo_recommendation_carousel.dart';
import 'package:eocout_flutter/features/homepage_eo/widget/eo_business_carousel_items.dart';
import 'package:eocout_flutter/features/homepage_eo/widget/today_booking_card.dart';
import 'package:eocout_flutter/features/service_detail/service_detail_page.dart';
import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/models/business_data.dart';
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

  @override
  void initState() {
    _categoryBloc.getCategories();
    _bookingBloc.getBookingRequest();
    _serviceBloc.getOwnService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
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
                const BalanceCard(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Pesanan Hari Ini",
                  style: textTheme.headlineMedium,
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
                              return TodayBookingCard(bookingData: booking);
                            }),
                      );
                    }),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Pengumuman Mitra",
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                const EoRecommendationCarousel(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Bisnis Kamu",
                  style: textTheme.headlineMedium,
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

                      List<BusinessData> businessData =
                          snapshot.data?.businessData ??
                              List.generate(5, (_) => BusinessData.dummy());

                      if (businessData.isEmpty) {
                        return const Center(
                            child: MyNoDataComponent(
                          label: "Tidak ada bisnis.",
                        ));
                      }

                      return Skeletonizer(
                          enabled: isLoading,
                          child: CarouselSlider.builder(
                              itemCount: businessData.length,
                              options: CarouselOptions(
                                  autoPlay: true,
                                  aspectRatio: 16 / 9,
                                  viewportFraction: 1,
                                  enableInfiniteScroll: false),
                              itemBuilder: (context, index, _) {
                                BusinessData business = businessData[index];
                                return EOBusinessCarouselItem(
                                    business: business);
                              }));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
