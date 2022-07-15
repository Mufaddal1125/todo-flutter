import 'dart:convert';
import 'dart:math';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

import 'models/todo.dart';
import 'package:http/http.dart' as http;

class TodoList extends StatefulWidget {
  const TodoList({Key? key, required this.todos}) : super(key: key);
  final List<Todo> todos;
  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: min(MediaQuery.of(context).size.width, 600),
        child: ListView.builder(
          itemCount: widget.todos.length,
          itemBuilder: (context, index) {
            var todo = widget.todos[index];
            return ListTile(
              leading: Checkbox(
                value: todo.completed,
                onChanged: (value) {
                  setState(() {
                    todo.completed = !todo.completed;
                  });
                  _updateTodo(todo);
                },
              ),
              title: TextFormField(
                  initialValue: todo.title,
                  decoration:
                      const InputDecoration.collapsed(hintText: 'Title'),
                  onChanged: (value) {
                    EasyDebounce.debounce(
                        'update_title', const Duration(milliseconds: 800), () {
                      todo.title = value;
                      _updateTodo(todo);
                    });
                  }),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'delete':
                      setState(() {
                        widget.todos.removeAt(index);
                      });
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _updateTodo(Todo todo) async {
    var uri = Uri.parse('http://localhost:8000/api/todo/${todo.id}');
    var res = await http.put(
      uri,
      body: json.encode(todo.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
