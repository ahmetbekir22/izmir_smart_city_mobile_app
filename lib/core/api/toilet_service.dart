import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_city_app/core/api/toilet_model.dart';

class CkanProvider {
  final Dio _dio = Dio();
  late final String apiUrl;

  CkanProvider() {
    apiUrl = dotenv.env['TUVALET_API'] ?? '';
    _dio.options.baseUrl = apiUrl;
    _dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    _dio.options.validateStatus = (status) {
      return status! < 500;
    };
  }

  Future<toilet> getToilets() async {
    try {
      final response = await _dio.get(
        '/datastore_search',
        queryParameters: {
          'resource_id': dotenv.env['RESOURCE_ID'],
        },
      );

      if (response.statusCode == 200) {
        return toilet.fromJson(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Veri yüklenirken hata oluştu',
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('API Hatası: ${e.response?.statusMessage}');
      } else {
        throw Exception('Bağlantı Hatası: ${e.message}');
      }
    } catch (e) {
      throw Exception('Beklenmeyen Hata: $e');
    }
  }
}
