import 'package:flutter/material.dart';
import 'package:notekeeping/core/core.dart';
import 'package:notekeeping/page/note_handling.dart';
import 'package:notekeeping/service/note_provider.dart';
import 'package:provider/provider.dart';

class HomeNoteListPage extends StatefulWidget {
  const HomeNoteListPage({super.key});

  @override
  State<HomeNoteListPage> createState() => _NoteListState();
}

class _NoteListState extends State<HomeNoteListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Consumer<Noteprovider>(
        builder: (BuildContext context, notevalueprovider, Widget? _) {
          if (notevalueprovider.isLoading) {
            return const CircularProgressIndicator();
          } else if (notevalueprovider.isNotData) {
            return const Center(child: Text('You have not any note',
               style: TextStyle(fontWeight: FontWeight.w500),
            ));
          } else {
            return ListView.builder(
              itemCount: notevalueprovider.noteListFuture?.length ?? 1,
              itemBuilder: (BuildContext context, int index) {
                final noteData = notevalueprovider.noteListFuture?[index];
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
                                  noteData?.title.firstletterCapital(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  noteData?.description.firstletterCapital(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  noteData?.formattedDate ?? "",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await notevalueprovider
                                .deleteNote(noteData?.id as int);
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
                                builder: (context) => NoteHandling(
                                  note: noteData,
                                ),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteHandling(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
