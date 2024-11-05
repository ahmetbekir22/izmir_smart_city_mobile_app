import 'package:get/get.dart';
import 'package:smart_city_app/core/api/event_api_service.dart';
import '../core/api/events_model.dart';

class EtkinlikController extends GetxController {
  var etkinlikListesi = <Etkinlik>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadEtkinlikler(); // Ekran açıldığında etkinlikleri yükle
  }

  void loadEtkinlikler() async {
    try {
      etkinlikListesi.value = await EtkinlikApiService().fetchEtkinlikler();
    } catch (e) {
      print('Error: $e');
    }
  }
}
