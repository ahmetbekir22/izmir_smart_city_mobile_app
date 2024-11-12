import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/event_controller.dart';
import 'package:intl/intl.dart';

class FilterDialog extends StatelessWidget {
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
    String? selectedLocation;
    DateTimeRange? selectedDateRange;

    return AlertDialog(
      title: const Text('Filtrele'),
      content: SingleChildScrollView( // Add this to enable scrolling if needed
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch, // Make widgets stretch to fit width
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Konum'),
              items: etkinlikController.getUniqueLocations().map((location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (value) {
                selectedLocation = value;
                onLocationSelected(value);
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                DateTimeRange? picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  selectedDateRange = picked;
                  onDateRangeSelected(picked);
                }
              },
              child: const Text('Tarih Aralığı Seçin'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('İptal'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('Filtrele'),
          onPressed: () {
            onLocationSelected(selectedLocation);
            onDateRangeSelected(selectedDateRange);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
