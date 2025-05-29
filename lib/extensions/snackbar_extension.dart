import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension SnackbarExtensions on BuildContext {
  
  /// Show a Snackbar
  void showSnackbar({
    required String title,
    Duration? showDuration,
    VoidCallback? onClose,
  }) {
    final snackBar = SnackBar(
      content: Text(
        title,
      ),
      duration: showDuration ?? const Duration(milliseconds: 1500),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(this).removeCurrentSnackBar();
    final controller = ScaffoldMessenger.of(this).showSnackBar(snackBar);

    controller.closed.then((reason) {
      if (reason == SnackBarClosedReason.timeout) {
        onClose?.call();
      }
    });
  }

  /// Copy text to clipboard and show Snackbar
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      showSnackbar(title: 'Copied to clipboard: $text', showDuration: const Duration(milliseconds: 1000));
    });
  }

  /// Custom Snackbar with delay (similar to hitTestBehaviour)
  void showDelayedSnackbar({
    required String title,
    Duration? delay,
    Duration? showDuration,
    VoidCallback? onClose,
  }) async {
    ScaffoldMessenger.of(this).removeCurrentSnackBar();
    if (delay != null) {
      await Future.delayed(delay);
    }
    showSnackbar(title: title, showDuration: showDuration, onClose: onClose);
  }
}
