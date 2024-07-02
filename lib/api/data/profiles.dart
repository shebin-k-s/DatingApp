import 'dart:convert';
import 'package:datingapp/api/Url.dart';
import 'package:datingapp/api/models/search_profiles/search_profiles.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileApiCalls {
  Future<SearchProfiles> searchProfiles(
    int? minAge,
    int? maxAge,
    String? gender,
    String? location,
    int? maxDistance,
    int? page,
    int? limit,
  );
}

class ProfileDB extends ProfileApiCalls {
  final Dio dio = Dio();
  final Url url = Url();
  late SharedPreferences _sharedPref;
  late String _token;
  bool _initialized = false;

  ProfileDB() {
    _initialize();
  }

  Future<void> _initialize() async {
    _sharedPref = await SharedPreferences.getInstance();
    _token = _sharedPref.getString('TOKEN') ?? '';

    dio.options = BaseOptions(
      baseUrl: url.baseUrl,
      responseType: ResponseType.plain,
      validateStatus: (status) => status! < 500,
      headers: {
        "authorization": _token,
      },
    );
    _initialized = true;
  }

  @override
  Future<SearchProfiles> searchProfiles(
    int? minAge,
    int? maxAge,
    String? gender,
    String? location,
    int? maxDistance,
    int? page,
    int? limit,
  ) async {
    if (!_initialized) {
      await _initialize();
    }
    try {
      final urlBuilder = StringBuffer('${url.searchProfiles}?');

      if (minAge != null) {
        urlBuilder.write('minAge=$minAge&');
      }
      if (maxAge != null) {
        urlBuilder.write('maxAge=$maxAge&');
      }
      if (gender != null) {
        urlBuilder.write('gender=$gender&');
      }
      if (location != null) {
        urlBuilder.write('location=$location&');
      }
      if (maxDistance != null) {
        urlBuilder.write('maxDistance=$maxDistance&');
      }
      if (page != null) {
        urlBuilder.write('page=$page&');
      }
      if (limit != null) {
        urlBuilder.write('limit=$limit');
      }

      final result = await dio.get(urlBuilder.toString());

      if (result.data != null && result.statusCode == 200) {
        final resultAsJson = jsonDecode(result.data);
        final profiles = SearchProfiles.fromJson(resultAsJson);
        return profiles;
      } else {
        throw Exception('Failed to load profiles: ${result.statusCode}');
      }
    } catch (e) {
      print(e);
      return SearchProfiles();
    }
  }
}
