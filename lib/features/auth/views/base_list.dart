import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/controllers/filter_controllers/general_filter_controller.dart';
import 'package:smart_city_app/controllers/location_controllers/location_controller.dart';
import 'package:smart_city_app/features/auth/views/filter_pages/general_filter_UI.dart';
import 'package:smart_city_app/features/auth/views/map_pages/map_view.dart';
import 'package:smart_city_app/features/auth/widgets/button_wigdets/custom_tab_bar.dart';
import 'package:smart_city_app/features/auth/widgets/card_widgets/general_card.dart';
import '../../../../core/mixins/performance_monitoring_mixin.dart';

abstract class BaseListPage<T> extends StatefulWidget {
  final String title;
  final RxList<T> items;
  final String Function(T) extractIlce;
  final String Function(T) extractMahalle;
  final String? Function(T)? extractAdi;
  final double? Function(T)? extractEnlem;
  final double? Function(T)? extractBoylam;
  final String? Function(T)? extractAciklama;
  final String? Function(T)? extractGun;

  BaseListPage({
    required this.title,
    required this.items,
    required this.extractIlce,
    required this.extractMahalle,
    required this.extractAdi,
    this.extractEnlem,
    this.extractBoylam,
    this.extractAciklama,
    this.extractGun, Key? key,
  }) : super(key: key);

  @override
  _BaseListPageState<T> createState() => _BaseListPageState<T>();
}

class _BaseListPageState<T> extends State<BaseListPage<T>> with PerformanceMonitoringMixin {
  final ScrollController scrollController = ScrollController();
  late final GenericFilterController<T> filterController;
  final RxInt currentTabIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    startPageLoadTrace('${widget.title}_page');

    try {
      filterController = Get.put(
        GenericFilterController<T>(
          extractIlce: widget.extractIlce,
          extractMahalle: widget.extractMahalle,
        ),
        tag: '${widget.title}_filter',
      );
    } catch (e) {
      // If controller already exists, find it
      filterController = Get.find<GenericFilterController<T>>(tag: '${widget.title}_filter');
    }

    ever(widget.items, (list) {
      if (list.isNotEmpty) {
        startApiTrace('filter_initialization');
        filterController.initializeFilterData(list);
        stopApiTrace();
        addMetric('items_count', list.length);
      }
    });
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
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          Obx(() {
            if (currentTabIndex.value == 0) {
              return IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  startTrace('filter_dialog');
                  showDialog(
                    context: context,
                    builder: (context) => GenericFilterDialog<T>(
                      filterController: filterController,
                      allItems: widget.items,
                      title: '${widget.title} Filtrele',
                    ),
                  )?.whenComplete(() => stopTrace('filter_dialog'));
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
        if (currentTabIndex.value == 0) {
          final displayList = filterController.filteredList.isNotEmpty
              ? filterController.filteredList
              : widget.items;

          if (displayList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

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
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  final item = displayList[index];
                  return GeneralCard(
                    adi: widget.extractAdi != null
                        ? widget.extractAdi!(item) ?? 'Bilinmiyor'
                        : 'Bilinmiyor',
                    ilce: widget.extractIlce(item),
                    mahalle: widget.extractMahalle(item),
                    aciklama: widget.extractAciklama != null
                        ? widget.extractAciklama!(item)
                        : null,
                    gun: widget.extractGun != null
                        ? widget.extractGun!(item)
                        : null,
                    onLocationTap: widget.extractEnlem != null &&
                            widget.extractBoylam != null
                        ? () {
                            startTrace('location_open');
                            final enlem = widget.extractEnlem!(item);
                            final boylam = widget.extractBoylam!(item);
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
          return const MapView();
        }
      }),
    );
  }
}
