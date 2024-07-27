import 'package:flutter/material.dart';
import 'package:notekeeping/core/model.dart';
import 'package:notekeeping/service/note_database.dart';

class Noteprovider extends ChangeNotifier {
  final NoteDatabase noteDatabase = NoteDatabase();
  List<Note>? noteListFuture;
  bool isLoading = false;
  bool isNotData = false;
  Noteprovider() {
    refreshNoteList();
    notifyListeners();
  }
Future<void> refreshNoteList() async {
    isLoading = true;
    isNotData = false;
    notifyListeners();

    try {
      noteListFuture = await noteDatabase.getNote();
      if (noteListFuture == null || noteListFuture!.isEmpty) {
        isNotData = true;
      }
    } catch (e) {
      throw Exception('Loading failed');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteNote(int id) async {
    await noteDatabase.deleteNote(id);
    refreshNoteList();
  }
}
