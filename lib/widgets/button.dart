import 'package:flutter/material.dart';
import 'package:pharma_niamey/app_theme.dart';

class Button extends StatelessWidget {
  final String buttonText;
  final VoidCallback callFunction;
  final Color? buttonColors;
  const Button({
    super.key,
    required this.buttonText,
    required this.callFunction,
    this.buttonColors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: callFunction,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          foregroundColor: Colors.white,
          backgroundColor: buttonColors ?? AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
