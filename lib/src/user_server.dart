import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:chat_api_app/src/user.dart';

class ApiService {
  // SignIn user
  Future<User?> signIn(String email, String password) async {
    try {
      var url = Uri.parse(dotenv.get('API_URL') + dotenv.get('signInEndpoint'));
      var response = await http.post(url,
          // headers: {"Authorization": "Bearer ${dotenv.get('accesToken')}"},
          body: {"identifier": email, "password": password});

      if (response.statusCode == 200) {
        User _model = User.fromJson(json.decode(response.body)['user']);
        return _model;
      } else {
        String error = jsonDecode(response.body)['error']['message'];
        throw Exception(error);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // SignUp user
  Future<User?> signUp(String email, String username, String password) async {
    try {
      var url = Uri.parse(dotenv.get('API_URL') + dotenv.get('signUpEndpoint'));
      var response = await http.post(url,
          // headers: {"Authorization": "Bearer ${dotenv.get('accesToken')}"},
          body: {"email": email, "username": username, "password": password});
      if (response.statusCode == 200) {
        // User _model = singleUserFromJson(response.body);
        User _model = User.fromJson(json.decode(response.body)['user']);
        return _model;
      } else {
        String error = jsonDecode(response.body)['error']['message'];
        throw Exception(error);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
