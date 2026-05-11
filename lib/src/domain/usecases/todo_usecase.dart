import '../models/todo_model.dart';
import '../repositories/todo_repository.dart';

class TodoUsecase {
  final TodoRepository repository;

  TodoUsecase({required this.repository});

  Future<(List<TodoModel>?, Exception?)> getTodos() async {
    try {
      final todos = await repository.getTodos();
      return (todos, null);
    } catch (e) {
      return (null, Exception(e.toString()));
    }
  }

  Future<(TodoModel?, Exception?)> addTodo(String title) async {
    try {
      if (title.trim().isEmpty) {
        return (null, Exception('Title cannot be empty'));
      }
      final todo = await repository.addTodo(title);
      return (todo, null);
    } catch (e) {
      return (null, Exception(e.toString()));
    }
  }

  Future<(TodoModel?, Exception?)> updateTodo(TodoModel todo) async {
    try {
      final updatedTodo = await repository.updateTodo(todo);
      return (updatedTodo, null);
    } catch (e) {
      return (null, Exception(e.toString()));
    }
  }

  Future<(bool, Exception?)> deleteTodo(int id) async {
    try {
      await repository.deleteTodo(id);
      return (true, null);
    } catch (e) {
      return (false, Exception(e.toString()));
    }
  }
}