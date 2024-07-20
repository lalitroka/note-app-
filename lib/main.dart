import 'package:flutter/material.dart';
import 'package:notekeeping/page/home_note_list.dart';
import 'package:notekeeping/page/note_handling.dart';
import 'package:notekeeping/page/note_read.dart';
import 'package:notekeeping/service/noteprovider.dart';
import 'package:provider/provider.dart';
// import 'package:notekeeping/service/note_database.dart';


//   //  WidgetsFlutterBinding.ensureInitialized();
//   // final noteDatabase = NoteDatabase();
//   // await noteDatabase.deleteDatabaseFile(); 
//   // await noteDatabase.initDatabase(); 
// 
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Noteprovider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
   
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeNoteList(),                                         
          '/notehandling': (context) => const NoteHandling(),
          '/noteread': (context) => const NoteRead(),
        },
    );
  }
}


