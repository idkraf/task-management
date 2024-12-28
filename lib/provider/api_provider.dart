import 'package:dio/dio.dart';
import 'package:task_management/model/standard_list_model.dart';

import '../model/task_model.dart';

class ApiProvider {
  //INITIAL DIO
  Dio _dio  = Dio();
  final String _baseUrl =  "https://reqres.in";

  ApiProvider() {
    //SETUP HEADER
    BaseOptions options = BaseOptions(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        receiveTimeout: Duration(seconds: 50000),
        connectTimeout: Duration(seconds: 50000),
        baseUrl: _baseUrl,
        contentType: Headers.jsonContentType);

    _dio = Dio(options);
  }

  //no need handle error response. because  didnt find succses or message response
  // String _handleError(error) {
  //   String errorDescription = "";
  //   if (error is DioError) {
  //     switch (error.type) {
  //       case DioExceptionType.cancel:
  //         errorDescription = "Request cancelled";
  //         break;
  //       case DioExceptionType.connectionTimeout:
  //         errorDescription = "Connection timeout";
  //         break;
  //       case DioExceptionType.connectionError:
  //         errorDescription = "Please check internet connection";
  //         break;
  //       case DioExceptionType.receiveTimeout:
  //         errorDescription = "Receive timeout";
  //         break;
  //       case DioExceptionType.badResponse:
  //         errorDescription =
  //         "Received invalid status code: ${error.response!.statusCode}";
  //         break;
  //       default:
  //         errorDescription = "Not Found Method";
  //         break;
  //     }
  //   } else {
  //     errorDescription = "Unexpected error occured ";
  //   }
  //   return errorDescription;
  // }

  //Gunakan mock API untuk endpoint login (contoh: https://reqres.in).
  Future<StandardListModels> actLogin({Map<String, dynamic>? body}) async {
    try {
      final response = await _dio.get('/api/login');
      // Parse the response into StandardListModels
      return StandardListModels.fromJson(response.data);
    } catch (error, _) {
      //because no succsess detect on response and no message then
      return StandardListModels.withError();
    }
  }

  //on scroll task demo from api login
  Future<StandardListModels> actTask({required int page}) async {
    try {
      final response = await _dio.get('/api/login', queryParameters: {'page': page});
      // Parse the response into StandardListModels
      print(response.data);
      return StandardListModels.fromJson(response.data);
    } catch (error, _) {
      //because no succsess detect on response and no message then
      return StandardListModels.withError();
    }
  }

  //Data akan disinkronkan ke mock API ketika koneksi internet kembali tersedia.
  Future<StandardListModels> syncTask({Map<String, dynamic>? body}) async {
    try {
      final response = await _dio.get('/api/login');
      // Parse the response into StandardListModels
      return StandardListModels.fromJson(response.data);
    } catch (error, _) {
      //because no succsess detect on response and no message then
      return StandardListModels.withError();
    }
  }
}