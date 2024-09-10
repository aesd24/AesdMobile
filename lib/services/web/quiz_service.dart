import 'package:aesd_app/requests/quiz_request.dart';

class QuizService {
  final QuizRequest _quizRequest = QuizRequest();

  all({dynamic queryParameters}) async {
    try {
      final response = await _quizRequest.all(queryParameters: queryParameters);

      return response.data;
    } catch (e) {
//
}
  }

  participants({required String slug, required dynamic queryParameters}) async {
    try {
      final response = await _quizRequest.participants(
        slug: slug,
        queryParameters: queryParameters,
      );

      return response.data;
    } catch (e) {
//
}
  }
}
