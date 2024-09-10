import 'package:dio/dio.dart';
import 'package:aesd_app/exceptions/http_form_validation_exception.dart';
import 'package:aesd_app/requests/course_request.dart';

class CourseService {
  final CourseRequest _coursesRequest = CourseRequest();

  deferred({dynamic queryParameters}) async {
    try {
      final response =
          await _coursesRequest.deferred(queryParameters: queryParameters);

      return response.data;
    } catch (e) {
//
}
  }

  streams({dynamic queryParameters}) async {
    try {
      final response =
          await _coursesRequest.streams(queryParameters: queryParameters);

      return response.data;
    } catch (e) {
      ////print(e);
    }
  }

  sendCoin({required String slug, required int coinId}) async {
    try {
      final response =
          await _coursesRequest.sendCoin(slug: slug, coinId: coinId);

      return response.data;
    } on DioException catch (e) {
      //print(e.response?.statusMessage);

      if (e.response?.statusCode == 422) {
        throw HttpFormValidationException(e.response?.data);
      }
    }
  }
}
