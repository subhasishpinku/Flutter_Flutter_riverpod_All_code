import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_riverpod_enum/models/todo_model.dart';


class TodoService {
  static const String baseUrl = 'https://todoshowlist.glitch.me/todos';

  Future<List<Todo>> getTodos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> todoList = json.decode(response.body);
      return todoList.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> addTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(todo.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add todo');
    }
  }

  Future<void> editTodo(String id, String desc) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'desc': desc}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to edit todo');
    }
  }

  Future<void> toggleTodo(String id) async {
    final response = await http.patch(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to toggle todo');
    }
  }

  Future<void> removeTodo(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to remove todo');
    }
  }
}
