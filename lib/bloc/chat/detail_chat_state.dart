import 'package:eocout_flutter/models/chat_message_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';

class DetailChatState {
  final List<ChatMessageData>? chatMessageList;
  final bool isLoading;
  final bool hasError;
  final AppError? error;

  DetailChatState(
      {this.chatMessageList,
      this.isLoading = false,
      this.hasError = false,
      this.error});

  DetailChatState copyWith(
      {List<ChatMessageData>? chatMessageList,
      bool? isLoading,
      bool? hasError,
      AppError? error}) {
    return DetailChatState(
        chatMessageList: chatMessageList ?? this.chatMessageList,
        isLoading: isLoading ?? this.isLoading,
        hasError: hasError ?? this.hasError,
        error: error ?? this.error);
  }

  factory DetailChatState.initial() => DetailChatState();

  factory DetailChatState.loading() => DetailChatState(isLoading: true);

  factory DetailChatState.error(AppError error) =>
      DetailChatState(hasError: true, error: error);

  factory DetailChatState.success(List<ChatMessageData> chatMessageList) =>
      DetailChatState(chatMessageList: chatMessageList);
}
