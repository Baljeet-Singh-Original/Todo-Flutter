import 'package:json_annotation/json_annotation.dart';

part 'todos.g.dart';

@JsonSerializable()
class Todos {
  
  String text;
  DateTime createdOn;
  bool isCompleted;
  Todos({ required this.text, required this.createdOn, this.isCompleted = false});

  factory Todos.fromJson(Map<String, dynamic> json) => _$TodosFromJson(json);
  Map<String, dynamic> toJson() => _$TodosToJson(this);
}