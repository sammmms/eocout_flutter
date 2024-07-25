import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/bloc/booking/booking_bloc.dart';
import 'package:eocout_flutter/bloc/booking/booking_state.dart';
import 'package:eocout_flutter/bloc/review/review_bloc.dart';
import 'package:eocout_flutter/bloc/review/review_state.dart';
import 'package:eocout_flutter/bloc/service/service_bloc.dart';
import 'package:eocout_flutter/components/my_confirmation_dialog.dart';
import 'package:eocout_flutter/components/my_error_component.dart';
import 'package:eocout_flutter/components/my_no_data_component.dart';
import 'package:eocout_flutter/components/my_review_card.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/chat_page/chat_detail_page.dart';
import 'package:eocout_flutter/features/review/review_page.dart';
import 'package:eocout_flutter/models/service_data.dart';
import 'package:eocout_flutter/models/review_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/role_type_util.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ServiceDetailPage extends StatefulWidget {
  final ServiceData businessData;
  const ServiceDetailPage({super.key, required this.businessData});

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  final _currentIndex = BehaviorSubject<int>.seeded(0);
  final _carouselController = CarouselControllerPlus();
  bool _isChecked = false;
  bool isEOOwner = false;
  final _choosenDate = BehaviorSubject<DateTime>();
  final _serviceBloc = ServiceBloc();
  final _bookingBloc = BookingBloc();
  final _datePickerKey = GlobalKey();
  final _scrollController = ScrollController();
  final _reviewBloc = ReviewBloc();

  @override
  void initState() {
    _currentIndex.listen((event) {
      _carouselController.animateToPage(event);
    });

    final userData = context.read<AuthBloc>().controller.valueOrNull?.user;

    if (userData != null) {
      if (userData.role == UserRole.eventOrganizer &&
          userData.username == widget.businessData.profile.username) {
        isEOOwner = true;
      }
    }

    _reviewBloc.fetchReviews(widget.businessData.id);

    super.initState();
  }

  @override
  void dispose() {
    _choosenDate.close();
    _currentIndex.close();
    _serviceBloc.dispose();
    _bookingBloc.dispose();
    _reviewBloc.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: const Text("Detail"),
        actions: [
          GestureDetector(
              onTap: () {
                Share.share(
                    "Check out this event: ${widget.businessData.name} at ${widget.businessData.location}");
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SvgPicture.asset("assets/svg/share_icon.svg"),
              ))
        ],
        scrolledUnderElevation: 0,
      ),
      bottomSheet: isEOOwner ? null : _buildBottomAppBar(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, isEOOwner ? 10 : 80),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CarouselSlider(
                            items: widget.businessData.images
                                .map((e) => SizedBox(
                                      height: 400,
                                      width: 400,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.memory(
                                          e.readAsBytesSync(),
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            controller: _carouselController,
                            options: CarouselOptions(
                                autoPlay: true,
                                onPageChanged: (index, reason) {
                                  _currentIndex.add(index);
                                },
                                aspectRatio: 1 / 1,
                                enableInfiniteScroll: false,
                                padEnds: true,
                                pageSnapping: true,
                                viewportFraction: 1)),
                        StreamBuilder<int>(
                            stream: _currentIndex,
                            initialData: 0,
                            builder: (context, snapshot) {
                              int index = snapshot.data!;
                              return Row(
                                children: [
                                  if (index > 0)
                                    GestureDetector(
                                        onTap: () {
                                          _currentIndex.add(index - 1);
                                        },
                                        child: const Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          color: Colors.white,
                                        )),
                                  const Spacer(),
                                  if (index <
                                          widget.businessData.images.length &&
                                      index !=
                                          widget.businessData.images.length - 1)
                                    GestureDetector(
                                        onTap: () {
                                          _currentIndex.add(index + 1);
                                        },
                                        child: const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.white)),
                                ],
                              );
                            }),
                        Positioned(
                            bottom: 20, child: _buildPaginationIndicator())
                      ],
                    ),

                    // DETAIL
                    const SizedBox(height: 20),
                    Text(widget.businessData.companyName,
                        style: textTheme.headlineMedium),
                    const SizedBox(height: 20),
                    Text(
                      widget.businessData.name,
                      style: textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.businessData.description,
                      style: textTheme.bodyMedium,
                    ),

                    // LOCATION
                    const SizedBox(height: 20),
                    Text(
                      "Lokasi",
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.businessData.location,
                      style: textTheme.bodyMedium,
                    ),

                    // LOCATION
                    if (!isEOOwner) ...[
                      const SizedBox(height: 20),
                      Text(
                        "Tanggal dan Waktu",
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      _buildDatePicker()
                    ],

                    // PROMOTION
                    if (!isEOOwner &&
                        widget.businessData
                            .isAcceptPartyPromotionOrMarketing) ...[
                      const SizedBox(height: 20),
                      Text("Pemasaran dan Promosi Acara",
                          style: textTheme.headlineSmall),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Kami akan membantu anda dalam memasarkan dan mempromosikan acara anda agar lebih dikenal oleh masyarakat luas.",
                              style: textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Checkbox(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            visualDensity: VisualDensity.compact,
                            activeColor: colorScheme.tertiary,
                            value: _isChecked,
                            onChanged: (_) {
                              setState(() {
                                _isChecked = !_isChecked;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // REVIEW
              StreamBuilder<ReviewState>(
                  stream: _reviewBloc.controller,
                  builder: (context, snapshot) {
                    bool isLoading =
                        snapshot.data?.isLoading ?? false || !snapshot.hasData;

                    bool hasError = snapshot.data?.hasError ?? false;

                    if (hasError) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 60),
                        child: MyErrorComponent(onRefresh: () {
                          _reviewBloc.fetchReviews(widget.businessData.id);
                        }),
                      );
                    }

                    List<ReviewData> reviews = snapshot.data?.reviews ??
                        List.generate(7, (index) => ReviewData.dummy());
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Ulasan", style: textTheme.headlineSmall),
                              if (reviews.length > 7)
                                GestureDetector(
                                  onTap: () {
                                    navigateTo(
                                        context,
                                        Provider<ReviewBloc>.value(
                                            value: _reviewBloc,
                                            child: ReviewPage(
                                              businessData: widget.businessData,
                                            )),
                                        transition:
                                            TransitionType.slideInFromRight);
                                  },
                                  child: Row(
                                    children: [
                                      Text("Lihat semua",
                                          style: textTheme.bodyMedium!.copyWith(
                                              color: colorScheme.tertiary)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.arrow_forward_ios_rounded,
                                          color: colorScheme.tertiary)
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (reviews.isEmpty)
                          const Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 80),
                            child: MyNoDataComponent(
                              label: "Belum ada ulasan",
                            ),
                          )
                        else
                          Skeletonizer(
                              enabled: isLoading,
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount:
                                      reviews.length > 7 ? 7 : reviews.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 40),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 10),
                                  itemBuilder: (context, index) {
                                    ReviewData review = reviews[index];
                                    return MyReviewCard(review: review);
                                  })),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Theme(
      data: Theme.of(context).copyWith(
          datePickerTheme: DatePickerThemeData(
        headerForegroundColor: Colors.white,
        headerBackgroundColor: colorScheme.tertiary,
      )),
      child: StreamBuilder<DateTime>(
          stream: _choosenDate,
          builder: (context, snapshot) {
            return Row(
              key: _datePickerKey,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 2))
                          .then((value) {
                        if (value != null) {
                          _choosenDate.add(value);
                        }
                      });
                    },
                    child: const Text("Pilih tanggal")),
                const SizedBox(
                  width: 10,
                ),
                if (snapshot.data != null)
                  Text(
                    DateFormat("dd MMMM yyyy").format(snapshot.data!),
                    style: textTheme.bodyMedium,
                  ),
              ],
            );
          }),
    );
  }

  Widget _buildPaginationIndicator() {
    return StreamBuilder<int>(
        stream: _currentIndex,
        initialData: 0,
        builder: (context, snapshot) {
          int index = snapshot.data!;
          return Row(
            children: List.generate(
                widget.businessData.images.length,
                (idx) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: idx == index ? Colors.white : Colors.grey,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 10,
                      width: 10,
                    )),
          );
        });
  }

  Widget _buildBottomAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              NumberFormat.currency(
                      locale: 'id', symbol: 'Rp', decimalDigits: 0)
                  .format(widget.businessData.price),
              style: textTheme.headlineMedium),
          Row(
            children: [
              SizedBox(
                height: 54,
                child: StreamBuilder<BookingState>(
                    stream: _bookingBloc.stream,
                    builder: (context, snapshot) {
                      bool isLoading = snapshot.data?.isLoading ?? false;
                      return OutlinedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (_choosenDate.valueOrNull == null) {
                                  showMySnackBar(
                                      context,
                                      "Pilih tanggal terlebih dahulu",
                                      SnackbarStatus.error);
                                  RenderBox box = _datePickerKey.currentContext
                                      ?.findRenderObject() as RenderBox;
                                  Offset position =
                                      box.localToGlobal(Offset.zero);
                                  _scrollController.animateTo(position.dy,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut);
                                  return;
                                }

                                Confirmation? confirmation = await showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const MyConfirmationDialog(
                                          label: "Ingin memesan layanan ini?",
                                          subLabel:
                                              "Apakah anda yang ingin memesan layanan ini?\n\nLayanan hanya dapat di batalkan sebelum Vendor mengonfirmasi layanan.",
                                          negativeLabel: "Tidak",
                                          positiveLabel: "Ya, saya mau",
                                        ));

                                if (confirmation == Confirmation.negative ||
                                    confirmation == null) return;

                                AppError? error =
                                    await _bookingBloc.createBooking(
                                  serviceId: widget.businessData.id,
                                  bookingDate: _choosenDate.value,
                                );

                                if (!context.mounted) return;
                                if (error != null) {
                                  showMySnackBar(context, error.message,
                                      SnackbarStatus.error);
                                } else {
                                  showMySnackBar(
                                      context,
                                      "Berhasil membuat pesanan terhadap layanan",
                                      SnackbarStatus.success);
                                  Navigator.pop(context);
                                }
                              },
                        style: OutlinedButton.styleFrom(
                            backgroundColor: isLoading ? Colors.grey : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "Pesan",
                            style: textTheme.bodyLarge!
                                .copyWith(color: colorScheme.surface),
                          ),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 54,
                child: OutlinedButton(
                    onPressed: () {
                      navigateTo(
                          context,
                          ChatDetailPage(
                            withUser: widget.businessData.profile,
                          ),
                          transition: TransitionType.slideInFromRight);
                    },
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                    child: SvgPicture.asset("assets/svg/chat_icon.svg")),
              )
            ],
          )
        ],
      ),
    );
  }
}
