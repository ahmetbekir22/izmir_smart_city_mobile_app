import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'kutuphane_model.dart';

class KutuphaneApiService {
  final Dio _dio = Dio();

  Future<List<Onemliyer>> fetchKutuphaneler() async {
    final String apiUrl = dotenv.env['KUTUPHANE_API']!;

    try {
      final response = await _dio.get(apiUrl);

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('onemliyer')) {
          final List<dynamic> onemliyer = data['onemliyer'];
          return onemliyer
              .map((item) => Onemliyer.fromJson(item))
              .toList();
        }
      }

      throw Exception('Unexpected data format');
    } catch (e) {
      throw Exception('Failed to load kutuphaneler: $e');
    }
  }
}
