import 'dart:convert';

import 'package:tasks/application/core/utils/helpers/extension_functions/dio_response_extensions.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../dio_request_strategy.dart';

@lazySingleton
@injectable
class DeleteRequestStrategy implements DioRequestStrategy {
  final Dio _dio;

  DeleteRequestStrategy(this._dio);

  @override
  Future<ApiResultModel<Response<dynamic>>> executeRequest({
    required String uri,
    Map<String, String> headers = const <String, String>{},
    Map<String, dynamic> requestData = const <String, dynamic>{},
    dynamic formData,
  }) async {
    final String encodedJson = json.encode(requestData);

    final Response response = await _dio.delete(
      uri,
      options: Options(headers: headers),
      data: encodedJson,
    );
    return response.performHttpRequest();
  }
}
