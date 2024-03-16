import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KeyBoardUtil {
  closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
    FocusScopeNode currentFocus = FocusScope.of(Get.context!);

    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }
}
