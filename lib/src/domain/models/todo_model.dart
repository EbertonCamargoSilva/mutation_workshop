import 'package:equatable/equatable.dart';

class TodoModel extends Equatable {
  final int id;
  final String title;
  final bool isCompleted;

  const TodoModel({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  TodoModel copyWith({
    int? id,
    String? title,
    bool? isCompleted,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object> get props => [id, title, isCompleted];
}