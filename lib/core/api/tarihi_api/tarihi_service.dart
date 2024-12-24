import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../tarihi_yerler_api/tarihi_model.dart';

class TarihiApiService {
  final Dio _dio = Dio();

  Future<List<Onemliyer>> fetchTarihiYapilar() async {
    final String apiUrl = dotenv.env['TARIHI_YAPILAR']!;

    try {
      final response = await _dio.get(apiUrl);

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('onemliyer')) {
          final List<dynamic> onemliyer = data['onemliyer'];
          return onemliyer.map((item) => Onemliyer.fromJson(item)).toList();
        }
      }

      throw Exception('Unexpected data format');
    } catch (e) {
      throw Exception('Failed to load tarihi yapilar: $e');
    }
  }
}
