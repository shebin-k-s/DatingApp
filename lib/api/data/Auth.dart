import 'dart:convert';
import 'package:datingapp/api/Url.dart';
import 'package:datingapp/api/models/user_model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthApiCalls {
  Future<int> sendOTP(String email, String phoneNumber, bool forLogin);
  Future<int> verifyOTP(String otp);
  Future<int> registerUser(UserModel user);
}

class AuthDB extends AuthApiCalls {
  final Dio dio = Dio();
  final Url url = Url();
  late SharedPreferences _sharedPrefs;
  bool _initialized = false;

  AuthDB() {
    _initialize();
  }

  Future<void> _initialize() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    dio.options = BaseOptions(
      baseUrl: url.baseUrl,
      responseType: ResponseType.plain,
      validateStatus: (status) => status! < 500,
    );
    _initialized = true;
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await _initialize();
    }
  }

  Future<void> _setSharedPref(String key, String value) async {
    await _ensureInitialized();
    await _sharedPrefs.setString(key, value);
  }

  Future<void> _saveUserData(UserModel user) async {
    await _ensureInitialized();
    final userJson = user.toJson();
    for (var entry in userJson.entries) {
      if (entry.value != null) {
        if (entry.value is DateTime) {
          await _setSharedPref(entry.key.toUpperCase(),
              (entry.value as DateTime).toIso8601String());
        } else if (entry.value is List) {
          await _setSharedPref(
              entry.key.toUpperCase(), jsonEncode(entry.value));
        } else {
          await _setSharedPref(entry.key.toUpperCase(), entry.value.toString());
        }
      }
    }
  }

  @override
  Future<int> sendOTP(String email, String phoneNumber, bool forLogin) async {
    await _ensureInitialized();
    try {
      _sharedPrefs.clear();
      final response = await dio.post(
        url.sendOTP,
        data: {
          'email': email,
          'phoneNumber': phoneNumber,
          'forLogin': forLogin
        },
      );

      final responseData = jsonDecode(response.data);
      await _setSharedPref('MESSAGE', responseData['message']);

      if (response.statusCode == 200) {
        await _setSharedPref('SESSIONID', responseData['sessionId']);
      }

      return response.statusCode ?? -1;
    } catch (e) {
      print(e);
      return -1;
    }
  }

  @override
  Future<int> verifyOTP(String otp) async {
    await _ensureInitialized();
    try {
      final sessionId = _sharedPrefs.getString('SESSIONID');
      final response = await dio.post(
        url.verifyOTP,
        data: {'otp': otp, 'sessionId': sessionId},
      );

      final responseData = jsonDecode(response.data);
      await _setSharedPref('MESSAGE', responseData['message']);

      if (response.statusCode == 200) {
        if (responseData['token'] != null) {
          await _setSharedPref('TOKEN', responseData['token']);
        }
        if (responseData['user'] != null) {
          final user = UserModel.fromJson(responseData['user']);
          await _saveUserData(user);
          await displayAllSharedPreferences();
        }
      }

      return response.statusCode ?? -1;
    } on DioException catch (e) {
      return e.response?.statusCode ?? -1;
    }
  }

  @override
  Future<int> registerUser(UserModel user) async {
    await _ensureInitialized();
    try {
      final sessionId = _sharedPrefs.getString('SESSIONID');
      final response = await dio.post(
        url.registerUser,
        data: {
          'sessionId': sessionId,
          ...user.toJson(),
        },
      );
      final responseData = jsonDecode(response.data);
      await _setSharedPref('MESSAGE', responseData['message']);
      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.data);
        await _setSharedPref('TOKEN', responseData['token']);

        final registeredUser = UserModel.fromJson(responseData['user']);
        await _saveUserData(registeredUser);
      }
      await displayAllSharedPreferences();

      return response.statusCode ?? -1;
    } on DioException catch (e) {
      return e.response?.statusCode ?? -1;
    }
  }

  Future<void> displayAllSharedPreferences() async {
    await _ensureInitialized();
    Map<String, dynamic> allPrefs = {};

    Set<String> keys = _sharedPrefs.getKeys();

    for (String key in keys) {
      print(key);
      var value = _sharedPrefs.get(key);
      print(value);

      if (value is String) {
        try {
          value = jsonDecode(value);
        } catch (e) {
          // If it's not a valid JSON string, keep the original value
        }
      }

      allPrefs[key] = value;
    }

    print('SharedPreferences contents:');
    allPrefs.forEach((key, value) {
      print('$key: $value');
    });
  }
}
