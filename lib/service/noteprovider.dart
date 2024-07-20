import 'package:flutter/material.dart';
import 'package:notekeeping/core/model.dart';
import 'package:notekeeping/service/note_database.dart';

class Noteprovider extends ChangeNotifier {
  final NoteDatabase noteDatabase = NoteDatabase();
  late Future<List<Note>> noteListFuture;

  Noteprovider() {
    refreshNoteList();
  }

  void refreshNoteList() {
    noteListFuture = noteDatabase.getNote();
    notifyListeners();
  }

  Future<void> deleteNote(int id) async {
    await noteDatabase.deleteNote(id);
    refreshNoteList();
  }
    
}
