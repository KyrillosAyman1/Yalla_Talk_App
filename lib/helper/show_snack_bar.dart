import 'package:flutter/material.dart';

void customShowSnackBar({required BuildContext context,required String message, Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(20),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(15),
      elevation: 30,
      backgroundColor: color?? Theme.of(context).colorScheme.primary,
      content: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer,fontWeight: FontWeight.bold),
      ),
    ),
  );
}
