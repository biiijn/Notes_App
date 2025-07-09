import 'package:flutter/material.dart';
import '../model/note.dart';


class NoteTile extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;

  const NoteTile({super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(note.title),
      subtitle: Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: Icon(
        note.isSynced ? Icons.cloud_done : Icons.cloud_off,
        color: note.isSynced ? Colors.green : Colors.red,
      ),
      onTap: onTap,
    );
  }
}
