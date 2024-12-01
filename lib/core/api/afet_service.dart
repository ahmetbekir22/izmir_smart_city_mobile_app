import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'afet_model.dart';

class AfetApiService {
  final Dio _dio = Dio();

  Future<List<Onemliyer>> fetchAfet() async {
    final String apiUrl = dotenv.env['AFET_TOPLANMA_YERLERI_API']!;

    try {
      final response = await _dio.get(apiUrl);

      // Yanıtın "onemliyer" anahtarı altındaki listeyi al
      final List<dynamic> body = response.data['onemliyer'];
      
      // Listeyi modele dönüştür
      return body.map((dynamic item) => Onemliyer.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load afet: $e');
    }
  }
}
