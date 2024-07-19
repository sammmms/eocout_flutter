import 'package:eocout_flutter/bloc/review/review_bloc.dart';
import 'package:eocout_flutter/bloc/review/review_state.dart';
import 'package:eocout_flutter/components/my_error_component.dart';
import 'package:eocout_flutter/components/my_review_card.dart';
import 'package:eocout_flutter/models/review_data.dart';
import 'package:eocout_flutter/models/service_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReviewPage extends StatefulWidget {
  final ServiceData businessData;
  const ReviewPage({super.key, required this.businessData});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late ReviewBloc _reviewBloc;

  @override
  void initState() {
    _reviewBloc = context.read<ReviewBloc>();
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
        title: const Text('Semua Ulasan'),
      ),
      body: StreamBuilder<ReviewState>(
          stream: _reviewBloc.controller,
          builder: (context, snapshot) {
            bool isLoading =
                snapshot.data?.isLoading ?? false || !snapshot.hasData;

            bool hasError = snapshot.data?.hasError ?? false;

            if (hasError) {
              return MyErrorComponent(onRefresh: () {
                _reviewBloc.fetchReviews(widget.businessData.id);
              });
            }

            List<ReviewData> reviews = snapshot.data?.reviews ??
                List.generate(7, (index) => ReviewData.dummy());
            return RefreshIndicator(
              onRefresh: () async {
                await _reviewBloc.fetchReviews(widget.businessData.id);
              },
              child: Skeletonizer(
                  enabled: isLoading,
                  child: ListView.separated(
                      itemCount: reviews.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        ReviewData review = reviews[index];
                        return MyReviewCard(review: review);
                      })),
            );
          }),
    );
  }
}
