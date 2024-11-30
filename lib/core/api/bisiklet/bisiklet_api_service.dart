import 'bisiklet_api_model.dart';

class BikeStationResponse {
  final String status;
  final List<Bisiklet> stations;

  BikeStationResponse({required this.status, required this.stations});

  factory BikeStationResponse.fromJson(Map<String, dynamic> json) {
    return BikeStationResponse(
      status: json['status'],
      stations: (json['stations'] as List)
          .map((station) => Bisiklet.fromJson(station))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'stations': stations.map((station) => station.toJson()).toList(),
    };
  }
}
