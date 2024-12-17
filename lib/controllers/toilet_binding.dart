// lib/app/bindings/toilet_binding.dart
import 'package:get/get.dart';
import 'package:smart_city_app/controllers/location_controller.dart';
import 'package:smart_city_app/core/api/toilet_service.dart';
import '../controllers/toilet_controller.dart';

class ToiletBinding implements Bindings {
  @override
  void dependencies() {
    // CkanProvider'ı singleton olarak kaydet
    Get.lazyPut<CkanProvider>(
      () => CkanProvider(),
      fenix: true, // Controller dispose edilse bile tekrar kullanılabilir
    );
    
    Get.lazyPut<LocationController>(
      () => LocationController(),
      fenix: true,
    );

    // ToiletController'ı provider ile birlikte kaydet
    Get.lazyPut<ToiletController>(
      () => ToiletController(
        ckanProvider: Get.find<CkanProvider>(),
      ),
      fenix: true,
    );
  }
}
