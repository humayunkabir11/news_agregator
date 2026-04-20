import 'dart:ui';

import '../config/strings/api_endpoint.dart';
import 'package:intl/intl.dart';
extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }

  double parseDouble() {
    return double.parse(this);
  }
}

extension TextExtensions on String {
  String get capitalizeFirstLetter {
    if (this.isEmpty) return this;

    return this[0].toUpperCase() + this.substring(1);
  }
}
