

import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/wine_batch_dto.dart';
import 'package:flutter/material.dart';

class WineBatchesPage extends StatefulWidget {
  const WineBatchesPage({super.key});

  @override
  State<WineBatchesPage> createState() => _WineBatchesPageState();
}

class _WineBatchesPageState extends State<WineBatchesPage> {
  
  // Lista de lotes de vino
  List<WineBatchDTO> wineBatches = [];

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }


}