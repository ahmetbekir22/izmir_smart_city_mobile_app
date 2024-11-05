import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../../controllers/event_controller.dart';
import 'event_detail_screen.dart';

class LatestEventsScreen extends StatefulWidget {
  @override
  _LatestEventsScreenState createState() => _LatestEventsScreenState();
}

class _LatestEventsScreenState extends State<LatestEventsScreen> {
  final EtkinlikController etkinlikController = Get.put(EtkinlikController());
  late PageController _pageController;
  RxInt currentIndex =
      0.obs; // Mevcut etkinlik indeksini tutar ve reaktif hale getirir
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startEventRotation();
  }

  @override
  void dispose() {
    _timer.cancel(); // Timer'ı iptal et
    _pageController.dispose(); // PageController'ı iptal et
    super.dispose();
  }

  void _startEventRotation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentIndex.value < etkinlikController.etkinlikListesi.length - 1) {
        currentIndex.value++;
      } else {
        currentIndex.value = 0;
      }
      _pageController.animateToPage(currentIndex.value,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Güncel Etkinlikler"),
        backgroundColor: const Color.fromARGB(255, 144, 117, 190),
      ),
      body: Obx(() {
        // Etkinlik listesi boşsa yükleniyor göstergesi göster
        if (etkinlikController.etkinlikListesi.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  currentIndex.value =
                      index; // Sayfa değiştiğinde mevcut indeksi güncelle
                },
                itemCount: etkinlikController.etkinlikListesi.length,
                itemBuilder: (context, index) {
                  var etkinlik = etkinlikController
                      .etkinlikListesi[index]; // Şu anki etkinlik

                  return GestureDetector(
                    onTap: () {
                      // Detay sayfasına yönlendirme
                      Get.to(() => DetailEventScreen(etkinlik: etkinlik));
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(etkinlik.kucukAfis),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          color: const Color.fromARGB(137, 107, 106, 106),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            etkinlik.adi,
                            style: const TextStyle(
                              color: Colors.white,
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
              right: 16, // Sağdan 16 piksel içeride
              top: 16, // Yukarıdan 16 piksel içeride
              child: Obx(() => Text(
                    '${currentIndex.value + 1}/${etkinlikController.etkinlikListesi.length}', // Mevcut etkinlik ve toplam etkinlik sayısı
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors
                          .black54, // Okunabilirliği artırmak için arka plan rengi
                    ),
                  )),
            ),
          ],
        );
      }),
    );
  }
}
