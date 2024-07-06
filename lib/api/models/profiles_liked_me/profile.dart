import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  String? userId;
  String? username;
  String? profilePic;
  DateTime? dateOfBirth;
  DateTime? dateLiked;

  Profile({
    this.userId,
    this.username,
    this.profilePic,
    this.dateOfBirth,
    this.dateLiked,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return _$ProfileFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
