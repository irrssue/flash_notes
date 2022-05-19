import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flash_notes/widgets/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> todos = [];
  final todoTitleController = TextEditingController();
  final todoDescriptionController = TextEditingController();
  @override
  void dispose() {
    todoTitleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _databaseInit();
    super.initState();
  }

  _databaseInit() async {
    print(await getDatabasesPath());
    final database = openDatabase(
      join(await getDatabasesPath(), 'todos_database.db'),
      onCreate: (db, version) async {
        return db.execute(
          'CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, description TEXT);',
        );
      },
      version: 1,
    );
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');
    for (var map in maps) {
      map = {
        'title': map['title'],
        'description': map['description'],
      };

      setState(() {
        todos.add(map);
      });
    }
  }

  _databaseInsert() async {
    print(await getDatabasesPath());
    final database = openDatabase(
      join(await getDatabasesPath(), 'todos_database.db'),
      version: 1,
    );
    final db = await database;
    await db.delete('todos');
    for (var i = 0; i < todos.length; i++) {
      await db.insert(
        'todos',
        {
          'title': todos[i]['title'],
          'description': todos[i]['description'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: Colors.transparent,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.1),
          child: Container(
            color: Colors.grey,
            height: 0.1,
          ),
        ),
      ),
      body: Center(
        child: TodoList(
          todos: todos,
          function: _databaseInsert,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              todoTitleController.clear();
              todoDescriptionController.clear();
              return AlertDialog(
                // the text place

                backgroundColor: Theme.of(context).colorScheme.background,
                title: const Text("New note"),
                content: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: todoTitleController,
                        autofocus: true,
                        textCapitalization: TextCapitalization.sentences,
                        strutStyle: StrutStyle.disabled,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: todoDescriptionController,
                        autofocus: true,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 7,
                        strutStyle: StrutStyle.disabled,
                        decoration: InputDecoration(
                          hintText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            todos.add({
                              'title': todoTitleController.text,
                              'description': todoDescriptionController.text,
                            });
                            _databaseInsert();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Add'),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        tooltip: 'New Note',
        child: const Icon(Icons.add_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
