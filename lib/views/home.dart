import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../model/note.dart';
import 'add_edit.dart';
import '../service/sync_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await DBHelper.getNotes();
    setState(() {
      _notes = notes;
    });
    await SyncService.syncNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D0D0D), // Dark background
      appBar: AppBar(
        backgroundColor: Color(0xFF1F1F1F),
        elevation: 0,
        centerTitle: false,
        title: Text(
          '📝 My Notes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add search functionality here
            },
          ),
          SizedBox(width: 6),
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () async {
              await SyncService.syncNotes();
              _loadNotes();
            },
          ),
        ],
      ),
      body: _notes.isEmpty
          ? Center(
        child: Text(
          'No notes yet!',
          style: TextStyle(color: Colors.white70),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return Card(
            color: Color(0xFF1A1A1A),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding:
              EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Text(
                note.title,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                note.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white70),
              ),
              trailing: Icon(
                note.isSynced
                    ? Icons.cloud_done_rounded
                    : Icons.cloud_off_rounded,
                color: note.isSynced ? Colors.green : Colors.red,
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditScreen(note: note),
                  ),
                );
                _loadNotes();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEditScreen()),
          );
          _loadNotes();
        },
      ),
    );
  }
}
