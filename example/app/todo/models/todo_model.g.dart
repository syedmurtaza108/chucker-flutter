// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoModel _$TodoModelFromJson(Map<String, dynamic> json) => TodoModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
    );

Map<String, dynamic> _$TodoModelToJson(TodoModel instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
    };
