import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form/utils/keyboard_utils.dart';

class DatePickerHelper {
  static Future<DateTime?> select(DateTime initial) async {
    KeyBoardUtil().closeKeyboard();
    return await showDatePicker(
      context: Get.context!,
      //  initialDate: con.endDate,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
  }
}
