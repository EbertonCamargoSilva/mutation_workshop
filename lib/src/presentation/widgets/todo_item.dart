import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/todo_model.dart';
import '../cubit/todo_cubit.dart';

class TodoItem extends StatelessWidget {
  final TodoModel todo;

  const TodoItem({required this.todo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: todo.isCompleted,
        onChanged: (_) => context.read<TodoCubit>().toggleTodo(todo),
      ),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => context.read<TodoCubit>().deleteTodo(todo.id),
      ),
    );
  }
}