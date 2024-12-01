import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'galeri_model.dart';

class GaleriApiService {
  final Dio _dio = Dio();

  Future<List<GaleriSalon>> fetchGaleriSalonlar() async {
    final String apiUrl = dotenv.env['GALERI_SALONLAR']!;

    try {
      final response = await _dio.get(apiUrl);

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('onemliyer')) {
          final List<dynamic> onemliyer = data['onemliyer'];
          return onemliyer.map((item) => GaleriSalon.fromJson(item)).toList();
        }
      }

      throw Exception('Unexpected data format');
    } catch (e) {
      throw Exception('Failed to load galeri salonlar: $e');
    }
  }
}
