import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../controllers/plaj_controllers/plaj_controller.dart';
import '../../../../core/api/plaj_api/plaj_model.dart';

class PlajMapsController extends GetxController {
  final PlajController _plajController = Get.put(PlajController());
  
  final markers = <Marker>[].obs;
  final mapController = Rx<GoogleMapController?>(null);

  @override
  void onInit() {
    super.onInit();
    ever(_plajController.plajList, _createMarkers);
  }

  void _createMarkers(List<Onemliyer> plajlar) {
    markers.assignAll(
      plajlar.map((plaj) {
        return Marker(
          markerId: MarkerId(plaj.aDI ?? 'Unknown'),
          position: LatLng(plaj.eNLEM ?? 0.0, plaj.bOYLAM ?? 0.0),
          infoWindow: InfoWindow(
            title: plaj.aDI ?? 'Plaj',
            snippet: plaj.aCIKLAMA ?? '',
          ),
        );
      }).toList(),
    );

    // İlk marker varsa haritayı ona odakla
    if (markers.isNotEmpty) {
      mapController.value?.animateCamera(
        CameraUpdate.newLatLng(markers.first.position),
      );
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController.value = controller;
  }
}