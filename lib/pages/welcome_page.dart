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
          TextField(
            decoration: const InputDecoration(
              labelText: "Name of Game",
            ),
            onChanged: (text) {
              gameState.setName(text);
            },
          ),
          const SizedBox(
            height: 8,
          ),
          ElevatedButton(
            onPressed: () {
              gameState.miniGameName = "Tic Tac Toe";
            },
            child: const Text("Tic Tac Toe"),
          ),
          const SizedBox(
            height: 8,
          ),
          ElevatedButton(
            onPressed: () {
              gameState.miniGameName = "Simon Says";
            },
            child: const Text("Simon Says"),
          ),
          const SizedBox(
            height: 8,
          ),
          ElevatedButton(
            onPressed: () {
              gameState.miniGameName = "Word Match";
            },
            child: const Text("Word Match"),
          ),
        ],
      ),
    );
  }
}
