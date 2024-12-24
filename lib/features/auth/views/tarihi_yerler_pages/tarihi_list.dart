import 'package:get/get.dart';
import 'package:smart_city_app/controllers/tarihi_yerler_controllers/tarihi_controller.dart';
import 'package:smart_city_app/core/api/tarihi_yerler_api/tarihi_model.dart';
import 'package:smart_city_app/features/auth/views/base_list.dart';

class TarihiList extends BaseListPage<Onemliyer> {
  TarihiList()
      : super(
          title: 'Tarihi Yapılar',
          items: Get.put(TarihiController()).tarihiList,
          extractIlce: (tarihi) => tarihi.iLCE ?? '',
          extractMahalle: (tarihi) => tarihi.mAHALLE ?? '',
          extractAdi: (tarihi) => tarihi.aDI,
          extractEnlem: (tarihi) => tarihi.eNLEM,
          extractBoylam: (tarihi) => tarihi.bOYLAM,
          extractAciklama: (tarihi) => tarihi.aCIKLAMA,
        );
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../controllers/filter_controllers/general_filter_controller.dart';
// import '../../../../controllers/location_controllers/location_controller.dart';
// import '../../../../controllers/tarihi_yerler_controllers/tarihi_controller.dart';
// import '../../../../controllers/theme_contoller.dart';
// import '../../../../core/api/tarihi_yerler_api/tarihi_model.dart';
// import '../../widgets/card_widgets/general_card.dart';
// import '../filter_pages/general_filter_UI.dart';

// class TarihiList extends StatelessWidget {
//   final ThemeController themeController = Get.find();
//   final TarihiController tarihiController = Get.put(TarihiController());
//   final ScrollController scrollController = ScrollController();
//   final LocationController locationController = Get.put(LocationController());

//   late final GenericFilterController<Onemliyer> filterController;

//   TarihiList({Key? key}) : super(key: key) {
//     filterController = Get.put(GenericFilterController<Onemliyer>(
//       extractIlce: (yapi) => yapi.iLCE ?? '',
//       extractMahalle: (yapi) => yapi.mAHALLE ?? '',
//     ));

//     ever(tarihiController.tarihiList, (list) {
//       if (list.isNotEmpty) {
//         filterController.initializeFilterData(list);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tarihi Yapılar'),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) => GenericFilterDialog<Onemliyer>(
//                   filterController: filterController,
//                   allItems: tarihiController.tarihiList,
//                   title: 'Tarihi Yapı Filtrele',
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (tarihiController.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (tarihiController.errorMessage.isNotEmpty) {
//           return Center(child: Text(tarihiController.errorMessage.value));
//         }

//         final displayList = filterController.filteredList.isNotEmpty
//             ? filterController.filteredList
//             : tarihiController.tarihiList;

//         if (displayList.isEmpty) {
//           return const Center(child: Text('Tarihi yapı bulunamadı.'));
//         }

//         return Scrollbar(
//           controller: scrollController,
//           thickness: 10,
//           radius: const Radius.circular(8),
//           thumbVisibility: false,
//           interactive: true,
//           child: ListView.builder(
//             controller: scrollController,
//             itemCount: displayList.length,
//             itemBuilder: (context, index) {
//               final yapi = displayList[index];
//               return GeneralCard(
//                 adi: yapi.aDI ?? 'Bilinmiyor',
//                 ilce: yapi.iLCE ?? 'Bilinmiyor',
//                 mahalle: yapi.mAHALLE ?? 'Bilinmiyor',
//                 aciklama: yapi.aCIKLAMA,
//                 onLocationTap: yapi.eNLEM != null && yapi.bOYLAM != null
//                     ? () {
//                         locationController.openLocationByCoordinates(
//                             yapi.eNLEM!, yapi.bOYLAM!);
//                       }
//                     : null,
//               );
//             },
//           ),
//         );
//       }),
//     );
//   }
// }
