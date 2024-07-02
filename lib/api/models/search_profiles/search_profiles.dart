import 'package:json_annotation/json_annotation.dart';

import 'profile.dart';

part 'search_profiles.g.dart';

@JsonSerializable()
class SearchProfiles {
  List<Profile>? profiles;
  int? currentPage;
  int? totalPages;
  int? totalProfiles;
  bool? hasNextPage;
  bool? hasPrevPage;
  dynamic nextPage;
  dynamic prevPage;

  SearchProfiles({
    this.profiles,
    this.currentPage,
    this.totalPages,
    this.totalProfiles,
    this.hasNextPage,
    this.hasPrevPage,
    this.nextPage,
    this.prevPage,
  });

  factory SearchProfiles.fromJson(Map<String, dynamic> json) {
    return _$SearchProfilesFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SearchProfilesToJson(this);
}
