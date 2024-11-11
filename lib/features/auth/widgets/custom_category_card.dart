import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/theme_contoller.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String? imagePath;
  final String? location;
  final String? date;
  final String? time;
  final VoidCallback onTap;
  final bool isNetworkImage;

  const CustomCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.location,
    this.date,
    this.time,
    required this.onTap,
    this.isNetworkImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            isNetworkImage
                ? Image.network(
                    imagePath ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Image.asset(
                    imagePath ??
                        'https://www.google.com/imgres?q=izmir&imgurl=http%3A%2F%2Fgreenpetition.com%\n2Fcdn%2Fshop%2Farticles%2FIzmir-Rehberi-Gezilecek-Yerler.jpg%3Fv%3D1708005903&imgrefurl=https%3A%2F%2Fgreenpetition.com%2Ftr%2Fblogs%2Fblog%2Fizmir-rehberi-gezilecek-yerler&docid=6wpU9ctmapcfDM&tbnid=niW5k_nirgNxVM&vet=12ahUKEwio-rDbzdSJAxVnR_EDHRSGCdoQM3oECBoQAA..i&w=1200&h=1200&hcb=2&ved=2ahUKEwio-rDbzdSJAxVnR_EDHRSGCdoQM3oECBoQAA',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: Get.height * 0.01,
                horizontal: Get.width * 0.02,
              ),
              color: Colors.black.withOpacity(0.4),
              child: Text(
                title,
                style: TextStyle(
                  color: themeController.isDarkTheme.value ? Colors.white : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
