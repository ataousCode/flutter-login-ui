// File: widgets/custom_button.dart
import 'package:flutter/material.dart';
import '../app/core/values/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onPressed; // Changed from VoidCallback to Function()?
  final bool isLoading;
  final bool isOutlined;
  final Color? color;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading || onPressed == null ? null : () async {
          // Add async wrapper to handle Future
          await onPressed!();
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: color ?? AppColors.primary,
          side: BorderSide(color: color ?? AppColors.primary),
        ),
        child: _buildChild(),
      );
    }

    return ElevatedButton(
      onPressed: isLoading || onPressed == null ? null : () async {
        // Add async wrapper to handle Future
        await onPressed!();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primary,
      ),
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      );
    }
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}