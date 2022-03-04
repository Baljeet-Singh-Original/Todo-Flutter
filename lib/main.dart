import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/todos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Task Impulse'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  
  List<Todos> _todos = [];
  final _textController = TextEditingController();
  String todoText = '';

  Future<void> _saveTodosPrefs() async {
    final SharedPreferences prefs = await _prefs;
    final json = _todos.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList('todos', json);
  }
  Future<void> _getTodosPrefs() async {
    final SharedPreferences prefs = await _prefs;
    final json = prefs.getStringList('todos');
    if(json != null) {
    final todos = json.map((e) => Todos.fromJson(jsonDecode(e)));
    setState(() {
      _todos = todos.toList();
    });
    }
  }

  @override
  void initState() {
    super.initState();
    _getTodosPrefs();

  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              children: [
            for(var todo in _todos)
                CheckboxListTile(
                  title: Text(todo.text),
                  subtitle: Text(DateFormat('dd-MM-yyyy – kk:mm').format(todo.createdOn)),
                  secondary: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: (){
                        setState(() {
                        _todos.remove(todo);
                        _saveTodosPrefs();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task Removed Succesfully.'), backgroundColor: Colors.green));
                        },
                      ),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: todo.isCompleted,
                  onChanged: (bool? value) {
                    setState(() {
                      todo.isCompleted = value??false;
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  ),
              ]),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(todoText),
              SizedBox(
                width: 255,
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Type Your To-Do',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _textController.clear();
                      },
                      icon: const Icon(Icons.clear),
                    )
                  ),
                ),
              ),
              MaterialButton(
                shape: const CircleBorder(),
                onPressed: (){
                  if(_textController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please Type Something!'), backgroundColor: Colors.redAccent)
                    );
                  }
                  else {
                  setState(() {
                    _todos.add(Todos(text: _textController.text, createdOn: DateTime.now()));
                    _saveTodosPrefs();
                    _textController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task Created.'), backgroundColor: Colors.green));
                  });
                  }
                },
                color: Colors.deepPurple,
                child: const Icon(Icons.arrow_forward_sharp), textColor: Colors.white,),              
            ],
          ),
        )
        ],
      )
    );
  }
}
