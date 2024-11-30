import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'eczane_api_model.dart';

class EczaneService {
  final Dio _dio = Dio();
  final String eczaneApiUrl = dotenv.env['NOBETCI_ECZANE_API'] ?? '';

  Future<List<Eczane>> fetchEczaneler() async {
    try {
      final response = await _dio.get(eczaneApiUrl);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Eczane.fromJson(json)).toList();
      } else {
        throw Exception('Veri alınamadı');
      }
    } catch (e) {
      throw Exception('Bir hata oluştu: $e');
    }
  }
}
