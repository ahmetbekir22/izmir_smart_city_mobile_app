import 'package:get/get.dart';
import 'package:smart_city_app/core/api/toilet_model.dart';
import 'package:smart_city_app/core/api/toilet_service.dart';
import '../../../../controllers/filter_controllers/general_filter_controller.dart';

class ToiletController extends GetxController {
  final CkanProvider ckanProvider;
  ToiletController({required this.ckanProvider});

  final _toiletData = Rxn<toilet>();
  final _isLoading = false.obs;
  final _error = ''.obs;
  final _hasConnection = true.obs;

 
  final RxList<Records> filteredToilets = <Records>[].obs;

  toilet? get toiletData => _toiletData.value;
  List<Records> get toilets => _toiletData.value?.result?.records ?? [];
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  bool get hasConnection => _hasConnection.value;

  
  late final GenericFilterController<Records> filterController;

  @override
  void onInit() {
    super.onInit();

  
    filterController = Get.find<GenericFilterController<Records>>();

 
    ever(_toiletData, (_) {
      final records = toilets;
      filterController.initializeFilterData(records);
      filteredToilets.assignAll(records);
    });


    fetchToilets();
  }

  Future<void> fetchToilets() async {
    try {
      _isLoading.value = true;
      _error.value = '';
      _hasConnection.value = true;

      final response = await ckanProvider.getToilets();
      _toiletData.value = response;

    
      if (response.result?.records?.isEmpty ?? true) {
        _error.value = 'Veri bulunamadı';
      }
    } catch (e) {
      _error.value = e.toString();
      _hasConnection.value = false;
    } finally {
      _isLoading.value = false;
    }
  }


  Future<void> refreshToilets() async {
    _error.value = '';
    await fetchToilets();
  }
}
