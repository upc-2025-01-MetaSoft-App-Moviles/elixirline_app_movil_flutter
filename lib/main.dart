import 'package:flutter/material.dart';
import 'features/fieldworkers_management/presentation/screens/worker_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ElixirLine Móvil',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const WorkerListScreen(), // ← esta es la clave
    );
  }
}
