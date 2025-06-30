import '../../constants/app_constants.dart';

class EnvironmentConfig {
  static const String TEST_VARIANT = String.fromEnvironment('FLAVOR', defaultValue: testEnvironmentString);
  static const String DEV_VARIANT = String.fromEnvironment('FLAVOR', defaultValue: devEnvironmentString);
  static const String STAGE_VARIANT = String.fromEnvironment('FLAVOR', defaultValue: stageEnvironmentString);
}
