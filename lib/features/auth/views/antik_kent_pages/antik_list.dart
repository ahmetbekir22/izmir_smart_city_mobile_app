import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/filter_controllers/general_filter_controller.dart';
import '../../../../controllers/location_controllers/location_controller.dart';
import '../../../../controllers/antik_yerler_controllers/antik_controller.dart';
import '../../../../controllers/theme_contoller.dart';
import '../../../../core/api/antik_api/antik_model.dart';
import '../../widgets/card_widgets/general_card.dart';
import '../filter_pages/general_filter_UI.dart';

class AntikList extends StatelessWidget {
  final ThemeController themeController = Get.find();
  final AntikController antikController = Get.put(AntikController());
  final ScrollController scrollController = ScrollController();
  final LocationController locationController = Get.put(LocationController());

  late final GenericFilterController<Antik> filterController;

  AntikList({Key? key}) : super(key: key) {
    filterController = Get.put(GenericFilterController<Antik>(
      extractIlce: (antik) => antik.iLCE ?? '',
      extractMahalle: (antik) => antik.mAHALLE ?? '',
    ));

    ever(antikController.antikList, (list) {
      if (list.isNotEmpty) {
        filterController.initializeFilterData(list);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Antik Kentler'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => GenericFilterDialog<Antik>(
                  filterController: filterController,
                  allItems: antikController.antikList,
                  title: 'Antik Kent Filtrele',
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (antikController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (antikController.errorMessage.isNotEmpty) {
          return Center(child: Text(antikController.errorMessage.value));
        }

        final displayList = filterController.filteredList.isNotEmpty
            ? filterController.filteredList
            : antikController.antikList;

        if (displayList.isEmpty) {
          return const Center(child: Text('Antik kent bulunamadı.'));
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
              final antik = displayList[index];
              return GeneralCard(
                adi: antik.aDI ?? 'Bilinmiyor',
                ilce: antik.iLCE ?? 'Bilinmiyor',
                mahalle: antik.mAHALLE ?? 'Bilinmiyor',
                aciklama: antik.aCIKLAMA,
                onLocationTap: antik.eNLEM != null && antik.bOYLAM != null
                    ? () {
                        locationController.openLocationByCoordinates(
                            antik.eNLEM!, antik.bOYLAM!);
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
