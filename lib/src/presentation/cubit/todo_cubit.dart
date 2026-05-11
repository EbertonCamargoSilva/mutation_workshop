import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/todo_model.dart';
import '../../domain/usecases/todo_usecase.dart';
import 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoUsecase usecase;

  TodoCubit(this.usecase) : super(const TodoState());

  Future<void> loadTodos() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    
    final result = await usecase.getTodos();
    
    if (result.$2 != null) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: result.$2!.toString(),
      ));
    } else {
      emit(state.copyWith(
        isLoading: false,
        todos: result.$1 ?? [],
        errorMessage: null,
      ));
    }
  }

  Future<void> addTodo(String title) async {
    final result = await usecase.addTodo(title);
    
    if (result.$2 != null) {
      emit(state.copyWith(errorMessage: result.$2!.toString()));
    } else {
      loadTodos();
    }
  }

  Future<void> toggleTodo(TodoModel todo) async {
    final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
    final result = await usecase.updateTodo(updatedTodo);
    
    if (result.$2 != null) {
      emit(state.copyWith(errorMessage: result.$2!.toString()));
    } else {
      loadTodos();
    }
  }

  Future<void> deleteTodo(int id) async {
    final result = await usecase.deleteTodo(id);
    
    if (result.$2 != null) {
      emit(state.copyWith(errorMessage: result.$2!.toString()));
    } else {
      loadTodos();
    }
  }
}