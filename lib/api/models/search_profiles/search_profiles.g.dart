// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_profiles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchProfiles _$SearchProfilesFromJson(Map<String, dynamic> json) =>
    SearchProfiles(
      profiles: (json['profiles'] as List<dynamic>?)
          ?.map((e) => Profile.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: (json['currentPage'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
      totalProfiles: (json['totalProfiles'] as num?)?.toInt(),
      hasNextPage: json['hasNextPage'] as bool?,
      hasPrevPage: json['hasPrevPage'] as bool?,
      nextPage: json['nextPage'],
      prevPage: json['prevPage'],
    );

Map<String, dynamic> _$SearchProfilesToJson(SearchProfiles instance) =>
    <String, dynamic>{
      'profiles': instance.profiles,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'totalProfiles': instance.totalProfiles,
      'hasNextPage': instance.hasNextPage,
      'hasPrevPage': instance.hasPrevPage,
      'nextPage': instance.nextPage,
      'prevPage': instance.prevPage,
    };
