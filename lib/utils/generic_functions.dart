import 'dart:io';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EventUtils {
  // Tarih formatlama fonksiyonu
  static String formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      final DateFormat formatter = DateFormat('dd MMMM yyyy - HH:mm');
      return formatter.format(parsedDate);
    } catch (e) {
      return 'Geçersiz tarih'; // Kullanıcı dostu bir hata mesajı
    }
  }

  // URL açma fonksiyonu (Harita)
  static void launchMap(String address) async {
    final String mapsUrl = Platform.isIOS
        ? "https://maps.apple.com/?q=${Uri.encodeComponent(address)}"
        : "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}";

    if (await canLaunchUrl(Uri.parse(mapsUrl))) {
      await launchUrl(Uri.parse(mapsUrl));
    } else {
      throw 'Bu URL açılamaz: $mapsUrl';
    }
  }
}
