import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/event_controller.dart';
import '../../../controllers/theme_contoller.dart';
import '../../../core/api/events_model.dart';
import '../widgets/custom_category_card.dart';
import 'event_detail_screen.dart';

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
              // Get.to(() => FiltreDrawer());
            },
          ),
        ],
      ),
      body: Obx(() {
        // Eğer etkinlikler boşsa, yükleniyor göstergesini göster
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

              // Eğer etkinlik saat bilgisi içeriyorsa, tarihi güncelle
              String formattedDate;
              try {
                // Eğer tarih ve saat bilgisini içeriyorsa
                formattedDate =
                    DateFormat('yyyy-MM-dd').format(DateTime.parse(etkinlik.etkinlikBaslamaTarihi));
              } catch (e) {
                // Sadece saati içeriyorsa, tarihi bugünün tarihi olarak kabul et
                formattedDate = DateFormat('dd-mm-yyyy').format(DateTime.now());
              }

              return Padding(
                padding: EdgeInsets.symmetric(vertical: Get.height * 0.005),
                child: CustomCard(
                  isNetworkImage: true,
                  title: etkinlik.adi,
                  category: etkinlik.tur,
                  imagePath: etkinlik.kucukAfis,
                  location: etkinlik.etkinlikMerkezi,
                  date: formattedDate, // Date burada formatlanmış şekilde geçiyor
                  time: etkinlik.etkinlikBaslamaTarihi, // Saat burada
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

  // Filtreleme dialogunu Get.dialog ile açma
  // void _showFilterDialog() {
  //   Get.dialog(
  //     LocationAndDateFilterDialog(
  //       locations:
  //           etkinlikController.eventList.map((event) => event.etkinlikMerkezi).toSet().toList(),
  //       onFilterApplied: (filters) {
  //         String? selectedLocation = filters['location'];
  //         DateTime? selectedDate = filters['date'];

  //         // Etkinlikleri filtrelemek için EtkinlikController'a çağrı yapıyoruz
  //         etkinlikController.filterEvents(selectedLocation, selectedDate);
  //       },
  //     ),
  //     barrierDismissible: true, // Kullanıcı dışarı tıklarsa dialog kapanabilir
  //   );
  // }
}
