// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../controllers/event_controller.dart';
// import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

// class FilterDialog extends StatefulWidget {
//   final EtkinlikController etkinlikController = Get.find<EtkinlikController>();
//   final ValueChanged<String?> onLocationSelected;
//   final ValueChanged<DateTimeRange?> onDateRangeSelected;

//   FilterDialog({
//     Key? key,
//     required this.onLocationSelected,
//     required this.onDateRangeSelected,
//   }) : super(key: key);

//   @override
//   State<FilterDialog> createState() => _FilterDialogState();
// }

// class _FilterDialogState extends State<FilterDialog> {
//   String? selectedLocation;
//   DateTime? startDate;
//   DateTime? endDate;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Başlık
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Filtrele',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () => Navigator.of(context).pop(),
//                 ),
//               ],
//             ),
//             const Divider(),

//             // Konum Seçici
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   isExpanded: true,
//                   value: selectedLocation,
//                   hint: const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 12),
//                     child: Text('Konum seçiniz'),
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   items: widget.etkinlikController
//                       .getUniqueLocations()
//                       .map((location) {
//                     return DropdownMenuItem<String>(
//                       value: location,
//                       child: Column(
//                         // Column widget'ı ekledik
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Flexible(
//                             // Flexible widget'ı Column içine taşındı
//                             child: Text(
//                               location,
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedLocation = value;
//                     });
//                   },
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Tarih Bilgileri
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Tarih Aralığı',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildDateButton(
//                           'Başlangıç',
//                           startDate,
//                           () async {
//                             final date = await DatePicker.showDatePicker(
//                               context,
//                               showTitleActions: true,
//                               minTime: DateTime(2020, 1, 1),
//                               maxTime: DateTime(2100, 12, 31),
//                               currentTime: DateTime.now(),
//                               locale: LocaleType.tr,
//                             );
//                             if (date != null) {
//                               setState(() {
//                                 startDate = date;
//                               });
//                             }
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: _buildDateButton(
//                           'Bitiş',
//                           endDate,
//                           () async {
//                             final date = await DatePicker.showDatePicker(
//                               context,
//                               showTitleActions: true,
//                               minTime: startDate ?? DateTime(2020, 1, 1),
//                               maxTime: DateTime(2100, 12, 31),
//                               currentTime: startDate ?? DateTime.now(),
//                               locale: LocaleType.tr,
//                             );
//                             if (date != null) {
//                               setState(() {
//                                 endDate = date;
//                               });
//                             }
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 24),

//             // Butonlar
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       side: BorderSide(color: Theme.of(context).primaryColor),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         selectedLocation = null;
//                         startDate = null;
//                         endDate = null;
//                       });
//                     },
//                     child: const Text('Temizle'),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     onPressed: () {
//                       widget.onLocationSelected(selectedLocation);
//                       if (startDate != null && endDate != null) {
//                         widget.onDateRangeSelected(DateTimeRange(
//                           start: startDate!,
//                           end: endDate!,
//                         ));
//                       }
//                       Navigator.of(context).pop();
//                     },
//                     child: const Text('Uygula'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDateButton(
//       String label, DateTime? date, VoidCallback onPressed) {
//     return InkWell(
//       onTap: onPressed,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 color: Colors.grey.shade600,
//                 fontSize: 12,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               date != null
//                   ? '${date.day}/${date.month}/${date.year}'
//                   : 'Seçiniz',
//               style: TextStyle(
//                 color: date != null ? Colors.black : Colors.grey.shade600,
//                 fontWeight: date != null ? FontWeight.w500 : FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/etkinlik_api_controllers/event_controller.dart';
import '../../../controllers/filter_controller.dart';
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
                border: Border.all(color: Colors.grey.shade300),
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
                color: Colors.grey.shade100,
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
