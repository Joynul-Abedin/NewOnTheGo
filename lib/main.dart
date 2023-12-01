import 'package:flutter/material.dart';

import 'Views/NewsList.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Remove the debug banner
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: const Text('NewsOnTheGo', style: TextStyle(color: Colors.white),),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.black,
            child: const NewsList()),
      ),
    );
  }
}
