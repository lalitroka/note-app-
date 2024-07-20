import 'package:flutter/material.dart';
import 'package:notekeeping/core/core.dart';
import 'package:notekeeping/core/model.dart';
import 'package:notekeeping/page/note_handling.dart';
import 'package:notekeeping/service/noteprovider.dart';
import 'package:provider/provider.dart';

class HomeNoteList extends StatefulWidget {
  const HomeNoteList({super.key});

  @override
  State<HomeNoteList> createState() => _NoteListState();
}

class _NoteListState extends State<HomeNoteList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Consumer<Noteprovider>(
        builder: (BuildContext context, notevalueprovider, Widget? _) {
          return FutureBuilder<List<Note>>(
            future: notevalueprovider.noteListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No notes available'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final noteData = snapshot.data![index];
                    return Card(
                      elevation: 2,
                      color: Colors.yellow,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.redAccent,
                              child: Icon(Icons.person_2),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/noteread',
                                    arguments: noteData,  
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      noteData.title.firstletterCapital(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      noteData.description.firstletterCapital(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      noteData.formattedDate,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                await  notevalueprovider
                                .deleteNote(noteData.id as int);
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.green,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NoteHandling(note: noteData, ),
                                  ),
                                ).then((_) {
                                    notevalueprovider.refreshNoteList();
                                  });
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteHandling(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
