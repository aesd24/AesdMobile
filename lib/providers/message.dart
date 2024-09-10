import 'package:aesd_app/models/message_model.dart';
import 'package:aesd_app/models/paginator.dart';
import 'package:aesd_app/services/web/chat_service.dart';
import 'package:flutter/material.dart';

class Message extends ChangeNotifier {
  ChatService chatService = ChatService();
  List<MessageModel> messages = [];
  late List paginators = [];

  Future all({required int id, dynamic queryParameters}) async {
    try {
      final data = await chatService.getMessages(
          id: id, queryParameters: queryParameters);

      data['data'].forEach((d) {
        messages.removeWhere((m) => m.id == d['id']);

        messages.add(MessageModel.fromJson(d));
      });

      paginators.add({
        'id': id,
        'paginator': Paginator.fromJson(data),
      });
    } catch (e) {
      //
    }

    notifyListeners();
  }

  List<MessageModel> getMessagesByInbox(int id) {
    var m = messages.where((m) => m.inboxId == id).toList();

    m.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });

    return m;
  }

  Paginator getPagintorByInbox(int id) {
    final p = paginators.firstWhere((p) => p['id'] == id);

    return p['paginator'];
  }

  sendMessage({required int id, required MessageModel message}) async {
    await chatService
        .sendMessage(id: id, message: message.message)
        .then((data) {
      addMessage(message);
    });
  }

  addMessageFromSocket(MessageModel message) {
    if (messages.isNotEmpty) {
      addMessage(message);
    }
  }

  addMessage(MessageModel message) {
    messages.insert(0, message);

    notifyListeners();
  }

  empty() {
    messages = [];

    paginators = [];

    notifyListeners();
  }
}
