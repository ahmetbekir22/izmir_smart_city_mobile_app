import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/event_controller.dart';
import 'event_detail_screen.dart';

class LatestEventsScreen extends StatelessWidget {
  final EtkinlikController etkinlikController = Get.put(EtkinlikController());

  LatestEventsScreen({super.key});

  String getCleanedTitle(String title) {
    return title.replaceAll('``', '');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (etkinlikController.etkinlikListesi.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      bool isDarkMode = Get.isDarkMode;
      Color textColor = Colors.white;

      return Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: etkinlikController.pageController,
            onPageChanged: (index) {
              if (etkinlikController.currentIndex.value != index) {
                etkinlikController.currentIndex.value = index;
              }
            },
            itemCount: etkinlikController.etkinlikListesi.length,
            itemBuilder: (context, index) {
              var etkinlik = etkinlikController.etkinlikListesi[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => DetailEventScreen(etkinlik: etkinlik));
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Boşluk ekleyerek başlık ve görseli aşağı kaydırma
                    const SizedBox(height: 50),

                    // Dinamik etkinlik adı
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        getCleanedTitle(etkinlik.adi),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Görsel tam çerçeveye sığdırılmış ve köşeleri yuvarlatılmış
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(20), // Köşeleri yuvarlat
                      child: Image.network(
                        etkinlik.kucukAfis,
                        width: Get.width * 0.9,
                        height: Get.height * 0.5,
                        fit: BoxFit.fill, // Görseli tam çerçeveye sığdır
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Sol ok butonu
          Positioned(
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
              onPressed: () {
                int currentIndex = etkinlikController.currentIndex.value;
                if (currentIndex > 0) {
                  etkinlikController.pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
          // Sağ ok butonu
          Positioned(
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward,
                  color: Colors.white, size: 32),
              onPressed: () {
                int currentIndex = etkinlikController.currentIndex.value;
                if (currentIndex <
                    etkinlikController.etkinlikListesi.length - 1) {
                  etkinlikController.pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
        ],
      );
    });
  }
}
