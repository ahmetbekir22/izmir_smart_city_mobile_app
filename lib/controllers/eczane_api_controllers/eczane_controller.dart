import 'package:get/get.dart';
import '../../core/api/eczane/eczane_api_model.dart';
import '../../core/api/eczane/eczane_api_service.dart';

class EczaneController extends GetxController {
  var eczaneList = <Eczane>[].obs;
  var isLoading = true.obs;

  final EczaneService _eczaneService = EczaneService();

  @override
  void onInit() {
    fetchEczaneler();
    super.onInit();
  }

  void fetchEczaneler() async {
    isLoading.value = true;
    eczaneList.value = await _eczaneService.fetchEczaneler();
    isLoading.value = false;
  }
}
