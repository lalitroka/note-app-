import 'package:flutter/material.dart';
import 'package:notekeeping/core/core.dart';
import 'package:notekeeping/core/model.dart';


class NoteRead extends StatefulWidget {
  const NoteRead({super.key});

  @override
  State<NoteRead> createState() => _NotestoreState();
}

class _NotestoreState extends State<NoteRead> {
  @override
  Widget build(BuildContext context) {
    final Note argumentNoteData =
        ModalRoute.of(context)?.settings.arguments as Note;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Happy Reading',
          style: TextStyle(
            fontFamily: 'fraktur'
          ),),
        ),
        actions: [
          InkWell(
              onTap: () {},
              child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.greenAccent,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 2,
                        color: const Color.fromARGB(255, 173, 194, 230)
                            .withOpacity(0.5),
                      )
                    ],
                  ),
                  child: const Icon(Icons.more_vert_rounded))),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Flexible(
        child: Column(
          children: [
            Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                              argumentNoteData.title.firstletterCapital(),
                              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                )),
            Divider(
              height: 15,
              endIndent: 15,
              indent: 15,
              thickness: 5,
              color: Colors.teal[50],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                argumentNoteData.description.firstletterCapital(),
                style: const TextStyle(fontSize: 20, fontFamily: 'sans-serif'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
