import 'dart:math';

import 'package:betrayal_on_board/state.dart';
import 'package:flutter/material.dart';

class WordMatch extends StatefulWidget {
  const WordMatch({Key? key});

  @override
  State<WordMatch> createState() => _WordMatchState();
}

class _WordMatchState extends State<WordMatch> {
  static final List<String> wordList = [
    "cloud",
    "dance",
    "apple",
    "board",
    "zebra",
    "toxic",
    "unity",
    "piano",
    "quark",
    "lunar",
    "jewel",
    "video",
    "space",
    "joker",
    "tiger",
    "swirl",
    "flame",
    "happy",
    "virus",
    "snake",
    "delta",
    "cabin",
    "grape",
    "dream",
    "cycle",
    "ocean",
    "quest",
    "pupil",
    "fever",
    "globe",
    "xylon",
    "magic",
    "eagle",
    "frost",
    "timer",
    "wedge",
    "music",
    "hound",
    "crane",
    "fairy",
    "tulip",
    "crisp",
    "hatch",
    "giant",
    "light",
    "noble",
    "power",
    "quiet",
    "rebel",
    "solar",
    "vocal"
  ];

  String? userInput;
  bool isMatched = false;
  String currentWord = wordList[0];
  int _completedWordCount = 0;
  TextEditingController _controller = TextEditingController();
  selectNewWord() {
    _controller.clear();
    Random random = Random();
    setState(() {
      _completedWordCount++;
      currentWord = wordList[random.nextInt(30)];
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.of(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Match'),
      ),
      body: Center(
        child: _completedWordCount == 5
            ? Column(
                children: [
                  const Text("Task Completed!"),
                  ElevatedButton(
                    onPressed: () {
                      gameState.miniGameName = "";
                    },
                    child: const Text('Go Back'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentWord,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    onChanged: (value) {
                      setState(() {
                        userInput = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Type the word here',
                      errorText: isMatched ? null : 'Incorrect word',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (userInput == currentWord) {
                        setState(() {
                          isMatched = true;
                          selectNewWord();
                          userInput = null;
                        });
                      } else {
                        setState(() {
                          isMatched = false;
                        });
                      }
                    },
                    child: const Text('Next Word'),
                  ),
                ],
              ),
      ),
    );
  }
}
