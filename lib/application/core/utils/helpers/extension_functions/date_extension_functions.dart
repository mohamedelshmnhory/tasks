import 'package:intl/intl.dart';

import '../cache/cache_manager.dart';

extension ExtensionsOnNullableInt on DateTime? {
  String? fromTimestampToDate({String dateFormat = 'yyyy-MM-dd'}) {
    if (this != null) {
      return DateFormat(dateFormat).format(this!);
    }
    return null;
  }
}

extension ExtensionsOnNullableString on String? {
  String? fromDateTimeToDate({String dateFormat = 'dd-MM-yyyy', String language = 'en'}) {
    if (this != null) {
      DateTime dateTime = DateTime.parse(this!);
      return DateFormat(dateFormat, language).format(dateTime);
    }
    return null;
  }

  DateTime? fromStringToDate() {
    return this == null ? null : DateTime.parse(this!);
  }
}

extension DateTimeFormatting on DateTime {
  String formatToCustomString() {
    return DateFormat('MM/dd/yyyy - hh:mm a', CacheManager.instance.getLanguage()).format(this);
  }

  String formatTimeToCustomString() {
    return DateFormat('hh:mm a', CacheManager.instance.getLanguage()).format(this);
  }

  String formatDateToCustomString() {
    return DateFormat('MMMM d, yyyy', CacheManager.instance.getLanguage()).format(this);
  }

  String formatDayMonthToCustomString() {
    return DateFormat('d MMMM', CacheManager.instance.getLanguage()).format(this);
  }
}

List<String> getMonthNames(language) {
  List<String> months = [];

  for (int i = 1; i <= 12; i++) {
    DateTime month = DateTime(2024, i);
    String monthName = DateFormat('MMMM', language).format(month);
    months.add(monthName);
  }

  return months;
}

String getMonthName(int monthNumber, String language) {
  DateTime month = DateTime(2024, monthNumber);
  return DateFormat('MMMM', language).format(month);
}

int getMonthNumber(String monthName, String language) {
  DateTime date = DateFormat('MMMM', language).parse(monthName);
  return date.month;
}

String formatDateTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);

  // Format date
  String formattedDate = DateFormat('d MMMM yyyy').format(dateTime);

  // Get time period (Morning, Afternoon, Evening, Night)
  String timePeriod = getTimePeriod(dateTime.hour);

  // Combine date and time period
  String formattedDateTime = '$formattedDate - $timePeriod';

  return formattedDateTime;
}

String getTimePeriod(int hour) {
  if (hour >= 5 && hour < 12) {
    return 'Morning';
  } else if (hour >= 12 && hour < 17) {
    return 'Afternoon';
  } else if (hour >= 17 && hour < 20) {
    return 'Evening';
  } else {
    return 'Night';
  }
}

DateTime getFirstDayOfMonth(DateTime date) {
  return DateTime(date.year, date.month, 1);
}

DateTime getLastDayOfMonth(DateTime date) {
  return DateTime(date.year, date.month + 1, 0);
}