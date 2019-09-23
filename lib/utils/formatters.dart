import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class LowerCaseTextFormatter extends TextInputFormatter {

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
      return newValue.copyWith(text: newValue.text.toLowerCase());
    }

}

class StatisticTextFormatter extends TextInputFormatter {

  String textFormatter(int statistic) {
    if (statistic >= 5000) {
      return "${String.fromCharCode(statistic)[0]}K";
    } else if (statistic >= 10000) {
      return "${String.fromCharCode(statistic)[0]}.${String.fromCharCode(statistic)[1]}K";
    } else if (statistic <= 100000) {
      return "${String.fromCharCode(statistic)[0]}${String.fromCharCode(statistic)[1]}.${String.fromCharCode(statistic)[2]}K";
    } else if (statistic >= 1000000) {
      return "${String.fromCharCode(statistic)[0]}.${String.fromCharCode(statistic)[1]}M";
    } else if (statistic >= 10000000) {
      return "${String.fromCharCode(statistic)[0]}${String.fromCharCode(statistic)[1]}M";
    } else if (statistic >= 100000000) {
      return "${String.fromCharCode(statistic)[0]}${String.fromCharCode(statistic)[1]}${String.fromCharCode(statistic)[2]}";
    } else if (statistic >= 1000000000) {
      return "${String.fromCharCode(statistic)[0]}B";
    }
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
      return newValue.copyWith(text: textFormatter(int.parse(newValue.text)));
    }

}