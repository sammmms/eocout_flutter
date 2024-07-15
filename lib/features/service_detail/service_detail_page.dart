import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/bloc/service/service_bloc.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/models/business_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/role_type_util.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';

class ServiceDetailPage extends StatefulWidget {
  final BusinessData businessData;
  const ServiceDetailPage({super.key, required this.businessData});

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  final _currentIndex = BehaviorSubject<int>.seeded(0);
  final _carouselController = CarouselControllerPlus();
  bool _isChecked = false;
  bool isEOOwner = false;
  final _serviceBloc = ServiceBloc();

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

    super.initState();
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
      bottomSheet: _buildBottomAppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: SingleChildScrollView(
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
                            if (index < widget.businessData.images.length &&
                                index != widget.businessData.images.length - 1)
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
                  Positioned(bottom: 20, child: _buildPaginationIndicator())
                ],
              ),

              // DETAIL
              const SizedBox(height: 20),
              Text(widget.businessData.name, style: textTheme.headlineMedium),
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

              // PROMOTION
              if (!isEOOwner) ...[
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

              // REVIEW
              const SizedBox(height: 20),
              Text("Ulasan", style: textTheme.headlineSmall),
            ],
          ),
        ),
      ),
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
      child: isEOOwner
          ? SizedBox(
              width: 150,
              height: 54,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onPressed: () async {
                  AppError? error = await _serviceBloc.deleteService(
                      eoServiceId: widget.businessData.id);

                  if (!mounted) return;
                  if (error != null) {
                    showMySnackBar(
                        context, error.message, SnackbarStatus.error);
                    return;
                  } else {
                    showMySnackBar(context, "Berhasil menghapus layanan",
                        SnackbarStatus.success);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Hapus Layanan",
                  style:
                      textTheme.bodyLarge!.copyWith(color: colorScheme.surface),
                ),
              ),
            )
          : Row(
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
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
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
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 54,
                      child: OutlinedButton(
                          onPressed: () {},
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
