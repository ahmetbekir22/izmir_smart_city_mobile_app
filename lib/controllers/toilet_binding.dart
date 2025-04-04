// toilet_binding.dart
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
import 'package:smart_city_app/controllers/toilet_controller.dart';
import 'package:smart_city_app/core/api/toilet_service.dart';

class ToiletBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CkanProvider>(() => CkanProvider(), fenix: true);
    Get.lazyPut<MapController>(() => MapController(), fenix: true);
    Get.lazyPut<ToiletController>(
      () => ToiletController(ckanProvider: Get.find<CkanProvider>()),
      fenix: true,
    );
  }
}