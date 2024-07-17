import 'dart:convert';
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
import 'package:eocout_flutter/utils/store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatBloc {
  final dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL']!));

  final controller = BehaviorSubject<ChatState>.seeded(ChatState.initial());
  final detailChatController =
      BehaviorSubject<DetailChatState>.seeded(DetailChatState.initial());

  WebSocketChannel? channel;

  ChatBloc() {
    dio.interceptors.add(TokenInterceptor());
  }

  Stream<ChatState> get stream => controller.stream;

  ChatState? get state => controller.valueOrNull;

  Stream<DetailChatState> get detailChatStream => detailChatController.stream;

  DetailChatState? get detailChatState => detailChatController.valueOrNull;

  void dispose() {
    if (kDebugMode) {
      print("disposing chat");
    }
    controller.close();
    detailChatController.close();
    channel?.sink.close();
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

  Future<void> getChatList({bool needLoading = true}) async {
    if (needLoading) _updateStream(ChatState.loading());
    _updateDetailChatStream(DetailChatState.loading());
    try {
      final response = await dio.get('/chat');

      final data = response.data['data'];

      if (kDebugMode) {
        print("getChatlist : $data");
      }

      List<ChatData> chatList = [];

      for (var chat in data) {
        String? imageId = chat['with_user']['profile_pic_media_id'];
        if (imageId == null) {
          chatList.add(ChatData.fromJson(chat));
        } else {
          File? image = await ImageBloc().loadImage(imageId);

          chatList.add(ChatData.fromJson(chat, profilePic: image));
        }
      }

      _updateStream(ChatState.success(chatList));
    } catch (err) {
      printError(err, method: "getChatList");
      _updateError(err);
    }
  }

  Future<void> getChatMessageHistory({required String chatId}) async {
    _updateDetailChatStream(DetailChatState.loading());
    try {
      final response = await dio.get('/chat/$chatId');

      final data = response.data['data'];

      if (kDebugMode) {
        print("getChatMessageHistory : $data");
      }

      final List<ChatMessageData> chatMessageList = data
          .map<ChatMessageData>((e) => ChatMessageData.fromJson(e))
          .toList();

      _updateDetailChatStream(DetailChatState.success(chatMessageList));
    } catch (err) {
      final error = AppError.fromErr(err);
      printError(err, method: "getChatMessageHistory");
      _updateDetailChatError(error);
    }
  }

  // When no chat id, or never chat before, REST instead
  Future<AppError?> sendNewMessage(
      {required String toUsername, required String content}) async {
    // Get chat message list
    List<ChatMessageData> chatMessageList = detailChatState!.chatMessageList!;

    // Create new chat message data
    ChatMessageData chatMessageData = ChatMessageData(
        content: content,
        createdAt: DateTime.now(),
        isMe: true,
        isLoading: true);

    // Add message to chat list
    chatMessageList.add(chatMessageData);
    _updateDetailChatStream(
        detailChatState!.copyWith(chatMessageList: chatMessageList));
    return _trySendNewMessage(
        chatMessageList: chatMessageList,
        toUsername: toUsername,
        chatMessageData: chatMessageData);
  }

  Future<AppError?> resendNewMessage(
      {required String toUsername,
      required ChatMessageData chatMessageData}) async {
    chatMessageData.isLoading = true;
    chatMessageData.hasError = false;

    _updateDetailChatStream(detailChatState!
        .copyWith(chatMessageList: detailChatState!.chatMessageList));

    List<ChatMessageData> chatMessageList = detailChatState!.chatMessageList!;
    return _trySendNewMessage(
        chatMessageList: chatMessageList,
        toUsername: toUsername,
        chatMessageData: chatMessageData);
  }

  Future<AppError?> _trySendNewMessage({
    required List<ChatMessageData> chatMessageList,
    required String toUsername,
    required ChatMessageData chatMessageData,
  }) async {
    try {
      var response = await dio.post("/chat", data: {
        "to_username": toUsername,
        "message": chatMessageData.content
      });

      await channel?.ready;

      if (response.statusCode == 200) {
        chatMessageData.isLoading = false;
        _updateDetailChatStream(
            detailChatState!.copyWith(chatMessageList: chatMessageList));
      }
    }
    //
    catch (err) {
      chatMessageData.hasError = true;

      AppError error = AppError.fromErr(err);
      printError(err, method: "resendNewMessage");
      return error;
    } finally {
      chatMessageData.isLoading = false;
      _updateDetailChatStream(
          detailChatState!.copyWith(chatMessageList: chatMessageList));
    }
    return null;
  }

  // Send message where id is provided
  Future<AppError?> sendMessage(
      {required String chatId, required String content}) async {
    // Get chat message list
    List<ChatMessageData> chatMessageList = detailChatState!.chatMessageList!;

    // Create new chat message data
    ChatMessageData chatMessageData = ChatMessageData(
        content: content,
        createdAt: DateTime.now(),
        isMe: true,
        isLoading: true);

    // Add message to chat list
    chatMessageList.add(chatMessageData);
    try {
      // Update chat list
      await _trySendMessage(
          chatMessageData: chatMessageData,
          chatId: chatId,
          chatMessageList: chatMessageList);

      //
      return null;
    }
    //
    catch (err) {
      AppError error = AppError.fromErr(err);
      printError(err, method: "sendMessage");
      return error;
    }
  }

  Future<AppError?> resendMessage(
      {required String chatId,
      required ChatMessageData chatMessageData}) async {
    chatMessageData.isLoading = true;
    chatMessageData.hasError = false;

    List<ChatMessageData> chatMessageList = detailChatState!.chatMessageList!;
    try {
      await _trySendMessage(
          chatMessageData: chatMessageData,
          chatId: chatId,
          chatMessageList: chatMessageList);
      return null;
    } catch (err) {
      AppError error = AppError.fromErr(err);
      printError(err, method: "resendMessage");
      return error;
    }
  }

  Future<void> _trySendMessage(
      {required ChatMessageData chatMessageData,
      required String chatId,
      required List<ChatMessageData> chatMessageList}) async {
    _updateDetailChatStream(
        detailChatState!.copyWith(chatMessageList: chatMessageList));
    try {
      if (channel == null || channel?.closeReason != null) {
        AppError? error = await connectToChat(chatId, loading: false);
        if (error != null) {
          throw error;
        }
      }

      Map<String, dynamic> data = {
        "chat_id": chatId,
        "content": chatMessageData.content
      };

      channel!.sink.add(jsonEncode(data));

      if (kDebugMode) {
        print("Sucessfully send message");
      }
      return;
    } catch (err) {
      printError(err, method: "trySendMessage");
      chatMessageData.hasError = true;

      rethrow;
    } finally {
      chatMessageData.isLoading = false;
      _updateDetailChatStream(
          detailChatState!.copyWith(chatMessageList: chatMessageList));
    }
  }

  Future<AppError?> connectToChat(String chatId, {loading = true}) async {
    try {
      // _updateDetailChatStream(detailChatState!.copyWith(isLoading: loading));

      String webSocketUrl = dotenv.env['WS_URL']!;

      Uri uri = Uri.parse("$webSocketUrl/ws");

      if (kDebugMode) {
        print(uri.toString());
      }

      String token = await Store.getToken();

      if (channel != null) {
        channel?.sink.close();
        channel = null;
      }

      channel = IOWebSocketChannel.connect(uri,
          headers: {'Authorization': 'Bearer $token'});

      await channel?.ready;

      channel?.stream.listen(
        (data) {
          if (kDebugMode) {
            print("Chat data : $data");
          }

          Map<String, dynamic> message = {};
          if (data is String) {
            message = jsonDecode(data);
          } else {
            message = data;
          }

          if (message['content'] != null) {
            ChatMessageData chatMessageData = ChatMessageData.fromJson(message);
            List<ChatMessageData> chatMessageList =
                detailChatState!.chatMessageList!;

            chatMessageList.add(chatMessageData);

            _updateDetailChatStream(
                detailChatState!.copyWith(chatMessageList: chatMessageList));
          }
        },
        onError: (err) {
          printError(err, method: "chatListenError");
        },
        onDone: () {
          if (kDebugMode) {
            print("Chat done");
          }
        },
      );

      if (kDebugMode) {
        print("Connected to chat");
      }

      channel?.sink.add(
        jsonEncode({
          'type': 'subscribe',
          'chat_id': chatId,
        }),
      );

      return null;
    } catch (err) {
      channel?.sink.close();
      channel = null;
      printError(err, method: "connectToChat");
      return AppError("Gagal terhubung ke chat", 400);
    } finally {
      _updateDetailChatStream(detailChatState!.copyWith(isLoading: false));
    }
  }

  /// Create a new chat (simulation)
  Future<void> createNewChat() async {
    _updateDetailChatStream(DetailChatState.success([]));
  }
}
