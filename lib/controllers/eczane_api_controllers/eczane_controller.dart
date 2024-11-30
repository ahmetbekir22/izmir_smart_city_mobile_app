import 'package:get/get.dart';
import '../../core/api/eczane/eczane_api_model.dart';
import '../../core/api/eczane/eczane_api_service.dart';

class EczaneController extends GetxController {
  var eczaneList = <Eczane>[].obs;
  var filteredList = <Eczane>[].obs;
  var isLoading = true.obs;
  var selectedRegion = ''.obs;

  @override
  void onInit() {
    fetchEczaneler();
    super.onInit();
  }

  void fetchEczaneler() async {
    try {
      isLoading(true);
      var eczaneler = await EczaneService().getEczaneler();
      eczaneList.value = eczaneler;
      filteredList.value = eczaneler;
    } finally {
      isLoading(false);
    }
  }

  void filterByRegion(String region) {
    selectedRegion.value = region;
    if (region.isEmpty) {
      filteredList.value = eczaneList;
    } else {
      filteredList.value = eczaneList
          .where(
              (eczane) => eczane.bolge?.toLowerCase() == region.toLowerCase())
          .toList();
    }
  }
}
