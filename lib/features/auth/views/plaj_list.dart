import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/plaj_controller.dart';
import '../../../controllers/theme_contoller.dart';
import '../widgets/general_card.dart';

class PlajList extends StatelessWidget {
  final ThemeController themeController = Get.find();
  final PlajController plajController = Get.put(PlajController());

  final ScrollController scrollController = ScrollController();

  PlajList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plajlar'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Obx(() {
        if (plajController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (plajController.errorMessage.isNotEmpty) {
          return Center(child: Text(plajController.errorMessage.value));
        } else if (plajController.plajList.isEmpty) {
          return const Center(child: Text('Plaj bulunamadı.'));
        }

        return Scrollbar(
          controller: scrollController,
          thickness: 10,
          radius: const Radius.circular(8),
          thumbVisibility: false, // Kaydırma çubuğu her zaman görünür olsun
          interactive: true, // Sürüklemeyi aktif eder
          child: ListView.builder(
            controller: scrollController,
            itemCount: plajController.plajList.length,
            itemBuilder: (context, index) {
              final plaj = plajController.plajList[index];
              return GeneralCard(
                adi: plaj.aDI ?? 'Bilinmiyor',
                ilce: plaj.iLCE ?? 'Bilinmiyor',
                mahalle: plaj.mAHALLE ?? 'Bilinmiyor',
                onIconPressed: () {
                  print('${plaj.aDI} seçildi.');
                },
              );
            },
          ),
        );
      }),
    );
  }
}
