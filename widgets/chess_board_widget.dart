import 'package:flutter/material.dart';
import '../chess_board.dart';

class ChessBoardWidget extends StatefulWidget {
  final ChessBoard chessBoard;

  const ChessBoardWidget({super.key, required this.chessBoard});

  @override
  _ChessBoardWidgetState createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends State<ChessBoardWidget> {
  void refreshBoard() {
    setState(() {
      // Trigger a rebuild to refresh the board
    });
  }

  String _getChessSymbol(String piece) {
    switch (piece) {
      case 'p':
        return '♙'; // White Pawn
      case 'r':
        return '♖'; // White Rook
      case 'n':
        return '♘'; // White Knight
      case 'b':
        return '♗'; // White Bishop
      case 'q':
        return '♕'; // White Queen
      case 'k':
        return '♔'; // White King
      case 'P':
        return '♟'; // Black Pawn
      case 'R':
        return '♜'; // Black Rook
      case 'N':
        return '♞'; // Black Knight
      case 'B':
        return '♝'; // Black Bishop
      case 'Q':
        return '♛'; // Black Queen
      case 'K':
        return '♚'; // Black King
      default:
        return ''; // Empty square
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Column(
                children: List.generate(ChessBoard.boardSize, (index) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        '${ChessBoard.boardSize - index}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }),
              ),
              Expanded(
                child: FractionallySizedBox(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: ChessBoard.boardSize,
                      ),
                      itemBuilder: (context, index) {
                        final row = ChessBoard.boardSize - 1 - (index ~/ ChessBoard.boardSize);
                        final col = index % ChessBoard.boardSize;
                        final piece = widget.chessBoard.getPiece(row, col);
                        final symbol = _getChessSymbol(piece);
                        return Container(
                          decoration: BoxDecoration(
                            color: (row + col) % 2 == 0 ? Colors.white : Colors.grey,
                            border: Border.all(color: Colors.black),
                          ),
                          child: Center(
                            child: Text(
                              symbol,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        );
                      },
                      itemCount: ChessBoard.boardSize * ChessBoard.boardSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: List.generate(ChessBoard.boardSize + 1, (index) {
            if (index == 0) {
              return const SizedBox(width: 16); // Empty space for row numbers
            }
            return Expanded(
              child: Center(
                child: Text(
                  String.fromCharCode('A'.codeUnitAt(0) + index - 1),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}