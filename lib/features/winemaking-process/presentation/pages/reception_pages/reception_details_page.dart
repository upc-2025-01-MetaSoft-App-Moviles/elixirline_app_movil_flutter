import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/reception_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/reception_pages/reception_create_and_edit_page.dart';
import 'package:flutter/material.dart';

class ReceptionDetailsPage extends StatefulWidget {
  final ReceptionStageDto receptionDto;
  final String batchId;

  const ReceptionDetailsPage({
    super.key, 
    required this.receptionDto,
    required this.batchId,
  });

  @override
  State<ReceptionDetailsPage> createState() => _ReceptionDetailsPageState();
}

class _ReceptionDetailsPageState extends State<ReceptionDetailsPage> {
  late ReceptionStageDto _receptionDto;
  bool _hasChanges = false; // Bandera para rastrear si hubo cambios

  @override
  void initState() {
    super.initState();
    _receptionDto = widget.receptionDto;
  }

  Future<void> _navigateToEditReception() async {
    final result = await Navigator.push<ReceptionStageDto>(
      context,
      MaterialPageRoute(
        builder: (_) => ReceptionCreateAndEditPage(
          batchId: widget.batchId,
          initialData: _receptionDto,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _receptionDto = result;
        _hasChanges = true; // Marcar que hubo cambios
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Etapa de recepción actualizada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _navigateBack() {
    // Si hubo cambios, devolver el DTO actualizado; si no, devolver null
    Navigator.of(context).pop(_hasChanges ? _receptionDto : null);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          _navigateBack();
          return false; // Evitar el pop automático porque ya lo manejamos manualmente
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorPalette.vinoTinto,
            foregroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: const Text(
              'Detalles de Recepción',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: _navigateBack,
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
                                    Icons.assignment_turned_in,
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
                                        'Información de Recepción',
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
                                          color: _receptionDto.isCompleted 
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.orange.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: _receptionDto.isCompleted 
                                                ? Colors.green.withOpacity(0.3)
                                                : Colors.orange.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          _receptionDto.isCompleted ? 'Completado' : 'En progreso',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: _receptionDto.isCompleted 
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
                              onPressed: _navigateToEditReception,
                              tooltip: 'Editar recepción',
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
                              _receptionDto.startedAt,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInfoItem(
                              Icons.calendar_month_outlined,
                              'Fecha de Finalización',
                              _receptionDto.completedAt,
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildInfoItem(
                        Icons.person_outline,
                        'Realizado por',
                        _receptionDto.completedBy,
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
                            'Parámetros Técnicos',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ColorPalette.vinoTinto,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Grid de parámetros
                      Row(
                        children: [
                          Expanded(
                            child: _buildParameterCard(
                              Icons.opacity_outlined,
                              'Nivel de Azúcar',
                              '${_receptionDto.sugarLevel} g/L',
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildParameterCard(
                              Icons.science_outlined,
                              'pH',
                              _receptionDto.pH.toString(),
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildParameterCard(
                              Icons.thermostat_outlined,
                              'Temperatura',
                              '${_receptionDto.temperature} °C',
                              Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildParameterCard(
                              Icons.scale_outlined,
                              'Cantidad',
                              '${_receptionDto.quantityKg} Kg',
                              Colors.purple,
                            ),
                          ),
                        ],
                      ),
                      
                      if (_receptionDto.observations.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: ColorPalette.vinoTinto.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      Icons.comment_outlined,
                                      color: ColorPalette.vinoTinto,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Observaciones',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: ColorPalette.vinoTinto,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _receptionDto.observations,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  height: 1.4,
                                ),
                              ),
                            ],
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
        ), // Cierre del Scaffold
      ), // Cierre del WillPopScope
    ); // Cierre del SafeArea
  }

  Widget _buildInfoItem(IconData icon, String label, String value, Color color) {
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
            value,
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

  Widget _buildParameterCard(IconData icon, String label, String value, Color color) {
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
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: color,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
