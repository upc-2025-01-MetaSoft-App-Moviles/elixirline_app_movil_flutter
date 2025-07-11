
import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/fermentation_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/fermentation_pages/fermentation_create_and_edit_page.dart';
import 'package:flutter/material.dart';

class FermentationDetailsPage extends StatefulWidget {
  final FermentationStageDto fermentationDto;
  final String batchId;

  const FermentationDetailsPage({
    super.key, 
    required this.fermentationDto,
    required this.batchId,
  });

  @override
  State<FermentationDetailsPage> createState() => _FermentationDetailsPageState();
}

class _FermentationDetailsPageState extends State<FermentationDetailsPage> {
  late FermentationStageDto _fermentationDto;

  @override
  void initState() {
    super.initState();
    _fermentationDto = widget.fermentationDto;
  }

  Future<void> _navigateToEditFermentation() async {
    final result = await Navigator.push<FermentationStageDto>(
      context,
      MaterialPageRoute(
        builder: (context) => FermentationCreateAndEditPage(
          batchId: widget.batchId,
          initialData: _fermentationDto,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _fermentationDto = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Etapa de fermentación actualizada correctamente'),
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
            'Detalles de Fermentación',
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
                                    Icons.science,
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
                                        'Etapa de Fermentación',
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
                                          color: _fermentationDto.isCompleted
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.orange.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          _fermentationDto.isCompleted
                                              ? 'Completada'
                                              : 'En Proceso',
                                          style: TextStyle(
                                            color: _fermentationDto.isCompleted
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
                            onPressed: _navigateToEditFermentation,
                            icon: Icon(
                              Icons.edit,
                              color: ColorPalette.vinoTinto,
                              size: 24,
                            ),
                            tooltip: 'Editar fermentación',
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
                        _formatDate(_fermentationDto.startedAt),
                        Icons.calendar_today,
                      ),
                      if (_fermentationDto.completedAt.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'Fecha de Finalización',
                          _formatDate(_fermentationDto.completedAt),
                          Icons.calendar_month,
                        ),
                      ],
                      if (_fermentationDto.completedBy.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'Responsable',
                          _fermentationDto.completedBy,
                          Icons.person,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card de Tanque y Tipo
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
                            'Tanque y Tipo de Fermentación',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_fermentationDto.tankCode.isNotEmpty)
                        _buildInfoRow(
                          'Código de Tanque',
                          _fermentationDto.tankCode,
                          Icons.storage,
                        ),
                      if (_fermentationDto.tankCode.isNotEmpty && _fermentationDto.fermentationType.isNotEmpty)
                        const SizedBox(height: 12),
                      if (_fermentationDto.fermentationType.isNotEmpty)
                        _buildInfoRow(
                          'Tipo de Fermentación',
                          _fermentationDto.fermentationType,
                          Icons.category,
                        ),
                      if (_fermentationDto.yeastUsed.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Levadura Utilizada',
                          _fermentationDto.yeastUsed,
                          Icons.grain,
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
                        '${_fermentationDto.initialSugarLevel.toStringAsFixed(2)} °Brix',
                        Icons.trending_up,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Nivel Final',
                        '${_fermentationDto.finalSugarLevel.toStringAsFixed(2)} °Brix',
                        Icons.trending_down,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card de pH
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
                            Icons.science_outlined,
                            color: Colors.purple.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Niveles de pH',
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
                        _fermentationDto.initialPh.toStringAsFixed(2),
                        Icons.analytics,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'pH Final',
                        _fermentationDto.finalPh.toStringAsFixed(2),
                        Icons.analytics_outlined,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card de Temperatura
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
                            Icons.thermostat,
                            color: Colors.orange.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Control de Temperatura',
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
                        'Temperatura Máxima',
                        '${_fermentationDto.temperatureMax.toStringAsFixed(1)} °C',
                        Icons.keyboard_arrow_up,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Temperatura Mínima',
                        '${_fermentationDto.temperatureMin.toStringAsFixed(1)} °C',
                        Icons.keyboard_arrow_down,
                      ),
                    ],
                  ),
                ),
              ),

              if (_fermentationDto.observations.isNotEmpty) ...[
                const SizedBox(height: 16),

                // Card de Observaciones
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  color: Colors.teal.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.description,
                              color: Colors.teal.shade600,
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
                          _fermentationDto.observations,
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

  
