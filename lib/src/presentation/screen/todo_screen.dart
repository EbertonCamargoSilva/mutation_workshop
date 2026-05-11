import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/todo_cubit.dart';
import '../cubit/todo_state.dart';
import '../widgets/todo_item.dart';

class TodoScreen extends StatelessWidget {
  final _controller = TextEditingController();

  TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Add todo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      context.read<TodoCubit>().addTodo(_controller.text);
                      _controller.clear();
                    }
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TodoCubit, TodoState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (state.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${state.errorMessage}'),
                        ElevatedButton(
                          onPressed: () => context.read<TodoCubit>().loadTodos(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                
                if (state.todos.isEmpty) {
                  return const Center(
                    child: Text('No todos yet. Add one above!'),
                  );
                }
                
                return ListView.builder(
                  itemCount: state.todos.length,
                  itemBuilder: (context, index) {
                    return TodoItem(todo: state.todos[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}