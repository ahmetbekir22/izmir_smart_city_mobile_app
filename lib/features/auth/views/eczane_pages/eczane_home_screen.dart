// eczane_list_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/controllers/eczane_api_controllers/eczane_controller.dart';
import 'package:smart_city_app/controllers/location_controllers/location_controller.dart';
import 'package:smart_city_app/features/auth/views/map_pages/map_view.dart';
import 'package:smart_city_app/features/auth/widgets/button_wigdets/custom_tab_bar.dart';
import 'package:smart_city_app/features/auth/widgets/card_widgets/general_card.dart';
import '../../../../core/mixins/performance_monitoring_mixin.dart';

class EczaneListPage extends StatefulWidget {
  const EczaneListPage({Key? key}) : super(key: key);

  @override
  _EczaneListPageState createState() => _EczaneListPageState();
}

class _EczaneListPageState extends State<EczaneListPage> with PerformanceMonitoringMixin {
  final ScrollController scrollController = ScrollController();
  final RxInt currentTabIndex = 0.obs;
  final EczaneController eczaneController = Get.put(EczaneController());

  @override
  void initState() {
    super.initState();
    startPageLoadTrace('eczane_page');
  }

  @override
  void dispose() {
    stopPageLoadTrace();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nöbetçi Eczaneler"),
        centerTitle: true,
        backgroundColor: Get.theme.appBarTheme.backgroundColor,
        actions: [
          Obx(() {
            if (currentTabIndex.value == 0) {
              return IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  startTrace('filter_bottom_sheet');
                  _showFilterBottomSheet(context);
                },
              );
            }
            return const SizedBox.shrink();
          }),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Obx(() {
            return CustomTabBar(
              currentIndex: currentTabIndex.value,
              labels: const ['Liste Görünümü', 'Harita Görünümü'],
              onTap: (index) {
                startTrace('view_switch');
                currentTabIndex.value = index;
                addMetric('view_type', index);
                stopTrace('view_switch');
              },
            );
          }),
        ),
      ),
      body: Obx(() {
        if (eczaneController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (currentTabIndex.value == 0) {
          if (eczaneController.filteredList.isEmpty) {
            return const Center(child: Text("Eczane bulunamadı."));
          }

          addMetric('filtered_items_count', eczaneController.filteredList.length);

          return Scrollbar(
            controller: scrollController,
            thickness: 10,
            radius: const Radius.circular(8),
            thumbVisibility: false,
            interactive: true,
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: ListView.builder(
                controller: scrollController,
                itemCount: eczaneController.filteredList.length,
                itemBuilder: (context, index) {
                  final eczane = eczaneController.filteredList[index];
                  return GeneralCard(
                    adi: eczane.adi ?? 'Bilinmiyor',
                    ilce: eczane.bolge ?? 'Bilinmiyor',
                    mahalle: eczane.adres ?? 'Bilinmiyor',
                    telefon: eczane.telefon,
                    onLocationTap: eczane.lokasyonX != null && 
                                 eczane.lokasyonY != null
                        ? () {
                            startTrace('location_open');
                            final enlem = double.tryParse(eczane.lokasyonX!);
                            final boylam = double.tryParse(eczane.lokasyonY!);
                            if (enlem != null && boylam != null) {
                              Get.put(LocationController())
                                  .openLocationByCoordinates(enlem, boylam);
                            }
                            stopTrace('location_open');
                          }
                        : null,
                  );
                },
              ),
            ),
          );
        } else {
          return MapView();
        }
      }),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Obx(() {
          final regions = eczaneController.eczaneList
              .map((eczane) => eczane.bolge ?? '')
              .toSet()
              .where((bolge) => bolge.isNotEmpty)
              .toList();

          addMetric('filter_regions_count', regions.length);

          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Bölgeye Göre Filtrele',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: regions.length,
                    itemBuilder: (context, index) {
                      final region = regions[index];
                      return ListTile(
                        title: Text(region),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          startTrace('filter_apply');
                          eczaneController.filterByRegion(region);
                          addMetric('selected_region_index', index);
                          Navigator.pop(context);
                          stopTrace('filter_apply');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
      },
    ).whenComplete(() => stopTrace('filter_bottom_sheet'));
  }
}
