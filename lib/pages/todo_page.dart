import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import '../amplifyconfiguration.dart';
import '../models/ModelProvider.dart';
import '../widgets/todo_list.dart';
import 'add_todo_page.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late StreamSubscription<QuerySnapshot<Todo>> _subscription;

  bool _isLoading = true;

  List<Todo> _todos = [];

  // amplify plugins
  final AmplifyAPI _apiPlugin = AmplifyAPI();
  final AmplifyDataStore _dataStorePlugin =
      AmplifyDataStore(modelProvider: ModelProvider.instance);

  @override
  void initState() {
    _initializeApp();

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    await _configureAmplify();

    _subscription = Amplify.DataStore.observeQuery(Todo.classType)
        .listen((QuerySnapshot<Todo> snapshot) {
      setState(() {
        if (_isLoading) _isLoading = false;
        _todos = snapshot.items;
      });
    });
  }

  Future<void> _configureAmplify() async {
    await Amplify.addPlugins([_dataStorePlugin, _apiPlugin]);

    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      safePrint(
          'Tried to reconfigure Amplify; this can occur when your app restarts on Android.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todo List'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TodosList(todos: _todos),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTodoPage()),
          );
        },
        tooltip: 'Add Todo',
        label: const Row(
          children: [Icon(Icons.add), Text('Add todo')],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
