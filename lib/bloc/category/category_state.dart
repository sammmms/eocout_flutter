import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/business_type_util.dart';

class CategoryState {
  final List<EOCategory>? categories;
  final bool isLoading;
  final bool hasError;
  final AppError? error;

  CategoryState(
      {this.categories,
      this.isLoading = false,
      this.hasError = false,
      this.error});

  CategoryState copyWith(
      {List<EOCategory>? categories,
      bool? isLoading,
      bool? hasError,
      AppError? error}) {
    return CategoryState(
        categories: categories ?? this.categories,
        isLoading: isLoading ?? this.isLoading,
        hasError: hasError ?? this.hasError,
        error: error ?? this.error);
  }

  factory CategoryState.initial() {
    return CategoryState();
  }

  factory CategoryState.loading() {
    return CategoryState(isLoading: true);
  }

  factory CategoryState.error(AppError error) {
    return CategoryState(hasError: true, error: error);
  }

  factory CategoryState.success(List<EOCategory> categories) {
    return CategoryState(categories: categories);
  }
}

class EOCategory {
  final String id;
  final BusinessType businessType;

  EOCategory({required this.id, required this.businessType});

  factory EOCategory.fromJson(Map<String, dynamic> json) {
    return EOCategory(
        id: json['id'],
        businessType: BusinessTypeUtil.fromString(json['name']));
  }

  factory EOCategory.dummy() {
    return EOCategory(id: "", businessType: BusinessType.publicEvent);
  }
}
