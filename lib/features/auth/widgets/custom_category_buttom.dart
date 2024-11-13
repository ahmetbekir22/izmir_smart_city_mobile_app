import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double width;
  final double height;
  final bool isSelected;
  final VoidCallback onPressed;

  const CategoryButton({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width = 160,
    this.height = 50,
    this.isSelected = false,
    required this.onPressed,
  });

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      duration: const Duration(milliseconds: 300),
      alignment: widget.isSelected ? Alignment.center : Alignment.centerLeft,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor:
              widget.backgroundColor ?? Get.theme.colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: Size(widget.width, widget.height),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null)
              Icon(
                widget.icon,
                color: widget.textColor ?? Get.theme.colorScheme.onPrimary,
                size: 24,
              ),
            if (widget.icon != null) const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                color: widget.textColor ?? Get.theme.colorScheme.onPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
