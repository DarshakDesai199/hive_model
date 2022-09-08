import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel {
  final String? title;
  final String? content;

  TaskModel({this.title, this.content});
}
