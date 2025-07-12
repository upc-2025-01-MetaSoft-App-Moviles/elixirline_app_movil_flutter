import 'package:flutter/material.dart';
import '../../domain/entities/parcel.dart';

class ParcelCard extends StatelessWidget {
  final Parcel parcel;
  const ParcelCard({super.key, required this.parcel});

  @override
  Widget build(BuildContext context) {
    const darkRed = Color(0xFF8B0000);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: darkRed, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lote - ${parcel.name}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: 'Variedad: ',
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [TextSpan(text: parcel.cropType)],
              ),
            ),
            Text.rich(
              TextSpan(
                text: 'Etapa: ',
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [TextSpan(text: parcel.growthStage)],
              ),
            ),
            Text.rich(
              TextSpan(
                text: 'Últ. actividad: ',
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [TextSpan(text: parcel.lastTask)],
              ),
            ),
            Text.rich(
              TextSpan(
                text: 'Cantidad estimado: ',
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [TextSpan(text: parcel.yieldEstimate)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
