import 'package:app_tarefas/pages/home_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas',
      theme: ThemeData(
          primaryColor: Colors.grey[700],
          secondaryHeaderColor: Colors.deepPurple[700]),
      home: const MyHomePage(),
    );
  }
}
