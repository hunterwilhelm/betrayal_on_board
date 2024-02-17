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

  String _miniGameName = "";

  String get miniGameName => _miniGameName;

  set miniGameName(String value) {
    _miniGameName = value;
    notifyListeners();
  }
}
