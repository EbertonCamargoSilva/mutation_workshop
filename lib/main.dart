import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/data/repository/todo_repository_impl.dart';
import 'src/domain/usecases/todo_usecase.dart';
import 'src/presentation/cubit/todo_cubit.dart';
import 'src/presentation/screen/todo_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final repository = TodoRepositoryImpl();
    final usecase = TodoUsecase(repository: repository);

    return MaterialApp(
      title: 'Todo List',
      home: BlocProvider(
        create: (context) => TodoCubit(usecase)..loadTodos(),
        child: TodoScreen(),
      ),
    );
  }
}