import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/controllers/pazar_yer_controllers/pazar_yeri_controller.dart';
import 'package:smart_city_app/core/coordiantes_calculations.dart';
import 'package:smart_city_app/features/auth/widgets/card_widgets/category_card.dart';

class PazarYeriHomeScreen extends StatelessWidget {
  const PazarYeriHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PazarYeriController pazarYeriController =
        Get.put(PazarYeriController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Semt Pazarları"),
        centerTitle: true,
        backgroundColor: Get.theme.appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _filterPagePazarYeri(context, pazarYeriController);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (pazarYeriController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final pazarYerleriList =
            pazarYeriController.filteredPazarYerleri.isEmpty
                ? pazarYeriController.pazarYerleri
                : pazarYeriController.filteredPazarYerleri;

        if (pazarYerleriList.isEmpty) {
          return const Center(child: Text("Hiçbir semt pazarı bulunamadı."));
        }

        return ListView.builder(
          itemCount: pazarYerleriList.length,
          itemBuilder: (context, index) {
            final pazar = pazarYerleriList[index];

            return CategoryCard(
              title: pazar.aDI ?? "Adı Belirtilmemiş",
              imagePath: "assets/images/semtpazarı.jpg",
              onTap: () {
                // Koordinatlar geçerli mi kontrol et
                if (pazar.eNLEM != null && pazar.bOYLAM != null) {
                  openMapWithCoordinates(
                      pazar.eNLEM!.toString(),
                      pazar.bOYLAM!
                          .toString()); // '!' null güvenliğini sağlamak
                } else {
                  // Koordinatlar yoksa uyarı ver
                  Get.snackbar('Hata', 'Bu pazar yerinin koordinatları yok.',
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
              customContent: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: Get.width * 0.04,
                      right: Get.width * 0.04,
                      top: Get.height * 0.01,
                    ),
                    child: Row(
                      children: [
                        const Icon(FontAwesomeIcons.locationArrow,
                            size: 21, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          "Mahalle: ${pazar.mAHALLE ?? "Bilinmiyor"}",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.04,
                      vertical: Get.height * 0.005,
                    ),
                    child: Row(
                      children: [
                        const Icon(FontAwesomeIcons.locationDot,
                            size: 21, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          "İlçe: ${pazar.iLCE ?? "Bilinmiyor"}",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: Get.width * 0.04,
                      right: Get.width * 0.04,
                      bottom: Get.height * 0.01,
                    ),
                    child: Row(
                      children: [
                        const Icon(FontAwesomeIcons.calendarDay,
                            size: 21, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          "Gün: ${pazarYeriController.extractDay(pazar.aCIKLAMA)}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
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
      }),
    );
  }
}

void _filterPagePazarYeri(
    BuildContext context, PazarYeriController controller) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Obx(() {
        // İlçeler listesi
        final regions = controller.pazarYerleri
            .map((pazar) => pazar.iLCE ?? '')
            .toSet()
            .where((ilce) => ilce.isNotEmpty)
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
                  controller.filterByIlce(region);
                  Navigator.pop(context); // BottomSheet'i kapat
                },
              );
            },
          ),
        );
      });
    },
  );
}

// void _filterPagePazarYeri(
//     BuildContext context, PazarYeriController controller) {
//   showModalBottomSheet(
//     context: context,
//     builder: (context) {
//       return Obx(() {
//         // İlçeler listesi
//         final regions = controller.pazarYerleri
//             .map((pazar) => pazar.iLCE ?? '')
//             .toSet()
//             .where((ilce) => ilce.isNotEmpty)
//             .toList();

//         return Container(
//           padding: const EdgeInsets.all(16),
//           child: ListView.builder(
//             itemCount: regions.length,
//             itemBuilder: (context, index) {
//               final region = regions[index];
//               return ListTile(
//                 title: Text(region),
//                 trailing: const Icon(Icons.chevron_right), // Sağ ok ikonu
//                 onTap: () {
//                   controller.filterByIlce(region);
//                   Navigator.pop(context); // BottomSheet'i kapat
//                 },
//               );
//             },
//           ),
//         );
//       });
//     },
//   );
// }
