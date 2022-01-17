import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:test_final/models/todo.dart';

class TodoService {
  final Dio _dio = Dio(BaseOptions(baseUrl: dotenv.env['API_URL']!));

  Future<List<Todo>> getTodos() async {
    final response = await _dio.get('/todos');
    return (response.data as List).map((todo) => Todo.fromJson(todo)).toList();
  }

  Future<void> createTodo(String task) async {
    await _dio.post('/todos', data: {"task": task});
  }

  Future<bool> updateTodo(Todo todo) async {
    bool newDone = !todo.done;
    await _dio.patch('/todos?id=eq.${todo.id}', data: {"done": newDone});
    return newDone;
  }

  Future<void> deleteTodo(int id) async {
    await _dio.delete('/todos?id=eq.$id');
  }
}
