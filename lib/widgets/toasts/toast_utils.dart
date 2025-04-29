import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class Toasts {
  static void showSuccessToast(String message) {
    _showCustomToast(
      message,
      icon: Icons.check_circle,
      backgroundColor: Colors.green,
    );
  }

  static void showErrorToast(String message) {
    _showCustomToast(
      message,
      icon: Icons.error,
      backgroundColor: Colors.red,
    );
  }

  static void showInfoToast(String message) {
    _showCustomToast(
      message,
      icon: Icons.info,
      backgroundColor: Colors.blue,
    );
  }

  static void showWarningToast(String message) {
    _showCustomToast(
      message,
      icon: Icons.warning,
      backgroundColor: Colors.orange,
    );
  }

  static void _showCustomToast(
    String message, {
    required IconData icon,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 4),
  }) {
    showToastWidget(
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      position: ToastPosition.bottom,
      duration: duration,
    );
  }
}
