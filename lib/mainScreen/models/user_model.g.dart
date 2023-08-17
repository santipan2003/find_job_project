// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      name: json['name'] as String?,
      id: json['id'] as int?,
      title: json['title'] as String?,
      location: json['location'] as String?,
      age: json['age'] as String?,
      image: json['image'] as String?,
      find: json['find'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('image', instance.image);
  writeNotNull('title', instance.title);
  writeNotNull('location', instance.location);
  writeNotNull('age', instance.age);
  writeNotNull('find', instance.find);
  return val;
}
