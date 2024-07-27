import 'package:flutter/material.dart';
import 'package:notekeeping/core/model.dart';
import 'package:notekeeping/service/note_database.dart';
import 'package:notekeeping/service/note_provider.dart';
import 'dart:developer';

import 'package:provider/provider.dart';

class NoteHandling extends StatefulWidget {
  final Note? note;

  const NoteHandling({
    super.key,
    this.note,
  });

  @override
  State<NoteHandling> createState() => _NoteCustomizeState();
}

class _NoteCustomizeState extends State<NoteHandling> {
  final NoteDatabase _noteDatabase = NoteDatabase();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      descriptionController.text = widget.note!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, 
      appBar: AppBar(
       title: Text(widget.note == null ? 'Create Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: titleController,
                  onChanged: (value) {
                    log('Something changed in title');
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  height: 200,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.top,
                    expands: true,
                    controller: descriptionController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      log('Something changed in description');
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your description here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                ElevatedButton(
                  onPressed: () async {
                    String title = titleController.text;
                    String description = descriptionController.text;
          
                    if (title.isNotEmpty && description.isNotEmpty) {
                      try {
                        if (widget.note != null) {
                          await _noteDatabase.updateNote(
                            Note(
                              id: widget.note!.id,
                              title: title,
                              description: description,
                              timestamp: DateTime.now().millisecondsSinceEpoch,
                            ),
                          );
                        } else {
                          await _noteDatabase.insertNote(
                            Note(
                              title: title,
                              description: description,
                              timestamp: DateTime.now().millisecondsSinceEpoch,
                            ),
                          );
                          // ignore: use_build_context_synchronously
                          Provider.of<Noteprovider>(context, listen: false)
                              .refreshNoteList();
                        }
          
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Note saved successfully')),
                        );
          
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context, true);
                      } catch (e) {
                        log('Error saving note: $e');
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error saving note: $e')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter your information')),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Exit'),
                ),
              ]),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
