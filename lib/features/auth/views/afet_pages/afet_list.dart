import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/features/auth/views/map_pages/map_view.dart';
import '../../../../controllers/filter_controllers/general_filter_controller.dart';
import '../../../../controllers/location_controllers/location_controller.dart';
import '../../../../controllers/afet_controllers/afet_controller.dart';
import '../../../../controllers/theme_contoller.dart';
import '../../../../core/api/afet_api/afet_model.dart';
import '../../widgets/card_widgets/general_card.dart';
import '../filter_pages/general_filter_UI.dart';

class AfetList extends StatefulWidget {
  @override
  _AfetListState createState() => _AfetListState();
}

class _AfetListState extends State<AfetList> {
  final ThemeController themeController = Get.find();
  final AfetController afetController = Get.put(AfetController());
  final ScrollController scrollController = ScrollController();
  final LocationController locationController = Get.put(LocationController());

  // Create a generic filter controller specific to Afet
  late final GenericFilterController<Onemliyer> filterController;
  final RxInt currentTabIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    // Initialize filter controller with extraction functions
    filterController = Get.put(
      GenericFilterController<Onemliyer>(
        extractIlce: (afet) => afet.iLCE ?? '',
        extractMahalle: (afet) => afet.mAHALLE ?? '',
      ),
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Afet Toplanma Alanları'),
          centerTitle: true,
          actions: [
            Obx(() {
              if (currentTabIndex.value == 0) {
                return IconButton(
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
                );
              }
              return const SizedBox.shrink();
            }),
          ],
          bottom: TabBar(
            onTap: (index) {
              currentTabIndex.value = index;
            },
            tabs: const [
              Tab(text: 'Liste Görünümü'),
              Tab(text: 'Harita Görünümü'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: List view
            Obx(() {
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
                                afet.bOYLAM!,
                              );
                            }
                          : null,
                    );
                  },
                ),
              );
            }),

            // Tab 2: Map view
            Center(
              child: MapView()
            ),
          ],
        ),
      ),
    );
  }
}
