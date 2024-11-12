import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/event_controller.dart';
import '../../../controllers/theme_contoller.dart';
import '../../../core/api/events_model.dart';
import '../widgets/custom_category_card.dart';
import 'event_detail_screen.dart';
import 'filter_dialog.dart';

class EtkinlikListesiSayfasi extends StatelessWidget {
  final EtkinlikController etkinlikController = Get.put(EtkinlikController());
  final ThemeController themeController = Get.put(ThemeController());
  final ScrollController _scrollController = ScrollController();

  EtkinlikListesiSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
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
        if (etkinlikController.filteredEventList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scrollbar(
          controller: _scrollController,
          thumbVisibility: false,
          thickness: 10,
          radius: const Radius.circular(8),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: etkinlikController.filteredEventList.length,
            itemBuilder: (context, index) {
              Etkinlik etkinlik = etkinlikController.filteredEventList[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: Get.height * 0.005),
                child: SizedBox(
                  height: Get.height * 0.4,
                  width: Get.width,
                  child: CustomCard(
                    isNetworkImage: true,
                    title: etkinlik.adi,
                    imagePath: etkinlik.kucukAfis,
                    location: etkinlik.etkinlikMerkezi,
                    date: etkinlik.etkinlikBaslamaTarihi.split('T')[0],
                    time: etkinlik.etkinlikBaslamaTarihi.split('T')[1],
                    onTap: () {
                      Get.to(() => DetailEventScreen(etkinlik: etkinlik));
                    },
                  ),
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
          onDateRangeSelected: etkinlikController.updateSelectedDateRange,
        );
      },
    );
  }
}
