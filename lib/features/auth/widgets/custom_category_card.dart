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
  final String? category;
  final double? height;

  const CustomCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.location,
    this.date,
    this.time,
    required this.onTap,
    this.isNetworkImage = false,
    this.category,
    this.height,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Resim kısmı
            Flexible(
              child: isNetworkImage
                  ? Image.network(
                      imagePath ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Image.asset(
                      imagePath ?? 'assets/images/Izmir-Rehberi-Gezilecek-Yerler.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
            ),
            // Metin Bilgileri
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  height != null
                      ? Container(
                          height: height,
                        )
                      : const SizedBox(height: 8),
                  if (category != null)
                    Row(
                      children: [
                        Icon(
                          Icons.category,
                          size: 20,
                          color:
                              themeController.isDarkTheme.value ? Colors.white70 : Colors.black87,
                        ),
                        SizedBox(
                          width: Get.width * 0.01,
                        ),
                        Expanded(
                          child: Text(
                            "$location",
                            style: TextStyle(
                              color: themeController.isDarkTheme.value
                                  ? Colors.white70
                                  : Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  if (time != null)
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 20,
                          color:
                              themeController.isDarkTheme.value ? Colors.white70 : Colors.black87,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$time",
                          style: TextStyle(
                            color:
                                themeController.isDarkTheme.value ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  if (date != null)
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 20,
                          color:
                              themeController.isDarkTheme.value ? Colors.white70 : Colors.black87,
                        ),
                        SizedBox(
                          width: Get.width * 0.01,
                        ),
                        Text(
                          "$date",
                          style: TextStyle(
                            color:
                                themeController.isDarkTheme.value ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  if (location != null)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 20,
                          color:
                              themeController.isDarkTheme.value ? Colors.white70 : Colors.black87,
                        ),
                        SizedBox(
                          width: Get.width * 0.01,
                        ),
                        Expanded(
                          child: Text(
                            "$location",
                            style: TextStyle(
                              color: themeController.isDarkTheme.value
                                  ? Colors.white70
                                  : Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
