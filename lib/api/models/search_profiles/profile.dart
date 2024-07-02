import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  @JsonKey(name: '_id')
  String? id;
  String? username;
  dynamic profilePic;
  String? gender;
  DateTime? dateOfBirth;
  dynamic bio;
  String? address;
  double? distanceInKm;

  Profile({
    this.id,
    this.username,
    this.profilePic,
    this.gender,
    this.dateOfBirth,
    this.bio,
    this.address,
    this.distanceInKm,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return _$ProfileFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
