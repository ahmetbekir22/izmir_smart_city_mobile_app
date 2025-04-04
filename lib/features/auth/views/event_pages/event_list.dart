import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/etkinlik_api_controllers/event_controller.dart';
import '../../../../controllers/theme_contoller.dart';
import '../../../../core/api/etkinlik/events_model.dart';
import '../../widgets/card_widgets/event_list_card.dart';
import 'event_detail_screen.dart';
import '../filter_pages/filter_dialog.dart';

class EtkinlikListesiSayfasi extends StatelessWidget {
  final EtkinlikController etkinlikController = Get.put(EtkinlikController());
  final ThemeController themeController = Get.put(ThemeController());
  final ScrollController _scrollController = ScrollController();

  EtkinlikListesiSayfasi({super.key});

  // Add a method to reset filters
  void onInit() {}

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
                    Get.to(() => DetailEventScreen(etkinlik: etkinlik));
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
          onLocationSelected: etkinlikController.updateSelectedLocation,
          onTypeSelected: etkinlikController.updateSelectedType,
          onDateRangeSelected: etkinlikController.updateSelectedDateRange,
        );
      },
    );
  }
}
