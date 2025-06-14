import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/etkinlik_api_controllers/event_controller.dart';
import '../../../../controllers/theme_contoller.dart';
import '../../../../core/api/etkinlik/events_model.dart';
import '../../../../core/mixins/performance_monitoring_mixin.dart';
import '../../widgets/card_widgets/event_list_card.dart';
import 'event_detail_screen.dart';
import '../filter_pages/filter_dialog.dart';

class EtkinlikListesiSayfasi extends StatefulWidget {
  const EtkinlikListesiSayfasi({super.key});

  @override
  State<EtkinlikListesiSayfasi> createState() => _EtkinlikListesiSayfasiState();
}

class _EtkinlikListesiSayfasiState extends State<EtkinlikListesiSayfasi> with PerformanceMonitoringMixin {
  final EtkinlikController etkinlikController = Get.put(EtkinlikController());
  final ThemeController themeController = Get.put(ThemeController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    startPageLoadTrace('etkinlik_listesi_page');
  }

  @override
  void dispose() {
    stopPageLoadTrace();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    etkinlikController.clearFilters(); // Reset filters when the page is built
    return Scaffold(
      appBar: AppBar(
        title: const Text("Güncel Etkinlikler"),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              startPageLoadTrace('filter_dialog');
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: Obx(() {
        // Display loading indicator if filtered events are empty
        if (etkinlikController.filteredEventList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        addMetric('filtered_events_count', etkinlikController.filteredEventList.length);

        return Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          thickness: 10,
          radius: const Radius.circular(8),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: etkinlikController.filteredEventList.length,
            itemBuilder: (context, index) {
              Etkinlik etkinlik = etkinlikController.filteredEventList[index];
              String formattedDate;
              try {
                formattedDate = DateFormat('dd-MM-yyyy')
                    .format(DateTime.parse(etkinlik.etkinlikBaslamaTarihi));
              } catch (e) {
                formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
              }
              return Padding(
                padding: EdgeInsets.symmetric(vertical: Get.height * 0.005),
                child: EventListCard(
                  isNetworkImage: true,
                  title: etkinlik.adi,
                  category: etkinlik.tur,
                  imagePath: etkinlik.kucukAfis,
                  location: etkinlik.etkinlikMerkezi,
                  date: formattedDate,
                  time: etkinlik.etkinlikBaslamaTarihi,
                  onTap: () {
                    startTrace('event_detail');
                    PerformanceMonitoringMixin.startNavigationTrace('event_detail_page');
                    Get.to(() => DetailEventScreen(etkinlik: etkinlik))
                        ?.whenComplete(() {
                          stopTrace('event_detail');
                          PerformanceMonitoringMixin.stopNavigationTrace('event_detail_page');
                        });
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          onLocationSelected: (location) {
            PerformanceMonitoringMixin.startApiCall('filter_location');
            etkinlikController.updateSelectedLocation(location);
            PerformanceMonitoringMixin.stopApiCall('filter_location');
          },
          onTypeSelected: (type) {
            PerformanceMonitoringMixin.startApiCall('filter_type');
            etkinlikController.updateSelectedType(type);
            PerformanceMonitoringMixin.stopApiCall('filter_type');
          },
          onDateRangeSelected: (range) {
            PerformanceMonitoringMixin.startApiCall('filter_date');
            etkinlikController.updateSelectedDateRange(range);
            PerformanceMonitoringMixin.stopApiCall('filter_date');
          },
        );
      },
    )?.whenComplete(() => stopTrace('filter_dialog'));
  }
}
