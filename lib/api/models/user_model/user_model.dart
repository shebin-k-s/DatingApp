import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: '_id')
  String? id;
  String? username;
  String? email;
  String? gender;
  DateTime? dateOfBirth;
  List<String>? interests;
  List<String>? photos;
  List<String>? matches;
  List<String>? likedProfiles;
  List<String>? favouriteProfiles;
  String? address;
  DateTime? createdAt;
  String? profilePic;
  String? bio;
  String? phoneNumber;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.gender,
    this.dateOfBirth,
    this.interests,
    this.photos,
    this.matches,
    this.likedProfiles,
    this.favouriteProfiles,
    this.address,
    this.createdAt,
    this.profilePic,
    this.bio,
    this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
