// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../controllers/event_controller.dart';

// class FiltreDrawer extends StatelessWidget {
//   final EtkinlikController controller = Get.put(EtkinlikController());

//   FiltreDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           const Text('Filtrele', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 20),

//           // Konum Dropdown
//           Obx(() => DropdownButton<String>(
//                 value: controller.secilenKonum.value.isEmpty ? null : controller.secilenKonum.value,
//                 hint: const Text('Konum Seçiniz'),
//                 onChanged: (deger) {
//                   controller.konumSec(deger!);
//                 },
//                 items: controller.etkinlikler
//                     .map((e) => e.etkinlikMerkezi)
//                     .toSet()
//                     .map((konum) => DropdownMenuItem(
//                           value: konum,
//                           child: Text(konum),
//                         ))
//                     .toList(),
//               )),
//           const SizedBox(height: 20),

//           // Başlangıç Tarihi
//           ListTile(
//             title: Text(
//                 "Başlangıç Tarihi: ${controller.baslangicTarihi.value.toLocal()}".split(' ')[0]),
//             trailing: const Icon(Icons.calendar_today),
//             onTap: () async {
//               DateTime? picked = await showDatePicker(
//                   context: context,
//                   initialDate: controller.baslangicTarihi.value,
//                   firstDate: DateTime(2020),
//                   lastDate: DateTime(2100));
//               if (picked != null && picked != controller.baslangicTarihi.value)
//                 controller.tarihSec(picked, controller.bitisTarihi.value);
//             },
//           ),
//           // Bitiş Tarihi
//           ListTile(
//             title: Text("Bitiş Tarihi: ${controller.bitisTarihi.value.toLocal()}".split(' ')[0]),
//             trailing: const Icon(Icons.calendar_today),
//             onTap: () async {
//               DateTime? picked = await showDatePicker(
//                   context: context,
//                   initialDate: controller.bitisTarihi.value,
//                   firstDate: DateTime(2020),
//                   lastDate: DateTime(2100));
//               if (picked != null && picked != controller.bitisTarihi.value)
//                 controller.tarihSec(controller.baslangicTarihi.value, picked);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
