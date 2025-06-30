enum Culture {
  English(0),
  Arabic(1);

  final int value;

  const Culture(this.value);

  static Culture fromValue(int value) {
    switch (value) {
      case 0:
        return Culture.English;
      case 1:
        return Culture.Arabic;
      default:
        return Culture.English;
    }
  }

  static Culture fromLanguageCode({String? code = 'en'}) {
    switch (code) {
      case 'en':
        return Culture.English;
      case 'ar':
        return Culture.Arabic;
      default:
        return Culture.English;
    }
  }
}
