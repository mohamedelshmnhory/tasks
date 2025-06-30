import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks/application/core/commundomain/usecases/base_params_usecase.dart';
import 'package:tasks/application/core/di/app_component/app_component.dart';
import 'package:tasks/domain/usecases/auth/get_profile_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../../application/core/commundomain/entitties/based_api_result/error_result_model.dart';
import '../../../../application/core/utils/auto_router_setup/app_router.dart';
import '../../../../application/core/utils/constants/app_constants.dart';
import '../../../../application/core/utils/helpers/cache/cache_manager.dart';
import '../../../../data/entities/request_entities/auth/login/login_request.dart';
import '../../../../data/entities/request_entities/auth/logout/logout_request.dart';
import '../../../../data/entities/response_entities/login/login_response.dart';
import '../../../../domain/models/user.dart';
import '../../../../domain/usecases/auth/do_login_usecase.dart';
import '../../../../domain/usecases/auth/logout_usecase.dart';
import '../../../../domain/usecases/auth/update_profile_usecase.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

@singleton
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final DoLoginUseCase doLoginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final RequestOTPUseCase requestOTPUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final GetProfileUseCase getProfileUseCase;

  User? user;

  AuthenticationBloc(
    this.doLoginUseCase,
    this.logoutUseCase,
    this.requestOTPUseCase,
    this.updateProfileUseCase,
    this.getProfileUseCase,
    this.registerUseCase,
  ) : super(AuthenticationInitial()) {
    on<LoginEvent>(_doLogin);
    on<RequestOTPEvent>(_requestOTP);
    on<LogoutEvent>(_logout);
    on<UpdateProfileEvent>(_updateProfile);
    on<GetProfileEvent>(_getProfile);
    on<RegisterEvent>(_register);
  }

  Future<void> _doLogin(LoginEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthLoading());
    final packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;

    final loginRequestModel = LoginRequest(
      username: event.username,
      passwordHash: event.password,
      buildVersion: version,
      fcmDeviceId: CacheManager.instance.getFCMDeviceToken(),
    );

    final ApiResultModel<User?> apiResult = await doLoginUseCase(loginRequestModel);

    apiResult.when(
      success: (User? data) {
        CacheManager.instance.setUserData(data);
        // add(UpdateUserLanguageEvent());
        user = data;
        emit(LoginSuccess(user: user));
      },
      failure: (ErrorResultModel error) => emit(AuthenticationError(message: error.message ?? errorMessage)),
    );
  }

  Future<void> _register(RegisterEvent event, Emitter<AuthenticationState> emit) async {
    emit(RegisterLoading());
    final ApiResultModel<User?> apiResult = await registerUseCase(event.requestModel!);
    apiResult.when(
      success: (User? data) {
        CacheManager.instance.setUserData(data);
        user = data;
        emit(LoginSuccess(user: user));
      },
      failure: (ErrorResultModel error) => emit(AuthenticationError(message: error.message ?? errorMessage)),
    );
  }

  Future<void> _requestOTP(RequestOTPEvent event, Emitter<AuthenticationState> emit) async {
    emit(RequestOTPLoading());
    final model = LoginRequest(
      phone: event.phone,
      phone_country: event.countryISOCode,
      country_code: event.countryCode,
      fcmDeviceId: CacheManager.instance.getFCMDeviceToken(),
    );
    final ApiResultModel<LoginResponse?> apiResult = await requestOTPUseCase(model);
    apiResult.when(
      success: (LoginResponse? data) {
        emit(RequestOTPSuccess());
      },
      failure: (ErrorResultModel error) => emit(AuthenticationError(message: error.message ?? errorMessage)),
    );
  }

  Future<void> _updateProfile(UpdateProfileEvent event, Emitter<AuthenticationState> emit) async {
    emit(UpdateProfileLoading());
    final ApiResultModel<User?> apiResult = await updateProfileUseCase(event.requestModel);
    apiResult.when(
      success: (User? data) {
        user = data;
        emit(UpdateProfileSuccess());
      },
      failure: (ErrorResultModel error) => emit(AuthenticationError(message: error.message ?? errorMessage)),
    );
  }

  Future<void> _getProfile(GetProfileEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthLoading());
    final ApiResultModel<User?> apiResult = await getProfileUseCase(NoParams());
    apiResult.when(
      success: (User? data) {
        user = data;
        emit(GetProfileSuccess(data!));
      },
      failure: (ErrorResultModel error) => emit(AuthenticationError(message: error.message ?? errorMessage)),
    );
  }

  Future<void> _logout(LogoutEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthLoading());
    if (!event.apiRequest) {
      CacheManager.instance.logout();
      locator<AppRouter>().pushAndPopUntil(LoginRoute(), predicate: (route) => false);
      emit(LogoutSuccess());
      return;
    }
    final requestModel = LogoutRequest(deviceId: CacheManager.instance.getFCMDeviceToken());
    final ApiResultModel<String?> apiResult = await logoutUseCase(event.model ?? requestModel);
    apiResult.when(
      success: (String? data) {
        CacheManager.instance.logout();
        locator<AppRouter>().pushAndPopUntil(LoginRoute(), predicate: (route) => false);
        emit(LogoutSuccess());
      },
      failure: (ErrorResultModel error) {
        CacheManager.instance.logout();
        locator<AppRouter>().pushAndPopUntil(LoginRoute(), predicate: (route) => false);
        emit(AuthenticationError(message: error.message ?? errorMessage));
      },
    );
  }
}
