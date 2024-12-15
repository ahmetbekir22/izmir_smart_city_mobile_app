import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/filter_controllers/general_filter_controller.dart';

class GenericFilterDialog<T> extends StatelessWidget {
  final GenericFilterController<T> filterController;
  final List<T> allItems;
  final String title;

  const GenericFilterDialog({
    Key? key,
    required this.filterController,
    required this.allItems,
    this.title = 'Filtrele',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
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
                    // Update mahalle list based on selected ilce
                    filterController.updateMahalleList(allItems);
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
            filterController.filterList();
            Navigator.of(context).pop();
          },
          child: const Text('Filtrele'),
        ),
      ],
    );
  }
}