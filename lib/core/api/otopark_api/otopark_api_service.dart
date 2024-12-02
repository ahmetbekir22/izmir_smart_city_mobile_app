import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'otopark_api_model.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _apiKey = dotenv.env['OTOPARK_API']!;

  Future<List<ParkingModel>> fetchParkingData() async {
    final response = await _dio.get(
      _apiKey,
      options: Options(
        headers: {
          'Authorization': 'Bearer $_apiKey',
        },
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      return data.map((e) => ParkingModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
