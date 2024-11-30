import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/general_filter_controller.dart';
import '../../../controllers/location_controller.dart';
import '../../../controllers/veteriner_controller.dart';
import '../../../controllers/theme_contoller.dart';
import '../../../core/api/veteriner_model.dart';
import '../widgets/general_card.dart';
import 'general_filter_UI.dart';

class VeterinerList extends StatelessWidget {
  final ThemeController themeController = Get.find();
  final VeterinerController veterinerController = Get.put(VeterinerController());
  final ScrollController scrollController = ScrollController();
  final LocationController locationController = Get.put(LocationController());
  
  // Create a generic filter controller specific to Veteriner
  late final GenericFilterController<Onemliyer> filterController;

  VeterinerList({Key? key}) : super(key: key) {
    // Initialize filter controller with extraction functions
    filterController = Get.put(
      GenericFilterController<Onemliyer>(
        extractIlce: (veteriner) => veteriner.iLCE ?? '',
        extractMahalle: (veteriner) => veteriner.mAHALLE ?? '',
      )
    );

    // Initialize filter data when controller is created
    ever(veterinerController.veterinerList, (list) {
      if (list.isNotEmpty) {
        filterController.initializeFilterData(list);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veterinerlar'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => GenericFilterDialog<Onemliyer>(
                  filterController: filterController,
                  allItems: veterinerController.veterinerList,
                  title: 'Veteriner Filtrele',
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (veterinerController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (veterinerController.errorMessage.isNotEmpty) {
          return Center(child: Text(veterinerController.errorMessage.value));
        }

        // Use filtered list or original list if no filter applied
        final displayList = filterController.filteredList.isNotEmpty
            ? filterController.filteredList
            : veterinerController.veterinerList;

        if (displayList.isEmpty) {
          return const Center(child: Text('Veteriner bulunamadı.'));
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
              final veteriner = displayList[index];
              return GeneralCard(
                adi: veteriner.aDI ?? 'Bilinmiyor',
                ilce: veteriner.iLCE ?? 'Bilinmiyor',
                mahalle: veteriner.mAHALLE ?? 'Bilinmiyor',
                onLocationTap: veteriner.eNLEM != null && veteriner.bOYLAM != null
                  ? () {
                      locationController.openLocationByCoordinates(
                        veteriner.eNLEM!,
                        veteriner.bOYLAM!
                      );
                    }
                  : null,
              );
            },
          ),
        );
      }),
    );
  }
}