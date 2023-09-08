// flutter and ui libraries
import 'package:flutter/material.dart';
// amplify model provider (should have been generated for you)
import '../models/ModelProvider.dart';
import 'todo_item.dart';
// presentational widgets

class TodosList extends StatelessWidget {
  final List<Todo> todos;

  const TodosList({super.key, required this.todos});

  @override
  Widget build(BuildContext context) {
    return todos.length >= 1
        ? ListView(
            padding: const EdgeInsets.all(8),
            children: todos.map((todo) => TodoItem(todo: todo)).toList())
        : const Center(child: Text('Tap button below to add a todo!'));
  }
}
