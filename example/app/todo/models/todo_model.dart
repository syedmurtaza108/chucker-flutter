import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class TodoModel {
  TodoModel({
    required this.id,
    required this.userId,
    required this.title,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodoModelToJson(this);

  final int id;
  final int userId;
  final String title;

  @override
  String toString() {
    return '{$id, #userId, $title}';
  }
}
