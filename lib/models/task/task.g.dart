// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Task _$$_TaskFromJson(Map<String, dynamic> json) => _$_Task(
      taskID: json['taskID'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      dueDate: json['dueDate'] as String?,
      dateCreated: json['dateCreated'] as String?,
      status: json['status'] as bool?,
    );

Map<String, dynamic> _$$_TaskToJson(_$_Task instance) => <String, dynamic>{
      'taskID': instance.taskID,
      'title': instance.title,
      'description': instance.description,
      'dueDate': instance.dueDate,
      'dateCreated': instance.dateCreated,
      'status': instance.status,
    };
