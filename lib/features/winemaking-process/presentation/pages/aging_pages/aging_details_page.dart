import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/aging_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/aging_pages/aging_create_and_edit_page.dart';
import 'package:flutter/material.dart';

class AgingDetailsPage extends StatefulWidget {
  final AgingStageDto agingDto;
  final String batchId;

  const AgingDetailsPage({
    super.key, 
    required this.agingDto,
    required this.batchId,
  });

  @override
  State<AgingDetailsPage> createState() => _AgingDetailsPageState();
}

class _AgingDetailsPageState extends State<AgingDetailsPage> {
  late AgingStageDto _agingDto;

  @override
  void initState() {
    super.initState();
    _agingDto = widget.agingDto;
  }

  Future<void> _navigateToEditAging() async {
    final result = await Navigator.push<AgingStageDto>(
      context,
      MaterialPageRoute(
        builder: (_) => AgingCreateAndEditPage(
          batchId: widget.batchId,
          initialData: _agingDto,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _agingDto = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Etapa de maduración actualizada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Notificar a la vista padre que hubo cambios
      Navigator.pop(context, result);
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
            'Detalles de Maduración',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(_agingDto),
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
                                        'Etapa de Maduración',
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
                                          color: _agingDto.isCompleted
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.orange.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          _agingDto.isCompleted
                                              ? 'Completada'
                                              : 'En Proceso',
                                          style: TextStyle(
                                            color: _agingDto.isCompleted
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
                            onPressed: _navigateToEditAging,
                            icon: Icon(
                              Icons.edit,
                              color: ColorPalette.vinoTinto,
                              size: 24,
                            ),
                            tooltip: 'Editar maduración',
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
                        _formatDate(_agingDto.startedAt),
                        Icons.calendar_today,
                      ),
                      if (_agingDto.completedAt.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'Fecha de Finalización',
                          _formatDate(_agingDto.completedAt),
                          Icons.calendar_month,
                        ),
                      ],
                      if (_agingDto.completedBy.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'Responsable',
                          _agingDto.completedBy,
                          Icons.person,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card de Contenedor
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
                            Icons.inventory_2,
                            color: Colors.amber.shade700,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Información del Contenedor',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_agingDto.containerType.isNotEmpty)
                        _buildInfoRow(
                          'Tipo de Contenedor',
                          _agingDto.containerType,
                          Icons.category,
                        ),
                      if (_agingDto.containerType.isNotEmpty && _agingDto.material.isNotEmpty)
                        const SizedBox(height: 12),
                      if (_agingDto.material.isNotEmpty)
                        _buildInfoRow(
                          'Material',
                          _agingDto.material,
                          Icons.build_circle,
                        ),
                      if (_agingDto.material.isNotEmpty && _agingDto.containerCode.isNotEmpty)
                        const SizedBox(height: 12),
                      if (_agingDto.containerCode.isNotEmpty)
                        _buildInfoRow(
                          'Código del Contenedor',
                          _agingDto.containerCode,
                          Icons.qr_code,
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card de Condiciones
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
                            Icons.thermostat,
                            color: Colors.blue.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Condiciones de Maduración',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_agingDto.avgTemperature > 0)
                        _buildInfoRow(
                          'Temperatura Promedio',
                          '${_agingDto.avgTemperature.toStringAsFixed(1)} °C',
                          Icons.device_thermostat,
                        ),
                      if (_agingDto.avgTemperature > 0 && _agingDto.volumeLiters > 0)
                        const SizedBox(height: 12),
                      if (_agingDto.volumeLiters > 0)
                        _buildInfoRow(
                          'Volumen',
                          '${_agingDto.volumeLiters.toStringAsFixed(2)} L',
                          Icons.local_drink,
                        ),
                      if (_agingDto.volumeLiters > 0 && _agingDto.durationMonths > 0)
                        const SizedBox(height: 12),
                      if (_agingDto.durationMonths > 0)
                        _buildInfoRow(
                          'Duración Planificada',
                          '${_agingDto.durationMonths} ${_agingDto.durationMonths == 1 ? 'mes' : 'meses'}',
                          Icons.schedule,
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card de Procesos
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
                            Icons.settings,
                            color: Colors.green.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Procesos y Mantenimiento',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_agingDto.frequencyDays > 0)
                        _buildInfoRow(
                          'Frecuencia de Revisión',
                          '${_agingDto.frequencyDays} días',
                          Icons.update,
                        ),
                      if (_agingDto.frequencyDays > 0 && _agingDto.refilled > 0)
                        const SizedBox(height: 12),
                      if (_agingDto.refilled > 0)
                        _buildInfoRow(
                          'Rellenos Realizados',
                          '${_agingDto.refilled}',
                          Icons.add_circle,
                        ),
                      if (_agingDto.refilled > 0 && _agingDto.batonnage > 0)
                        const SizedBox(height: 12),
                      if (_agingDto.batonnage > 0)
                        _buildInfoRow(
                          'Batonnage Realizados',
                          '${_agingDto.batonnage}',
                          Icons.rotate_right,
                        ),
                      if (_agingDto.batonnage > 0 && _agingDto.rackings > 0)
                        const SizedBox(height: 12),
                      if (_agingDto.rackings > 0)
                        _buildInfoRow(
                          'Trasiegos Realizados',
                          '${_agingDto.rackings}',
                          Icons.swap_horiz,
                        ),
                    ],
                  ),
                ),
              ),

              if (_agingDto.purpose.isNotEmpty) ...[
                const SizedBox(height: 16),
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
                              Icons.flag,
                              color: Colors.purple.shade600,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Propósito',
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
                          'Objetivo de la Maduración',
                          _agingDto.purpose,
                          Icons.flag_outlined,
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              if (_agingDto.observations.isNotEmpty) ...[
                const SizedBox(height: 16),
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
                          _agingDto.observations,
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
