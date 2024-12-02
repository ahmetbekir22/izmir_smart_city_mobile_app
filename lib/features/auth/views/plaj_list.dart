import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/general_filter_controller.dart';
import '../../../controllers/location_controller.dart';
import '../../../controllers/plaj_controller.dart';
import '../../../controllers/theme_contoller.dart';
import '../../../core/api/plaj_model.dart';
import '../widgets/general_card.dart';
import 'general_filter_UI.dart';

class PlajList extends StatelessWidget {
  final ThemeController themeController = Get.find();
  final PlajController plajController = Get.put(PlajController());
  final ScrollController scrollController = ScrollController();
  final LocationController locationController = Get.put(LocationController());
  
  // Create a generic filter controller specific to Plaj
  late final GenericFilterController<Onemliyer> filterController;

  PlajList({Key? key}) : super(key: key) {
    // Initialize filter controller with extraction functions
    filterController = Get.put(
      GenericFilterController<Onemliyer>(
        extractIlce: (plaj) => plaj.iLCE ?? '',
        extractMahalle: (plaj) => plaj.mAHALLE ?? '',
      )
    );

    // Initialize filter data when controller is created
    ever(plajController.plajList, (list) {
      if (list.isNotEmpty) {
        filterController.initializeFilterData(list);
      }
    });
  }

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
                builder: (context) => GenericFilterDialog<Onemliyer>(
                  filterController: filterController,
                  allItems: plajController.plajList,
                  title: 'Plaj Filtrele',
                ),
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
        final displayList = filterController.filteredList.isNotEmpty
            ? filterController.filteredList
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
                      locationController.openLocationByCoordinates(
                        plaj.eNLEM!,
                        plaj.bOYLAM!
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