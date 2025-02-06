class SeparatedListsService {
  final List<String> words;

  SeparatedListsService({required this.words});

  Map<String, List<String>> getFilteredWords() {
    return _filterWords(words);
  }

  Map<String, List<String>> _filterWords(List<String> words) {
    List<String> whiteToBlack = [];
    List<String> blackAndAfter = [];
    int currentIndex = 0;

    while (currentIndex < words.length) {
      final whiteIndex = words.indexWhere((word) => word.toUpperCase() == 'WHITE', currentIndex);
      final blackIndex = words.indexWhere((word) => word.toUpperCase() == 'BLACK', currentIndex);

      if (whiteIndex == -1 || blackIndex == -1 || whiteIndex >= blackIndex) {
        break;
      }

      whiteToBlack.addAll(words.sublist(whiteIndex + 1, blackIndex));

      final blackAndAfterSublist = words.sublist(blackIndex + 1);
      final endIndex = blackAndAfterSublist.indexWhere((word) => _isNumber(word) || word.toUpperCase() == 'WHITE');

      if (endIndex == -1) {
        blackAndAfter.addAll(blackAndAfterSublist);
        break;
      } else {
        blackAndAfter.addAll(blackAndAfterSublist.sublist(0, endIndex));
        currentIndex = blackIndex + 1 + endIndex;
      }
    }

    return {
      'whiteToBlack': whiteToBlack,
      'blackAndAfter': blackAndAfter,
    };
  }

  bool _isNumber(String word) {
    return int.tryParse(word) != null;
  }
}