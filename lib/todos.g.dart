// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todos _$TodosFromJson(Map<String, dynamic> json) => Todos(
      text: json['text'] as String,
      createdOn: DateTime.parse(json['createdOn'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$TodosToJson(Todos instance) => <String, dynamic>{
      'text': instance.text,
      'createdOn': instance.createdOn.toIso8601String(),
      'isCompleted': instance.isCompleted,
    };
