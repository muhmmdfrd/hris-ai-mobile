import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hris_ai/http/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  Future<String> login(String email, String password) async {
    try {
      final response = await ApiClient().dio.post('/auth/login', data: {'email': email, 'password': password});

      if (response.data['token'] != null && response.data['employee'] != null) {
        final token = response.data['token'];
        final employee = response.data['employee'];

        final prefs = await SharedPreferences.getInstance();

        // Simpan token
        await prefs.setString('token', token);

        // Simpan data karyawan sebagai JSON string
        await prefs.setString('employee', jsonEncode(employee));

        // Jika ingin menyimpan sebagian field saja:
        await prefs.setString('employee_name', employee['name']);
        await prefs.setString('employee_email', employee['email']);
        await prefs.setString('employee_position', employee['position']);
        await prefs.setString('employee_phone', employee['phone_number']);

        return token;
      } else {
        throw Exception('Login gagal. Data tidak lengkap.');
      }
    } on DioException catch (e) {
      print(e);
      throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan saat login.');
    }
  }
}
