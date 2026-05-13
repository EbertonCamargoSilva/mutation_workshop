import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todo_list_app/src/domain/models/todo_model.dart';
import 'package:todo_list_app/src/domain/usecases/todo_usecase.dart';
import 'package:todo_list_app/src/domain/repositories/todo_repository.dart';

import 'todo_usecase_test.mocks.dart';

@GenerateMocks([TodoRepository])
void main() {
  late TodoUsecase usecase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    usecase = TodoUsecase(repository: mockRepository);
  });

  group('TodoUsecase - getTodos', () {
    final mockTodos = [
      TodoModel(id: 1, title: 'Test Todo', isCompleted: false),
      TodoModel(id: 2, title: 'Another Todo', isCompleted: true),
    ];

    test('should return todos when repository call succeeds', () async {
      when(mockRepository.getTodos()).thenAnswer((_) async => mockTodos);

      final result = await usecase.getTodos();

      expect(result.$1, mockTodos);
      expect(result.$2, isNull);
      verify(mockRepository.getTodos()).called(1);
    });

    test('should return exception when repository call fails', () async {
      when(mockRepository.getTodos()).thenThrow(Exception('Database error'));

      final result = await usecase.getTodos();

      expect(result.$1, isNull);
      expect(result.$2, isA<Exception>());
    });

    test('should return empty list when repository returns empty', () async {
      when(mockRepository.getTodos()).thenAnswer((_) async => []);

      final result = await usecase.getTodos();

      expect(result.$1, isEmpty);
      expect(result.$2, isNull);
    });
  });

  group('TodoUsecase - addTodo', () {
    final mockTodo = TodoModel(id: 1, title: 'New Todo', isCompleted: false);

    test('should return todo when repository call succeeds', () async {
      when(mockRepository.addTodo('New Todo')).thenAnswer((_) async => mockTodo);

      final result = await usecase.addTodo('New Todo');

      expect(result.$1, mockTodo);
      expect(result.$2, isNull);
      verify(mockRepository.addTodo('New Todo')).called(1);
    });

    test('should return exception when title is empty', () async {
      final result = await usecase.addTodo('');

      expect(result.$1, isNull);
      expect(result.$2, isA<Exception>());
      verifyNever(mockRepository.addTodo(any));
    });

    test('should return exception when repository call fails', () async {
      when(mockRepository.addTodo('New Todo')).thenThrow(Exception('Add failed'));

      final result = await usecase.addTodo('New Todo');

      expect(result.$1, isNull);
      expect(result.$2, isA<Exception>());
    });
  });

  group('TodoUsecase - updateTodo', () {
    final mockTodo = TodoModel(id: 1, title: 'Updated Todo', isCompleted: true);

    test('should return updated todo when repository call succeeds', () async {
      when(mockRepository.updateTodo(mockTodo)).thenAnswer((_) async => mockTodo);

      final result = await usecase.updateTodo(mockTodo);

      expect(result.$1, mockTodo);
      expect(result.$2, isNull);
      verify(mockRepository.updateTodo(mockTodo)).called(1);
    });

    test('should return exception when repository call fails', () async {
      when(mockRepository.updateTodo(mockTodo)).thenThrow(Exception('Update failed'));

      final result = await usecase.updateTodo(mockTodo);

      expect(result.$1, isNull);
      expect(result.$2, isA<Exception>());
    });
  });

  group('TodoUsecase - deleteTodo', () {
    test('should return true when repository call succeeds', () async {
      when(mockRepository.deleteTodo(1)).thenAnswer((_) async => {});

      final result = await usecase.deleteTodo(1);

      expect(result.$1, true);
      expect(result.$2, isNull);
      verify(mockRepository.deleteTodo(1)).called(1);
    });

    test('should return exception when repository call fails', () async {
      when(mockRepository.deleteTodo(1)).thenThrow(Exception('Delete failed'));

      final result = await usecase.deleteTodo(1);

      expect(result.$1, false);
      expect(result.$2, isA<Exception>());
    });
  });
}