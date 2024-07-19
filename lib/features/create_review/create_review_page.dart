import 'package:collection/collection.dart';
import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/bloc/review/review_bloc.dart';
import 'package:eocout_flutter/bloc/review/review_state.dart';
import 'package:eocout_flutter/components/my_error_component.dart';
import 'package:eocout_flutter/components/my_review_card.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/models/service_data.dart';
import 'package:eocout_flutter/models/review_data.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CreateReviewPage extends StatefulWidget {
  final BookingData bookingData;
  const CreateReviewPage({super.key, required this.bookingData});

  @override
  State<CreateReviewPage> createState() => _CreateReviewPageState();
}

class _CreateReviewPageState extends State<CreateReviewPage> {
  final ReviewBloc bloc = ReviewBloc();
  late BookingData bookingData;
  late ServiceData businessData;

  late EditableReviewData reviewData;

  @override
  void initState() {
    bookingData = widget.bookingData;
    businessData = widget.bookingData.businessData;

    bloc.fetchReviews(businessData.id);

    reviewData = EditableReviewData(
      serviceId: bookingData.businessData.id,
    );
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
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text('Ulas Event'),
      ),
      body: StreamBuilder<ReviewState>(
          stream: bloc.stream,
          builder: (context, snapshot) {
            bool isLoading =
                snapshot.data?.isLoading ?? false || !snapshot.hasData;

            bool hasError = snapshot.data?.hasError ?? false;

            if (hasError) {
              return MyErrorComponent(onRefresh: () {
                bloc.fetchReviews(businessData.id);
              });
            }

            List<ReviewData> reviews = snapshot.data?.reviews ?? [];

            UserData? userData = context.read<AuthBloc>().state?.user;

            ReviewData? myReview = reviews.firstWhereOrNull(
              (element) => element.user.username == userData?.username,
            );

            bool canReview = myReview == null;

            return Skeletonizer(
              enabled: isLoading,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: businessData.images.isNotEmpty
                                  ? Image.file(
                                      businessData.images.first,
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/placeholder.png',
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(businessData.companyName,
                                      style: textTheme.titleMedium),
                                  Text(businessData.name,
                                      style: textTheme.titleSmall),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          height: 40,
                        ),
                        Text("Location : ${businessData.location}"),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                            "Date : ${DateFormat('dd MMMM yyyy').format(bookingData.bookingDate)}"),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          NumberFormat.currency(locale: 'id', symbol: 'Rp')
                              .format(businessData.price),
                          style: textTheme.titleMedium,
                        ),
                      ],
                    ),
                  )),
                  if (canReview) ...[
                    const SizedBox(height: 20),
                    Text("Ulasan anda", style: textTheme.headlineMedium),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Ulasan',
                      ),
                      maxLines: 5,
                      minLines: 5,
                      textAlign: TextAlign.start,
                      onChanged: (value) {
                        reviewData.comment = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Rating", style: textTheme.titleLarge),
                        const SizedBox(width: 20),
                        Row(
                          children: _clickableReviewStar(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        AppError? error = await bloc.createReview(
                            eoServiceId: reviewData.serviceId,
                            reviewData: reviewData);

                        if (!context.mounted) return;

                        if (error != null) {
                          showMySnackBar(
                              context, error.message, SnackbarStatus.error);
                          return;
                        }

                        showMySnackBar(context, "Berhasil menambahkan review",
                            SnackbarStatus.success);
                      },
                      child: const Text('Submit'),
                    ),
                  ] else ...[
                    const SizedBox(height: 20),
                    Text("Anda sudah memberikan ulasan",
                        style: textTheme.headlineMedium),
                    const SizedBox(height: 20),
                    MyReviewCard(review: myReview),
                  ],
                ],
              ),
            );
          }),
    );
  }

  List<Widget> _clickableReviewStar() {
    return List.generate(5, (index) {
      return GestureDetector(
        onTap: () {
          reviewData.rating = index + 1;
          setState(() {});
        },
        child: Icon(
          reviewData.rating >= index + 1
              ? Icons.star_rounded
              : Icons.star_outline_rounded,
          color: reviewData.rating >= index + 1 ? Colors.yellow : Colors.grey,
        ),
      );
    });
  }
}
