import 'package:get/get.dart';
import '../core/api/plaj_model.dart';
import '../core/api/plaj_service.dart';

class GeneralFilterController extends GetxController {
  final PlajApiService apiService = PlajApiService();

  final RxList<String> ilceler = <String>[].obs;
  final RxList<String> mahalleler = <String>[].obs;
  
  final RxString selectedIlce = ''.obs;
  final RxString selectedMahalle = ''.obs;
  
  final RxList<Onemliyer> filteredPlajList = <Onemliyer>[].obs;
  final RxList<Onemliyer> originalPlajList = <Onemliyer>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFilterData();
  }

  void fetchFilterData() async {
    try {
      final fetchedData = await apiService.fetchPlajlar();
      originalPlajList.assignAll(fetchedData);
      
      // Extract unique ilçeler and mahalleler
      ilceler.assignAll(fetchedData.map((plaj) => plaj.iLCE ?? '').toSet().toList());
      mahalleler.assignAll(fetchedData.map((plaj) => plaj.mAHALLE ?? '').toSet().toList());
    } catch (e) {
      print('Filter data fetch error: $e');
    }
  }

  void filterPlajList() {
    if (selectedIlce.value.isEmpty && selectedMahalle.value.isEmpty) {
      filteredPlajList.assignAll(originalPlajList);
      return;
    }

    filteredPlajList.assignAll(
      originalPlajList.where((plaj) {
        final matchesIlce = selectedIlce.value.isEmpty || plaj.iLCE == selectedIlce.value;
        final matchesMahalle = selectedMahalle.value.isEmpty || plaj.mAHALLE == selectedMahalle.value;
        return matchesIlce && matchesMahalle;
      }).toList()
    );
  }

  void resetFilter() {
    selectedIlce.value = '';
    selectedMahalle.value = '';
    filteredPlajList.assignAll(originalPlajList);
  }
}