import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/aging_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/datasources/aging_stage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AgingCreateAndEditPage extends StatefulWidget {
  final String batchId;
  final AgingStageDto? initialData;

  const AgingCreateAndEditPage({
    super.key,
    required this.batchId,
    this.initialData,
  });

  @override
  State<AgingCreateAndEditPage> createState() => _AgingCreateAndEditPageState();
}

class _AgingCreateAndEditPageState extends State<AgingCreateAndEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AgingStageService _agingService = AgingStageService('/wine-batch');

  // Form controllers
  final TextEditingController _startedAtController = TextEditingController();
  final TextEditingController _completedAtController = TextEditingController();
  final TextEditingController _completedByController = TextEditingController();
  final TextEditingController _containerTypeController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _containerCodeController = TextEditingController();
  final TextEditingController _avgTemperatureController = TextEditingController();
  final TextEditingController _volumeLitersController = TextEditingController();
  final TextEditingController _durationMonthsController = TextEditingController();
  final TextEditingController _frequencyDaysController = TextEditingController();
  final TextEditingController _refilledController = TextEditingController();
  final TextEditingController _batonnageController = TextEditingController();
  final TextEditingController _rackingsController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();

  bool _isLoading = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _startedAtController.text = _formatDateForInput(data.startedAt);
      _completedAtController.text = _formatDateForInput(data.completedAt);
      _completedByController.text = data.completedBy;
      _containerTypeController.text = data.containerType;
      _materialController.text = data.material;
      _containerCodeController.text = data.containerCode;
      _avgTemperatureController.text = data.avgTemperature > 0 ? data.avgTemperature.toString() : '';
      _volumeLitersController.text = data.volumeLiters > 0 ? data.volumeLiters.toString() : '';
      _durationMonthsController.text = data.durationMonths > 0 ? data.durationMonths.toString() : '';
      _frequencyDaysController.text = data.frequencyDays > 0 ? data.frequencyDays.toString() : '';
      _refilledController.text = data.refilled > 0 ? data.refilled.toString() : '';
      _batonnageController.text = data.batonnage > 0 ? data.batonnage.toString() : '';
      _rackingsController.text = data.rackings > 0 ? data.rackings.toString() : '';
      _purposeController.text = data.purpose;
      _observationsController.text = data.observations;
      _isCompleted = data.isCompleted;
    } else {
      // Set default started date for new entries
      _startedAtController.text = _formatDateForInput(DateTime.now().toIso8601String());
      _isCompleted = false;
    }
  }

  String _formatDateForInput(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    
    try {
      DateTime? date = _parseDate(dateString);
      if (date != null) {
        return _formatDate(date);
      }
      return dateString;
    } catch (e) {
      debugPrint('❌ [AGING] Error formateando fecha para input: $e');
      return dateString;
    }
  }

  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) {
      debugPrint('🗓️ [AGING] dateStr está vacío');
      return null;
    }
    
    try {
      debugPrint('🗓️ [AGING] Intentando parsear: "$dateStr"');
      
      // Intentar formato dd/MM/yyyy
      if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final year = int.tryParse(parts[2]);
          if (day != null && month != null && year != null) {
            final result = DateTime(year, month, day);
            debugPrint('🗓️ [AGING] Fecha parseada con formato dd/MM/yyyy: $result');
            return result;
          }
        }
      }
      
      // Intentar formato ISO o con T
      if (dateStr.contains('T') || dateStr.contains('-')) {
        final result = DateTime.parse(dateStr);
        debugPrint('🗓️ [AGING] Fecha parseada con formato ISO: $result');
        return result;
      }
      
    } catch (e) {
      debugPrint('❌ [AGING] Error parseando fecha "$dateStr": $e');
    }
    
    return null;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateForApi(String dateString) {
    if (dateString.isEmpty) return '';
    
    try {
      DateTime? date = _parseDate(dateString);
      if (date != null) {
        String formatted = _formatDate(date);
        debugPrint('🔄 [AGING] Formateando para API: "$dateString" -> "$formatted"');
        return formatted;
      }
      debugPrint('⚠️ [AGING] No se pudo parsear fecha: "$dateString", devolviendo original');
      return dateString;
    } catch (e) {
      debugPrint('❌ [AGING] Error formateando fecha para API: $e');
      return dateString;
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorPalette.vinoTinto,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      controller.text = '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
    }
  }

  Future<void> _saveAging() async {
    if (!_formKey.currentState!.validate()) {
      debugPrint('❌ [AGING] Formulario no válido');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('🚀 [AGING] Iniciando guardado de maduración');
      
      String startedAt = _formatDateForApi(_startedAtController.text);
      debugPrint('📅 [AGING] Fecha inicio formateada: $startedAt');

      // Construir payload base
      Map<String, dynamic> payload = {
        'startedAt': startedAt,
        'completedBy': _completedByController.text.trim(),
        'containerType': _containerTypeController.text.trim(),
        'material': _materialController.text.trim(),
        'containerCode': _containerCodeController.text.trim(),
        'avgTemperature': double.tryParse(_avgTemperatureController.text) ?? 0.0,
        'volumeLiters': double.tryParse(_volumeLitersController.text) ?? 0.0,
        'durationMonths': int.tryParse(_durationMonthsController.text) ?? 0,
        'frequencyDays': int.tryParse(_frequencyDaysController.text) ?? 0,
        'refilled': int.tryParse(_refilledController.text) ?? 0,
        'batonnage': int.tryParse(_batonnageController.text) ?? 0,
        'rackings': int.tryParse(_rackingsController.text) ?? 0,
        'purpose': _purposeController.text.trim(),
        'observations': _observationsController.text.trim(),
        'isCompleted': _isCompleted,
      };

      // Para crear: manejar completedAt solo si la etapa está marcada como completada
      if (widget.initialData == null) {
        debugPrint('🆕 [AGING] Creando nueva etapa de maduración');
        
        if (_isCompleted) {
          // Si se marca como completada en la creación, usar fecha actual o la especificada
          String formattedCompletedAt;
          if (_completedAtController.text.isNotEmpty) {
            DateTime? completedDate = _parseDate(_completedAtController.text);
            if (completedDate != null) {
              formattedCompletedAt = _formatDate(completedDate);
            } else {
              formattedCompletedAt = _formatDate(DateTime.now());
            }
          } else {
            formattedCompletedAt = _formatDate(DateTime.now());
          }
          
          payload['completedAt'] = formattedCompletedAt;
          debugPrint('📅 [AGING] Fecha completado (creación): $formattedCompletedAt');
        }
        // Si no está completada, no incluir completedAt en el payload
        
      } else {
        // Para editar: siempre incluir completedAt
        debugPrint('✏️ [AGING] Editando etapa existente');
        
        String formattedCompletedAt;
        if (_isCompleted) {
          if (_completedAtController.text.isNotEmpty) {
            DateTime? completedDate = _parseDate(_completedAtController.text);
            if (completedDate != null) {
              formattedCompletedAt = _formatDate(completedDate);
            } else {
              formattedCompletedAt = _formatDate(DateTime.now());
            }
          } else {
            formattedCompletedAt = _formatDate(DateTime.now());
          }
        } else {
          // Si no está completada, usar string vacío
          formattedCompletedAt = '';
        }
        
        payload['completedAt'] = formattedCompletedAt;
        debugPrint('📅 [AGING] Fecha completado (edición): $formattedCompletedAt');
      }

      debugPrint('📦 [AGING] Payload final: $payload');

      final AgingStageDto result;
      
      if (widget.initialData != null) {
        debugPrint('🔄 [AGING] Llamando update service');
        result = await _agingService.update(widget.batchId, payload);
      } else {
        debugPrint('➕ [AGING] Llamando create service');
        result = await _agingService.create(widget.batchId, payload);
      }

      debugPrint('✅ [AGING] Maduración guardada exitosamente para lote: ${result.batchId}');

      if (mounted) {
        Navigator.of(context).pop(result);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Etapa de maduración guardada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ [AGING] Error al guardar: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _startedAtController.dispose();
    _completedAtController.dispose();
    _completedByController.dispose();
    _containerTypeController.dispose();
    _materialController.dispose();
    _containerCodeController.dispose();
    _avgTemperatureController.dispose();
    _volumeLitersController.dispose();
    _durationMonthsController.dispose();
    _frequencyDaysController.dispose();
    _refilledController.dispose();
    _batonnageController.dispose();
    _rackingsController.dispose();
    _purposeController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.initialData != null;
    
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPalette.vinoTinto,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            isEdit ? 'Editar Maduración' : 'Nueva Maduración',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Volver',
          ),
          actions: [
            if (_isLoading)
              Container(
                margin: const EdgeInsets.all(16),
                height: 20,
                width: 20,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else
              IconButton(
                onPressed: _saveAging,
                icon: const Icon(Icons.save),
                tooltip: 'Guardar',
              ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Card de fechas
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  color: Colors.grey.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: ColorPalette.vinoTinto,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Fechas',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _startedAtController,
                          decoration: InputDecoration(
                            labelText: 'Fecha de Inicio *',
                            hintText: 'DD/MM/YYYY',
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: ColorPalette.vinoTinto),
                            ),
                          ),
                          readOnly: true,
                          onTap: () => _selectDate(_startedAtController),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La fecha de inicio es obligatoria';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _completedAtController,
                          decoration: InputDecoration(
                            labelText: 'Fecha de Finalización',
                            hintText: 'DD/MM/YYYY',
                            prefixIcon: const Icon(Icons.calendar_month),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: ColorPalette.vinoTinto),
                            ),
                          ),
                          readOnly: true,
                          onTap: () => _selectDate(_completedAtController),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _completedByController,
                          decoration: InputDecoration(
                            labelText: 'Responsable',
                            hintText: 'Nombre del responsable',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: ColorPalette.vinoTinto),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SwitchListTile(
                          title: const Text(
                            'Marcar como completada',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            _isCompleted
                                ? 'La etapa está marcada como completada'
                                : 'La etapa aún no está completada',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          value: _isCompleted,
                          onChanged: (bool value) {
                            setState(() {
                              _isCompleted = value;
                            });
                          },
                          activeColor: ColorPalette.vinoTinto,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Card de contenedor
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
                        TextFormField(
                          controller: _containerTypeController,
                          decoration: InputDecoration(
                            labelText: 'Tipo de Contenedor',
                            hintText: 'Ej: Barrica, Tanque, Fudre',
                            prefixIcon: const Icon(Icons.category),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: ColorPalette.vinoTinto),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _materialController,
                          decoration: InputDecoration(
                            labelText: 'Material',
                            hintText: 'Ej: Roble francés, Acero inoxidable',
                            prefixIcon: const Icon(Icons.build_circle),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: ColorPalette.vinoTinto),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _containerCodeController,
                          decoration: InputDecoration(
                            labelText: 'Código del Contenedor',
                            hintText: 'Ej: B001, T-15',
                            prefixIcon: const Icon(Icons.qr_code),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: ColorPalette.vinoTinto),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Card de condiciones
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
                        TextFormField(
                          controller: _avgTemperatureController,
                          decoration: InputDecoration(
                            labelText: 'Temperatura Promedio',
                            hintText: 'Ej: 16.5',
                            prefixIcon: const Icon(Icons.device_thermostat),
                            suffixText: '°C',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: ColorPalette.vinoTinto),
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _volumeLitersController,
                          decoration: InputDecoration(
                            labelText: 'Volumen',
                            hintText: 'Ej: 225.5',
                            prefixIcon: const Icon(Icons.local_drink),
                            suffixText: 'L',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: ColorPalette.vinoTinto),
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _durationMonthsController,
                          decoration: InputDecoration(
                            labelText: 'Duración Planificada',
                            hintText: 'Ej: 12',
                            prefixIcon: const Icon(Icons.schedule),
                            suffixText: 'meses',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: ColorPalette.vinoTinto),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Card de procesos
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
                        TextFormField(
                          controller: _frequencyDaysController,
                          decoration: InputDecoration(
                            labelText: 'Frecuencia de Revisión',
                            hintText: 'Ej: 30',
                            prefixIcon: const Icon(Icons.update),
                            suffixText: 'días',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: ColorPalette.vinoTinto),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _refilledController,
                          decoration: InputDecoration(
                            labelText: 'Rellenos Realizados',
                            hintText: 'Ej: 3',
                            prefixIcon: const Icon(Icons.add_circle),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: ColorPalette.vinoTinto),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _batonnageController,
                          decoration: InputDecoration(
                            labelText: 'Batonnage Realizados',
                            hintText: 'Ej: 5',
                            prefixIcon: const Icon(Icons.rotate_right),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: ColorPalette.vinoTinto),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _rackingsController,
                          decoration: InputDecoration(
                            labelText: 'Trasiegos Realizados',
                            hintText: 'Ej: 2',
                            prefixIcon: const Icon(Icons.swap_horiz),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: ColorPalette.vinoTinto),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Card de propósito
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
                        TextFormField(
                          controller: _purposeController,
                          decoration: InputDecoration(
                            labelText: 'Objetivo de la Maduración',
                            hintText: 'Ej: Aporte de taninos, estabilización, desarrollo aromático...',
                            prefixIcon: const Icon(Icons.flag_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: ColorPalette.vinoTinto),
                            ),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Card de observaciones
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
                        TextFormField(
                          controller: _observationsController,
                          decoration: InputDecoration(
                            labelText: 'Observaciones',
                            hintText: 'Describe cualquier detalle importante del proceso de maduración...',
                            prefixIcon: const Icon(Icons.note),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: ColorPalette.vinoTinto),
                            ),
                          ),
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Botón de guardar
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveAging,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.vinoTinto,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: _isLoading
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Guardando...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            isEdit ? 'Actualizar Maduración' : 'Crear Maduración',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
