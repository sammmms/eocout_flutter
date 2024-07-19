import 'package:eocout_flutter/models/service_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';

class ServiceState {
  List<ServiceData>? serviceData;
  final bool isLoading;
  final bool hasError;
  final AppError? error;

  ServiceState({
    this.serviceData,
    this.isLoading = false,
    this.hasError = false,
    this.error,
  });

  ServiceState copyWith({
    List<ServiceData>? serviceData,
    bool? isLoading,
    bool? hasError,
    AppError? error,
  }) {
    return ServiceState(
      serviceData: serviceData ?? this.serviceData,
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

  factory ServiceState.success(List<ServiceData> serviceData) {
    return ServiceState(serviceData: serviceData);
  }
}
