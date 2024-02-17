import 'package:betrayal_on_board/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TicTacToe extends HookWidget {
  const TicTacToe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.of(context, listen: false);
    final winState = useState<bool?>(null);

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            gameState.miniGameName = "";
          },
          child: const Text('Back to menu'),
        ),
        if (winState.value == true) const Text("You win!"),
        _Game(
          winsRequired: 3,
          onComplete: () {
            winState.value = true;
            Future.delayed(
              const Duration(seconds: 2),
              () => gameState.miniGameName = "",
            );
          },
        )
      ],
    );
  }
}

class _Game extends HookWidget {
  const _Game({
    required this.winsRequired,
    required this.onComplete,
  });
  final int winsRequired;
  final void Function() onComplete;

  @override
  Widget build(BuildContext context) {
    final ticTacToeState = useState<List<String>>(List.filled(9, ""));
    final isWinO = isWinner("O", ticTacToeState.value);
    final isWinX = isWinner("X", ticTacToeState.value);
    final showWinState = useState<bool>(false);
    final showLoseState = useState<bool>(false);
    final showTieState = useState<bool>(false);
    final winCounts = useState(0);
    final blockClicks = useState(false);
    final refresh = useState(0);
    next(int index, String player) {
      final isWinX = isWinner("X", ticTacToeState.value);
      if (isWinX) {
        return;
      }
      if (ticTacToeState.value[index] == "") {
        ticTacToeState.value[index] = player;
        if (player == "X") {
          Future.delayed(const Duration(milliseconds: 300), () {
            // make an array of indices 0 - 8
            final indices = List.generate(9, (index) => index);
            final empties = indices.where((element) => ticTacToeState.value[element] == "").toList();
            empties.shuffle();
            if (empties.isNotEmpty) {
              next(empties.first, "O");
            }
            blockClicks.value = false;
            refresh.value++;
          });
        } else {
          blockClicks.value = true;
        }
        final isWinO = isWinner("O", ticTacToeState.value);
        final isWinX = isWinner("X", ticTacToeState.value);
        final isFull = checkIfFull(ticTacToeState.value);
        if (isFull && !isWinO && !isWinX) {
          showLoseState.value = true;
          blockClicks.value = true;
          Future.delayed(const Duration(milliseconds: 500), () {
            ticTacToeState.value = List.filled(9, "");
            showLoseState.value = false;
            showWinState.value = false;
            showTieState.value = false;
          });
        }
        if (isWinO) {
          showLoseState.value = true;
        }
        if (isWinX) {
          showWinState.value = true;
          winCounts.value++;
        }
        if (isWinO || isWinX) {
          blockClicks.value = true;
          Future.delayed(const Duration(milliseconds: 500), () {
            ticTacToeState.value = List.filled(9, "");
            showWinState.value = false;
            showLoseState.value = false;
            showTieState.value = false;
            if (winCounts.value == winsRequired) {
              onComplete();
            }
          });
        }
        refresh.value++;
      }
    }

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Text("Wins: ${winCounts.value}/$winsRequired"),
          Container(
            color: isWinX
                ? Colors.green
                : isWinO
                    ? Colors.red
                    : showTieState.value
                        ? const Color.fromARGB(255, 215, 198, 46)
                        : Colors.white,
            child: SizedBox(
              width: 300,
              height: 300,
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (!blockClicks.value) next(index, "X");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Center(
                        child: Text(ticTacToeState.value[index], style: const TextStyle(fontSize: 40)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

bool isWinner(String player, List<String> board) {
  if (board[0] == player && board[1] == player && board[2] == player) {
    return true;
  }
  if (board[3] == player && board[4] == player && board[5] == player) {
    return true;
  }
  if (board[6] == player && board[7] == player && board[8] == player) {
    return true;
  }
  if (board[0] == player && board[3] == player && board[6] == player) {
    return true;
  }
  if (board[1] == player && board[4] == player && board[7] == player) {
    return true;
  }
  if (board[2] == player && board[5] == player && board[8] == player) {
    return true;
  }
  if (board[0] == player && board[4] == player && board[8] == player) {
    return true;
  }
  if (board[2] == player && board[4] == player && board[6] == player) {
    return true;
  }
  return false;
}

bool checkIfFull(List<String> board) {
  return !board.contains("");
}
