import 'package:flutter/material.dart';
import '../../domain/entities/wine_batch.dart';

class WineBatchDetailCardWidget extends StatelessWidget {
  final WineBatch batch;

  const WineBatchDetailCardWidget({
    super.key,
    required this.batch,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.grey, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (batch.urlImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  batch.urlImage!,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),
            _InfoRow(label: 'Creado por:', value: batch.createdBy),
            _InfoRow(label: 'Código Interno:', value: batch.internalCode),
            _InfoRow(label: 'Campaña de Cosecha:', value: batch.harvestCampaign),
            _InfoRow(label: 'Viñedo de Origen:', value: batch.vineyardOrigin),
            _InfoRow(label: 'Variedad de Uva:', value: batch.grapeVariety),
            _InfoRow(
              label: 'Cantidad Inicial de Uva (kg):',
              value: batch.initialGrapeQuantityKg.toString(),
            ),
            _InfoRow(label: 'Estado:', value: batch.status),
            _InfoRow(label: 'Etapa Actual:', value: batch.currentStage),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
