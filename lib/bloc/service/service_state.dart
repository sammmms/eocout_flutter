import 'package:eocout_flutter/models/business_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/business_type_util.dart';

class ServiceState {
  List<BusinessData> businessData;
  final bool isLoading;
  final bool hasError;
  final AppError? error;

  ServiceState({
    this.businessData = const [],
    this.isLoading = false,
    this.hasError = false,
    this.error,
  });

  ServiceState copyWith({
    List<BusinessData>? businessData,
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

  factory ServiceState.success(List<BusinessData> businessData) {
    return ServiceState(businessData: businessData);
  }
}
