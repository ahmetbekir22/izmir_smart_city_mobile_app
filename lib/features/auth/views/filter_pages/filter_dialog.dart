import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/etkinlik_api_controllers/event_controller.dart';
import '../../../../controllers/filter_controllers/filter_controller.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class FilterDialog extends StatelessWidget {
  final FilterDialogController controller = Get.put(FilterDialogController());
  final EtkinlikController etkinlikController = Get.find<EtkinlikController>();
  final ValueChanged<String?> onLocationSelected;
  final ValueChanged<DateTimeRange?> onDateRangeSelected;

  FilterDialog({
    Key? key,
    required this.onLocationSelected,
    required this.onDateRangeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Başlık
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filtrele',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(),

            // Konum Seçici
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).cardColor),
              ),
              child: Obx(() {
                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: controller.selectedLocation.value,
                    hint: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Konum seçiniz'),
                    ),
                    items: etkinlikController
                        .getUniqueLocations()
                        .map((location) => DropdownMenuItem<String>(
                              value: location,
                              child: Text(
                                location,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        controller.selectedLocation.value = value,
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            // Tarih Bilgileri
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tarih Aralığı',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateButton(
                          'Başlangıç',
                          controller.startDate,
                          (date) => controller.startDate.value = date,
                          context,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDateButton(
                          'Bitiş',
                          controller.endDate,
                          (date) => controller.endDate.value = date,
                          context,
                          minDate: controller.startDate.value,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Butonlar
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: controller.resetFilters,
                    child: const Text('Temizle'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      onLocationSelected(controller.selectedLocation.value);
                      onDateRangeSelected(controller.dateRange);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Uygula'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton(
    String label,
    Rxn<DateTime> date,
    void Function(DateTime) onDateSelected,
    BuildContext context, {
    DateTime? minDate,
  }) {
    return Obx(() {
      return InkWell(
        onTap: () async {
          final selectedDate = await DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            minTime: minDate ?? DateTime(2020, 1, 1),
            maxTime: DateTime(2100, 12, 31),
            currentTime: date.value ?? DateTime.now(),
            locale: LocaleType.tr,
          );
          if (selectedDate != null) {
            onDateSelected(selectedDate);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date.value != null
                    ? '${date.value!.day}/${date.value!.month}/${date.value!.year}'
                    : 'Seçiniz',
                style: TextStyle(
                  color:
                      date.value != null ? Colors.black : Colors.grey.shade600,
                  fontWeight:
                      date.value != null ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
