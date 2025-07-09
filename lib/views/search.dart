import 'package:flutter/material.dart';
import '../model/note.dart';

class NotesSearchDelegate extends SearchDelegate {
  final List<Note> notes;

  NotesSearchDelegate(this.notes);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // closes the search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = notes.where((note) =>
    note.title.toLowerCase().contains(query.toLowerCase()) ||
        note.content.toLowerCase().contains(query.toLowerCase())
    ).toList();

    if (results.isEmpty) {
      return const Center(child: Text('No results found.'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final note = results[index];
        return ListTile(
          title: Text(note.title),
          subtitle: Text(note.content, maxLines: 1),
          onTap: () {
            close(context, null);
            // optionally navigate to detail screen or edit
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context); // show suggestions as same as result
  }
}
