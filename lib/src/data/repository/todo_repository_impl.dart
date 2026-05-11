import '../../domain/models/todo_model.dart';
import '../../domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  static final List<TodoModel> _todos = [];
  static int _nextId = 1;

  @override
  Future<List<TodoModel>> getTodos() async {
    return List.from(_todos);
  }

  @override
  Future<TodoModel> addTodo(String title) async {
    final todo = TodoModel(
      id: _nextId++,
      title: title,
      isCompleted: false,
    );
    _todos.add(todo);
    return todo;
  }

  @override
  Future<TodoModel> updateTodo(TodoModel todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index == -1) {
      throw Exception('Todo not found');
    }
    
    _todos[index] = todo;
    return todo;
  }

  @override
  Future<void> deleteTodo(int id) async {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index == -1) {
      throw Exception('Todo not found');
    }
    _todos.removeAt(index);
  }
}