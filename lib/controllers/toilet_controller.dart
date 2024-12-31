// toilet_controller.dart
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
import 'package:smart_city_app/core/api/toilet_model.dart';
import 'package:smart_city_app/core/api/toilet_service.dart';

class ToiletController extends GetxController {
  final CkanProvider ckanProvider;
  final MapController mapController = Get.put(MapController());
  
  ToiletController({required this.ckanProvider});
  
  final _toiletData = Rxn<toilet>();
  final _isLoading = false.obs;
  final _error = ''.obs;
  
  final RxList<Records> toilets = <Records>[].obs;
  String get error => _error.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    fetchToilets();
    
    ever(toilets, (_) {
      updateMapMarkers();
    });
  }

  void updateMapMarkers() {
    if (toilets.isNotEmpty) {
      mapController.addMarkers(
        locations: toilets,
        getLatitude: (toilet) => toilet.eNLEM ?? 0,
        getLongitude: (toilet) => toilet.bOYLAM ?? 0,
        getTitle: (toilet) => toilet.tESISADI ?? 'İsimsiz Tesis',
        getSnippet: (toilet) => '${toilet.iLCE ?? ''}, ${toilet.mAHALLE ?? ''}',
      );
    }
  }

  Future<void> fetchToilets() async {
    try {
      _isLoading.value = true;
      _error.value = '';
      final response = await ckanProvider.getToilets();
      _toiletData.value = response;
      toilets.assignAll(response.result?.records ?? []);
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }
}
