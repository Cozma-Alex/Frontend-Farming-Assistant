String formatDateTimeString(DateTime dateTime) {
  return dateTime.toString().replaceFirst(" ", "T");
}
