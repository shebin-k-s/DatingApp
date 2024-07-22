import 'dart:convert';
import 'package:datingapp/api/Url.dart';
import 'package:datingapp/api/data/Auth.dart';
import 'package:datingapp/api/models/chat_model/chat_model.dart';
import 'package:datingapp/api/models/chat_model/message.dart';
import 'package:datingapp/api/models/messaged_profiles/messaged_profiles.dart';
import 'package:datingapp/api/models/profiles_liked_me/profiles_liked_me.dart';
import 'package:datingapp/api/models/search_profiles/search_profiles.dart';
import 'package:datingapp/api/models/user_model/user_model.dart';
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
  Future<UserModel> getProfiles(String profileId);
  Future<ProfilesLikedMe> profilesLikedMe();
  Future<MessagedProfiles> getMessagedProfiles();
  Future<Message> sendMessage(String profileId, String message);
  Future<ChatModel> getChats(String profileId);
  Future<bool> likeProfile(String profileId);
  Future<bool> unlikeProfile(String profileId);
  Future<bool> favoriteProfile(String profileId);
  Future<bool> unfavoriteProfile(String profileId);

  Future<int> editProfile(UserModel updatedUser);
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
      print(urlBuilder.toString());
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
      throw Exception('Failed to load profiles');
    }
  }

  @override
  Future<bool> likeProfile(String profileId) async {
    if (!_initialized) {
      await _initialize();
    }
    try {
      final response = await dio.post('${url.likeProfile}/$profileId');
      print(response);
      return response.statusCode == 200;
    } catch (e) {
      print('Failed to like profile: $e');
      return false;
    }
  }

  @override
  Future<bool> unlikeProfile(String profileId) async {
    if (!_initialized) {
      await _initialize();
    }
    try {
      final response = await dio.delete('${url.unlikeProfile}/$profileId');
      print(response);

      return response.statusCode == 200;
    } catch (e) {
      print('Failed to unlike profile: $e');
      return false;
    }
  }

  @override
  Future<bool> favoriteProfile(String profileId) async {
    if (!_initialized) {
      await _initialize();
    }
    try {
      final response = await dio.post('${url.addFavouriteProfile}/$profileId');
      print(response);
      return response.statusCode == 200;
    } catch (e) {
      print('Failed to favorite profile: $e');
      return false;
    }
  }

  @override
  Future<bool> unfavoriteProfile(String profileId) async {
    if (!_initialized) {
      await _initialize();
    }
    try {
      final response =
          await dio.delete('${url.removeFavouriteProfile}/$profileId');
      print(response);

      return response.statusCode == 200;
    } catch (e) {
      print('Failed to unfavorite profile: $e');
      return false;
    }
  }

  Future<void> updateLikedProfiles(String profileId, bool isLiked) async {
    await _updateProfileList('LIKEDPROFILES', profileId, isLiked);
  }

  Future<void> updateFavoriteProfiles(String profileId, bool isFavorite) async {
    await _updateProfileList('FAVOURITEPROFILES', profileId, isFavorite);
  }

  Future<List<String>> getListFromSharedPreferences(String key) async {
    if (!_initialized) {
      await _initialize();
    }
    return _sharedPref.getStringList(key.toUpperCase()) ?? [];
  }

  Future<void> _updateProfileList(
      String key, String profileId, bool addToList) async {
    if (!_initialized) {
      await _initialize();
    }
    List<String> profiles = await getListFromSharedPreferences(key);

    if (addToList && !profiles.contains(profileId)) {
      profiles.add(profileId);
    } else if (!addToList) {
      profiles.remove(profileId);
    }

    await _sharedPref.setStringList(key, profiles);
  }

  @override
  Future<ProfilesLikedMe> profilesLikedMe() async {
    if (!_initialized) {
      await _initialize();
    }
    try {
      print(url.profilesLikedMe);
      final result = await dio.get(url.profilesLikedMe);
      if (result.data != null && result.statusCode == 200) {
        final resultAsJson = jsonDecode(result.data);
        final profiles = ProfilesLikedMe.fromJson(resultAsJson);
        return profiles;
      } else {
        throw Exception('Failed to load profiles: ${result.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load profiles');
    }
  }

  @override
  Future<MessagedProfiles> getMessagedProfiles() async {
    if (!_initialized) {
      await _initialize();
    }
    try {
      print(url.messagedProfiles);
      final result = await dio.get(url.messagedProfiles);
      if (result.data != null && result.statusCode == 200) {
        final resultAsJson = jsonDecode(result.data);
        final profiles = MessagedProfiles.fromJson(resultAsJson);
        return profiles;
      } else {
        throw Exception('Failed to load profiles: ${result.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load profiles');
    }
  }

  @override
  Future<ChatModel> getChats(String profileId) async {
    if (!_initialized) {
      await _initialize();
    }
    try {
      print(url.conversation);
      final result = await dio.get('${url.conversation}/$profileId');
      if (result.data != null && result.statusCode == 200) {
        final resultAsJson = jsonDecode(result.data);
        final profiles = ChatModel.fromJson(resultAsJson);
        return profiles;
      } else {
        throw Exception('Failed to load chats: ${result.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load chats');
    }
  }

  @override
  Future<Message> sendMessage(String profileId, String message) async {
    if (!_initialized) {
      await _initialize();
    }
    try {
      print(url.sendMessage);
      final result = await dio.post(
        url.sendMessage,
        data: {'profileId': profileId, 'message': message},
      );
      if (result.data != null && result.statusCode == 201) {
        final resultAsJson = jsonDecode(result.data);
        final newMessage = Message.fromJson(resultAsJson);
        return newMessage;
      } else {
        throw Exception('Failed to send message: ${result.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to send message');
    }
  }

  @override
  Future<UserModel> getProfiles(String profileId) async {
    if (!_initialized) {
      await _initialize();
    }
    try {
      final result = await dio.get(
        '${url.getProfile}/${profileId}',
      );
      if (result.data != null && result.statusCode == 200) {
        final resultAsJson = jsonDecode(result.data);
        final profile = UserModel.fromJson(resultAsJson);
        return profile;
      } else {
        throw Exception('Failed to load profile: ${result.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load profile');
    }
  }

  @override
  Future<int> editProfile(UserModel updatedUser) async {
    if (!_initialized) {
      await _initialize();
    }
    try {
      final data = Map<String, dynamic>.from(updatedUser.toJson())
        ..removeWhere((key, value) => value == null);

      final response = await dio.put(
        url.editProfile,
        data: data,
      );
      final sharedPref = await SharedPreferences.getInstance();
      final responseData = jsonDecode(response.data);
      print(response);
      print("data : ${responseData}");
      print("profile: ${responseData['profile']}");
      await sharedPref.setString('MESSAGE', responseData['message']);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.data);

        final updatedUser = UserModel.fromJson(responseData['profile']);
        print(responseData['profile']);
        await AuthDB().saveUserData(updatedUser);
      }

      return response.statusCode ?? -1;
    } on DioException catch (e) {
      final sharedPref = await SharedPreferences.getInstance();
      await sharedPref.setString('MESSAGE', 'Failed to upload');

      return e.response?.statusCode ?? -1;
    }
  }
}
