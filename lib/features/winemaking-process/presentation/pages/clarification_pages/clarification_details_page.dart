import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/clarification_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/clarification_pages/clarification_create_and_edit_page.dart';
import 'package:flutter/material.dart';

class ClarificationDetailsPage extends StatefulWidget {
  final ClarificationStageDto clarificationDto;
  final String batchId;

  const ClarificationDetailsPage({
    super.key, 
    required this.clarificationDto,
    required this.batchId,
  });

  @override
  State<ClarificationDetailsPage> createState() => _ClarificationDetailsPageState();
}

class _ClarificationDetailsPageState extends State<ClarificationDetailsPage> {
  late ClarificationStageDto _clarificationDto;

  @override
  void initState() {
    super.initState();
    _clarificationDto = widget.clarificationDto;
  }

  Future<void> _navigateToEditClarification() async {
    final result = await Navigator.push<ClarificationStageDto>(
      context,
      MaterialPageRoute(
        builder: (_) => ClarificationCreateAndEditPage(
          batchId: widget.batchId,
          initialData: _clarificationDto,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _clarificationDto = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Etapa de clarificación actualizada correctamente'),
          backgroundColor: Colors.green,
        ),
      );

      // Retornar el resultado actualizado al wine_batch_detail_page para que recargue los datos
      if (mounted) {
        Navigator.of(context).pop(result);
      }
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
            'Detalles de Clarificación',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(_clarificationDto),
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
                                    Icons.cleaning_services,
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
                                        'Etapa de Clarificación',
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
                                          color: _clarificationDto.isCompleted
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.orange.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          _clarificationDto.isCompleted
                                              ? 'Completada'
                                              : 'En Proceso',
                                          style: TextStyle(
                                            color: _clarificationDto.isCompleted
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
                            onPressed: _navigateToEditClarification,
                            icon: Icon(
                              Icons.edit,
                              color: ColorPalette.vinoTinto,
                              size: 24,
                            ),
                            tooltip: 'Editar clarificación',
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
                        _formatDate(_clarificationDto.startedAt),
                        Icons.calendar_today,
                      ),
                      if (_clarificationDto.completedAt.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'Fecha de Finalización',
                          _formatDate(_clarificationDto.completedAt),
                          Icons.calendar_month,
                        ),
                      ],
                      if (_clarificationDto.completedBy.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'Responsable',
                          _clarificationDto.completedBy,
                          Icons.person,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card de Método y Duración
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
                            Icons.settings,
                            color: Colors.blue.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Método y Configuración',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_clarificationDto.method.isNotEmpty)
                        _buildInfoRow(
                          'Método de Clarificación',
                          _clarificationDto.method,
                          Icons.science,
                        ),
                      if (_clarificationDto.method.isNotEmpty && _clarificationDto.durationHours > 0)
                        const SizedBox(height: 12),
                      if (_clarificationDto.durationHours > 0)
                        _buildInfoRow(
                          'Duración',
                          '${_clarificationDto.durationHours} horas',
                          Icons.timer,
                        ),
                      if (_clarificationDto.temperature > 0) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Temperatura',
                          '${_clarificationDto.temperature.toStringAsFixed(1)} °C',
                          Icons.thermostat,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card de Turbidez
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
                            Icons.opacity,
                            color: Colors.green.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Medición de Turbidez',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_clarificationDto.initialTurbidityNtu > 0)
                        _buildInfoRow(
                          'Turbidez Inicial',
                          '${_clarificationDto.initialTurbidityNtu.toStringAsFixed(2)} NTU',
                          Icons.trending_up,
                        ),
                      if (_clarificationDto.initialTurbidityNtu > 0 && _clarificationDto.finalTurbidityNtu > 0)
                        const SizedBox(height: 12),
                      if (_clarificationDto.finalTurbidityNtu > 0)
                        _buildInfoRow(
                          'Turbidez Final',
                          '${_clarificationDto.finalTurbidityNtu.toStringAsFixed(2)} NTU',
                          Icons.trending_down,
                        ),
                      if (_clarificationDto.initialTurbidityNtu > 0 && _clarificationDto.finalTurbidityNtu > 0) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Reducción de Turbidez',
                          '${((_clarificationDto.initialTurbidityNtu - _clarificationDto.finalTurbidityNtu) / _clarificationDto.initialTurbidityNtu * 100).toStringAsFixed(1)}%',
                          Icons.trending_down_outlined,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card de Volumen
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
                            Icons.local_drink,
                            color: Colors.purple.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Volumen de Vino',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_clarificationDto.wineVolumeLitres > 0)
                        _buildInfoRow(
                          'Volumen Procesado',
                          '${_clarificationDto.wineVolumeLitres.toStringAsFixed(2)} L',
                          Icons.local_bar,
                        ),
                    ],
                  ),
                ),
              ),

              if (_clarificationDto.observations.isNotEmpty) ...[
                const SizedBox(height: 16),

                // Card de Observaciones
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  color: Colors.orange.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.description,
                              color: Colors.orange.shade600,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Observaciones',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTextSection(
                          'Observaciones',
                          _clarificationDto.observations,
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
