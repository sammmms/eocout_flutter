import 'package:eocout_flutter/utils/app_error.dart';

class BalanceState {
  final int? currentBalance;
  final bool isLoading;
  final bool hasError;
  final AppError? error;

  BalanceState({
    this.currentBalance,
    this.isLoading = false,
    this.hasError = false,
    this.error,
  });

  BalanceState copyWith({
    int? currentBalance,
    bool? isLoading,
    bool? hasError,
    AppError? error,
  }) {
    return BalanceState(
      currentBalance: currentBalance ?? this.currentBalance,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      error: error ?? this.error,
    );
  }

  factory BalanceState.initial() {
    return BalanceState();
  }

  factory BalanceState.loading() {
    return BalanceState(isLoading: true);
  }

  factory BalanceState.error(AppError error) {
    return BalanceState(hasError: true, error: error);
  }

  factory BalanceState.success(int currentBalance) {
    return BalanceState(currentBalance: currentBalance);
  }
}
