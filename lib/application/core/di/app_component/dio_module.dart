// app_component.config.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class DioModule {
  final Dio _dio = Dio();

  @singleton
  Dio get dio {
    _configureInterceptors(_dio);
    return _dio;
  }

  @Named('LoggerInterceptor')
  @singleton
  Interceptor get loggerInterceptor => PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 120,
      );

  void _configureInterceptors(Dio dio) {
    dio.interceptors.add(loggerInterceptor);
  }
}
