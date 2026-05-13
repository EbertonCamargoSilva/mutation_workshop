import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/src/data/repository/todo_repository_impl.dart';
import 'package:todo_list_app/src/domain/models/todo_model.dart';
import 'package:todo_list_app/src/domain/usecases/todo_usecase.dart';

void main() {
  late TodoUsecase usecase;
  late TodoRepositoryImpl repository;

  setUp(() {
    repository = TodoRepositoryImpl();
    TodoRepositoryImpl.reset();
    usecase = TodoUsecase(repository: repository);
  });

  group('TodoUsecase Mutation - getTodos', () {
    test('should return empty list initially', () async {
      final result = await usecase.getTodos();

      expect(result.$1, isNotNull);
      expect(result.$1, isEmpty);
      expect(result.$2, isNull);
    });

    test('should return todos after adding', () async {
      await usecase.addTodo('Todo 1');
      await usecase.addTodo('Todo 2');

      final result = await usecase.getTodos();

      expect(result.$1, isNotNull);
      expect(result.$1!.length, equals(2));
      expect(result.$2, isNull);
    });
  });

  group('TodoUsecase Mutation - addTodo', () {
    test('should add todo with valid title', () async {
      final result = await usecase.addTodo('New Todo');

      expect(result.$1, isNotNull);
      expect(result.$1!.title, equals('New Todo'));
      expect(result.$1!.isCompleted, isFalse);
      expect(result.$2, isNull);
    });

    test('should return exception when title is empty', () async {
      final result = await usecase.addTodo('');

      expect(result.$1, isNull);
      expect(result.$2, isNotNull);
      expect(result.$2, isA<Exception>());
    });

    test('should return exception when title is only spaces', () async {
      final result = await usecase.addTodo('   ');

      expect(result.$1, isNull);
      expect(result.$2, isNotNull);
      expect(result.$2, isA<Exception>());
    });

    test('should not call repository when title is empty', () async {
      await usecase.addTodo('');

      final todos = await usecase.getTodos();
      expect(todos.$1, isEmpty);
    });
  });

  group('TodoUsecase Mutation - updateTodo', () {
    test('should update todo successfully', () async {
      final added = await usecase.addTodo('Original');
      final updated = added.$1!.copyWith(title: 'Updated', isCompleted: true);

      final result = await usecase.updateTodo(updated);

      expect(result.$1, isNotNull);
      expect(result.$1!.title, equals('Updated'));
      expect(result.$1!.isCompleted, isTrue);
      expect(result.$2, isNull);
    });

    test('should return exception when updating non-existent todo', () async {
      final fakeTodo = TodoModel(id: 999, title: 'Fake', isCompleted: false);

      final result = await usecase.updateTodo(fakeTodo);

      expect(result.$1, isNull);
      expect(result.$2, isNotNull);
      expect(result.$2, isA<Exception>());
    });
  });

  group('TodoUsecase Mutation - deleteTodo', () {
    test('should delete todo and return true', () async {
      final added = await usecase.addTodo('To Delete');

      final result = await usecase.deleteTodo(added.$1!.id);

      expect(result.$1, isTrue);
      expect(result.$1, equals(true));
      expect(result.$1 != false, isTrue);
      expect(result.$2, isNull);

      final todos = await usecase.getTodos();
      expect(todos.$1, isEmpty);
    });

    test('should return false and exception when deleting non-existent', () async {
      final result = await usecase.deleteTodo(999);

      expect(result.$1, isFalse);
      expect(result.$1, equals(false));
      expect(result.$1 != true, isTrue);
      expect(result.$2, isNotNull);
      expect(result.$2, isA<Exception>());
    });
  });
}
