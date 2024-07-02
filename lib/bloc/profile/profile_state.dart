import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';

class ProfileState {
  final UserData? profile;
  final bool isLoading;
  final bool hasError;
  final AppError? error;

  ProfileState(
      {this.profile,
      this.isLoading = false,
      this.hasError = false,
      this.error});

  factory ProfileState.initial() => ProfileState();

  factory ProfileState.loading() => ProfileState(isLoading: true);

  factory ProfileState.success([UserData? data]) => ProfileState(profile: data);

  factory ProfileState.failure(AppError error) =>
      ProfileState(hasError: true, error: error);
}
