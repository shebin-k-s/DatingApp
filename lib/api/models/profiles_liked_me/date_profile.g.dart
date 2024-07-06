// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateProfile _$DateProfileFromJson(Map<String, dynamic> json) => DateProfile(
      date: json['date'] as String?,
      profiles: (json['profiles'] as List<dynamic>?)
          ?.map((e) => Profile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DateProfileToJson(DateProfile instance) =>
    <String, dynamic>{
      'date': instance.date,
      'profiles': instance.profiles,
    };
