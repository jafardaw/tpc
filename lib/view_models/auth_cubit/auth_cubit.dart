import 'dart:convert';
import 'dart:developer';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/view_models/auth_cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SharedPreferences sharedPreferences;
  AuthCubit(this.sharedPreferences) : super(AuthInitial());
  final TextEditingController email = TextEditingController(
    text: 'updated@example.com',
  );
  final TextEditingController phone = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> logIn() async {
    emit(Loading());
    try {
      log('Attempting login with email: ${email.text}');

      final response = await ApiService().post('login', {
        "email": email.text,
        "password": password.text,
      });

      log('Raw response: ${response.data}');

      final data = response.data;

      if (data is Map &&
          data.containsKey('token') &&
          data.containsKey('status')) {
        await sharedPreferences.setString('auth_token', data['token']);
        log('Login successful, token saved');

        if (response.statusCode == 200) {
          emit(LoginSucces());
        } else {
          emit(LoginError(error: data['message'] ?? 'Login failed'));
        }
      } else {
        log('Unexpected response format: $data');
        emit(LoginError(error: 'Unexpected response format'));
      }
    } catch (e) {
      log("Login error: ${e.toString()}");
      emit(LoginError(error: 'An error occurred during login'));
    }
  }

  Future<void> register({required String userRole}) async {
    emit(Loading());
    try {
      log(email.text);
      final url = Uri.parse("http://10.0.2.2:8000/api/register");

      log(password.text);
      log(name.text);
      log(phone.text);
      final response = await http.post(
        url,
        body: {
          "name": name.text,
          "email": email.text,
          "password": password.text,
          "phone": phone.text,
          "user_role": userRole,
        },
        headers: {"Accept": "application/json"},
      );
      log('statuscode ${response.statusCode}');
      final decodedResponse = json.decode(response.body);
      log('statuscode2 ${decodedResponse["status"]}');
      if (decodedResponse["status"] == 201) {
        log(decodedResponse.toString());
        emit(SignUpSucces());
      } else {
        log('========================');
        emit(SignUpError(error: "${decodedResponse["message"]}"));
      }
    } catch (e) {
      log("==============000000=${e.toString()}");
    }
  }
}
