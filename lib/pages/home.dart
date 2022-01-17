import 'package:flutter/material.dart';
import 'package:test_final/models/todo.dart';
import 'package:test_final/services/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TodoService todoService = TodoService();
  late Future<List<Todo>> _todos;
  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    _todos = todoService.getTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _displayDialog(context),
          tooltip: "Add Todo"),
      body: SafeArea(
          child: FutureBuilder<List<Todo>>(
        future: _todos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final todo = snapshot.data?[index];
                return CheckboxListTile(
                  onChanged: (bool? value) {
                    todoService.updateTodo(todo!).then((res) {
                      setState(() {
                        todo.done = res;
                      });
                    });
                  },
                  value: todo!.done,
                  title: Text(todo.task),
                  controlAffinity: ListTileControlAffinity.leading,
                  secondary: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      todoService.deleteTodo(todo.id).then((_) {
                        setState(() {
                          _todos = todoService.getTodos();
                        });
                      });
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        },
      )),
    );
  }

  void _addTodoItem(String title) {
    // Wrapping it inside a set state will notify
    // the app that the state has changed
    setState(() {
      todoService.createTodo(_textFieldController.text).then((_) {
        _todos = todoService.getTodos();
        _textFieldController.clear();
      });
    });
  }

  Future<bool> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add a task to your list'),
              content: TextField(
                controller: _textFieldController,
                decoration: const InputDecoration(hintText: 'Enter task here'),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('ADD'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    setState(() {
                      _addTodoItem(_textFieldController.text);
                    });
                    /*_addTodoItem(_textFieldController.text);*/
                  },
                ),
                TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            );
          });
        }).then((t) => t ?? false);
  }
}
