import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/event_controller.dart';
import 'event_detail_screen.dart';

class LatestEventsScreen extends StatelessWidget {
  final EtkinlikController etkinlikController = Get.put(EtkinlikController());

  LatestEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (etkinlikController.etkinlikListesi.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      bool isDarkMode = Get.isDarkMode;
      Color textColor = isDarkMode ? Colors.white : Colors.black;
      Color overlayColor = isDarkMode ? Colors.black45 : Colors.white10;

      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: Get.height * 0.4,
            child: PageView.builder(
              controller: etkinlikController.pageController,
              onPageChanged: (index) {
                etkinlikController.currentIndex.value = index;
              },
              itemCount: etkinlikController.etkinlikListesi.length,
              itemBuilder: (context, index) {
                var etkinlik = etkinlikController.etkinlikListesi[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => DetailEventScreen(etkinlik: etkinlik));
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(etkinlik.kucukAfis),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        color: overlayColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.05,
                            vertical: Get.height * 0.01),
                        child: Text(
                          etkinlik.adi,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: Obx(() => Text(
                  '${etkinlikController.currentIndex.value + 1}/${etkinlikController.etkinlikListesi.length}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    backgroundColor: overlayColor,
                  ),
                )),
          ),
        ],
      );
    });
  }
}
