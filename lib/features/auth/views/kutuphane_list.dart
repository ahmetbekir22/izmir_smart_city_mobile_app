import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/general_filter_controller.dart';
import '../../../controllers/location_controller.dart';
import '../../../controllers/kutuphane_controller.dart';
import '../../../controllers/theme_contoller.dart';
import '../../../core/api/kutuphane_model.dart';
import '../widgets/general_card.dart';
import 'general_filter_UI.dart';

class KutuphaneList extends StatelessWidget {
  final ThemeController themeController = Get.find();
  final KutuphaneController kutuphaneController =
      Get.put(KutuphaneController());
  final ScrollController scrollController = ScrollController();
  final LocationController locationController = Get.put(LocationController());

  late final GenericFilterController<KutuphaneBilgi> filterController;

  KutuphaneList({Key? key}) : super(key: key) {
    filterController = Get.put(GenericFilterController<KutuphaneBilgi>(
      extractIlce: (kutuphane) => kutuphane.iLCE ?? '',
      extractMahalle: (kutuphane) => kutuphane.mAHALLE ?? '',
    ));

    ever(kutuphaneController.kutuphaneList, (list) {
      if (list.isNotEmpty) {
        filterController.initializeFilterData(list);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kütüphaneler'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => GenericFilterDialog<KutuphaneBilgi>(
                  filterController: filterController,
                  allItems: kutuphaneController.kutuphaneList,
                  title: 'Kütüphane Filtrele',
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (kutuphaneController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (kutuphaneController.errorMessage.isNotEmpty) {
          return Center(child: Text(kutuphaneController.errorMessage.value));
        }

        final displayList = filterController.filteredList.isNotEmpty
            ? filterController.filteredList
            : kutuphaneController.kutuphaneList;

        if (displayList.isEmpty) {
          return const Center(child: Text('Kütüphane bulunamadı.'));
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
              final kutuphane = displayList[index];
              return GeneralCard(
                adi: kutuphane.aDI ?? 'Bilinmiyor',
                ilce: kutuphane.iLCE ?? 'Bilinmiyor',
                mahalle: kutuphane.mAHALLE ?? 'Bilinmiyor',
                aciklama: kutuphane.aCIKLAMA,
                onLocationTap:
                    kutuphane.eNLEM != null && kutuphane.bOYLAM != null
                        ? () {
                            locationController.openLocationByCoordinates(
                                kutuphane.eNLEM!, kutuphane.bOYLAM!);
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
