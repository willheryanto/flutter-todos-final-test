class Todo {
  final int id;
  bool done;
  final String task;

  Todo({required this.id, required this.done, required this.task});

  factory Todo.fromJson(Map<dynamic, dynamic> json) {
    return Todo(
      id: json['id'],
      done: json['done'],
      task: json['task'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'done': done,
      'task': task,
    };
  }
}
