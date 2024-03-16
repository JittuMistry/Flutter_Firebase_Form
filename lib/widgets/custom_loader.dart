import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form/utils/colors_utils.dart';

bool isShowingLoader = false;

extension ContextExtensions on StatelessWidget {
  //
  void showCustomLoader({String loaderMessage = '', Color? barrierColor}) {
    if (!isShowingLoader) {
      isShowingLoader = true;
      showDialog(
        context: Get.context!,
        barrierColor: barrierColor ?? AppColors.black.withOpacity(0.8),
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: AppColors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (loaderMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        loaderMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.white,
                          height: 2,
                        ),
                      ),
                    ),
                  if (loaderMessage.isNotEmpty) const SizedBox(height: 20),
                  // const SpinKitSpinningLines(
                  //   color: AppColors.white,
                  //   size: 50.0,
                  // ),
                  const CircularProgressIndicator(color: AppColors.white),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void hideCustomLoader() {
    if (isShowingLoader) {
      try {
        Navigator.of(Get.context!, rootNavigator: true).pop();
      } catch (e) {
        log(e.toString());
      }

      isShowingLoader = false;
    }
  }
}
