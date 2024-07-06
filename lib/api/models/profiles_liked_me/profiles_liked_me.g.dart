// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profiles_liked_me.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfilesLikedMe _$ProfilesLikedMeFromJson(Map<String, dynamic> json) =>
    ProfilesLikedMe(
      profilesLikedMe: (json['profilesLikedMe'] as List<dynamic>?)
          ?.map((e) => DateProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProfilesLikedMeToJson(ProfilesLikedMe instance) =>
    <String, dynamic>{
      'profilesLikedMe': instance.profilesLikedMe,
    };
