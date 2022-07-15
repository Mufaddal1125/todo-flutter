import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo/app.dart';
import 'package:todo/models/todo.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    _fetchTodos().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: TodoList(todos: todos),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          var todo = await addTodo('');
          setState(() {
            todos.add(todo);
          });
        },
      ),
    );
  }

  Future<List<Todo>> _fetchTodos() async {
    var res = await http.get(Uri.parse('http://localhost:8000/api/todo'));
    var data = json.decode(utf8.decode(res.bodyBytes)) as List<dynamic>;
    return data.map((todo) => Todo.fromJson(todo)).toList();
  }

  Future<Todo> addTodo(String title) async {
    var res = await http.post(
      Uri.parse('http://localhost:8000/api/todo'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title}),
    );
    var data = json.decode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    return Todo.fromJson(data);
  }
}
