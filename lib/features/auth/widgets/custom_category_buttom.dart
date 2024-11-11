import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const CategoryButton({
    super.key,
    required this.label,
    required this.icon,
    this.backgroundColor,
    this.textColor,
    this.width = 160, // Default width
    this.height = 50, // Default height
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor:
            backgroundColor ?? Get.theme.colorScheme.primary, // Tema uyumlu arka plan rengi
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: Size(width, height),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: textColor ?? Get.theme.colorScheme.onPrimary, // Tema uyumlu ikon rengi
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: textColor ?? Get.theme.colorScheme.onPrimary, // Tema uyumlu metin rengi
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
