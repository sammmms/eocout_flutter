import 'package:eocout_flutter/models/service_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';

class ServiceState {
  List<ServiceData>? businessData;
  final bool isLoading;
  final bool hasError;
  final AppError? error;

  ServiceState({
    this.businessData,
    this.isLoading = false,
    this.hasError = false,
    this.error,
  });

  ServiceState copyWith({
    List<ServiceData>? businessData,
    bool? isLoading,
    bool? hasError,
    AppError? error,
  }) {
    return ServiceState(
      businessData: businessData ?? this.businessData,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      error: error ?? this.error,
    );
  }

  factory ServiceState.initial() {
    return ServiceState();
  }

  factory ServiceState.loading() {
    return ServiceState(isLoading: true);
  }

  factory ServiceState.error(AppError error) {
    return ServiceState(hasError: true, error: error);
  }

  factory ServiceState.success(List<ServiceData> businessData) {
    return ServiceState(businessData: businessData);
  }
}
