// import 'package:dio/dio.dart';
// import 'package:get/get.dart';

// class FilterController extends GetxController {
//   RxList<String> locations = <String>[].obs; // Konumları burada saklayacağız
//   RxString selectedLocation = ''.obs;
//   Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

//   final Dio _dio = Dio();

//   @override
//   void onInit() {
//     super.onInit();
//     fetchLocations(); // API'den konumları al
//   }

//   // API'den konumları al
//   Future<void> fetchLocations() async {
//     try {
//       final response = await _dio.get('https://your-api-endpoint.com/locations');
//       if (response.statusCode == 200) {
//         // Veriyi aldıktan sonra listeyi güncelle
//         List<dynamic> data = response.data;
//         locations.value = data.map((item) => item['name'] as String).toList();
//       } else {
//         print('Konumlar alınamadı, API hatası: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Bir hata oluştu: $e');
//     }
//   }

//   // Filtreyi uygula
//   void applyFilter(String location, DateTime? date) {
//     selectedLocation.value = location;
//     selectedDate.value = date;
//   }

//   // Filtreyi sıfırla
//   void resetFilter() {
//     selectedLocation.value = '';
//     selectedDate.value = null;
//   }
// }
