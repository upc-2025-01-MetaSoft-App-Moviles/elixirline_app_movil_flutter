
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/correction_stage_dto.dart';
import 'package:flutter/material.dart';


class CorrectionDetailsPage extends StatefulWidget {
  final CorrectionStageDto correctionDto;

  const CorrectionDetailsPage({super.key, required this.correctionDto});

  @override
  State<CorrectionDetailsPage> createState() => _CorrectionDetailsPageState();
}

class _CorrectionDetailsPageState extends State<CorrectionDetailsPage> {
  late CorrectionStageDto _correctionDto;

  @override
  void initState() {
    super.initState();
    _correctionDto = widget.correctionDto;
  }

  Future<void> _navigateToEditCorrection() async {
    // Navegación a edición
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalles de Corrección'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _navigateToEditCorrection,
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
                    'Información General',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.calendar_today, 'Fecha de Inicio', _correctionDto.startedAt),
                  _buildDetailRow(Icons.calendar_month, 'Fecha de Finalización', _correctionDto.completedAt ?? "N/A"),
                  _buildDetailRow(Icons.person, 'Realizado por', _correctionDto.completedBy),
                  _buildDetailRow(
                    _correctionDto.isCompleted ? Icons.check_circle : Icons.cancel,
                    '¿Completado?',
                    _correctionDto.isCompleted ? "Sí" : "No",
                  ),
                  _buildDetailRow(Icons.comment, 'Observaciones', _correctionDto.observations ?? "N/A"),
                  const Divider(height: 32),

                  // Detalles de Corrección
                  Text(
                    'Detalles de Corrección',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.opacity, 'Azúcar Inicial', '${_correctionDto.initialSugarLevel} g/L'),
                  _buildDetailRow(Icons.opacity, 'Azúcar Final', '${_correctionDto.finalSugarLevel} g/L'),
                  _buildDetailRow(Icons.local_cafe, 'Azúcar Añadida', '${_correctionDto.addedSugarKg} Kg'),

                  _buildDetailRow(Icons.science, 'pH Inicial', '${_correctionDto.initialPh}'),
                  _buildDetailRow(Icons.science_outlined, 'pH Final', '${_correctionDto.finalPh}'),

                  _buildDetailRow(Icons.bubble_chart, 'Tipo de Ácido', _correctionDto.acidType),
                  _buildDetailRow(Icons.add_circle_outline, 'Ácido Añadido', '${_correctionDto.acidAddedGl} g/L'),

                  _buildDetailRow(Icons.bolt, 'SO₂ Añadido', '${_correctionDto.so2AddedMgL} mg/L'),
                  _buildDetailRow(Icons.notes, 'Justificación', _correctionDto.justification),
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
