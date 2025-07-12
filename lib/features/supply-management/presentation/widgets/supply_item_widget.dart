import 'package:flutter/material.dart';
import '../../domain/entities/supply.dart';

class SupplyItemWidget extends StatelessWidget {
  final Supply supply;
  final VoidCallback onEdit;
  final VoidCallback onRegisterUsage;

  const SupplyItemWidget({
    super.key,
    required this.supply,
    required this.onEdit,
    required this.onRegisterUsage,
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
            Text(
              supply.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Fecha: ${supply.expirationDate}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Cantidad: ${supply.quantity} ${supply.unit}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              supply.category,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF8B0000),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(
                    Icons.edit,
                    color: Color(0xFF8B0000),
                  ),
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(
                    Icons.info,
                    color: Color(0xFF8B0000),
                  ),
                ),
                IconButton(
                  onPressed: onRegisterUsage,
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Color(0xFF8B0000),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
