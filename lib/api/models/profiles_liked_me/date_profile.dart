import 'package:json_annotation/json_annotation.dart';
import 'profile.dart';

part 'date_profile.g.dart';

@JsonSerializable()
class DateProfile {
  String? date;
  List<Profile>? profiles;

  DateProfile({this.date, this.profiles});

  factory DateProfile.fromJson(Map<String, dynamic> json) =>
      _$DateProfileFromJson(json);

  Map<String, dynamic> toJson() => _$DateProfileToJson(this);
}
