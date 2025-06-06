import 'package:dio/dio.dart';
import 'package:hris_ai/http/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  Future<String> login(String email, String password) async {
    try {
      final response = await ApiClient().dio.post('/auth/login', data: {'email': email, 'password': password});

      if (response.data['token'] != null) {
        final token = response.data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return token;
      } else {
        throw Exception('Login gagal. Cek kembali username/password.');
      }
    } on DioException catch (e) {
      print(e);
      throw Exception('Login gagal. Cek kembali username/password.');
    }
  }
}
