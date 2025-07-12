// ignore_for_file: unused_import
import 'package:elixirline_app_movil_flutter/core/shared/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'ManagementAgriculturalActivities/presentation/screens/main_screen.dart';
import 'ManagementAgriculturalActivities/presentation/screens/calendar_screen.dart';
import 'ManagementAgriculturalActivities/presentation/screens/new_task_screen.dart';
import 'ManagementAgriculturalActivities/presentation/screens/parcels_screen.dart';
import 'ManagementAgriculturalActivities/presentation/screens/new_parcel_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}