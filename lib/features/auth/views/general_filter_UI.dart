import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/general_filter_controller.dart';
import '../../../controllers/plaj_controller.dart';

class GeneralFilterDialog extends StatelessWidget {
  final GeneralFilterController filterController = Get.find();
  final PlajController plajController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Plaj Filtrele'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // İlçe Dropdown
            Obx(() => DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'İlçe Seç'),
                  value: filterController.selectedIlce.value.isEmpty 
                      ? null 
                      : filterController.selectedIlce.value,
                  items: filterController.ilceler.map((ilce) {
                    return DropdownMenuItem(
                      value: ilce,
                      child: Text(ilce),
                    );
                  }).toList(),
                  onChanged: (value) {
                    filterController.selectedIlce.value = value ?? '';
                    // Güncellenen ilçeye göre mahalle listesini filtrele
                    filterController.mahalleler.assignAll(
                      plajController.plajList
                        .where((plaj) => plaj.iLCE == value)
                        .map((plaj) => plaj.mAHALLE ?? '')
                        .toSet()
                        .toList()
                    );
                    filterController.selectedMahalle.value = '';
                  },
                )),

            const SizedBox(height: 16),

            // Mahalle Dropdown
            Obx(() => DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Mahalle Seç'),
                  value: filterController.selectedMahalle.value.isEmpty 
                      ? null 
                      : filterController.selectedMahalle.value,
                  items: filterController.mahalleler.map((mahalle) {
                    return DropdownMenuItem(
                      value: mahalle,
                      child: Text(mahalle),
                    );
                  }).toList(),
                  onChanged: (value) {
                    filterController.selectedMahalle.value = value ?? '';
                  },
                )),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            filterController.resetFilter();
            Navigator.of(context).pop();
          },
          child: const Text('Temizle'),
        ),
        ElevatedButton(
          onPressed: () {
            filterController.filterPlajList();
            Navigator.of(context).pop();
          },
          child: const Text('Filtrele'),
        ),
      ],
    );
  }
}