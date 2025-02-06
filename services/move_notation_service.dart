import 'package:pair/pair.dart';

import '../chess_board.dart';

class MoveNotationService {
  final ChessBoard chessBoard;
  bool isWhiteTurn;

  final List<String> _pieces = ['R', 'N', 'B', 'Q', 'K'];

  final Map<String, String> _coloredPieces = {
    'Pawn': '-',
    'Rook': '-',
    'Knight': '-',
    'Bishop': '-',
    'Queen': '-',
    'King': '-',
  };

  MoveNotationService({required this.chessBoard, required this.isWhiteTurn});

  Pair<String, String>? applyMove(String notation) {
    _fillColoredPieces();
    final move = _parseNotation(notation);
    if (move != null) {
      return _makeMove(move);
    }
    return null;
  }

  void reset() {
    chessBoard.reset();
  }

  void _fillColoredPieces() {
    _coloredPieces['Pawn'] = isWhiteTurn ? 'p' : 'P';
    _coloredPieces['Rook'] = isWhiteTurn ? 'r' : 'R';
    _coloredPieces['Knight'] = isWhiteTurn ? 'n' : 'N';
    _coloredPieces['Bishop'] = isWhiteTurn ? 'b' : 'B';
    _coloredPieces['Queen'] = isWhiteTurn ? 'q' : 'Q';
    _coloredPieces['King'] = isWhiteTurn ? 'k' : 'K';
  }

  Map<String, String>? _parseNotation(String notation) {
    // Implement the logic to parse the move notation


    // TODO make more corrections
    if(notation[notation.length - 1] == "s" || notation[notation.length - 1] == "S"){
      notation = '${notation.substring(0, notation.length - 1)}5';
    }

    //King side Castle
    if (notation == 'O-O' || notation == '0-0') {
      return {
        'castle': 'King',
      };
    }

    //Queen side Castle
    if (notation == 'O-O-O' || notation == '0-0-0') {
      return {
        'castle': 'Queen',
      };
    }

    if (notation[notation.length - 1] == '+' ||
        notation[notation.length - 1] == '#') {
      notation = notation.substring(0, notation.length - 1);
    }

    notation = notation.replaceAll('x', '');
    notation = notation.replaceAll('X', '');

    final toRow = (int.parse(notation[notation.length - 1]) - 1).toString();
    final toCol =
        (notation[notation.length - 2].toUpperCase().codeUnitAt(0) - 65)
            .toString();

    if (notation.length == 2) {
      return _findPawnMove(toRow, toCol);
    }

    if (!_pieces.contains(notation[0])) {
      if (isWhiteTurn) {
        return {
          'fromRow': (int.parse(toRow) - 1).toString(),
          'fromCol': notation[0],
          'toRow': toRow,
          'toCol': toCol,
          'checkEP': "true",
        };
      } else {
        return {
          'fromRow': (int.parse(toRow) + 1).toString(),
          'fromCol': notation[0],
          'toRow': toRow,
          'toCol': toCol,
          'checkEP': "true",
        };
      }
    }

    if (notation[0] == notation[0].toUpperCase()) {
      return _distributeByPiece(
        notation,
      );
    }

    return null;
  }

  Map<String, String>? _findPawnMove(String toRow, String toCol) {
    // Implement the logic to find the pawn move
    int toRowInt = int.parse(toRow);
    int toColInt = int.parse(toCol);

    int startRow = isWhiteTurn ? toRowInt - 1 : toRowInt + 1;
    int endRow = isWhiteTurn ? -1 : 8;
    int step = isWhiteTurn ? -1 : 1;

    for (int row = startRow; row != endRow; row += step) {
      if (chessBoard.getPiece(row, toColInt) == _coloredPieces['Pawn']) {
        return {
          'fromRow': row.toString(),
          'fromCol': toCol,
          'toRow': toRow,
          'toCol': toCol,
        };
      }
    }
    return null;
  }

  Map<String, String>? _distributeByPiece(String notation) {
    switch (notation[0]) {
      case 'R':
        return _findRookMove(notation);
      case 'N':
        return _findKnightMove(notation);
      case 'B':
        return _findBishopMove(notation);
      case 'Q':
        return _findQueenMove(notation);
      case 'K':
        return _findKingMove(notation);
      default:
        return null;
    }
  }

  Map<String, String>? _findRookMove(String notation) {
    // Implement the logic to find the rook move
    final toRow = (int.parse(notation[notation.length - 1]) - 1).toString();
    final toCol =
        (notation[notation.length - 2].toUpperCase().codeUnitAt(0) - 65)
            .toString();
    var fromRow = -1;
    var fromCol = -1;

    final givenPosition = notation.substring(1, notation.length - 2);

    if (givenPosition.length == 1) {
      if (RegExp(r'^\d$').hasMatch(givenPosition)) {
        fromRow = int.parse(givenPosition);
      } else if (RegExp(r'^[a-zA-Z]$').hasMatch(givenPosition)) {
        fromCol = givenPosition.toUpperCase().codeUnitAt(0) - 65;
      }
    } else if (givenPosition.length == 2) {
      return {
        'fromRow': givenPosition[1],
        'fromCol':
            (givenPosition[0].toUpperCase().codeUnitAt(0) - 65).toString(),
        'toRow': toRow,
        'toCol': toCol,
      };
    }

    if (givenPosition.isEmpty) {
      //If the rook's position is not specified (aka only one rook can make that move)
      for (var i = 0; i < 8; i++) {
        if (chessBoard.getPiece(i, int.parse(toCol)) ==
            _coloredPieces['Rook']) {
          return {
            'fromRow': i.toString(),
            'fromCol': toCol,
            'toRow': toRow,
            'toCol': toCol,
          };
        }
      }
      for (var i = 0; i < 8; i++) {
        if (chessBoard.getPiece(int.parse(toRow), i) ==
            _coloredPieces['Rook']) {
          return {
            'fromRow': toRow,
            'fromCol': i.toString(),
            'toRow': toRow,
            'toCol': toCol,
          };
        }
      }
    } else if (givenPosition.isNotEmpty) {
      if (fromRow != -1) {
        for (var i = 0; i < 8; i++) {
          if (chessBoard.getPiece(fromRow, i) == _coloredPieces['Rook']) {
            return {
              'fromRow': fromRow.toString(),
              'fromCol': i.toString(),
              'toRow': toRow,
              'toCol': toCol,
            };
          }
        }
      } else if (fromCol != -1) {
        for (var i = 0; i < 8; i++) {
          if (chessBoard.getPiece(i, fromCol) == _coloredPieces['Rook']) {
            return {
              'fromRow': i.toString(),
              'fromCol': fromCol.toString(),
              'toRow': toRow,
              'toCol': toCol,
            };
          }
        }
      }
      return null;
    }

    return null;
  }

  Map<String, String>? _findKnightMove(String notation) {
    // Implement the logic to find the knight move
    final toRow = (int.parse(notation[notation.length - 1]) - 1).toString();
    final toCol =
        (notation[notation.length - 2].toUpperCase().codeUnitAt(0) - 65)
            .toString();
    var fromRow = -1;
    var fromCol = -1;

    final givenPosition = notation.substring(1, notation.length - 2);

    if (givenPosition.length == 1) {
      if (RegExp(r'^\d$').hasMatch(givenPosition)) {
        fromRow = int.parse(givenPosition);
      } else if (RegExp(r'^[a-zA-Z]$').hasMatch(givenPosition)) {
        fromCol = givenPosition.toUpperCase().codeUnitAt(0) - 65;
      }
    } else if (givenPosition.length == 2) {
      return {
        'fromRow': givenPosition[1],
        'fromCol':
            (givenPosition[0].toUpperCase().codeUnitAt(0) - 65).toString(),
        'toRow': toRow,
        'toCol': toCol,
      };
    }

    final List<List<int>> knightMoves = [
      [2, 1],
      [2, -1],
      [-2, 1],
      [-2, -1],
      [1, 2],
      [1, -2],
      [-1, 2],
      [-1, -2]
    ];

    if (givenPosition.isEmpty) {
      for (var move in knightMoves) {
        int potentialFromRow = int.parse(toRow) + move[0];
        int potentialFromCol = int.parse(toCol) + move[1];

        if (potentialFromRow >= 0 &&
            potentialFromRow < 8 &&
            potentialFromCol >= 0 &&
            potentialFromCol < 8) {
          String piece =
              chessBoard.getPiece(potentialFromRow, potentialFromCol);
          if (piece == _coloredPieces['Knight']) {
            return {
              'fromRow': potentialFromRow.toString(),
              'fromCol': potentialFromCol.toString(),
              'toRow': toRow.toString(),
              'toCol': toCol.toString(),
            };
          }
        }
      }
    }

    if (fromCol != -1) {
      List<List<int>> possibleKnightMoves = knightMoves
          .where((element) => element[1] == int.parse(toCol) - fromCol)
          .toList();
      for (var move in possibleKnightMoves) {
        int potentialFromRow = int.parse(toRow) + move[0];
        if (potentialFromRow >= 0 && potentialFromRow < 8) {
          String piece = chessBoard.getPiece(potentialFromRow, fromCol);
          if (piece == _coloredPieces['Knight']) {
            return {
              'fromRow': potentialFromRow.toString(),
              'fromCol': fromCol.toString(),
              'toRow': toRow.toString(),
              'toCol': toCol.toString(),
            };
          }
        }
      }
    }

    if (fromRow != -1) {
      List<List<int>> possibleKnightMoves = knightMoves
          .where((element) => element[0] == int.parse(toRow) - fromRow)
          .toList();
      for (var move in possibleKnightMoves) {
        int potentialFromCol = int.parse(toCol) + move[1];
        if (potentialFromCol >= 0 && potentialFromCol < 8) {
          String piece = chessBoard.getPiece(fromRow, potentialFromCol);
          if (piece == _coloredPieces['Knight']) {
            return {
              'fromRow': fromRow.toString(),
              'fromCol': potentialFromCol.toString(),
              'toRow': toRow.toString(),
              'toCol': toCol.toString(),
            };
          }
        }
      }
    }

    return null;
  }

  Map<String, String>? _findBishopMove(String notation) {
    // Implement the logic to find the bishop move
    final toRow = (int.parse(notation[notation.length - 1]) - 1).toString();
    final toCol =
        (notation[notation.length - 2].toUpperCase().codeUnitAt(0) - 65)
            .toString();
    var fromRow = -1;
    var fromCol = -1;

    final givenPosition = notation.substring(1, notation.length - 2);

    if (givenPosition.length == 1) {
      if (RegExp(r'^\d$').hasMatch(givenPosition)) {
        fromRow = int.parse(givenPosition);
      } else if (RegExp(r'^[a-zA-Z]$').hasMatch(givenPosition)) {
        fromCol = givenPosition.toUpperCase().codeUnitAt(0) - 65;
      }
    } else if (givenPosition.length == 2) {
      return {
        'fromRow': givenPosition[1],
        'fromCol':
            (givenPosition[0].toUpperCase().codeUnitAt(0) - 65).toString(),
        'toRow': toRow,
        'toCol': toCol,
      };
    }

    final List<List<int>> bishopDirections = [
      [-1, 1],
      [-1, -1],
      [1, 1],
      [1, -1]
    ];

    if (givenPosition.isEmpty) {
      var i = int.parse(toRow);
      var j = int.parse(toCol);

      for (int k = 1; k < 8; k++) {
        for (var direction in bishopDirections) {
          int potentialFromRow = i + direction[0] * k;
          int potentialFromCol = j + direction[1] * k;

          if (potentialFromRow >= 0 &&
              potentialFromRow < 8 &&
              potentialFromCol >= 0 &&
              potentialFromCol < 8) {
            if (chessBoard.getPiece(potentialFromRow, potentialFromCol) ==
                _coloredPieces['Bishop']) {
              return {
                'fromRow': potentialFromRow.toString(),
                'fromCol': potentialFromCol.toString(),
                'toRow': toRow,
                'toCol': toCol,
              };
            }
          }
        }
      }
    }

    if (fromRow != -1) {
      final difference = (int.parse(toRow) - fromRow).abs();
      final possibleCol1 = int.parse(toCol) + difference;
      final possibleCol2 = int.parse(toCol) - difference;
      if (possibleCol1 >= 0 && possibleCol1 < 8) {
        if (chessBoard.getPiece(fromRow, possibleCol1) ==
            _coloredPieces['Bishop']) {
          return {
            'fromRow': fromRow.toString(),
            'fromCol': possibleCol1.toString(),
            'toRow': toRow,
            'toCol': toCol,
          };
        }
      }
      if (possibleCol2 >= 0 && possibleCol2 < 8) {
        if (chessBoard.getPiece(fromRow, possibleCol2) ==
            _coloredPieces['Bishop']) {
          return {
            'fromRow': fromRow.toString(),
            'fromCol': possibleCol2.toString(),
            'toRow': toRow,
            'toCol': toCol,
          };
        }
      }
    }
    return null;
  }

  Map<String, String>? _findKingMove(String notation) {
    // Implement the logic to find the king move

    final toRow = (int.parse(notation[notation.length - 1]) - 1).toString();
    final toCol =
        (notation[notation.length - 2].toUpperCase().codeUnitAt(0) - 65)
            .toString();

    final List<List<int>> kingMoves = [
      [1, 0],
      [1, 1],
      [0, 1],
      [-1, 1],
      [-1, 0],
      [-1, -1],
      [0, -1],
      [1, -1]
    ];

    for (var move in kingMoves) {
      final potentialFromRow = int.parse(toRow) + move[0];
      final potentialFromCol = int.parse(toCol) + move[1];

      if (potentialFromRow >= 0 &&
          potentialFromRow < 8 &&
          potentialFromCol >= 0 &&
          potentialFromCol < 8) {
        if (chessBoard.getPiece(potentialFromRow, potentialFromCol) ==
            _coloredPieces['King']) {
          return {
            'fromRow': potentialFromRow.toString(),
            'fromCol': potentialFromCol.toString(),
            'toRow': toRow,
            'toCol': toCol,
          };
        }
      }
    }

    return null;
  }

  Map<String, String>? _findQueenMove(String notation) {
    // Implement the logic to find the queen move

    final toRow = (int.parse(notation[notation.length - 1]) - 1).toString();
    final toCol =
        (notation[notation.length - 2].toUpperCase().codeUnitAt(0) - 65)
            .toString();

    final List<List<int>> queenDirections = [
      [-1, 1],
      [-1, -1],
      [1, 1],
      [1, -1],
      [1, 0],
      [0, 1],
      [-1, 0],
      [0, -1]
    ];

    for (var move in queenDirections) {
      var i = int.parse(toRow);
      var j = int.parse(toCol);

      for (int k = 1; k < 8; k++) {
        int potentialFromRow = i + move[0] * k;
        int potentialFromCol = j + move[1] * k;

        if (potentialFromRow >= 0 &&
            potentialFromRow < 8 &&
            potentialFromCol >= 0 &&
            potentialFromCol < 8) {
          if (chessBoard.getPiece(potentialFromRow, potentialFromCol) ==
              _coloredPieces['Queen']) {
            return {
              'fromRow': potentialFromRow.toString(),
              'fromCol': potentialFromCol.toString(),
              'toRow': toRow,
              'toCol': toCol,
            };
          }
        }
      }
    }

    return null;
  }

  Pair<String, String>? _makeMove(Map<String, String> move) {
    if (move['castle'] == 'King') {
      return _makeKingSideCastle();
    }
    if (move['castle'] == 'Queen') {
      return _makeQueenSideCastle();
    }
    final fromRow = int.parse(move['fromRow']!);
    if (RegExp(r'^[a-h]$').hasMatch(move['fromCol']!)) {
      move['fromCol'] =
          (move['fromCol']!.toUpperCase().codeUnitAt(0) - 65).toString();
    }
    final fromCol = int.parse(move['fromCol']!);
    final toRow = int.parse(move['toRow']!);
    if (RegExp(r'^[a-h]$').hasMatch(move['toCol']!)) {
      move['toCol'] =
          (move['toCol']!.toUpperCase().codeUnitAt(0) - 65).toString();
    }
    final toCol = int.parse(move['toCol']!);

    //TODO implement EP reverse move
    if(move['checkEP'] == "true"){
      if(isWhiteTurn && chessBoard.getPiece(toRow - 1, toCol) == 'P'){
        chessBoard.setPiece(toRow - 1, toCol, '');
      } else if (!isWhiteTurn && chessBoard.getPiece(toRow + 1, toCol) == 'p'){
        chessBoard.setPiece(toRow + 1, toCol, '');
      }
    }

    final piece = chessBoard.getPiece(fromRow, fromCol);
    chessBoard.setPiece(fromRow, fromCol, '');
    chessBoard.setPiece(toRow, toCol, piece);
    return Pair('$fromRow$fromCol ','$toRow$toCol');
  }

  Pair<String, String> _makeKingSideCastle() {
    if (isWhiteTurn) {
      chessBoard.setPiece(0, 4, '');
      chessBoard.setPiece(0, 5, 'r');
      chessBoard.setPiece(0, 6, 'k');
      chessBoard.setPiece(0, 7, '');
      return Pair('white', 'kingCastle');
    } else {
      chessBoard.setPiece(7, 4, '');
      chessBoard.setPiece(7, 5, 'R');
      chessBoard.setPiece(7, 6, 'K');
      chessBoard.setPiece(7, 7, '');
      return Pair('black', 'kingCastle');
    }
  }

  Pair<String, String> _makeQueenSideCastle() {
    if (isWhiteTurn) {
      chessBoard.setPiece(0, 4, '');
      chessBoard.setPiece(0, 3, 'r');
      chessBoard.setPiece(0, 2, 'k');
      chessBoard.setPiece(0, 0, '');
      return Pair('white', 'queenCastle');
    } else {
      chessBoard.setPiece(7, 4, '');
      chessBoard.setPiece(7, 3, 'R');
      chessBoard.setPiece(7, 2, 'K');
      chessBoard.setPiece(7, 0, '');
      return Pair('black', 'queenCastle');
    }
  }

  void applyPreviousMove(Pair<String,String> move){
    List moves = move.toList;
    if(moves[1] == 'kingCastle'){
      if(moves[0] == 'white'){
        chessBoard.setPiece(0, 4, 'k');
        chessBoard.setPiece(0, 5, '');
        chessBoard.setPiece(0, 6, '');
        chessBoard.setPiece(0, 7, 'r');
      } else {
        chessBoard.setPiece(7, 4, 'K');
        chessBoard.setPiece(7, 5, '');
        chessBoard.setPiece(7, 6, '');
        chessBoard.setPiece(7, 7, 'R');
      }
    } else if(moves[1] == 'queenCastle'){
      if(moves[0] == 'white'){
        chessBoard.setPiece(0, 4, 'k');
        chessBoard.setPiece(0, 3, '');
        chessBoard.setPiece(0, 2, '');
        chessBoard.setPiece(0, 0, 'r');
      } else {
        chessBoard.setPiece(7, 4, 'K');
        chessBoard.setPiece(7, 3, '');
        chessBoard.setPiece(7, 2, '');
        chessBoard.setPiece(7, 0, 'R');
      }
    } else {

      final fromRow = int.parse(moves[0][0]);
      final fromCol = int.parse(moves[0][1]);
      final toRow = int.parse(moves[1][0]);
      final toCol = int.parse(moves[1][1]);

      final piece = chessBoard.getPiece(toRow, toCol);
      chessBoard.setPiece(toRow, toCol, '');
      chessBoard.setPiece(fromRow, fromCol, piece);
    }
  }
}


