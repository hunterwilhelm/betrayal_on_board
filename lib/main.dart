import 'package:betrayal_on_board/minigames/simonsays.dart';
import 'package:betrayal_on_board/minigames/tictactoe.dart';
import 'package:betrayal_on_board/minigames/word_match.dart';
import 'package:betrayal_on_board/pages/welcome_page.dart';
import 'package:betrayal_on_board/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
        ),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider<GameState>(
        create: (context) => GameState(),
        child: Loader(),
      ),
    );
  }
}

class Loader extends HookWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.of(context);
    final isLoaded = useState(false);
    useEffect(() {
      gameState.sync().then((value) {
        isLoaded.value = true;
      });
      return null;
    }, []);

    return Scaffold(
      body: Center(
        child: isLoaded.value ? const MyHomePage() : const CircularProgressIndicator(),
      ),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.of(context);

    if (gameState.name.isEmpty) {
      return TextField(
        onSubmitted: (text) {
          gameState.setName(text);
          gameState.join();
        },
      );
    }
    if (!gameState.serverState["started"]) {
      return Column(
        children: [
          Text("Waiting to start"),
          gameState.serverState["online"] != null
              ? Column(
                  children: gameState.serverState["online"].map<Widget>((user) {
                    return Text(user["name"] ?? '');
                  }).toList(),
                )
              : const SizedBox(),
          ElevatedButton(
            onPressed: () {
              gameState.start();
            },
            child: const Text("Start Game"),
          ),
        ],
      );
    }
    Widget page = WelcomePage(gameState: gameState);

    if (gameState.miniGameName == "Tic Tac Toe") {
      page = const TicTacToe();
    } else if (gameState.miniGameName == "Simon Says") {
      page = SimonSays();
    } else if (gameState.miniGameName == "Word Match") {
      page = WordMatch();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(gameState.name),
      ),
      body: page,
    );
  }
}
