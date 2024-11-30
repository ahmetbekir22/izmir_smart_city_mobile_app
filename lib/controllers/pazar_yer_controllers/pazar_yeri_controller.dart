import 'package:get/get.dart';

import '../../core/api/pazarYeri/pazar_yeri_api_model.dart';
import '../../core/api/pazarYeri/pazar_yeri_api_service.dart';

class PazarYeriController extends GetxController {
  var pazarYerleri = <PazarYeri>[].obs;
  var filteredPazarYerleri = <PazarYeri>[].obs; // Filtrelenmiş pazar yerleri

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPazarYerleri();
  }

  void fetchPazarYerleri() async {
    try {
      isLoading(true);
      var pazarYerleri = await PazarYeriApiService().getPazarYerleri();
      this.pazarYerleri.value = pazarYerleri;
    } finally {
      isLoading(false);
    }
  }

  String extractDay(String? description) {
    if (description == null) return "Gün Bilinmiyor";

    description = description.toLowerCase();

    final days = [
      "pazartesi",
      "salı",
      "çarşamba",
      "perşembe",
      "cuma",
      "cumartesi",
      "pazar"
    ];

    // Gün listesinden bir eşleşme ara
    for (var day in days) {
      if (description.contains(day)) {
        return day[0].toUpperCase() + day.substring(1); // İlk harfi büyük yap
      }
    }

    return "Gün Bilinmiyor"; // Hiçbir gün bulunamazsa
  }

  void filterByIlce(String region) {
    filteredPazarYerleri.value =
        pazarYerleri.where((pazar) => pazar.iLCE == region).toList();
  }
}
