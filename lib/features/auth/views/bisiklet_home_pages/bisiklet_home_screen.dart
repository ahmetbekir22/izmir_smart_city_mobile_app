import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../controllers/bisiklet_api_controllers/bisiklet_controller.dart';
import '../../../../controllers/theme_contoller.dart';

class BisikletHomeScreen extends StatelessWidget {
  final BisikletController bisikletController = Get.put(BisikletController());
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bisiklet İstasyonları'),
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
        // AppBar arka plan rengi
      ),
      body: Obx(() {
        if (bisikletController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (bisikletController.errorMessage.isNotEmpty) {
          return Center(child: Text(bisikletController.errorMessage.value));
        } else {
          return ListView.builder(
            itemCount: bisikletController.stations.length,
            itemBuilder: (context, index) {
              final station = bisikletController.stations[index];
              return Container(
                margin: EdgeInsets.symmetric(
                    vertical: Get.height * 0.007,
                    horizontal: Get.width * 0.03), // Dinamik margin
                padding: EdgeInsets.all(Get.height * 0.015), // Dinamik padding
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blueGrey, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.bicycle, // Bisiklet ikonu
                      color: Colors.green,
                      size: Get.height * 0.06, // Dinamik ikon boyutu
                    ),
                    SizedBox(width: Get.width * 0.05), // Dinamik aralık
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            station['IstasyonAdi'] ?? 'İstasyon Adı',
                            style: TextStyle(
                              fontSize:
                                  Get.height * 0.025, // Dinamik font boyutu
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                              height: Get.height * 0.002), // Dinamik boşluk
                          Text(
                            'Kapasite: ${station['Kapasite']}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(
                            'Bisiklet Sayısı: ${station['BisikletSayisi']}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(
                            'Durum: ${station['Durumu'] == "1" ? "Açık" : "Kapalı"}',
                            style: TextStyle(
                              color: station['Durumu'] == "1"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }),
    );
  }
}
