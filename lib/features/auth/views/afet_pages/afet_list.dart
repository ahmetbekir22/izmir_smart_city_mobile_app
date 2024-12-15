import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/filter_controllers/general_filter_controller.dart';
import '../../../../controllers/location_controllers/location_controller.dart';
import '../../../../controllers/afet_controllers/afet_controller.dart';
import '../../../../controllers/theme_contoller.dart';
import '../../../../core/api/afet_api/afet_model.dart';
import '../../widgets/card_widgets/general_card.dart';
import '../filter_pages/general_filter_UI.dart';

class AfetList extends StatelessWidget {
  final ThemeController themeController = Get.find();
  final AfetController afetController = Get.put(AfetController());
  final ScrollController scrollController = ScrollController();
  final LocationController locationController = Get.put(LocationController());
  
  // Create a generic filter controller specific to Afet
  late final GenericFilterController<Onemliyer> filterController;

  AfetList({Key? key}) : super(key: key) {
    // Initialize filter controller with extraction functions
    filterController = Get.put(
      GenericFilterController<Onemliyer>(
        extractIlce: (afet) => afet.iLCE ?? '',
        extractMahalle: (afet) => afet.mAHALLE ?? '',
      )
    );

    // Initialize filter data when controller is created
    ever(afetController.afetList, (list) {
      if (list.isNotEmpty) {
        filterController.initializeFilterData(list);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Afet Toplanma Alanları'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => GenericFilterDialog<Onemliyer>(
                  filterController: filterController,
                  allItems: afetController.afetList,
                  title: 'Toplanma Alanları Filtrele',
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (afetController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (afetController.errorMessage.isNotEmpty) {
          return Center(child: Text(afetController.errorMessage.value));
        }

        // Use filtered list or original list if no filter applied
        final displayList = filterController.filteredList.isNotEmpty
            ? filterController.filteredList
            : afetController.afetList;

        if (displayList.isEmpty) {
          return const Center(child: Text('Toplanma Alanı bulunamadı.'));
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
              final afet = displayList[index];
              return GeneralCard(
                adi: afet.aDI ?? 'Bilinmiyor',
                ilce: afet.iLCE ?? 'Bilinmiyor',
                mahalle: afet.mAHALLE ?? 'Bilinmiyor',
                onLocationTap: afet.eNLEM != null && afet.bOYLAM != null
                  ? () {
                      locationController.openLocationByCoordinates(
                        afet.eNLEM!,
                        afet.bOYLAM!
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