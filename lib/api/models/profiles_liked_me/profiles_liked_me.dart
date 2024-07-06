import 'package:json_annotation/json_annotation.dart';
import 'date_profile.dart';

part 'profiles_liked_me.g.dart';

@JsonSerializable()
class ProfilesLikedMe {
  List<DateProfile>? profilesLikedMe;

  ProfilesLikedMe({this.profilesLikedMe});

  factory ProfilesLikedMe.fromJson(Map<String, dynamic> json) => _$ProfilesLikedMeFromJson(json);

  Map<String, dynamic> toJson() => _$ProfilesLikedMeToJson(this);
}
