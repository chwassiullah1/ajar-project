import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDateWithTime(String date) {
  DateTime parsedDate = DateTime.parse(date);
  // Check if time is included by verifying if the string contains 'T' (common in ISO 8601 format)
  String format;
  if (date.contains('T')) {
    // Format with date and time if the time component is present
    format = 'MMMM d, y - h:mm a'; // Example: October 18, 2024 - 5:30 PM
  } else {
    // Format with just date if no time component
    format = 'MMMM d, y'; // Example: October 18, 2024
  }
  return DateFormat(format).format(parsedDate);
}

String formatDate(String date) {
  DateTime parsedDate = DateTime.parse(date);
  String format = 'yyyy-MM-dd'; // Example: October 18, 2024
  return DateFormat(format).format(parsedDate);
}

String formatDateInMonthNameFormat(String date) {
  DateTime parsedDate = DateTime.parse(date);
  String format = 'MMMM d, yyyy'; // Format: October 18, 2024
  return DateFormat(format).format(parsedDate);
}

String formatTime(String date) {
  DateTime parsedDate = DateTime.parse(date);
  String format = 'hh:mm a'; // Example: October 18, 2024
  return DateFormat(format).format(parsedDate);
}


// Function to combine date and time into a DateTime object
DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
}

// Function to format DateTime to '2024-10-20T00:00:00.000Z' format
String formatDateTimeToISO(DateTime dateTime) {
  return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(dateTime);
}

// Format the picked time as a readable string
String formatTimeRange(
    BuildContext context, TimeOfDay? startTime, TimeOfDay? endTime) {
  if (startTime != null && endTime != null) {
    final startFormatted = startTime.format(context);
    final endFormatted = endTime.format(context);
    return '$startFormatted - $endFormatted';
  }
  return '';
}

String formatDateRange(DateTimeRange dateRange) {
  final DateFormat dateFormatter = DateFormat('yyyy/MM/dd');
  final String startDate = dateFormatter.format(dateRange.start);
  final String endDate = dateFormatter.format(dateRange.end);

  return '$startDate - $endDate';
}

int calculateTotalDays(String startDateStr, String endDateStr) {

  // Parse the formatted strings to DateTime
  DateTime startDate = DateTime.parse(startDateStr);
  DateTime endDate = DateTime.parse(endDateStr);

  // Calculate the difference in days and add 1 to include both dates
  return endDate.difference(startDate).inDays;
}
