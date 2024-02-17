import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class GameState extends ChangeNotifier {
  Future<void> init() async {
    await sync();
    // call sync every 5 seconds
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      await sync();
    });
  }

  Future<void> sync() async {
    // request http://localhost:3000/state using http
    print("fetching");
    final response = await http.get(Uri.parse('http://localhost:3000/state'));
    _serverState = jsonDecode(response.body);
    print(_serverState);
    notifyListeners();
  }

  static GameState of(BuildContext context, {bool listen = true}) => Provider.of<GameState>(context, listen: listen);

  Map<String, dynamic> _serverState = {};

  Map<String, dynamic> get serverState => _serverState;
  final server = 'http://localhost:3000';

  join() async {
    print("joining");
    print(jsonEncode({'name': name}));
    final response = await http.post(Uri.parse('http://localhost:3000/join'), body: {'name': name});
    id = jsonDecode(response.body)["id"];
    await sync();
  }

  start() async {
    print("starting");
    await http.post(Uri.parse('$server/start'));
    await sync();
  }

  kill(String id) async {
    print("killing");
    await http.post(
      Uri.parse('$server/kill'),
      body: jsonEncode({'id': id}),
    );
    await sync();
  }

  final ticTacToeId = "1";
  final simonSaysId = "2";

  task(String taskId) async {
    print("tasking");
    await http.post(
      Uri.parse('$server/task'),
      body: jsonEncode({'userId': id, 'taskId': taskId}),
    );
    await sync();
  }

  int? id;
  String _name = '';
  String get name => _name;
  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  String _miniGameName = "";

  String get miniGameName => _miniGameName;

  set miniGameName(String value) {
    _miniGameName = value;
    notifyListeners();
  }
}
