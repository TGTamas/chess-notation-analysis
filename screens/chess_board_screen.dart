import 'package:cns/services/move_notation_service.dart';
import 'package:flutter/material.dart';
import '../chess_board.dart';
import '../widgets/chess_board_widget.dart';
import '../services/separated_lists_service.dart';
import 'package:pair/pair.dart';

class ChessBoardScreen extends StatefulWidget {
  final ChessBoard chessBoard;
  final List<String> recognizedWords;

  const ChessBoardScreen(
      {super.key, required this.chessBoard, required this.recognizedWords});

  @override
  _ChessBoardScreenState createState() => _ChessBoardScreenState();
}

class _ChessBoardScreenState extends State<ChessBoardScreen> {
  int currentMoveIndex = -1; // -1 means no move is highlighted
  List<Pair<String, String>> reverseMoves = []; 

  void refreshBoard() {
    setState(() {
      // Trigger a rebuild to refresh the board
    });
  }

  @override
  Widget build(BuildContext context) {
    final separatedListsService =
        SeparatedListsService(words: widget.recognizedWords);
    final filteredWords = separatedListsService.getFilteredWords();
    final blackMoves = filteredWords['blackAndAfter']!;
    final whiteMoves = filteredWords['whiteToBlack']!;
    // List of moves for previous move button

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess Board'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BLACK',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                RichText(
                  text: TextSpan(
                    children: blackMoves.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String move = entry.value;
                      return TextSpan(
                        text: move + (idx < blackMoves.length - 1 ? ', ' : ''),
                        style: TextStyle(
                          fontSize: 14,
                          color: currentMoveIndex == idx * 2 + 1
                              ? Colors.red
                              : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 4,
            child: Center(
              child: ChessBoardWidget(chessBoard: widget.chessBoard),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: currentMoveIndex >= 0
                      ? () {
                          setState(() {
                            bool isWhiteTurn = currentMoveIndex % 2 == 0;

                            final moveNotationService = MoveNotationService(
                              chessBoard: widget.chessBoard,
                              isWhiteTurn: isWhiteTurn,
                            );
                            moveNotationService
                                .applyPreviousMove(reverseMoves.last);
                            reverseMoves.removeLast();
                            currentMoveIndex--;
                            refreshBoard();
                          });
                        }
                      : null,
                  child: const Text('Previous move'),
                ),
                ElevatedButton(
                  onPressed: currentMoveIndex <
                          whiteMoves.length + blackMoves.length - 1
                      ? () {
                          setState(() {
                            currentMoveIndex++;
                            String notation = currentMoveIndex % 2 == 0
                                ? whiteMoves[currentMoveIndex ~/ 2]
                                : blackMoves[currentMoveIndex ~/ 2];
                            bool isWhiteTurn = currentMoveIndex % 2 == 0;

                            final moveNotationService = MoveNotationService(
                              chessBoard: widget.chessBoard,
                              isWhiteTurn: isWhiteTurn,
                            );
                            final move =
                                moveNotationService.applyMove(notation);
                            if (move != null) {
                              reverseMoves.add(move);
                            }
                            refreshBoard();
                          });
                        }
                      : null,
                  child: const Text('Next move'),
                ),
                ElevatedButton(
                  onPressed: currentMoveIndex > -1
                      ? () {
                          setState(() {
                            currentMoveIndex =
                                -1; // Reset to no move highlighted
                            reverseMoves.clear();
                            widget.chessBoard.reset();
                          });
                        }
                      : null,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WHITE',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                RichText(
                  text: TextSpan(
                    children: whiteMoves.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String move = entry.value;
                      return TextSpan(
                        text: move + (idx < whiteMoves.length - 1 ? ', ' : ''),
                        style: TextStyle(
                          fontSize: 14,
                          color: currentMoveIndex == idx * 2
                              ? Colors.red
                              : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
