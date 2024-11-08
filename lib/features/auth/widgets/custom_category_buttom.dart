import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const CategoryButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    this.width = 160, // Default width
    this.height = 50, // Default height
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: Size(width, height),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: textColor,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
