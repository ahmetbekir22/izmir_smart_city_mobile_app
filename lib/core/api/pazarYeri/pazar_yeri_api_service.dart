// import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:smart_city_app/core/api/pazarYeri/pazar_yeri_api_model.dart';

// class PazarYeriApiService {
//   final Dio _dio = Dio();
//   final String pazarYeriApiUrl = dotenv.env['SEMT_PAZAR_API'] ?? '';

//   Future<List<PazarYeri>> getPazarYerleri() async {
//     try {
//       final response = await _dio.get(pazarYeriApiUrl);

//       if (response.statusCode == 200) {
//         if (response.data is Map<String, dynamic> &&
//             response.data['data'] is List) {
//           List<dynamic> data = response.data['data']; // 'data' anahtarına eriş
//           return data.map((json) => PazarYeri.fromJson(json)).toList();
//         } else {
//           throw Exception('Beklenmeyen veri formatı');
//         }
//       } else {
//         throw Exception('Veri alınamadı');
//       }
//     } catch (e) {
//       throw Exception('Bir hata oluştu: $e');
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_city_app/core/api/pazarYeri/pazar_yeri_api_model.dart';

class PazarYeriApiService {
  final Dio _dio = Dio();
  final String pazarYeriApiUrl = dotenv.env['SEMT_PAZAR_API'] ?? '';

  Future<List<PazarYeri>> getPazarYerleri() async {
    try {
      final response = await _dio.get(pazarYeriApiUrl);

      if (response.statusCode == 200) {
        // Gelen JSON'un 'onemliyer' anahtarını kontrol et
        if (response.data is Map<String, dynamic> &&
            response.data['onemliyer'] is List) {
          List<dynamic> data = response.data['onemliyer'];
          return data.map((json) => PazarYeri.fromJson(json)).toList();
        } else {
          throw Exception('Beklenmeyen veri formatı');
        }
      } else {
        throw Exception('Veri alınamadı');
      }
    } catch (e) {
      throw Exception('Bir hata oluştu: $e');
    }
  }
}
