import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/controllers/filter_controllers/general_filter_controller.dart';
import 'package:smart_city_app/controllers/location_controllers/location_controller.dart';
import 'package:smart_city_app/features/auth/views/filter_pages/general_filter_UI.dart';
import 'package:smart_city_app/features/auth/views/map_pages/map_view.dart';
import 'package:smart_city_app/features/auth/widgets/card_widgets/general_card.dart';

abstract class BaseListPage<T> extends StatefulWidget {
  final String title;
  final RxList<T> items;
  final String Function(T) extractIlce;
  final String Function(T) extractMahalle;
  final String? Function(T) extractAdi;
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
    this.extractGun,
  });

  @override
  _BaseListPageState<T> createState() => _BaseListPageState<T>();
}

class _BaseListPageState<T> extends State<BaseListPage<T>> {
  final ScrollController scrollController = ScrollController();
  late final GenericFilterController<T> filterController;
  final RxInt currentTabIndex = 0.obs;

  @override
  void initState() {
    super.initState();

    filterController = Get.put(
      GenericFilterController<T>(
        extractIlce: widget.extractIlce,
        extractMahalle: widget.extractMahalle,
      ),
    );

    // Initialize filter data
    ever(widget.items, (list) {
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
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          Obx(() {
            if (currentTabIndex.value == 0) {
              return IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => GenericFilterDialog<T>(
                      filterController: filterController,
                      allItems: widget.items,
                      title: '${widget.title} Filtrele',
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
      body: Obx(() {
        // TabBar'a göre doğru içeriği seç
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
            child: ListView.builder(
              controller: scrollController,
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                final item = displayList[index];
                return GeneralCard(
                  adi: widget.extractAdi(item) ?? 'Bilinmiyor',
                  ilce: widget.extractIlce(item),
                  mahalle: widget.extractMahalle(item),
                  aciklama: widget.extractAciklama != null ? widget.extractAciklama!(item) : null,
                  gun: widget.extractGun != null ? widget.extractGun!(item) : null,
                  onLocationTap: widget.extractEnlem != null && widget.extractBoylam != null
                      ? () {
                          final enlem = widget.extractEnlem!(item);
                          final boylam = widget.extractBoylam!(item);
                          if (enlem != null && boylam != null) {
                            Get.put(LocationController()).openLocationByCoordinates(
                              enlem,
                              boylam,
                            );
                          }
                        }
                      : null,
                );
              },
            ),
          );
        } else {
          return const MapView(); // Map görünümü
        }
      }),
    ),
  );
}

}
