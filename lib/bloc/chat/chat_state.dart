import 'package:eocout_flutter/models/chat_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';

class ChatState {
  final List<ChatData>? chatList;
  final bool isLoading;
  final bool hasError;
  final AppError? error;

  ChatState(
      {this.chatList,
      this.isLoading = false,
      this.hasError = false,
      this.error});

  ChatState copyWith(
      {List<ChatData>? chatList,
      bool? isLoading,
      bool? hasError,
      AppError? error}) {
    return ChatState(
        chatList: chatList ?? this.chatList,
        isLoading: isLoading ?? this.isLoading,
        hasError: hasError ?? this.hasError,
        error: error ?? this.error);
  }

  factory ChatState.initial() => ChatState();

  factory ChatState.loading() => ChatState(isLoading: true);

  factory ChatState.error(AppError error) =>
      ChatState(hasError: true, error: error);

  factory ChatState.success(List<ChatData> chatList) =>
      ChatState(chatList: chatList);
}
