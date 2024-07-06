// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      userId: json['userId'] as String?,
      username: json['username'] as String?,
      profilePic: json['profilePic'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      dateLiked: json['dateLiked'] == null
          ? null
          : DateTime.parse(json['dateLiked'] as String),
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'profilePic': instance.profilePic,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'dateLiked': instance.dateLiked?.toIso8601String(),
    };
