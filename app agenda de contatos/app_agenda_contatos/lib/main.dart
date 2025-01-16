import 'package:app_agenda_contatos/pages/Cadrastro/Cadrastro.dart';
import 'package:app_agenda_contatos/pages/Home/HomePage.dart';
import 'package:flutter/material.dart';

import "package:path/path.dart";
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const HomePage(),
      initialRoute: "/",
       routes: {
        '/home': (context) => HomePage(),
        '/cadrastro': (context) => CadrastroPage(),
      },
      debugShowCheckedModeBanner:false,

    );
  }
}