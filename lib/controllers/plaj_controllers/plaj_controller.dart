import 'package:get/get.dart';
import '../../core/api/plaj_api/plaj_model.dart';
import '../../core/api/plaj_api/plaj_service.dart';

class PlajController extends GetxController {
  final plajList = <Onemliyer>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final PlajApiService apiService = PlajApiService();

  @override
  void onInit() {
    super.onInit();
    fetchPlajData();
  }

  void fetchPlajData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final fetchedData = await apiService.fetchPlajlar();
      plajList.assignAll(fetchedData);
    } catch (e) {
      errorMessage.value = 'Veriler alınırken bir hata oluştu: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
