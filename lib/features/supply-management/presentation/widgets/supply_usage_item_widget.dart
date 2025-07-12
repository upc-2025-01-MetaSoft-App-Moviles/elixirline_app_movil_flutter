import 'package:flutter/material.dart';
import '../blocs/supply_usage/supply_usage_bloc.dart';

class SupplyUsageItemWidget extends StatelessWidget {
  final SupplyUsageWithDetails usageWithDetails;

  const SupplyUsageItemWidget({
    super.key,
    required this.usageWithDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    usageWithDetails.supplyName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Text(
                  usageWithDetails.usage.date,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Actividad: ${usageWithDetails.usage.activity}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Cantidad: ${usageWithDetails.usage.quantity} ${usageWithDetails.supplyUnit}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Categoría: ${usageWithDetails.supplyCategory}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF8B0000),
              ),
            ),
            if (usageWithDetails.usage.operatorName.isNotEmpty) ...[
              const SizedBox(height: 4),
              const Divider(),
              const SizedBox(height: 4),
              Text(
                'Operario: ${usageWithDetails.usage.operatorName}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              'Lote: ${usageWithDetails.usage.batchId}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
