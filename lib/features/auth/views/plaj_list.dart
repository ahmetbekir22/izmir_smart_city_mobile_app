import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/location_controller.dart';
import '../../../controllers/plaj_controller.dart';
import '../../../controllers/theme_contoller.dart';
import '../../../controllers/general_filter_controller.dart';
import '../widgets/general_card.dart';
import 'general_filter_UI.dart';

class PlajList extends StatelessWidget {
  final ThemeController themeController = Get.find();
  final PlajController plajController = Get.put(PlajController()); // Change this line
  final GeneralFilterController filterController = Get.put(GeneralFilterController());
  final LocationController locationController = Get.put(LocationController());

  final ScrollController scrollController = ScrollController();

  PlajList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plajlar'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => GeneralFilterDialog(),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (plajController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (plajController.errorMessage.isNotEmpty) {
          return Center(child: Text(plajController.errorMessage.value));
        }

        // Use filtered list or original list if no filter applied
        final displayList = filterController.filteredPlajList.isNotEmpty 
            ? filterController.filteredPlajList 
            : plajController.plajList;

        if (displayList.isEmpty) {
          return const Center(child: Text('Plaj bulunamadı.'));
        }

        return Scrollbar(
          controller: scrollController,
          thickness: 10,
          radius: const Radius.circular(8),
          thumbVisibility: false,
          interactive: true,
          child: ListView.builder(
            controller: scrollController,
            itemCount: displayList.length,
            itemBuilder: (context, index) {
              final plaj = displayList[index];
              return GeneralCard(
                adi: plaj.aDI ?? 'Bilinmiyor',
                ilce: plaj.iLCE ?? 'Bilinmiyor',
                mahalle: plaj.mAHALLE ?? 'Bilinmiyor',
                onLocationTap: plaj.eNLEM != null && plaj.bOYLAM != null
                  ? () {
                      final LocationController locationController = Get.find();
                      locationController.openLocationByCoordinates(
                        plaj.eNLEM!, 
                        plaj.bOYLAM!
                      );
                    }
                  : null, // Disable location tap if coordinates are missing
              );
            },
          ),
        );
      }),
    );
  }
}