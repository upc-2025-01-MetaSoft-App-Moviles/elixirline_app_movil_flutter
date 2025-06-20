import 'package:flutter/material.dart';
import '../../domain/entities/wine_batch.dart';

class WineBatchCardWidget extends StatelessWidget {
  final WineBatch batch;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const WineBatchCardWidget({
    super.key,
    required this.batch,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF8B0000)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  batch.internalCode,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'En Progreso',
                  style: const TextStyle(color: Color(0xFFFFA500)),
                ),
                const SizedBox(height: 4),
                Text('Fecha: ${batch.receptionDate}'),
                Text(
                  'Etapa actual: ${batch.currentStage}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text('Tipo de uva: ${batch.grapeVariety}'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: onEdit,
                      child: const Text('Editar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
