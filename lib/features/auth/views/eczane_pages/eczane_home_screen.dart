import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/eczane_api_controllers/eczane_controller.dart';
import '../../../../core/coordiantes_calculations.dart';
import '../../widgets/category_card.dart';

class EczaneHomeScreen extends StatelessWidget {
  const EczaneHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EczaneController eczaneController = Get.put(EczaneController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nöbetçi Eczaneler"),
        centerTitle: true,
        backgroundColor: Get.theme.appBarTheme.backgroundColor,
      ),
      body: Obx(() {
        if (eczaneController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (eczaneController.eczaneList.isEmpty) {
          return const Center(child: Text("Eczane bulunamadı."));
        }

        return ListView.builder(
          itemCount: eczaneController.eczaneList.length,
          itemBuilder: (context, index) {
            final eczane = eczaneController.eczaneList[index];
            return CategoryCard(
              title: eczane.adi ?? 'Eczane',
              imagePath: 'assets/images/eczane.png',
              onTap: () {
                if (eczane.lokasyonX != null && eczane.lokasyonY != null) {
                  openMapWithCoordinates(eczane.lokasyonX!, eczane.lokasyonY!);
                } else {
                  Get.snackbar('Konum bilgisi eksik',
                      'Eczanenin konum bilgisi bulunamadı.',
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
              customContent: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 18, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Adres: ${eczane.adres ?? 'Bilinmiyor'}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 18, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Telefon: ${eczane.telefon ?? 'Bilinmiyor'}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.map, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Bölge: ${eczane.bolge ?? 'Bilinmiyor'}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
