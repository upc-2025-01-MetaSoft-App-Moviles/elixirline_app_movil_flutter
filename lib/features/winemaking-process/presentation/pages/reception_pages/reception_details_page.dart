import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/reception_stage_dto.dart';
import 'package:flutter/material.dart';

class ReceptionDetailsPage extends StatefulWidget {
  final ReceptionStageDto receptionDto;

  const ReceptionDetailsPage({super.key, required this.receptionDto});

  @override
  State<ReceptionDetailsPage> createState() => _ReceptionDetailsPageState();
}

class _ReceptionDetailsPageState extends State<ReceptionDetailsPage> {
  late ReceptionStageDto _receptionDto;

  @override
  void initState() {
    super.initState();
    _receptionDto = widget.receptionDto;
  }

  Future<void> _navigateToEditReception() async {
    // Navegación a edición
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalles de Recepción'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _navigateToEditReception,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información de Recepción',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.calendar_today, 'Fecha de Inicio', _receptionDto.startedAt),
                  _buildDetailRow(Icons.calendar_month, 'Fecha de Finalización', _receptionDto.completedAt),
                  _buildDetailRow(Icons.person, 'Realizado por', _receptionDto.completedBy),
                  _buildDetailRow(
                    _receptionDto.isCompleted ? Icons.check_circle : Icons.cancel,
                    '¿Completado?',
                    _receptionDto.isCompleted ? "Sí" : "No",
                  ),
                  const Divider(height: 32),
                  Text(
                    'Parámetros Técnicos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.opacity, 'Nivel de Azúcar', '${_receptionDto.sugarLevel} g/L'),
                  _buildDetailRow(Icons.science, 'pH', _receptionDto.pH.toString()),
                  _buildDetailRow(Icons.thermostat, 'Temperatura', '${_receptionDto.temperature} °C'),
                  _buildDetailRow(Icons.scale, 'Cantidad', '${_receptionDto.quantityKg} Kg'),
                  _buildDetailRow(Icons.comment, 'Observaciones', _receptionDto.observations ?? "N/A"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.teal),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
