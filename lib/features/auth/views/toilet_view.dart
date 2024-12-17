// lib/app/views/toilet_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/controllers/location_controller.dart';
import 'package:smart_city_app/controllers/toilet_controller.dart';
import 'package:smart_city_app/core/api/toilet_model.dart';

import '../widgets/general_card.dart';

class ToiletView extends GetView<ToiletController> {
  const ToiletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // LocationController'ı find veya put ile alıyoruz
    final locationController = Get.find<LocationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Akıllı Tuvaletler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchToilets(),
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hata: ${controller.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.fetchToilets(),
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          }

          if (controller.toilets.isEmpty) {
            return const Center(child: Text('Veri bulunamadı'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.toilets.length,
            itemBuilder: (context, index) {
              final toilet = controller.toilets[index];

              return GeneralCard(
                adi: toilet.tESISADI ?? 'İsimsiz Tesis',
                ilce: toilet.iLCE ?? 'Belirtilmemiş',
                mahalle: toilet.mAHALLE ?? 'Belirtilmemiş',
                onLocationTap: () {
                  try {
                    if (toilet.eNLEM != null && toilet.bOYLAM != null) {
                      locationController.openLocationByCoordinates(
                        toilet.eNLEM!,
                        toilet.bOYLAM!,
                      );
                    } else if (toilet.tESISADI != null) {
                      // Koordinat yoksa tesis adı ile arama yap
                      locationController.openLocation(toilet.tESISADI!);
                    } else {
                      Get.snackbar(
                        'Hata',
                        'Konum bilgisi bulunamadı',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  } catch (e) {
                    Get.snackbar(
                      'Hata',
                      'Harita açılırken bir hata oluştu',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}


class ToiletDetailView extends StatelessWidget {
  const ToiletDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Records toilet = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(toilet.tESISADI ?? 'Tesis Detayı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: const Text('Tesis Bilgileri'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text('ID: ${toilet.iId}'),
                    const SizedBox(height: 4),
                    Text('İlçe: ${toilet.iLCE ?? 'Belirtilmemiş'}'),
                    const SizedBox(height: 4),
                    Text('Mahalle: ${toilet.mAHALLE ?? 'Belirtilmemiş'}'),
                    const SizedBox(height: 4),
                    Text('Adres: ${toilet.aDRES ?? 'Belirtilmemiş'}'),
                    const SizedBox(height: 4),
                    Text('Koordinatlar: ${toilet.eNLEM}, ${toilet.bOYLAM}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Harita uygulamasına yönlendirme yapılabilir
                // TODO: Implement map navigation
              },
              icon: const Icon(Icons.map),
              label: const Text('Haritada Göster'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}