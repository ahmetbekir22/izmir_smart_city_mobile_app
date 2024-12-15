import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../controllers/eczane_api_controllers/eczane_controller.dart';
import '../../../../core/coordiantes_calculations.dart';
import '../../widgets/card_widgets/category_card.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context, eczaneController);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (eczaneController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (eczaneController.filteredList.isEmpty) {
          return const Center(child: Text("Eczane bulunamadı."));
        }

        return ListView.builder(
          itemCount: eczaneController.filteredList.length,
          itemBuilder: (context, index) {
            final eczane = eczaneController.filteredList[index];
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Get.height * 0.004,
                            horizontal: Get.width * 0.005),
                        child: const Icon(FontAwesomeIcons.locationDot,
                            size: 20, color: Colors.red),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Adres: ${eczane.adres ?? 'Bilinmiyor'}',
                              style: const TextStyle(fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Get.height * 0.005,
                            horizontal: Get.width * 0.01),
                        child: const Icon(FontAwesomeIcons.phoneVolume,
                            size: 20, color: Colors.green),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Get.height * 0.005,
                            horizontal: Get.width * 0.01),
                        child: Text(
                            'Telefon: ${eczane.telefon ?? 'Bilinmiyor'}',
                            style: const TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Get.height * 0.005,
                            horizontal: Get.width * 0.01),
                        child: const Icon(FontAwesomeIcons.mapLocationDot,
                            size: 20, color: Colors.blue),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Get.height * 0.005,
                            horizontal: Get.width * 0.01),
                        child: Text('Bölge: ${eczane.bolge ?? 'Bilinmiyor'}',
                            style: const TextStyle(fontSize: 14)),
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

  void _showFilterBottomSheet(
      BuildContext context, EczaneController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Obx(() {
          final regions = controller.eczaneList
              .map((eczane) => eczane.bolge ?? '')
              .toSet()
              .where((bolge) => bolge.isNotEmpty)
              .toList();

          return Container(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: regions.length,
              itemBuilder: (context, index) {
                final region = regions[index];
                return ListTile(
                  title: Text(region),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    controller.filterByRegion(region);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          );
        });
      },
    );
  }
}
