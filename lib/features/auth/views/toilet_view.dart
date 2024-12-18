import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/controllers/location_controllers/location_controller.dart';
import 'package:smart_city_app/controllers/toilet_controller.dart';
import 'package:smart_city_app/core/api/toilet_model.dart';
import 'package:smart_city_app/features/auth/views/filter_pages/general_filter_UI.dart';
import '../widgets/general_card.dart';
import '../../../../controllers/filter_controllers/general_filter_controller.dart';

class ToiletView extends GetView<ToiletController> {
  const ToiletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locationController = Get.find<LocationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Akıllı Tuvaletler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => GenericFilterDialog<Records>(
                  filterController: controller.filterController,
                  allItems: controller.toilets,
                  title: 'Tuvalet Filtrele',
                ),
              );
            },
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

          final displayedToilets =
              controller.filterController.filteredList.isEmpty
                  ? controller.toilets
                  : controller.filterController.filteredList;

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: displayedToilets.length,
            itemBuilder: (context, index) {
              final toilet = displayedToilets[index];

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
