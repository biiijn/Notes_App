import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/db_helper.dart';
import '../model/note.dart';

class SyncService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> syncNotes() async {
    final unsyncedNotes = await DBHelper.getUnsyncedNotes();

    for (var note in unsyncedNotes) {
      try {
        await _firestore.collection('notes').add(note.toFirestoreMap());

        // Mark as synced
        note.isSynced = true;
        await DBHelper.updateNote(note);

        print('✅ Synced: ${note.title}');
      } catch (e) {
        print('❌ Sync failed: $e');
      }
    }
  }
}
