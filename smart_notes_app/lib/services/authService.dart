import 'package:smart_notes_app/models/User.dart';
import 'package:smart_notes_app/config/apiConfig.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final String apiBaseUrl = getApiBaseUrl();

Future<User?> login(String email, String password) async {
  final url = Uri.parse('$apiBaseUrl/api/auth/login');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print('Login successful!');
      return User.fromJson(jsonData);
    } else {
      print('Login error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Login exception: $e');
    return null;
  }
}

Future<User?> register(String name, String email, String password) async {
  final url = Uri.parse('$apiBaseUrl/api/auth/register');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    
    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print('User registered successfully!');
      return User.fromJson(jsonData);
    } else {
      print('Registration error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Registration exception: $e');
    return null;
  }
}
