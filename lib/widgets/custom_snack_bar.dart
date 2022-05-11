import 'package:flutter/material.dart';

///FUNC [showCustomSnackBar] : Show snackbar messages during success or fail
ScaffoldMessengerState showCustomSnackBar({
  required BuildContext context,
  required String message,
  bool isError = false,
  SnackBarAction? action,
  IconData? icon,
}) {
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        action: action,
        content: Row(
          children: [
            icon == null
                ? Icon(
                    isError ? Icons.error : Icons.check_circle_outline,
                    color: Colors.white,
                  )
                : Icon(
                    icon,
                    color: Colors.white,
                  ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
}
