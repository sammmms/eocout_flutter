import 'package:eocout_flutter/models/review_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';

class ReviewState {
  final List<ReviewData>? reviews;
  final bool isLoading;
  final bool hasError;
  final AppError? error;

  ReviewState({
    this.reviews,
    this.isLoading = false,
    this.hasError = false,
    this.error,
  });

  ReviewState copyWith({
    List<ReviewData>? reviews,
    bool? isLoading,
    bool? hasError,
    AppError? error,
  }) {
    return ReviewState(
      reviews: reviews ?? this.reviews,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      error: error ?? this.error,
    );
  }

  factory ReviewState.initial() => ReviewState();

  factory ReviewState.loading() => ReviewState(isLoading: true);

  factory ReviewState.error(AppError error) =>
      ReviewState(hasError: true, error: error);

  factory ReviewState.success(List<ReviewData> reviews) =>
      ReviewState(reviews: reviews);
}
