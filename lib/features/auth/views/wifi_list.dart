import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/general_filter_controller.dart';
import '../../../controllers/location_controller.dart';
import '../../../controllers/wifi_controller.dart';
import '../../../controllers/theme_contoller.dart';
import '../../../core/api/wifi_model.dart';
import '../widgets/general_card.dart';
import 'general_filter_UI.dart';

class WifiList extends StatelessWidget {
  final ThemeController themeController = Get.find();
  final WifiController wifiController = Get.put(WifiController());
  final ScrollController scrollController = ScrollController();
  final LocationController locationController = Get.put(LocationController());
  
  // Create a generic filter controller specific to Wifi
  late final GenericFilterController<Onemliyer> filterController;

  WifiList({Key? key}) : super(key: key) {
    // Initialize filter controller with extraction functions
    filterController = Get.put(
      GenericFilterController<Onemliyer>(
        extractIlce: (wifi) => wifi.iLCE ?? '',
        extractMahalle: (wifi) => wifi.mAHALLE ?? '',
      )
    );

    // Initialize filter data when controller is created
    ever(wifiController.wifiList, (list) {
      if (list.isNotEmpty) {
        filterController.initializeFilterData(list);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wifi'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => GenericFilterDialog<Onemliyer>(
                  filterController: filterController,
                  allItems: wifiController.wifiList,
                  title: 'Wifi Filtrele',
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (wifiController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (wifiController.errorMessage.isNotEmpty) {
          return Center(child: Text(wifiController.errorMessage.value));
        }

        // Use filtered list or original list if no filter applied
        final displayList = filterController.filteredList.isNotEmpty
            ? filterController.filteredList
            : wifiController.wifiList;

        if (displayList.isEmpty) {
          return const Center(child: Text('Wifi bulunamadı.'));
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
              final wifi = displayList[index];
              return GeneralCard(
                adi: wifi.aDI ?? 'Bilinmiyor',
                ilce: wifi.iLCE ?? 'Bilinmiyor',
                mahalle: wifi.mAHALLE ?? 'Bilinmiyor',
                onLocationTap: wifi.eNLEM != null && wifi.bOYLAM != null
                  ? () {
                      locationController.openLocationByCoordinates(
                        wifi.eNLEM!,
                        wifi.bOYLAM!
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