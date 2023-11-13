import 'package:app_tarefas/pages/home_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas',
      theme: ThemeData(
          primaryColor: Colors.purple[50],
          secondaryHeaderColor: Colors.purple[300]),
      home: const MyHomePage(),
    );
  }
}
