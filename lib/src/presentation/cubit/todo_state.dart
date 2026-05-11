import 'package:equatable/equatable.dart';
import '../../domain/models/todo_model.dart';

class TodoState extends Equatable {
  final bool isLoading;
  final List<TodoModel> todos;
  final String? errorMessage;

  const TodoState({
    this.isLoading = false,
    this.todos = const [],
    this.errorMessage,
  });

  TodoState copyWith({
    bool? isLoading,
    List<TodoModel>? todos,
    String? errorMessage,
  }) {
    return TodoState(
      isLoading: isLoading ?? this.isLoading,
      todos: todos ?? this.todos,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, todos, errorMessage];
}