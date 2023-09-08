import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import '../models/Todo.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _saveTodo() async {
    // get the current text field contents
    String name = _nameController.text;
    String description = _descriptionController.text;

    // create a new Todo from the form values
    // `isComplete` is also required, but should start false in a new Todo
    Todo newTodo = Todo(
        name: name,
        description: description.isNotEmpty ? description : null,
        isCompleted: false);

    try {
      // to write data to DataStore, we simply pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(newTodo);

      // after creating a new Todo, close the form
      Navigator.of(context).pop();
    } catch (e) {
      print('An error occurred while saving Todo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                  controller: _nameController,
                  decoration:
                      const InputDecoration(filled: true, labelText: 'Name')),
              TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      filled: true, labelText: 'Description')),
              ElevatedButton(onPressed: _saveTodo, child: const Text('Save'))
            ],
          ),
        ),
      ),
    );
  }
}
