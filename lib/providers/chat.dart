import 'package:aesd_app/models/chat_model.dart';
import 'package:aesd_app/models/paginator.dart';
import 'package:aesd_app/services/web/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class Chat extends ChangeNotifier {
  ChatService chatService = ChatService();
  List<ChatModel> _chats = [];
  late Paginator _paginator;

  Future<Tuple2<List<ChatModel>, Paginator>> inbox(
      {dynamic queryParameters}) async {
    _chats = [];
    try {
      final data = await chatService.inbox(queryParameters: queryParameters);

      data['data'].forEach((d) {
        _chats.add(ChatModel.fromJson(d));
      });

      _paginator = Paginator.fromJson(data);
    } catch (e) {
      // ecrire quelque chose !
    }

    return Tuple2(_chats, _paginator);
  }
}
