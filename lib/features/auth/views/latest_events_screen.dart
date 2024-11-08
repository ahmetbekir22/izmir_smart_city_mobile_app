// LatestEventsScreen.dart
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
  RxInt currentIndex = 0.obs;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startEventRotation();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
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
    return Obx(() {
      if (etkinlikController.etkinlikListesi.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                currentIndex.value = index;
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
            right: 16,
            top: 16,
            child: Obx(() => Text(
                  '${currentIndex.value + 1}/${etkinlikController.etkinlikListesi.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.black54,
                  ),
                )),
          ),
        ],
      );
    });
  }
}
