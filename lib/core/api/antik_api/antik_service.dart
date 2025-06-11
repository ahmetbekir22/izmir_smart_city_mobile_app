import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'antik_model.dart';

// class AntikApiService {
//   final Dio _dio = Dio();

//   Future<List<Onemliyer>> fetchAntikKentler() async {
//     final String apiUrl = dotenv.env['ANTIK_KENTLER']!;

//     try {
//       final response = await _dio.get(apiUrl);

//       if (response.data is Map<String, dynamic>) {
//         final data = response.data as Map<String, dynamic>;
//         if (data.containsKey('onemliyer')) {
//           final List<dynamic> onemliyer = data['onemliyer'];
//           return onemliyer.map((item) => Onemliyer.fromJson(item)).toList();
//         }
//       }

//       throw Exception('Unexpected data format');
//     } catch (e) {
//       throw Exception('Failed to load antik kentler: $e');
//     }
//   }
// }

abstract class AntikApiService {
  Future<List<Onemliyer>> fetchAntikKentler();
}

class AntikApiServiceImpl implements AntikApiService {
  final Dio _dio = Dio();

  @override
  Future<List<Onemliyer>> fetchAntikKentler() async {
    final String apiUrl = dotenv.env['ANTIK_KENTLER']!;

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
      throw Exception('Failed to load antik kentler: $e');
    }
  }
}
