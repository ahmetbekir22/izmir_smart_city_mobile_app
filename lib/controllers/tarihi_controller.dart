import 'package:get/get.dart';
import '../core/api/tarihi_model.dart';
import '../core/api/tarihi_service.dart';

class TarihiController extends GetxController {
  final tarihiList = <Yapilar>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final TarihiApiService apiService = TarihiApiService();

  @override
  void onInit() {
    super.onInit();
    fetchTarihiData();
  }

  void fetchTarihiData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final fetchedData = await apiService.fetchTarihiYapilar();
      tarihiList.assignAll(fetchedData);
    } catch (e) {
      errorMessage.value = 'Veriler alınırken bir hata oluştu: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
