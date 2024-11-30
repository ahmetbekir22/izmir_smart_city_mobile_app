import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class BisikletController extends GetxController {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: dotenv.env['BISIKLET_ISTASYONLARI'] ?? '',
  ));

  var stations = [].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchStations(); // Uygulama açıldığında çağırılıyor.
  }

  Future<void> fetchStations() async {
    isLoading(true);
    try {
      final response = await _dio.get(''); // baseUrl'deki tüm endpoint'i kapsar

      if (response.statusCode == 200) {
        stations.value = response.data['stations'];
      } else {
        errorMessage('Veri çekilemedi: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Bir hata oluştu: $e');
    } finally {
      isLoading(false);
    }
  }
}
