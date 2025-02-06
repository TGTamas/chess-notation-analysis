class ChessBoard {
  static const int boardSize = 8;
  List<List<String>> board;

  ChessBoard() : board = List.generate(boardSize, (_) => List.filled(boardSize, '', growable: false), growable: false) {
    _initializeBoard();
  }

  void _initializeBoard() {
    // Initialize pawns
    for (int i = 0; i < boardSize; i++) {
      board[6][i] = 'P'; // BLACK pawns
      board[1][i] = 'p'; // WHITE pawns
    }

    board[5] = List.filled(boardSize, ''); // Empty spaces
    board[4] = List.filled(boardSize, ''); // Empty spaces
    board[3] = List.filled(boardSize, ''); // Empty spaces
    board[2] = List.filled(boardSize, ''); // Empty spaces

    // Initialize other pieces
    board[7] = ['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R']; // BLACK pieces
    board[0] = ['r', 'n', 'b', 'q', 'k', 'b', 'n', 'r']; // WHITE pieces
  }

  String getPiece(int row, int col) {
    return board[row][col];
  }

  void setPiece(int row, int col, String piece) {
    board[row][col] = piece;
  }

  void movePiece(int fromRow, int fromCol, int toRow, int toCol) {
    final piece = getPiece(fromRow, fromCol);
    setPiece(fromRow, fromCol, '');
    setPiece(toRow, toCol, piece);
  }

  List<List<String>> getBoard() {
    return List.generate(boardSize, (row) => List.generate(boardSize, (col) => board[row][col]));
  }

  void reset(){
    _initializeBoard();
  }
}