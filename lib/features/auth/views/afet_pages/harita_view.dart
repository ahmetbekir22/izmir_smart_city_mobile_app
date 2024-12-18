import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_controller.dart';

class PlajMapsView extends StatelessWidget {
  const PlajMapsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plajlar Haritası'),
      ),
      body: GetX<PlajMapsController>(
        init: PlajMapsController(),
        builder: (controller) {
          if (controller.markers.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: controller.markers.first.position,
              zoom: 10,
            ),
            markers: Set.from(controller.markers),
            onMapCreated: controller.onMapCreated,
          );
        },
      ),
    );
  }
}