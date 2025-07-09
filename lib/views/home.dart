import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../model/note.dart';
import '../service/sync_service.dart';
import '../widgets/note_tile.dart';
import 'add_edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notes = [];

  Future<void> _loadNotes() async {
    final notes = await DBHelper.getNotes();
    setState(() => _notes = notes);
  }

  @override
  void initState() {
    super.initState();
    SyncService.syncNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: [
              Text('My Notes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26
              ),),
              Spacer(),
              Container(
                height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(onPressed: () {}, icon: Icon(Icons.search_outlined))),
              SizedBox(width: 10),
              Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(onPressed: () {}, icon: Icon(Icons.info_outline_rounded))),
            ],
          ),

      ),
      body: _notes.isEmpty
          ? const Center(child: Text('No notes yet.'))
          : ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) => NoteTile(
          note: _notes[index],
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddEditScreen(note: _notes[index]),
              ),
            );
            _loadNotes();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditScreen()),
          );
          _loadNotes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}