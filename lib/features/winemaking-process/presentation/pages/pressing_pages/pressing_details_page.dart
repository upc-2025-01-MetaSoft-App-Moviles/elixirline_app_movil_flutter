import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/pressing_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/pressing_pages/pressing_create_and_edit_page.dart';
import 'package:flutter/material.dart';

class PressingDetailsPage extends StatefulWidget {
  final PressingStageDto pressingDto;
  final String batchId;

  const PressingDetailsPage({
    super.key, 
    required this.pressingDto,
    required this.batchId,
  });

  @override
  State<PressingDetailsPage> createState() => _PressingDetailsPageState();
}

class _PressingDetailsPageState extends State<PressingDetailsPage> {
  late PressingStageDto _pressingDto;

  @override
  void initState() {
    super.initState();
    _pressingDto = widget.pressingDto;
  }

  Future<void> _navigateToEditPressing() async {
    final result = await Navigator.push<PressingStageDto>(
      context,
      MaterialPageRoute(
        builder: (_) => PressingCreateAndEditPage(
          batchId: widget.batchId,
          initialData: _pressingDto,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _pressingDto = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Etapa de prensado actualizada correctamente'),
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
      } else if (value is bool) {
        displayValue = value ? 'Sí' : 'No';
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              displayValue,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
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
            'Detalles de Prensado',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(_pressingDto),
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
                                    Icons.compress,
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
                                        'Información de Prensado',
                                        style: TextStyle(
                                          fontSize: 20,
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
                                          color: _pressingDto.isCompleted 
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.orange.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: _pressingDto.isCompleted 
                                                ? Colors.green.withOpacity(0.3)
                                                : Colors.orange.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          _pressingDto.isCompleted ? 'Completado' : 'En progreso',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: _pressingDto.isCompleted 
                                                ? Colors.green.shade700 
                                                : Colors.orange.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: ColorPalette.vinoTinto.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              color: ColorPalette.vinoTinto,
                              onPressed: _navigateToEditPressing,
                              tooltip: 'Editar prensado',
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Grid de información general
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(
                              Icons.calendar_today_outlined,
                              'Fecha de Inicio',
                              _pressingDto.startedAt,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInfoItem(
                              Icons.calendar_month_outlined,
                              'Fecha de Finalización',
                              _pressingDto.completedAt,
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildInfoItem(
                        Icons.person_outline,
                        'Realizado por',
                        _pressingDto.completedBy,
                        Colors.purple,
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
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Parámetros de Prensado',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ColorPalette.vinoTinto,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      _buildDetailRow('Tipo de Prensa', _pressingDto.pressType),
                      _buildDetailRow('Presión de Prensa', _pressingDto.pressPressureBars, unit: ' bar'),
                      _buildDetailRow('Duración', _pressingDto.durationMinutes, unit: ' minutos'),
                      _buildDetailRow('Orujo Obtenido', _pressingDto.pomaceKg, unit: ' kg'),
                      _buildDetailRow('Rendimiento', _pressingDto.yieldLiters, unit: ' litros'),
                      _buildDetailRow('Uso del Mosto', _pressingDto.mustUsage),
                      
                      if (_pressingDto.observations.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.note_outlined, color: ColorPalette.vinoTinto, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Observaciones',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorPalette.vinoTinto,
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
                            _pressingDto.observations,
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
