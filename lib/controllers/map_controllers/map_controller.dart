// map_controller.dart
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  final markers = <Marker>{}.obs;
  final initialPosition = const LatLng(41.015137, 28.979530).obs; // İstanbul koordinatları
  final isLoading = true.obs;

  void addMarkers({
    required List<dynamic> locations,
    required double Function(dynamic) getLatitude,
    required double Function(dynamic) getLongitude,
    required String Function(dynamic) getTitle,
    required String Function(dynamic) getSnippet,
  }) {
    markers.clear();
    
    for (var location in locations) {
      final marker = Marker(
        markerId: MarkerId(getTitle(location)),
        position: LatLng(
          getLatitude(location),
          getLongitude(location),
        ),
        infoWindow: InfoWindow(
          title: getTitle(location),
          snippet: getSnippet(location),
        ),
      );
      
      markers.add(marker);
    }
    
    if (markers.isNotEmpty) {
      // İlk marker'ın konumunu haritanın merkezi yap
      final firstMarker = markers.first;
      initialPosition.value = firstMarker.position;
    }
    
    isLoading.value = false;
  }
}
