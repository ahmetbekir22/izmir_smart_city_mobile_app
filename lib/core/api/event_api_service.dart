import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'events_model.dart';

class EtkinlikApiService {
  final Dio _dio = Dio();

  Future<List<Etkinlik>> fetchEtkinlikler() async {
    final String apiUrl = dotenv.env[
        'KULTUR_SANAT_ETKINLILERI_API']!; // .env dosyasından API URL'sini al

    try {
      final response = await _dio.get(apiUrl);
      // API'den gelen verinin 'data' kısmı yerine doğrudan dizi döndürdüğünü varsayıyoruz.
      List<dynamic> body = response.data; // Eğer yanıt direkt liste ise
      return body.map((dynamic item) => Etkinlik.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load etkinlikler: $e');
    }
  }
}
