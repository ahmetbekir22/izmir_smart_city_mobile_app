import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/location_controllers/location_controller.dart';
import '../../../../controllers/theme_contoller.dart';
import '../../../../core/api/etkinlik/events_model.dart';
import '../../../../utils/data_cleaning_utility.dart';

class DetailEventScreen extends StatelessWidget {
  final Etkinlik etkinlik;
  final LocationController _locationController = Get.put(LocationController());
  final ThemeController themeController = Get.find<ThemeController>();

  DetailEventScreen({super.key, required this.etkinlik});

  @override
  Widget build(BuildContext context) {
    String cleanedDescription =
        DataCleaningUtility.cleanHtmlText(etkinlik.kisaAciklama);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          etkinlik.adi,
          style: Get.theme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: Obx(() => Icon(
                  themeController.isDarkTheme.value
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Get.theme.colorScheme.onPrimary,

                  //color: Theme.of(context).colorScheme.onPrimary,
                )),
            onPressed: themeController.toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Etkinlik Resmi
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                etkinlik.resim,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                      child: Icon(Icons.error, color: Colors.red, size: 50));
                },
              ),
            ),
            const SizedBox(height: 20),

// Get.theme.textTheme.bodyLarge?.copyWith(
//                 fontWeight: FontWeight.w600
            // Etkinlik Başlığı ve Kısa Açıklama
            Text(
              etkinlik.adi,
              style: const TextStyle(
                  color: Color.fromARGB(255, 113, 96, 96),
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              cleanedDescription,
              style: const TextStyle(
                color: Color.fromARGB(255, 109, 96, 96),
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Etkinlik Bilgileri Listesi
                  ListTile(
                    leading:
                        Icon(Icons.category, color: Get.theme.iconTheme.color),
                    title: const Text('Etkinlik Türü',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(etkinlik.tur),
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 206, 205, 205),
                  ),
                  ListTile(
                    leading: Icon(Icons.date_range,
                        color: Get.theme.iconTheme.color),
                    title: const Text('Tarih',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(etkinlik.etkinlikBaslamaTarihi),
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 206, 205, 205),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.money_off, color: Get.theme.iconTheme.color),
                    title: const Text('Ücret Durumu',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle:
                        Text(etkinlik.ucretsizMi ? 'Ücretsiz' : 'Ücretli'),
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 206, 205, 205),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on,
                        color: Get.theme.iconTheme.color),
                    title: const Text('Etkinlik Merkezi',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(etkinlik.etkinlikMerkezi),
                    onTap: () {
                      _locationController
                          .openLocation(etkinlik.etkinlikMerkezi);
                    },
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 16.0, color: Colors.grey),
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
