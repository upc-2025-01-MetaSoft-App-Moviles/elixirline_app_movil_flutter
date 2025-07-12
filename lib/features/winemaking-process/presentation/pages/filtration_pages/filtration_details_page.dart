import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/filtration_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/filtration_pages/filtration_create_and_edit_page.dart';
import 'package:flutter/material.dart';

class FiltrationDetailsPage extends StatefulWidget {
  final FiltrationStageDto filtrationDto;
  final String batchId;

  const FiltrationDetailsPage({
    super.key, 
    required this.filtrationDto,
    required this.batchId,
  });

  @override
  State<FiltrationDetailsPage> createState() => _FiltrationDetailsPageState();
}

class _FiltrationDetailsPageState extends State<FiltrationDetailsPage> {
  late FiltrationStageDto _filtrationDto;

  @override
  void initState() {
    super.initState();
    _filtrationDto = widget.filtrationDto;
  }

  Future<void> _navigateToEditFiltration() async {
    debugPrint('🔄 [FILTRATION_DETAILS] Navegando a editar filtración...');
    
    final result = await Navigator.push<FiltrationStageDto>(
      context,
      MaterialPageRoute(
        builder: (_) => FiltrationCreateAndEditPage(
          batchId: widget.batchId,
          initialData: _filtrationDto,
        ),
      ),
    );

    if (result != null) {
      debugPrint('✅ [FILTRATION_DETAILS] Resultado recibido de edición: ${result.toString()}');
      
      setState(() {
        _filtrationDto = result;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Etapa de filtración actualizada correctamente'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      
      debugPrint('🔄 [FILTRATION_DETAILS] Estado actualizado localmente');
    } else {
      debugPrint('ℹ️ [FILTRATION_DETAILS] No se recibió resultado de la edición');
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
            'Detalles de Filtración',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              debugPrint('🔄 [FILTRATION_DETAILS] Regresando con datos actualizados');
              Navigator.of(context).pop(_filtrationDto);
            },
            tooltip: 'Volver',
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildMainCard(),
              const SizedBox(height: 16),
              _buildFilterConfigurationCard(),
              const SizedBox(height: 16),
              _buildProcessParametersCard(),
              const SizedBox(height: 16),
              _buildQualityControlCard(),
              const SizedBox(height: 16),
              _buildMaintenanceCard(),
              if (_filtrationDto.observations.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildObservationsCard(),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
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
                            Icons.filter_alt,
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
                                'Etapa de Filtración',
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
                                  color: _filtrationDto.isCompleted
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _filtrationDto.isCompleted
                                      ? 'Completada'
                                      : 'En Proceso',
                                  style: TextStyle(
                                    color: _filtrationDto.isCompleted
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
                    onPressed: _navigateToEditFiltration,
                    icon: Icon(
                      Icons.edit,
                      color: ColorPalette.vinoTinto,
                      size: 24,
                    ),
                    tooltip: 'Editar filtración',
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
              _buildDetailRow('Fecha de Inicio', _formatDate(_filtrationDto.startedAt)),
              if (_filtrationDto.completedAt.isNotEmpty)
                _buildDetailRow('Fecha de Finalización', _formatDate(_filtrationDto.completedAt)),
              _buildDetailRow('Responsable', _filtrationDto.completedBy),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterConfigurationCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.filter_alt, color: Colors.purple.shade700, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Configuración del Filtro',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_filtrationDto.filterType.isNotEmpty)
                _buildDetailRow('Tipo de Filtro', _filtrationDto.filterType),
              _buildDetailRow('Tipo de Filtración', _filtrationDto.filtrationType),
              _buildDetailRow('Medio Filtrante', _filtrationDto.filterMedia),
              _buildDetailRow('Tamaño de Poro', '${_filtrationDto.poreMicrons.toStringAsFixed(1)} μm'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProcessParametersCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.settings, color: Colors.green.shade700, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Parámetros de Proceso',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailRow('Turbidez Inicial', '${_filtrationDto.turbidityBefore.toStringAsFixed(1)} NTU'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDetailRow('Turbidez Final', '${_filtrationDto.turbidityAfter.toStringAsFixed(1)} NTU'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailRow('Temperatura', '${_filtrationDto.temperature.toStringAsFixed(1)}°C'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDetailRow('Presión', '${_filtrationDto.pressureBars.toStringAsFixed(1)} bar'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDetailRow('Volumen Filtrado', '${_filtrationDto.filteredVolumeLiters.toStringAsFixed(1)} L'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQualityControlCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.verified, color: Colors.orange.shade700, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Control de Calidad',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildBooleanDetailRow('Filtración Estéril', _filtrationDto.isSterile),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildBooleanDetailRow('Filtro Cambiado', _filtrationDto.filterChanged),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaintenanceCard() {
    if (!_filtrationDto.filterChanged || _filtrationDto.changeReason.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.amber.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.build, color: Colors.amber.shade700, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Mantenimiento del Filtro',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Razón del Cambio', _filtrationDto.changeReason),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildObservationsCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.notes, color: Colors.grey.shade700, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Observaciones',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  _filtrationDto.observations,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? 'No especificado' : value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBooleanDetailRow(String label, bool value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: value ? Colors.green.shade100 : Colors.red.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: value ? Colors.green.shade300 : Colors.red.shade300,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  value ? Icons.check_circle : Icons.cancel,
                  size: 16,
                  color: value ? Colors.green.shade700 : Colors.red.shade700,
                ),
                const SizedBox(width: 4),
                Text(
                  value ? 'Sí' : 'No',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: value ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
