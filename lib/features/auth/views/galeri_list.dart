import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/general_filter_controller.dart';
import '../../../controllers/location_controller.dart';
import '../../../controllers/galeri_controller.dart';
import '../../../controllers/theme_contoller.dart';
import '../../../core/api/galeri_model.dart';
import '../widgets/general_card.dart';
import 'general_filter_UI.dart';

class GaleriList extends StatelessWidget {
  final ThemeController themeController = Get.find();
  final GaleriController galeriController = Get.put(GaleriController());
  final ScrollController scrollController = ScrollController();
  final LocationController locationController = Get.put(LocationController());

  late final GenericFilterController<GaleriSalon> filterController;

  GaleriList({Key? key}) : super(key: key) {
    filterController = Get.put(GenericFilterController<GaleriSalon>(
      extractIlce: (galeri) => galeri.iLCE ?? '',
      extractMahalle: (galeri) => galeri.mAHALLE ?? '',
    ));

    ever(galeriController.galeriList, (list) {
      if (list.isNotEmpty) {
        filterController.initializeFilterData(list);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeri Salonları'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => GenericFilterDialog<GaleriSalon>(
                  filterController: filterController,
                  allItems: galeriController.galeriList,
                  title: 'Galeri Filtrele',
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (galeriController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (galeriController.errorMessage.isNotEmpty) {
          return Center(child: Text(galeriController.errorMessage.value));
        }

        final displayList = filterController.filteredList.isNotEmpty
            ? filterController.filteredList
            : galeriController.galeriList;

        if (displayList.isEmpty) {
          return const Center(child: Text('Galeri salonu bulunamadı.'));
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
              final galeri = displayList[index];
              return GeneralCard(
                adi: galeri.aDI ?? 'Bilinmiyor',
                ilce: galeri.iLCE ?? 'Bilinmiyor',
                mahalle: galeri.mAHALLE ?? 'Bilinmiyor',
                aciklama: galeri.aCIKLAMA,
                onLocationTap: galeri.eNLEM != null && galeri.bOYLAM != null
                    ? () {
                        locationController.openLocationByCoordinates(
                            galeri.eNLEM!, galeri.bOYLAM!);
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
