// resource/utils/parsing_helper.dart
double parseToDouble(dynamic value) {
  if (value == null) return 0.0; // Default value
  if (value is num) return value.toDouble();
  if (value is String) {
    final parsed = double.tryParse(value);
    return parsed ?? 0.0; // Return 0.0 if parsing fails
  }
  return 0.0; // Default value for invalid types
}

int parseToInt(dynamic value) {
  if (value == null) return 0; // Default value
  if (value is num) return value.toInt();
  if (value is String) {
    final parsed = int.tryParse(value);
    return parsed ?? 0; // Return 0 if parsing fails
  }
  return 0; // Default value for invalid types
}

String? parseToString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}