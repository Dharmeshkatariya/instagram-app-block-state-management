import 'package:intl/intl.dart';

class AppDateTimeUtils {
  static getDateFromPicker(String dateTimeString) {
    List<String> parts = dateTimeString.split(RegExp(r'\s+'));
    String datePart = parts[0];
    return datePart;
  }

  static DateTime? parseSelectedDateTime(String dateTimeString) {
    List<String> parts = dateTimeString.split(RegExp(r'\s+'));
    String datePart = parts[0];
    String timePart = parts[1];
    List<String> dateComponents = datePart.split('-');
    Map<String, String> monthMap = {
      'Jan': '01',
      'Feb': '02',
      'Mar': '03',
      'Apr': '04',
      'May': '05',
      'Jun': '06',
      'Jul': '07',
      'Aug': '08',
      'Sep': '09',
      'Oct': '10',
      'Nov': '11',
      'Dec': '12',
      'ene': '01',
      'feb': '02',
      'mar': '03',
      'abr': '04',
      'may': '05',
      'jun': '06',
      'jul': '07',
      'ago': '08',
      'sep': '09',
      'oct': '10',
      'nov': '11',
      'dic': '12'
    };
    String month = monthMap[dateComponents[1].toLowerCase()] ?? '01';
    List<String> timeComponents = timePart.split(':');
    DateTime? parsedDateTime;
    parsedDateTime = DateTime(
      int.parse(dateComponents[0]),
      int.parse(month),
      int.parse(dateComponents[2]),
      int.parse(timeComponents[0]),
      int.parse(timeComponents[1]),
    );
    return parsedDateTime;
  }

  static String formatDateTimeString(String dateTimeString) {
    List<String> parts = dateTimeString.split(RegExp(r'\s+'));
    String datePart = parts[0];
    String timePart = parts[1];
    List<String> dateComponents = datePart.split('-');
    Map<String, String> monthMap = {
      'Jan': '01',
      'Feb': '02',
      'Mar': '03',
      'Apr': '04',
      'May': '05',
      'Jun': '06',
      'Jul': '07',
      'Aug': '08',
      'Sep': '09',
      'Oct': '10',
      'Nov': '11',
      'Dec': '12',
      'ene': '01',
      'feb': '02',
      'mar': '03',
      'abr': '04',
      'may': '05',
      'jun': '06',
      'jul': '07',
      'ago': '08',
      'sep': '09',
      'oct': '10',
      'nov': '11',
      'dic': '12'
    };
    String month = monthMap[dateComponents[1].substring(0, 3)] ?? '01';
    List<String> timeComponents = timePart.split(':');
    DateTime dateTime = DateTime(
      int.parse(dateComponents[0]),
      int.parse(month),
      int.parse(dateComponents[2]),
      int.parse(timeComponents[0]),
      int.parse(timeComponents[1]),
    );
    DateFormat formatter = DateFormat("yyyyMMdd'T'HHmm");
    return formatter.format(dateTime);
  }
}
