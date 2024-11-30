import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

/// [latitude]: Enlem
/// [longitude]: Boylam
Future<void> openMapWithCoordinates(String latitude, String longitude) async {
  final googleMapsUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  final appleMapsUrl = 'https://maps.apple.com/?q=$latitude,$longitude';

  final url = Platform.isIOS ? appleMapsUrl : googleMapsUrl;

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Harita açılamadı: $url';
  }
}
