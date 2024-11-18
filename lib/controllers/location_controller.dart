// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';

// class LocationController extends GetxController {
//   final String googleMapsBaseUrl =
//       dotenv.env['GOOGLE_MAPS_BASE_URL'] ?? 'https://www.google.com/maps/search/?api=1&query=';

//   void openLocationInGoogleMaps(String etkinlikMerkezi) async {
//     final Uri url =
//         Uri.parse('$googleMapsBaseUrl${Uri.encodeComponent("$etkinlikMerkezi, İzmir")}');

//     if (await canLaunchUrl(url)) {
//       await launchUrl(url, mode: LaunchMode.externalApplication);
//     } else {
//       throw 'Google Maps açılamıyor.';
//     }
//   }
// }

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationController extends GetxController {
  final String googleMapsBaseUrl = dotenv.env['GOOGLE_MAPS_BASE_URL'] ??
      'https://www.google.com/maps/search/?api=1&query=';
  final String appleMapsBaseUrl = 'https://maps.apple.com/?q=';

  void openLocation(String etkinlikMerkezi) async {
    // Harita URL'sini platforma göre seçiyoruz
    final Uri url = Uri.parse(
      GetPlatform.isIOS
          ? '$appleMapsBaseUrl${Uri.encodeComponent("$etkinlikMerkezi, İzmir")}'
          : '$googleMapsBaseUrl${Uri.encodeComponent("$etkinlikMerkezi, İzmir")}',
    );

    // URL'nin açılabilirliğini kontrol et
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Harita uygulaması açılamıyor.';
    }
  }
}
