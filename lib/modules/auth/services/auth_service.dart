import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  final Dio _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.hrisproject.online/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    )
    ..interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {'email': email, 'password': password});

      if (response.data['token'] != null) {
        final token = response.data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // Set token di header default Dio
        _dio.options.headers['Authorization'] = 'Bearer $token';

        return token;
      } else {
        throw Exception('Login gagal. Cek kembali username/password.');
      }
    } on DioException catch (e) {
      print(e);
      throw Exception('Login gagal. Cek kembali username/password.');
    }
  }

  Future<Dio> getDioWithToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }

    return _dio;
  }
}
