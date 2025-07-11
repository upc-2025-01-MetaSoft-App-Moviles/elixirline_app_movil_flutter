import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/bottling_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/bottling_pages/bottling_create_and_edit_page.dart';
import 'package:flutter/material.dart';

class BottlingDetailsPage extends StatefulWidget {
  final BottlingStageDto bottlingDto;
  final String batchId;

  const BottlingDetailsPage({
    super.key, 
    required this.bottlingDto,
    required this.batchId,
  });

  @override
  State<BottlingDetailsPage> createState() => _BottlingDetailsPageState();
}

class _BottlingDetailsPageState extends State<BottlingDetailsPage> {
  late BottlingStageDto _bottlingDto;

  @override
  void initState() {
    super.initState();
    _bottlingDto = widget.bottlingDto;
  }

  Future<void> _navigateToEditBottling() async {
    final result = await Navigator.push<BottlingStageDto>(
      context,
      MaterialPageRoute(
        builder: (_) => BottlingCreateAndEditPage(
          batchId: widget.batchId,
          initialData: _bottlingDto,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _bottlingDto = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Etapa de embotellado actualizada correctamente'),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPalette.vinoTinto,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Text(
            'Detalles de Embotellado',
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
              // Card principal
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
                                    Icons.wine_bar,
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
                                        'Etapa de Embotellado',
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
                                          color: _bottlingDto.isCompleted
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.orange.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          _bottlingDto.isCompleted
                                              ? 'Completada'
                                              : 'En Proceso',
                                          style: TextStyle(
                                            color: _bottlingDto.isCompleted
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
                            onPressed: _navigateToEditBottling,
                            icon: Icon(
                              Icons.edit,
                              color: ColorPalette.vinoTinto,
                              size: 24,
                            ),
                            tooltip: 'Editar embotellado',
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
                      _buildInfoRow(
                        'Fecha de Inicio',
                        _formatDate(_bottlingDto.startedAt),
                        Icons.calendar_today,
                      ),
                      if (_bottlingDto.completedAt.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'Fecha de Finalización',
                          _formatDate(_bottlingDto.completedAt),
                          Icons.calendar_month,
                        ),
                      ],
                      if (_bottlingDto.completedBy.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'Responsable',
                          _bottlingDto.completedBy,
                          Icons.person,
                        ),
                      ],
                      if (_bottlingDto.code.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'Código de Lote',
                          _bottlingDto.code,
                          Icons.qr_code,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card de Línea de Embotellado
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                color: Colors.indigo.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.precision_manufacturing,
                            color: Colors.indigo.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Línea de Embotellado',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_bottlingDto.bottlingLine.isNotEmpty)
                        _buildInfoRow(
                          'Línea Utilizada',
                          _bottlingDto.bottlingLine,
                          Icons.settings,
                        ),
                      if (_bottlingDto.temperature > 0) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Temperatura',
                          '${_bottlingDto.temperature.toStringAsFixed(1)} °C',
                          Icons.thermostat,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card de Producción
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
                            Icons.inventory_2,
                            color: Colors.green.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Datos de Producción',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_bottlingDto.bottlesFilled > 0)
                        _buildInfoRow(
                          'Botellas Llenadas',
                          '${_bottlingDto.bottlesFilled.toString()} unidades',
                          Icons.local_drink,
                        ),
                      if (_bottlingDto.bottlesFilled > 0 && _bottlingDto.bottleVolumeMl > 0)
                        const SizedBox(height: 12),
                      if (_bottlingDto.bottleVolumeMl > 0)
                        _buildInfoRow(
                          'Volumen por Botella',
                          '${_bottlingDto.bottleVolumeMl.toString()} ml',
                          Icons.science,
                        ),
                      if (_bottlingDto.bottleVolumeMl > 0 && _bottlingDto.totalVolumeLiters > 0)
                        const SizedBox(height: 12),
                      if (_bottlingDto.totalVolumeLiters > 0)
                        _buildInfoRow(
                          'Volumen Total',
                          '${_bottlingDto.totalVolumeLiters.toStringAsFixed(2)} L',
                          Icons.water_drop,
                        ),
                      if (_bottlingDto.sealType.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Tipo de Sellado',
                          _bottlingDto.sealType,
                          Icons.lock,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card de Control de Calidad
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
                            Icons.verified_user,
                            color: Colors.orange.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Control de Calidad',
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
                        'Filtrado Previo',
                        _bottlingDto.wasFiltered ? 'Sí' : 'No',
                        _bottlingDto.wasFiltered ? Icons.check_circle : Icons.cancel,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Etiquetas Aplicadas',
                        _bottlingDto.wereLabelsApplied ? 'Sí' : 'No',
                        _bottlingDto.wereLabelsApplied ? Icons.check_circle : Icons.cancel,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Cápsulas Aplicadas',
                        _bottlingDto.wereCapsulesApplied ? 'Sí' : 'No',
                        _bottlingDto.wereCapsulesApplied ? Icons.check_circle : Icons.cancel,
                      ),
                    ],
                  ),
                ),
              ),

              if (_bottlingDto.observations.isNotEmpty) ...[
                const SizedBox(height: 16),
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
                              Icons.description,
                              color: Colors.blue.shade600,
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
                          _bottlingDto.observations,
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
