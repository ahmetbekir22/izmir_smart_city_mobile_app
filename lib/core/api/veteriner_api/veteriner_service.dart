// import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'veteriner_model.dart';

// class VeterinerApiService {
//   final Dio _dio = Dio();

//   Future<List<Onemliyer>> fetchVeteriner() async {
//     final String apiUrl = dotenv.env['VETERINER_API']!;

//     try {
//       final response = await _dio.get(apiUrl);

//       // Yanıtın "onemliyer" anahtarı altındaki listeyi al
//       final List<dynamic> body = response.data['onemliyer'];

//       // Listeyi modele dönüştür
//       return body.map((dynamic item) => Onemliyer.fromJson(item)).toList();
//     } catch (e) {
//       throw Exception('Failed to load veterinerler: $e');
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http; // ← ekleyin
import '../veteriner_api/veteriner_model.dart';

class VeterinerApiService {
  final http.Client client;
  VeterinerApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Onemliyer>> fetchVeteriner() async {
    final res = await client.get(
      Uri.parse('https://…/veteriner'),
    );
    if (res.statusCode == 200) {
      final List js = json.decode(res.body);
      return js.map((e) => Onemliyer.fromJson(e)).toList();
    } else {
      throw Exception('API hatası: ${res.statusCode}');
    }
  }
}
