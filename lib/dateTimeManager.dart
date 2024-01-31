class DateTimeManager {
  static String getCurrentDateTime() {
    DateTime dateTime = DateTime.now();
    return "${dateTime.day} - ${dateTime.month} - ${dateTime.year} - ${dateTime.hour} : ${dateTime.minute}";
  }
}
