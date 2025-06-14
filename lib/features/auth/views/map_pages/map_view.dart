import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
import '../../../../core/mixins/performance_monitoring_mixin.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with PerformanceMonitoringMixin {
  late final MapController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<MapController>();
    startPageLoadTrace('map_view');
  }

  @override
  void dispose() {
    stopPageLoadTrace();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: controller.initialPosition.value,
                  zoom: 11.0,
                ),
                markers: controller.markers.toSet(),
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                onMapCreated: (GoogleMapController mapController) {
                  PerformanceMonitoringMixin.startApiCall('map_initialization');
                  addMetric('markers_count', controller.markers.length);
                  PerformanceMonitoringMixin.stopApiCall('map_initialization');
                },
              ),
      ),
    );
  }
}
