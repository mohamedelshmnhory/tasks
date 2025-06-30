import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/entitties/based_api_result/error_result_model.dart';
import '../../../application/core/di/app_component/app_component.dart';
import '../../../application/core/utils/constants/app_constants.dart';
import '../../../application/core/utils/helpers/app_flavor_helper/app_flavors_helper.dart';
import '../../../application/core/utils/helpers/cache/cache_manager.dart';
import '../../../application/core/utils/helpers/connectivity_helper/connectivity_checker_helper.dart';
import '../../../application/core/utils/helpers/custom_exceptions/custom_connection_exception.dart';
import '../../../presentaion/pages/auth/bloc/authentication_bloc.dart';
import 'dio_request_strategy.dart';

@injectable
class DioRequestContext {
  DioRequestContext(this.connectivityCheckerHelper);
  final ConnectivityCheckerHelper connectivityCheckerHelper;

  Map<String, String> _sharedDefaultHeader = <String, String>{};

  Future<void> initSharedDefaultHeader([String contentValue = contentTypeValue]) async {
    _sharedDefaultHeader = <String, String>{};
    _sharedDefaultHeader.addAll(<String, String>{
      contentTypeKey: contentValue,
      //'language header': 'x-localization',
      'Accept': 'application/json',
      authorisationKey: CacheManager.instance.getAuthToken()?.isNotEmpty == true
          ? bearerKey + (CacheManager.instance.getAuthToken() ?? '')
          : '',
      acceptLanguageKey: CacheManager.instance.getLanguage() ?? 'en',
    });
  }

  Future<bool> _getConnectionState() async {
    final bool result = await connectivityCheckerHelper.checkConnectivity();
    return result;
  }

  Future<ApiResultModel<Response>> makeRequest({
    required String uri,
    required DioRequestStrategy dioRequestStrategy,
    Map<String, String> headers = const <String, String>{},
    dynamic requestData,
    dynamic formData,
  }) async {
    await initSharedDefaultHeader();
    _sharedDefaultHeader.addAll(headers);
    if (await _getConnectionState()) {
      try {
        final String url = '${AppFlavorsHelper.instance.baseUrl}$uri';
        final ApiResultModel<Response> result = await dioRequestStrategy.executeRequest(
          uri: url,
          headers: _sharedDefaultHeader,
          requestData: requestData ?? {},
          formData: formData,
        );
        return result;
      } on DioException catch (e) {
        debugPrint('DioException : $e');
        if (e.response != null) {
          if (shouldLogout(e)) {
            locator<AuthenticationBloc>().add(const LogoutEvent(apiRequest: false));
            return const ApiResultModel<Response>.failure(
              errorResultEntity: ErrorResultModel(message: 'Unauthorized', statusCode: unAuthorizedStatusCode),
            );
          }
          return ApiResultModel<Response>.failure(
            errorResultEntity: ErrorResultModel(
              message: e.response?.data != null && e.response?.data.toString().isNotEmpty == true
                  ? e.response?.data['message'] ?? e.response?.statusCode
                  : 'Unexpected error occurred (${e.response?.statusCode ?? 'Unknown'})',
              statusCode: e.response?.statusCode,
            ),
          );
        }
        return const ApiResultModel<Response>.failure(
          errorResultEntity: ErrorResultModel(message: commonConnectionFailedMessage, statusCode: ioExceptionStatusCode),
        );
      } on TimeoutException catch (_) {
        return const ApiResultModel<Response>.failure(
          errorResultEntity: ErrorResultModel(message: commonErrorUnexpectedMessage, statusCode: timeoutRequestStatusCode),
        );
      } on IOException catch (_) {
        return const ApiResultModel<Response>.failure(
          errorResultEntity: ErrorResultModel(message: commonConnectionFailedMessage, statusCode: ioExceptionStatusCode),
        );
      } on FormatException catch (e) {
        debugPrint('Unexpected error: $e');
        return const ApiResultModel<Response>.failure(
          errorResultEntity: ErrorResultModel(message: formatExceptionMessage, statusCode: formatExceptionStatusCode),
        );
      } catch (e) {
        debugPrint('Unexpected error: $e');
        return const ApiResultModel<Response>.failure(
          errorResultEntity: ErrorResultModel(message: commonErrorUnexpectedMessage, statusCode: timeoutRequestStatusCode),
        );
      }
    } else {
      throw CustomConnectionException(exceptionMessage: commonConnectionFailedMessage, exceptionCode: ioExceptionStatusCode);
    }
  }

  bool shouldLogout(DioException e) {
    return e.response?.statusCode == unAuthorizedStatusCode || e.response?.statusCode == serviceUnavailableStatusCode;
  }
}
