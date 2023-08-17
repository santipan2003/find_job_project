import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class UserModel{
  int ? id ;
  String ? name ;
  String ? image ;
  String ? title ;
  String ? location ;
  String ? age ;
  String? find;
  UserModel({this.name,this.id, this.title, this.location, this.age, this.image , this.find});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}