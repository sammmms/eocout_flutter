import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/error_status.dart';

class ProfileState {
  final UserData? profile;
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final ErrorStatus? error;

  ProfileState(
      {this.profile,
      this.isLoading = false,
      this.isSuccess = false,
      this.isFailure = false,
      this.error});

  factory ProfileState.loading() => ProfileState(isLoading: true);

  factory ProfileState.success() => ProfileState(isSuccess: true);

  factory ProfileState.failure(ErrorStatus error) =>
      ProfileState(isFailure: true, error: error);
}
