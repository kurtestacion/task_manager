import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task extends Equatable with _$Task {
  const Task._();

  factory Task({
    String? taskID,
    String? title,
    String? description,
    String? dueDate,
    String? dateCreated,
    bool? status,
  }) = _Task;

  factory Task.fromJson(Map<String, Object?> json) => _$TaskFromJson(json);

  @override
  List<Object?> get props => [
        // <- custom class properties to check
        taskID, title, description, dueDate, dateCreated, status
      ];
}
