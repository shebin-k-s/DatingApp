// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['_id'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      photos:
          (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      matches:
          (json['matches'] as List<dynamic>?)?.map((e) => e as String).toList(),
      likedProfiles: (json['likedProfiles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      favouriteProfiles: (json['favouriteProfiles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      address: json['address'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      profilePic: json['profilePic'] as String?,
      bio: json['bio'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'interests': instance.interests,
      'photos': instance.photos,
      'matches': instance.matches,
      'likedProfiles': instance.likedProfiles,
      'favouriteProfiles': instance.favouriteProfiles,
      'address': instance.address,
      'createdAt': instance.createdAt?.toIso8601String(),
      'profilePic': instance.profilePic,
      'bio': instance.bio,
      'phoneNumber': instance.phoneNumber,
    };
