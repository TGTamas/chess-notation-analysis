import 'package:flutter/material.dart';
import '../services/separated_lists_service.dart';

class TextListScreen extends StatelessWidget {
  final List<String> recognizedWords;

  const TextListScreen({super.key, required this.recognizedWords});

  @override
  Widget build(BuildContext context) {
    final separatedListsWidget = SeparatedListsService(words: recognizedWords);
    final filteredWords = separatedListsWidget.getFilteredWords();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Text List'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'WHITE',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredWords['whiteToBlack']!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredWords['whiteToBlack']![index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'BLACK',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredWords['blackAndAfter']!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredWords['blackAndAfter']![index]),
                      );
                    },
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