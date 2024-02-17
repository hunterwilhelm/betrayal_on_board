import 'package:betrayal_on_board/state.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    super.key,
    required this.gameState,
  });

  final GameState gameState;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
          ),
          GestureDetector(
            child: Text("Tick Tack Toe"),
            onTap: () {
              gameState.miniGameName = "Tic Tac Toe";
            },
          ),
          GestureDetector(
            child: Text(
              "Simon Says",
            ),
            onTap: () {
              gameState.miniGameName = "Simon Says";
            },
          ),
        ],
      ),
    );
  }
}
