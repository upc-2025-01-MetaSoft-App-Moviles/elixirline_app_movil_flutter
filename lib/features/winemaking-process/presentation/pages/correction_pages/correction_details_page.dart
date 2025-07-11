
import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/correction_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/correction_pages/correction_create_and_edit_page.dart';
import 'package:flutter/material.dart';

class CorrectionDetailsPage extends StatefulWidget {
  final CorrectionStageDto correctionDto;
  final String batchId;

  const CorrectionDetailsPage({
    super.key, 
    required this.correctionDto,
    required this.batchId,
  });

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
    final result = await Navigator.push<CorrectionStageDto>(
      context,
      MaterialPageRoute(
        builder: (_) => CorrectionCreateAndEditPage(
          batchId: widget.batchId,
          initialData: _correctionDto,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _correctionDto = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Etapa de corrección actualizada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'No especificado';
    }

    try {
      DateTime date;
      
      // Try parsing as ISO format first
      if (dateString.contains('T')) {
        date = DateTime.parse(dateString);
      } else if (dateString.contains('/')) {
        // Try parsing as dd/MM/yyyy format
        final parts = dateString.split('/');
        if (parts.length == 3) {
          date = DateTime(
            int.parse(parts[2]), // year
            int.parse(parts[1]), // month
            int.parse(parts[0]), // day
          );
        } else {
          return dateString; // Return as-is if can't parse
        }
      } else {
        return dateString; // Return as-is if format is unknown
      }

      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPalette.vinoTinto,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Text(
            'Detalles de Corrección',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Volver',
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Card principal con información general
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                shadowColor: ColorPalette.vinoTinto.withOpacity(0.2),
                color: Colors.grey.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header con ícono, título y botón de editar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: ColorPalette.vinoTinto.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.tune,
                                    color: ColorPalette.vinoTinto,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Etapa de Corrección',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _correctionDto.isCompleted
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.orange.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          _correctionDto.isCompleted
                                              ? 'Completada'
                                              : 'En Proceso',
                                          style: TextStyle(
                                            color: _correctionDto.isCompleted
                                                ? Colors.green.shade700
                                                : Colors.orange.shade700,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: _navigateToEditCorrection,
                            icon: Icon(
                              Icons.edit,
                              color: ColorPalette.vinoTinto,
                              size: 24,
                            ),
                            tooltip: 'Editar corrección',
                            style: IconButton.styleFrom(
                              backgroundColor: ColorPalette.vinoTinto.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Información básica
                      _buildInfoRow(
                        'Fecha de Inicio',
                        _formatDate(_correctionDto.startedAt),
                        Icons.calendar_today,
                      ),
                      if (_correctionDto.completedBy.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'Responsable',
                          _correctionDto.completedBy,
                          Icons.person,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card de Niveles de Azúcar
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_drink,
                            color: Colors.blue.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Niveles de Azúcar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        'Nivel Inicial',
                        '${_correctionDto.initialSugarLevel.toStringAsFixed(2)} °Brix',
                        Icons.trending_up,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Nivel Final',
                        '${_correctionDto.finalSugarLevel.toStringAsFixed(2)} °Brix',
                        Icons.trending_down,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Azúcar Añadido',
                        '${_correctionDto.addedSugarKg.toStringAsFixed(2)} kg',
                        Icons.add_circle_outline,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card de pH y Acidez
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.science,
                            color: Colors.green.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'pH y Acidez',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        'pH Inicial',
                        _correctionDto.initialPh.toStringAsFixed(2),
                        Icons.analytics,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'pH Final',
                        _correctionDto.finalPh.toStringAsFixed(2),
                        Icons.analytics,
                      ),
                      if (_correctionDto.acidType.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Tipo de Ácido',
                          _correctionDto.acidType,
                          Icons.category,
                        ),
                      ],
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Ácido Añadido',
                        '${_correctionDto.acidAddedGl.toStringAsFixed(2)} g/L',
                        Icons.add,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card de SO2
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.bubble_chart,
                            color: Colors.amber.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Dióxido de Azufre (SO₂)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        'SO₂ Añadido',
                        '${_correctionDto.so2AddedMgL.toStringAsFixed(2)} mg/L',
                        Icons.add_circle,
                      ),
                    ],
                  ),
                ),
              ),

              if (_correctionDto.justification.isNotEmpty ||
                  _correctionDto.observations.isNotEmpty) ...[
                const SizedBox(height: 16),

                // Card de Justificación y Observaciones
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  color: Colors.purple.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.description,
                              color: Colors.purple.shade600,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Detalles Adicionales',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (_correctionDto.justification.isNotEmpty) ...[
                          _buildTextSection(
                            'Justificación',
                            _correctionDto.justification,
                            Icons.assignment,
                          ),
                          if (_correctionDto.observations.isNotEmpty)
                            const SizedBox(height: 16),
                        ],
                        if (_correctionDto.observations.isNotEmpty)
                          _buildTextSection(
                            'Observaciones',
                            _correctionDto.observations,
                            Icons.note,
                          ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextSection(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
