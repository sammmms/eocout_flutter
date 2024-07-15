import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eocout_flutter/bloc/chat/chat_state.dart';
import 'package:eocout_flutter/bloc/chat/detail_chat_state.dart';
import 'package:eocout_flutter/bloc/image_handle/image_bloc.dart';
import 'package:eocout_flutter/models/chat_data.dart';
import 'package:eocout_flutter/models/chat_message_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/dio_interceptor.dart';
import 'package:eocout_flutter/utils/print_error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';

class ChatBloc {
  final dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL']!));

  final controller = BehaviorSubject<ChatState>.seeded(ChatState.initial());
  final detailChatController =
      BehaviorSubject<DetailChatState>.seeded(DetailChatState.initial());

  ChatBloc() {
    dio.interceptors.add(TokenInterceptor());
  }

  Stream<ChatState> get stream => controller.stream;

  ChatState? get state => controller.valueOrNull;

  Stream<DetailChatState> get detailChatStream => detailChatController.stream;

  DetailChatState? get detailChatState => detailChatController.valueOrNull;

  void dispose() {
    controller.close();
    detailChatController.close();
  }

  void _updateStream(ChatState state) {
    if (controller.isClosed) {
      if (kDebugMode) {
        print("ChatBloc is closed");
      }
      return;
    }
    if (kDebugMode) {
      print("ChatBloc : update stream");
    }
    controller.add(state);
  }

  void _updateDetailChatStream(DetailChatState state) {
    if (detailChatController.isClosed) {
      if (kDebugMode) {
        print("DetailChatBloc is closed");
      }
      return;
    }
    if (kDebugMode) {
      print("DetailChatBloc : update stream");
    }
    detailChatController.add(state);
  }

  AppError _updateError(Object err) {
    AppError error = AppError.fromErr(err);
    _updateStream(ChatState.error(error));
    return error;
  }

  AppError _updateDetailChatError(Object err) {
    AppError error = AppError.fromErr(err);
    _updateDetailChatStream(DetailChatState.error(error));
    return error;
  }

  Future<void> getChatList() async {
    _updateStream(ChatState.loading());
    _updateDetailChatStream(DetailChatState.loading());
    try {
      final response = await dio.get('/chat');

      final data = response.data['data'];

      if (kDebugMode) {
        print("getChatlist : $data");
      }

      List<ChatData> chatList = [];

      for (var chat in data) {
        String? imageId = data['with_user']['profile_pic_media_id'];
        if (imageId == null) {
          chatList.add(ChatData.fromJson(chat));
        } else {
          File? image = await ImageBloc().loadImage(imageId);

          chatList.add(ChatData.fromJson(chat, profilePic: image));
        }
      }

      _updateStream(ChatState.success(chatList));
    } catch (err) {
      printError(err);
      _updateError(err);
    }
  }

  Future<void> getChatMessageHistory({required String chatId}) async {
    detailChatController.add(DetailChatState.loading());
    try {
      final response = await dio.get('/chat/$chatId');

      final data = response.data['data'];

      if (kDebugMode) {
        print("getChatMessageHistory : $data");
      }

      final List<ChatMessageData> chatMessageList =
          data.map((e) => ChatMessageData.fromJson(e)).toList();

      _updateDetailChatStream(DetailChatState.success(chatMessageList));
    } catch (err) {
      final error = AppError.fromErr(err);
      printError(err);
      _updateDetailChatError(error);
    }
  }

  Future<AppError?> sendMessage(
      {required String toUsername, required String message}) async {
    // Get chat message list
    List<ChatMessageData> chatMessageList = detailChatState!.chatMessageList!;

    // Create new chat message data
    ChatMessageData chatMessageData = ChatMessageData(
        content: message,
        createdAt: DateTime.now(),
        isMe: true,
        isLoading: true);

    // Add message to chat list
    chatMessageList.add(chatMessageData);
    try {
      // Update chat list
      await _trySendMessage(chatMessageData, toUsername, chatMessageList);

      //
      return null;
    }
    //
    catch (err) {
      AppError error = AppError.fromErr(err);
      printError(err);
      return error;
    }
  }

  Future<AppError?> resendMessage(
      String toUsername, ChatMessageData chatMessageData) async {
    chatMessageData.isLoading = true;
    chatMessageData.hasError = false;

    _updateDetailChatStream(detailChatState!
        .copyWith(chatMessageList: detailChatState!.chatMessageList));

    List<ChatMessageData> chatMessageList = detailChatState!.chatMessageList!;

    try {
      await _trySendMessage(chatMessageData, toUsername, chatMessageList);
      return null;
    } catch (err) {
      AppError error = AppError.fromErr(err);
      printError(err);
      return error;
    }
  }

  Future<void> _trySendMessage(ChatMessageData chatMessageData,
      String toUsername, List<ChatMessageData> chatMessageList) async {
    _updateDetailChatStream(
        detailChatState!.copyWith(chatMessageList: chatMessageList));
    try {
      final response = await dio.post('/chat', data: {
        'to_username': toUsername,
        'message': chatMessageData.content
      });

      final data = response.data['data'];

      chatMessageData.isLoading = false;

      if (data == null || response.statusCode != 200) {
        chatMessageData.hasError = true;
        _updateDetailChatStream(
            detailChatState!.copyWith(chatMessageList: chatMessageList));
        throw AppError("Failed to send message", 400);
      }

      chatMessageData.createdAt = DateTime.parse(data['created_at']).toLocal();
      _updateDetailChatStream(
          detailChatState!.copyWith(chatMessageList: chatMessageList));

      if (kDebugMode) {
        print("sentMessage : $data");
      }
    } catch (err) {
      chatMessageData.isLoading = false;
      chatMessageData.hasError = true;
      _updateDetailChatStream(
          detailChatState!.copyWith(chatMessageList: chatMessageList));
      rethrow;
    }
  }

  /// Create a new chat (simulation)
  Future<void> createNewChat() async {
    _updateDetailChatStream(DetailChatState.success([]));
  }
}
