import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/clarification_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/datasources/clarification_stage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClarificationCreateAndEditPage extends StatefulWidget {
  final String batchId;
  final ClarificationStageDto? initialData;

  const ClarificationCreateAndEditPage({
    super.key,
    required this.batchId,
    this.initialData,
  });

  @override
  State<ClarificationCreateAndEditPage> createState() => _ClarificationCreateAndEditPageState();
}

class _ClarificationCreateAndEditPageState extends State<ClarificationCreateAndEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ClarificationStageService _clarificationService = ClarificationStageService('/wine-batch');

  // Form controllers
  final TextEditingController _startedAtController = TextEditingController();
  final TextEditingController _completedAtController = TextEditingController();
  final TextEditingController _methodController = TextEditingController();
  final TextEditingController _turbidityBeforeController = TextEditingController();
  final TextEditingController _turbidityAfterController = TextEditingController();
  final TextEditingController _wineVolumeController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
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
      _methodController.text = data.method;
      _turbidityBeforeController.text = data.initialTurbidityNtu > 0 ? data.initialTurbidityNtu.toString() : '';
      _turbidityAfterController.text = data.finalTurbidityNtu > 0 ? data.finalTurbidityNtu.toString() : '';
      _wineVolumeController.text = data.wineVolumeLitres > 0 ? data.wineVolumeLitres.toString() : '';
      _temperatureController.text = data.temperature > 0 ? data.temperature.toString() : '';
      _durationController.text = data.durationHours > 0 ? data.durationHours.toString() : '';
      _observationsController.text = data.observations;
      _isCompleted = data.isCompleted;
    } else {
      // Set default started date for new entries
      _startedAtController.text = _formatDateForInput(DateTime.now().toIso8601String());
      _isCompleted = false;
    }
  }

  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) {
      debugPrint('🗓️ [CLARIFICATION] dateStr está vacío');
      return null;
    }
    
    try {
      debugPrint('🗓️ [CLARIFICATION] Intentando parsear: "$dateStr"');
      
      // Intentar formato dd/MM/yyyy
      if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final year = int.tryParse(parts[2]);
          if (day != null && month != null && year != null) {
            final result = DateTime(year, month, day);
            debugPrint('🗓️ [CLARIFICATION] Fecha parseada con formato dd/MM/yyyy: $result');
            return result;
          }
        }
      }
      
      // Intentar formato ISO o con T
      if (dateStr.contains('T') || dateStr.contains('-')) {
        final result = DateTime.parse(dateStr);
        debugPrint('🗓️ [CLARIFICATION] Fecha parseada con formato ISO: $result');
        return result;
      }
      
    } catch (e) {
      debugPrint('❌ [CLARIFICATION] Error parseando fecha "$dateStr": $e');
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
        return _formatDate(date);
      }
      return dateString;
    } catch (e) {
      debugPrint('❌ [CLARIFICATION] Error formateando fecha para API: $e');
      return dateString;
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

  Future<void> _saveClarification() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Validar fecha requerida
      if (_startedAtController.text.isEmpty) {
        throw Exception('La fecha de inicio es requerida');
      }

      // Convertir las fechas al formato requerido por el backend (dd/MM/yyyy)
      String startedAt = _formatDateForApi(_startedAtController.text);

      Map<String, dynamic> stageMap;
      
      if (widget.initialData == null) {
        // Estructura para CREAR nueva etapa
        stageMap = {
          'method': _methodController.text.trim(),
          'turbidityBeforeNtu': _turbidityBeforeController.text.trim().isEmpty ? 0.0 : double.tryParse(_turbidityBeforeController.text.trim()) ?? 0.0,
          'turbidityAfterNtu': _turbidityAfterController.text.trim().isEmpty ? 0.0 : double.tryParse(_turbidityAfterController.text.trim()) ?? 0.0,
          'volumeLiters': _wineVolumeController.text.trim().isEmpty ? 0.0 : double.tryParse(_wineVolumeController.text.trim()) ?? 0.0,
          'temperature': _temperatureController.text.trim().isEmpty ? 0.0 : double.tryParse(_temperatureController.text.trim()) ?? 0.0,
          'durationHours': _durationController.text.trim().isEmpty ? 0 : int.tryParse(_durationController.text.trim()) ?? 0,
          'startedAt': startedAt,
          'completedBy': 'Especialista en Clarificación',
          'observations': _observationsController.text.trim(),
        };
      } else {
        // Estructura para EDITAR etapa existente
        stageMap = {
          'startedAt': startedAt,
          'completedBy': widget.initialData?.completedBy ?? 'Especialista en Clarificación',
          'isCompleted': _isCompleted,
          'method': _methodController.text.trim(),
          'initialTurbidityNtu': _turbidityBeforeController.text.trim().isEmpty ? 0.0 : double.tryParse(_turbidityBeforeController.text.trim()) ?? 0.0,
          'finalTurbidityNtu': _turbidityAfterController.text.trim().isEmpty ? 0.0 : double.tryParse(_turbidityAfterController.text.trim()) ?? 0.0,
          'wineVolumeLitres': _wineVolumeController.text.trim().isEmpty ? 0.0 : double.tryParse(_wineVolumeController.text.trim()) ?? 0.0,
          'temperature': _temperatureController.text.trim().isEmpty ? 0.0 : double.tryParse(_temperatureController.text.trim()) ?? 0.0,
          'durationHours': _durationController.text.trim().isEmpty ? 0 : int.tryParse(_durationController.text.trim()) ?? 0,
          'observations': _observationsController.text.trim(),
        };
      }

      debugPrint('📤 [CLARIFICATION] Datos a enviar: $stageMap');
      debugPrint('📤 [CLARIFICATION] BatchId: ${widget.batchId}');
      debugPrint('📤 [CLARIFICATION] Es edición: ${widget.initialData != null}');

      ClarificationStageDto result;
      if (widget.initialData == null) {
        // Crear nueva etapa
        result = await _clarificationService.create(widget.batchId, stageMap);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Etapa de clarificación creada correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Actualizar etapa existente
        debugPrint('🔄 [CLARIFICATION] Iniciando actualización de etapa existente...');
        debugPrint('🔄 [CLARIFICATION] Payload completo: $stageMap');
        
        result = await _clarificationService.update(widget.batchId, stageMap);
        
        debugPrint('✅ [CLARIFICATION] Etapa actualizada correctamente');
        debugPrint('✅ [CLARIFICATION] StartedAt=${result.startedAt}, IsCompleted=${result.isCompleted}');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Clarificación actualizada exitosamente'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }

      if (mounted) {
        Navigator.of(context).pop(result);
      }
    } catch (e) {
      debugPrint('❌ [CLARIFICATION] Error al guardar la etapa de clarificación: $e');
      debugPrint('❌ [CLARIFICATION] Tipo de error: ${e.runtimeType}');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
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
    _methodController.dispose();
    _turbidityBeforeController.dispose();
    _turbidityAfterController.dispose();
    _wineVolumeController.dispose();
    _temperatureController.dispose();
    _durationController.dispose();
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
            isEdit ? 'Editar Clarificación' : 'Nueva Clarificación',
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
                onPressed: _saveClarification,
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

                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Card de método y configuración
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
                        TextFormField(
                          controller: _methodController,
                          decoration: InputDecoration(
                            labelText: 'Método de Clarificación',
                            hintText: 'Ej: Filtración, Bentonita, etc.',
                            prefixIcon: const Icon(Icons.science),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: ColorPalette.vinoTinto),
                            ),
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _durationController,
                          decoration: InputDecoration(
                            labelText: 'Duración (horas)',
                            hintText: 'Ej: 24',
                            prefixIcon: const Icon(Icons.timer),
                            suffixText: 'hrs',
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
                          controller: _temperatureController,
                          decoration: InputDecoration(
                            labelText: 'Temperatura',
                            hintText: 'Ej: 15.5',
                            prefixIcon: const Icon(Icons.thermostat),
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
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Card de turbidez
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
                        TextFormField(
                          controller: _turbidityBeforeController,
                          decoration: InputDecoration(
                            labelText: isEdit ? 'Turbidez Inicial' : 'Turbidez Antes',
                            hintText: 'Ej: 15.25',
                            prefixIcon: const Icon(Icons.trending_up),
                            suffixText: 'NTU',
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
                          controller: _turbidityAfterController,
                          decoration: InputDecoration(
                            labelText: isEdit ? 'Turbidez Final' : 'Turbidez Después',
                            hintText: 'Ej: 2.15',
                            prefixIcon: const Icon(Icons.trending_down),
                            suffixText: 'NTU',
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
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Card de volumen
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
                        TextFormField(
                          controller: _wineVolumeController,
                          decoration: InputDecoration(
                            labelText: 'Volumen Procesado',
                            hintText: 'Ej: 1000.50',
                            prefixIcon: const Icon(Icons.local_bar),
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
                            hintText: 'Describe cualquier detalle importante del proceso...',
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

                const SizedBox(height: 16),

                // Card del estado de completado
                if (widget.initialData != null) ...[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: Colors.green.withOpacity(0.3),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.green.withOpacity(0.05),
                            Colors.green.withOpacity(0.02),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green.shade600,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Estado de la Etapa',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
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
                  ),
                  const SizedBox(height: 16),
                ],

                const SizedBox(height: 24),

                // Botón de guardar
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveClarification,
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
                            isEdit ? 'Actualizar Clarificación' : 'Crear Clarificación',
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
