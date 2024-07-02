// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      id: json['_id'] as String?,
      username: json['username'] as String?,
      profilePic: json['profilePic'],
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      bio: json['bio'],
      address: json['address'] as String?,
      distanceInKm: (json['distanceInKm'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'profilePic': instance.profilePic,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'bio': instance.bio,
      'address': instance.address,
      'distanceInKm': instance.distanceInKm,
    };
