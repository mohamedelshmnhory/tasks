import 'package:flutter/cupertino.dart';

import '../../constants/app_constants.dart';

/// this enum will present the list of supported environments
enum ProductFlavor {
  TEST(testBaseUrl),
  DEV(devBaseUrl),
  STAGE(stageBaseUrl);

  final String url;

  const ProductFlavor(this.url);

  static ProductFlavor getTypeFromString(String flavor) {
    for (var element in ProductFlavor.values) {
      if (element.name.toLowerCase() == flavor.toLowerCase()) {
        return element;
      }
    }
    return ProductFlavor.TEST;
  }
}

class AppFlavorsHelper {
  static ProductFlavor? _productFlavor;
  static String? _baseUrl;

  static final AppFlavorsHelper _instance = AppFlavorsHelper._internal();

  // Private constructor for singleton
  AppFlavorsHelper._internal() {
    const String flavor = String.fromEnvironment("FLAVOR", defaultValue: devEnvironmentString);
    debugPrint("FLAVOR: $flavor");
    _productFlavor = ProductFlavor.getTypeFromString(flavor);
    _baseUrl = _productFlavor?.url;
  }

  static AppFlavorsHelper get instance => _instance;

  ProductFlavor? get productFlavor => _productFlavor;

  String get baseUrl => _baseUrl ?? devBaseUrl;
}
