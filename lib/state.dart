import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameState extends ChangeNotifier {
  static GameState of(BuildContext context, {bool listen = true}) => Provider.of<GameState>(context, listen: listen);

  String _name = '';
  String get name => _name;
  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  String _hello = "hello";

  String get hello => _hello;

  set hello(String value) {
    _hello = value;
    notifyListeners();
  }
}
