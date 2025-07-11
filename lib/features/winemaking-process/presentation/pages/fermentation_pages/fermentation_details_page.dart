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
          wineBatchId: widget.batchId,
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
      
      if (dateString.contains('T')) {
        date = DateTime.parse(dateString);
      } else if (dateString.contains('/')) {
        final parts = dateString.split('/');
        if (parts.length == 3) {
          date = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        } else {
          return dateString;
        }
      } else {
        return dateString;
      }

      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildInfoItem(IconData icon, String label, String? value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            label.contains('Fecha') ? _formatDate(value) : (value ?? 'No especificado'),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value, {String? unit}) {
    String displayValue = 'No especificado';
    if (value != null) {
      if (value is double && value > 0) {
        displayValue = '${value.toStringAsFixed(1)}${unit ?? ''}';
      } else if (value is int && value > 0) {
        displayValue = '$value${unit ?? ''}';
      } else if (value is String && value.isNotEmpty) {
        displayValue = value;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              displayValue,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
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
            onPressed: () => Navigator.of(context).pop(_fermentationDto),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ColorPalette.vinoTinto.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.bubble_chart,
                              color: ColorPalette.vinoTinto,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Información de Fermentación',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: ColorPalette.vinoTinto,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _fermentationDto.isCompleted 
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _fermentationDto.isCompleted 
                                          ? Colors.green.withOpacity(0.3)
                                          : Colors.orange.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    _fermentationDto.isCompleted ? 'Completado' : 'En progreso',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _fermentationDto.isCompleted 
                                          ? Colors.green.shade700 
                                          : Colors.orange.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: ColorPalette.vinoTinto.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              color: ColorPalette.vinoTinto,
                              onPressed: _navigateToEditFermentation,
                              tooltip: 'Editar fermentación',
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Grid de información general
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoItem(
                                  Icons.calendar_today_outlined,
                                  'Fecha de Inicio',
                                  _fermentationDto.startedAt,
                                  Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInfoItem(
                                  Icons.calendar_month_outlined,
                                  'Fecha de Finalización',
                                  _fermentationDto.completedAt,
                                  Colors.green,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          _buildInfoItem(
                            Icons.person_outline,
                            'Realizado por',
                            _fermentationDto.completedBy,
                            Colors.purple,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Card de parámetros técnicos
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
                      // Header de parámetros técnicos
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ColorPalette.vinoTinto.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.science_outlined,
                              color: ColorPalette.vinoTinto,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Parámetros de Fermentación',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ColorPalette.vinoTinto,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Información de fermentación organizada en dos columnas
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildDetailRow('Tipo de Fermentación', _fermentationDto.fermentationType),
                              ),
                              Expanded(
                                child: _buildDetailRow('Código del Tanque', _fermentationDto.tankCode),
                              ),
                            ],
                          ),
                          _buildDetailRow('Levadura Utilizada', _fermentationDto.yeastUsed),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDetailRow('Temp. Mínima', _fermentationDto.temperatureMin, unit: '°C'),
                              ),
                              Expanded(
                                child: _buildDetailRow('Temp. Máxima', _fermentationDto.temperatureMax, unit: '°C'),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDetailRow('pH Inicial', _fermentationDto.initialPh),
                              ),
                              Expanded(
                                child: _buildDetailRow('pH Final', _fermentationDto.finalPh),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDetailRow('Azúcar Inicial', _fermentationDto.initialSugarLevel, unit: ' Brix'),
                              ),
                              Expanded(
                                child: _buildDetailRow('Azúcar Final', _fermentationDto.finalSugarLevel, unit: ' Brix'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      if (_fermentationDto.observations.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.note_outlined, color: ColorPalette.vinoTinto, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Observaciones',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorPalette.vinoTinto,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _fermentationDto.observations,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
