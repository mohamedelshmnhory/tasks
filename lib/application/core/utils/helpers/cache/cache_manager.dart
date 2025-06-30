import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../domain/models/user.dart';
import '../../../../config/l10n.dart';
import 'memory_cache_manager.dart';

class CacheManager {
  static final CacheManager _instance = CacheManager._private();

  static CacheManager get instance {
    return _instance;
  }

  late SharedPreferences _prefs;

  static const String keyOnboardingShown = "onboardingShown";
  static const String keyToken = "token";
  static const String keyUserId = "userId";
  static const String keyIsLogged = "isLogged";
  static const String keyLanguage = "language";
  static const String keyFCMDeviceToken = "fcmDeviceToken";
  static const keyUserData = 'keyUserData';

  CacheManager._private();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void setOnBoardingShown(bool language) async {
    await _prefs.setBool(keyOnboardingShown, language);
  }

  bool getOnBoardingShown() => _prefs.getBool(keyOnboardingShown) ?? false;

  Future<void> setAuthToken(String? token) async => await _prefs.setString(keyToken, token ?? '');

  String? getAuthToken() => _prefs.getString(keyToken)  ;

  void setLanguage(String language) async {
    MemoryCacheManager.instance.setLanguage(language);
    await _prefs.setString(keyLanguage, language);
  }

  String? getLanguage() => _prefs.getString(keyLanguage);

  Future<void> setUserId(String? userId) async => await _prefs.setString(keyUserId, userId ?? '');
  String getUserId() => _prefs.getString(keyUserId) ?? '';

  Future<void> setIsLogged(bool value) async => await _prefs.setBool(keyIsLogged, value);

  bool getIsLogged() => _prefs.getBool(keyIsLogged) ?? false;

  Future<void> setFCMDeviceToken(String? deviceToken) async {
    await _prefs.setString(keyFCMDeviceToken, deviceToken ?? '');
  }

  String getFCMDeviceToken() => _prefs.getString(keyFCMDeviceToken) ?? 'test';

  Future<void> setUserData(User? data) async {
    await Future.wait([
      setIsLogged(true),
      setUserId(data?.id.toString()),
      setAuthToken(data?.token),
    ]);
  }

  Future<void> logout() async {
    await _prefs.remove(keyToken);
    await _prefs.remove(keyUserId);
    await _prefs.remove(keyIsLogged);
    await _prefs.remove(keyUserData);
  }
}

extension CacheManagerExtension on CacheManager {
  Locale getSavedLocale() {
    return getLanguage() == 'ar' ? L10n.langAr : L10n.langEn;
  }
}
