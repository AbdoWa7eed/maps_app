import 'package:dio/dio.dart';
import 'package:maps_app/app/constants.dart';

class DioFactory {
  Future<Dio> getDio() async {
    Dio dio = Dio();

    dio.options = BaseOptions(
        baseUrl: Constants.mapsBaseUrl,
        receiveTimeout: const Duration(seconds: Constants.apiTimeOut),
        sendTimeout: const Duration(seconds: Constants.apiTimeOut));

    return dio;
  }
}
