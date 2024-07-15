import 'package:eocout_flutter/models/booking_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';

class BookingState {
  final List<BookingData>? bookings;
  final bool isLoading;
  final bool hasError;
  final AppError? error;

  BookingState({
    this.bookings,
    this.isLoading = false,
    this.hasError = false,
    this.error,
  });

  BookingState copyWith({
    List<BookingData>? bookings,
    bool? isLoading,
    bool? hasError,
    AppError? error,
  }) {
    return BookingState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      error: error ?? this.error,
    );
  }

  factory BookingState.initial() {
    return BookingState();
  }

  factory BookingState.loading() {
    return BookingState(isLoading: true);
  }

  factory BookingState.error(AppError error) {
    return BookingState(hasError: true, error: error);
  }

  factory BookingState.success(List<BookingData> bookings) {
    return BookingState(bookings: bookings);
  }
}
