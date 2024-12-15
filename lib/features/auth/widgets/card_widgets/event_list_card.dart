import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/theme_contoller.dart';

class EventListCard extends StatelessWidget {
  final String title;
  final String? imagePath;
  final String? location;
  final String? date; // Tarih
  final String? time; // Saat
  final VoidCallback onTap;
  final bool isNetworkImage;
  final String? category;
  final double? height;

  const EventListCard({
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

    // Tarih ve saat formatlama
    String? formattedDate;
    String? formattedTime;

    // Tarih biçimlendirme (dd-MM-yyyy -> ISO format)
    if (date != null) {
      try {
        DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date!);
        formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
      } catch (e) {
        formattedDate = "Invalid Date";
      }
    }

    // Saat biçimlendirme (ISO format -> HH:mm)
    if (time != null) {
      try {
        DateTime parsedTime = DateTime.parse(time!);
        formattedTime = DateFormat('HH:mm').format(parsedTime);
      } catch (e) {
        formattedTime = "Invalid Time";
      }
    }

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
            Flexible(
              child: isNetworkImage
                  ? Image.network(
                      imagePath ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                    )
                  : Image.asset(
                      imagePath ??
                          'assets/images/Izmir-Rehberi-Gezilecek-Yerler.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: themeController.isDarkTheme.value
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  if (height != null)
                    Container(height: height)
                  else
                    const SizedBox(height: 8),
                  if (category != null)
                    Row(
                      children: [
                        Icon(
                          Icons.category,
                          size: 20,
                          color: themeController.isDarkTheme.value
                              ? Colors.white70
                              : Colors.black87,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            category!,
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
                  if (formattedTime != null)
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 20,
                          color: themeController.isDarkTheme.value
                              ? Colors.white70
                              : Colors.black87,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formattedTime,
                          style: TextStyle(
                            color: themeController.isDarkTheme.value
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  if (formattedDate != null)
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: themeController.isDarkTheme.value
                              ? Colors.white70
                              : Colors.black87,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: themeController.isDarkTheme.value
                                ? Colors.white70
                                : Colors.black87,
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
                          color: themeController.isDarkTheme.value
                              ? Colors.white70
                              : Colors.black87,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location!,
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
