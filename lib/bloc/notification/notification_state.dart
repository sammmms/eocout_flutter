import 'package:eocout_flutter/models/notification_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';

class NotificationState {
  final List<NotificationData>? notificationList;
  final bool isLoading;
  final bool hasError;
  final AppError? error;

  NotificationState({
    this.notificationList,
    this.isLoading = false,
    this.hasError = false,
    this.error,
  });

  NotificationState copyWith({
    List<NotificationData>? notificationList,
    bool? isLoading,
    bool? hasError,
    AppError? error,
  }) {
    return NotificationState(
      notificationList: notificationList ?? this.notificationList,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      error: error,
    );
  }

  factory NotificationState.initial() {
    return NotificationState();
  }

  factory NotificationState.loading() {
    return NotificationState(isLoading: true);
  }

  factory NotificationState.error(AppError error) {
    return NotificationState(hasError: true, error: error);
  }

  factory NotificationState.success(List<NotificationData> notificationList) {
    return NotificationState(notificationList: notificationList);
  }
}
