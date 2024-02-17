import 'package:betrayal_on_board/state.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SimonSays extends StatefulWidget {
  const SimonSays({super.key});

  @override
  _SimonSaysState createState() => _SimonSaysState();
}

class _SimonSaysState extends State<SimonSays> {
  List<int> sequence = [];
  List<int> playerSequence = [];
  int round = 1;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    sequence.clear();
    playerSequence.clear();
    round = 1;
    currentIndex = -1;
    generateFirstSequence();
    playSequence();
  }

  void generateFirstSequence() {
    Random random = Random();
    for (int i = 0; i < round + 2; i++) {
      sequence.add(random.nextInt(9));
    }
  }

  void generateSequence() {
    Random random = Random();
    sequence.add(random.nextInt(9));
  }

  void playSequence() async {
    for (int i = 0; i < sequence.length; i++) {
      await Future.delayed(const Duration(milliseconds: 450));
      setState(() {
        currentIndex = sequence[i];
      });
      await Future.delayed(const Duration(milliseconds: 450));
      setState(() {
        currentIndex = -1;
      });
    }
  }

  void checkSequence(int index) {
    setState(() {
      playerSequence.add(index);
    });

    if (playerSequence.length == sequence.length) {
      bool isCorrect = true;
      for (int i = 0; i < sequence.length; i++) {
        if (sequence[i] != playerSequence[i]) {
          isCorrect = false;
          break;
        }
      }

      if (isCorrect) {
        setState(() {
          round++;
        });
        if (round <= 3) {
          playerSequence.clear();
          generateSequence();
          playSequence();
        } else {
          playerSequence.clear();
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Wrong Order'),
              content:
                  const Text('You pressed the squares in the wrong order.'),
              actions: [
                ElevatedButton(
                  child: const Text('Try Again'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    playerSequence.clear();
                    playSequence();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.of(context, listen: false);
    return round == 4
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Task Completed!"),
              ElevatedButton(
                onPressed: () => gameState.miniGameName = "",
                child: const Text("Go Back"),
              )
            ],
          )
        : SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      return SquareWidget(
                        checkSequence: () => checkSequence(index),
                        isSelected: currentIndex == index,
                      );
                    },
                  ),
                ),
                Text('Round: $round'),
              ],
            ),
          );
  }
}

class SquareWidget extends StatelessWidget {
  const SquareWidget({
    super.key,
    required this.checkSequence,
    required this.isSelected,
  });

  final Function checkSequence;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Material(
        color: isSelected
            ? Theme.of(context).colorScheme.tertiaryContainer
            : Theme.of(context).colorScheme.tertiary,
        child: InkWell(
          onTap: () => checkSequence(),
          splashColor: Theme.of(context).colorScheme.tertiaryContainer,
        ),
        // color: currentIndex == index ? Colors.blue : Colors.grey,
      ),
    );
  }
}
