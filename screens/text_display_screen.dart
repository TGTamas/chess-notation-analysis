import 'package:cns/chess_board.dart';
import 'package:cns/screens/chess_board_screen.dart';
import 'package:flutter/material.dart';
import 'text_list_screen.dart';

class TextDisplayScreen extends StatelessWidget {
  final String recognizedText;
  final List<String> recognizedWords;

  const TextDisplayScreen(
      {Key? key, required this.recognizedText, required this.recognizedWords})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chessBoard = ChessBoard();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recognized Text'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    recognizedText,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TextListScreen(recognizedWords: recognizedWords),
                  ),
                );
              },
              child: const Text('View Recognized Words'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChessBoardScreen(chessBoard: chessBoard, recognizedWords: recognizedWords,),
                  ),
                );
              },
              child: const Text('Show Chess Board'),
            )
          ],
        ),
      ),
    );
  }
}
