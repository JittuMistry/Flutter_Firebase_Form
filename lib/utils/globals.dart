import 'dart:developer';
import 'package:flutter/material.dart';

bool isShowingLoader = false;

extension ContextExtensions on State {
  showLoaderDialog({String loaderMessage = '', Color? barrierColor}) {
    if (!isShowingLoader) {
      isShowingLoader = true;
      showDialog(
        context: context,
        barrierColor: barrierColor ?? Colors.black.withOpacity(0.50),
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
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
                        style: const TextStyle(height: 2),
                      ),
                    ),
                  if (loaderMessage.isNotEmpty) const SizedBox(height: 10),
                  const CircularProgressIndicator(color: Colors.blue),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  closeLoader() {
    if (isShowingLoader) {
      if (mounted) {
        try {
          Navigator.of(context, rootNavigator: true).pop();
        } catch (e) {
          log(e.toString());
        }
      }
      isShowingLoader = false;
    }
  }
}
