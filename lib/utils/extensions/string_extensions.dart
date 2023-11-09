import 'package:street_calle/utils/patterns.dart';
import 'package:street_calle/utils/common.dart';

extension StringExtension on String? {
  /// Check email validation
  bool validateEmail() => hasMatch(this, Patterns.email);

  /// Check email validation
  bool validateEmailEnhanced() => hasMatch(this, Patterns.emailEnhanced);

  /// Check phone validation
  bool validatePhone() => hasMatch(this, Patterns.phone);

  /// Returns true if given String is null or isEmpty
  bool get isEmptyOrNull =>
      this == null ||
          (this != null && this!.isEmpty) ||
          (this != null && this! == 'null');

  /// Capitalize given String
  String capitalizeEachFirstLetter() {
    if (this == null || this!.isEmpty) return validate();

    List<String> words = this!.trim().split(' ');
    List<String> capitalizedWords = words.map((word) {
      return word.trim().substring(0, 1).toUpperCase() + word.trim().substring(1).toLowerCase();
    }).toList();

    return capitalizedWords.join(' ');
  }


  /// Capitalize given String
  String capitalizeFirstLetter() => (validate().length >= 1)
      ? (this!.trim().substring(0, 1).toUpperCase() + this!.trim().substring(1).toLowerCase())
      : validate();

  // Check null string, return given value if null
  String validate({String value = ''}) {
    if (isEmptyOrNull) {
      return value;
    } else {
      return this!;
    }
  }
}