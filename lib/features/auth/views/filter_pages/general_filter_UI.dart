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
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(
      title,
      style: TextStyle(color: theme.iconTheme.color), // Başlık rengini burada değiştirin
    ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // İlçe Dropdown
            Container(
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.primaryColor),
              color: theme.cardColor,
              ),
              child: Obx(() {
              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                isExpanded: true,
                value: filterController.selectedIlce.value.isEmpty 
                  ? null 
                  : filterController.selectedIlce.value,
                hint: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('İlçe Seç',
                  style: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
                  ),
                ),
                dropdownColor: theme.cardColor,
                items: filterController.ilceler.map((ilce) {
                  return DropdownMenuItem<String>(
                  value: ilce,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(ilce, style: theme.textTheme.bodyLarge),
                  ),
                  );
                }).toList(),
                onChanged: (value) {
                  filterController.selectedIlce.value = value ?? '';
                  filterController.updateMahalleList(allItems);
                },
                ),
              );
              }),
            ),

            const SizedBox(height: 16),

            // Mahalle Dropdown
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.primaryColor),
                color: theme.cardColor,
              ),
              child: Obx(() {
                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: filterController.selectedMahalle.value.isEmpty 
                        ? null 
                        : filterController.selectedMahalle.value,
                    hint: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Mahalle Seç',
                        style: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
                      ),
                    ),
                    dropdownColor: theme.cardColor,
                    items: filterController.mahalleler.map((mahalle) {
                      return DropdownMenuItem<String>(
                        value: mahalle,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(mahalle, style: theme.textTheme.bodyLarge),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      filterController.selectedMahalle.value = value ?? '';
                    },
                  ),
                );
              }),
            )
          ],
        ),
      ),
      actions: [
        Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: theme.primaryColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              filterController.resetFilter();
            },
            child: Text('Temizle', style: theme.textTheme.titleMedium?.copyWith(
                color: theme.iconTheme.color,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: theme.primaryColor,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              filterController.filterList();
              Navigator.of(context).pop();
            },
            child: Text(
              'Uygula',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    ),
      ],
    );
  }
}