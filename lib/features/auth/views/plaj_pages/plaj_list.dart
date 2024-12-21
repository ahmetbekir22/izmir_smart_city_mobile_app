import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/features/auth/views/map_pages/map_view.dart';
import '../../../../controllers/filter_controllers/general_filter_controller.dart';
import '../../../../controllers/location_controllers/location_controller.dart';
import '../../../../controllers/plaj_controllers/plaj_controller.dart';
import '../../../../controllers/theme_contoller.dart';
import '../../../../core/api/plaj_api/plaj_model.dart';
import '../../widgets/card_widgets/general_card.dart';
import '../filter_pages/general_filter_UI.dart';

class PlajList extends StatefulWidget {
  @override
  _PlajListState createState() => _PlajListState();
}

class _PlajListState extends State<PlajList> {
  final ThemeController themeController = Get.find();
  final PlajController plajController = Get.put(PlajController());
  final ScrollController scrollController = ScrollController();
  final LocationController locationController = Get.put(LocationController());

  // Create a generic filter controller specific to Plaj
  late final GenericFilterController<Onemliyer> filterController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize filter controller with extraction functions
    filterController = Get.put(
      GenericFilterController<Onemliyer>(
        extractIlce: (plaj) => plaj.iLCE ?? '',
        extractMahalle: (plaj) => plaj.mAHALLE ?? '',
      ),
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plajlar'),
          centerTitle: true,
          actions: _currentTabIndex == 0
              ? [
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      setState(() {}); // Ensure state rebuilds for filter controller
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
                ]
              : null,
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _currentTabIndex = index;
              });
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
                                plaj.bOYLAM!,
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