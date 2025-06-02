import 'package:dio/dio.dart';

class LoginService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.hris.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post('/login', data: {'username': username, 'password': password});

      if (response.statusCode == 200 && response.data['token'] != null) {
        return response.data['token'];
      } else {
        throw Exception('Login gagal. Cek kembali username/password.');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan jaringan');
    }
  }
}
