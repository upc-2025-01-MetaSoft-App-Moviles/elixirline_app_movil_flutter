import 'package:flutter/material.dart';
import 'features/app/presentation/pages/app_wrapper.dart';
import 'core/themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {                    
    return MaterialApp(
      title: 'Elixir Line - Gestión Vitivinícola',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppWrapper(),
    );
  }
}
