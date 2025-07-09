import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/presentation/viewmodels/worker_viewmodel.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/presentation/viewmodels/worker_task_viewmodel.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/presentation/screens/worker_list_screen.dart';

void main() {
  runApp(const ElixirLineApp());
}

class ElixirLineApp extends StatelessWidget {
  const ElixirLineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkerViewModel()),
        ChangeNotifierProvider(create: (_) => WorkerTaskViewModel()),
      ],
      child: MaterialApp(
        title: 'ElixirLine Gestión de Trabajadores',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
        ),
        home: const WorkerListScreen(),
      ),
    );
  }
}
