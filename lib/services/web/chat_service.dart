import 'package:aesd_app/requests/chat_request.dart';

class ChatService {
  final ChatRequest _chatRequest = ChatRequest();

  inbox({dynamic queryParameters}) async {
    try {
      final response =
          await _chatRequest.inbox(queryParameters: queryParameters);

      return response.data;
    } catch (e) {
      ////print(e);
    }
  }

  getMessages({required int id, dynamic queryParameters}) async {
    try {
      final response =
          await _chatRequest.message(id: id, queryParameters: queryParameters);

      return response.data;
    } catch (e) {
      ////print(e);
    }
  }

  sendMessage({required int id, required String message}) async {
    try {
      final response = await _chatRequest.sendMessage(id: id, message: message);

      return response.data;
    } catch (e) {
      ////print(e);
    }
  }
}
