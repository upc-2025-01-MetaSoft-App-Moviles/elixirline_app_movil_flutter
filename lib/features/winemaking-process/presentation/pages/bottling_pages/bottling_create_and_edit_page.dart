import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/bottling_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/datasources/bottling_stage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottlingCreateAndEditPage extends StatefulWidget {
  final String batchId;
  final BottlingStageDto? initialData;

  const BottlingCreateAndEditPage({
    super.key,
    required this.batchId,
    this.initialData,
  });

  @override
  State<BottlingCreateAndEditPage> createState() =>
      _BottlingCreateAndEditPageState();
}

class _BottlingCreateAndEditPageState extends State<BottlingCreateAndEditPage> {
  final BottlingStageService _bottlingService = BottlingStageService('/wine-batch');
  final _formKey = GlobalKey<FormState>();

  // Controllers para línea y producción
  late TextEditingController _bottlingLineController;
  late TextEditingController _bottlesFilledController;
  late TextEditingController _bottleVolumeMlController;
  late TextEditingController _totalVolumeLitersController;
  late TextEditingController _sealTypeController;
  late TextEditingController _codeController;
  late TextEditingController _temperatureController;

  // Controllers para fechas y observaciones
  late TextEditingController _startedAtController;
  late TextEditingController _completedAtController;
  late TextEditingController _completedByController;
  late TextEditingController _observationsController;

  // Estados
  bool _wasFiltered = false;
  bool _wereLabelsApplied = false;
  bool _wereCapsulesApplied = false;
  bool _isCompleted = false;
  bool _isLoading = false;

  bool get _isEdit => widget.initialData != null;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadInitialData();
  }

  void _initializeControllers() {
    _bottlingLineController = TextEditingController();
    _bottlesFilledController = TextEditingController();
    _bottleVolumeMlController = TextEditingController();
    _totalVolumeLitersController = TextEditingController();
    _sealTypeController = TextEditingController();
    _codeController = TextEditingController();
    _temperatureController = TextEditingController();
    _startedAtController = TextEditingController();
    _completedAtController = TextEditingController();
    _completedByController = TextEditingController();
    _observationsController = TextEditingController();
  }

  void _loadInitialData() {
    if (_isEdit && widget.initialData != null) {
      final data = widget.initialData!;
      
      _bottlingLineController.text = data.bottlingLine;
      _bottlesFilledController.text = data.bottlesFilled > 0 ? data.bottlesFilled.toString() : '';
      _bottleVolumeMlController.text = data.bottleVolumeMl > 0 ? data.bottleVolumeMl.toString() : '';
      _totalVolumeLitersController.text = data.totalVolumeLiters > 0 ? data.totalVolumeLiters.toString() : '';
      _sealTypeController.text = data.sealType;
      _codeController.text = data.code;
      _temperatureController.text = data.temperature > 0 ? data.temperature.toString() : '';
      
      _startedAtController.text = _formatDateForInput(data.startedAt);
      _completedAtController.text = _formatDateForInput(data.completedAt);
      _completedByController.text = data.completedBy;
      _observationsController.text = data.observations;
      
      _wasFiltered = data.wasFiltered;
      _wereLabelsApplied = data.wereLabelsApplied;
      _wereCapsulesApplied = data.wereCapsulesApplied;
      _isCompleted = data.isCompleted;
    }
  }

  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) {
      debugPrint('🗓️ [BOTTLING] dateStr está vacío');
      return null;
    }
    
    try {
      debugPrint('🗓️ [BOTTLING] Intentando parsear: "$dateStr"');
      
      // Limpiar la fecha removiendo componentes de tiempo si existen
      String cleanedDateStr = dateStr.trim();
      if (cleanedDateStr.contains(' ')) {
        cleanedDateStr = cleanedDateStr.split(' ')[0];
      }
      
      // Intentar formato dd/MM/yyyy
      if (cleanedDateStr.contains('/')) {
        final parts = cleanedDateStr.split('/');
        if (parts.length == 3) {
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final year = int.tryParse(parts[2]);
          if (day != null && month != null && year != null) {
            final result = DateTime(year, month, day);
            debugPrint('🗓️ [BOTTLING] Fecha parseada con formato dd/MM/yyyy: $result');
            return result;
          }
        }
      }
      
      // Intentar formato dd-MM-yyyy
      if (cleanedDateStr.contains('-') && !cleanedDateStr.contains('T')) {
        final parts = cleanedDateStr.split('-');
        if (parts.length == 3) {
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final year = int.tryParse(parts[2]);
          if (day != null && month != null && year != null) {
            final result = DateTime(year, month, day);
            debugPrint('🗓️ [BOTTLING] Fecha parseada con formato dd-MM-yyyy: $result');
            return result;
          }
        }
      }
      
      // Intentar formato ISO o con T
      if (cleanedDateStr.contains('T')) {
        final result = DateTime.parse(cleanedDateStr);
        debugPrint('🗓️ [BOTTLING] Fecha parseada con formato ISO: $result');
        return result;
      }
      
    } catch (e) {
      debugPrint('❌ [BOTTLING] Error parseando fecha "$dateStr": $e');
    }
    
    return null;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateForInput(String dateString) {
    if (dateString.isEmpty) return '';
    
    try {
      DateTime? date = _parseDate(dateString);
      if (date != null) {
        return _formatDate(date);
      }
      return dateString;
    } catch (e) {
      debugPrint('❌ [BOTTLING] Error formateando fecha para input: $e');
      return dateString;
    }
  }

  String _formatDateForApi(String dateString) {
    if (dateString.isEmpty) return '';
    
    try {
      DateTime? date = _parseDate(dateString);
      if (date != null) {
        String formatted = _formatDate(date);
        debugPrint('🔄 [BOTTLING] Formateando para API: "$dateString" -> "$formatted"');
        return formatted;
      }
      debugPrint('⚠️ [BOTTLING] No se pudo parsear fecha: "$dateString", devolviendo original');
      return dateString;
    } catch (e) {
      debugPrint('❌ [BOTTLING] Error formateando fecha para API: $e');
      return dateString;
    }
  }

  @override
  void dispose() {
    _bottlingLineController.dispose();
    _bottlesFilledController.dispose();
    _bottleVolumeMlController.dispose();
    _totalVolumeLitersController.dispose();
    _sealTypeController.dispose();
    _codeController.dispose();
    _temperatureController.dispose();
    _startedAtController.dispose();
    _completedAtController.dispose();
    _completedByController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
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

    if (picked != null) {
      controller.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  Future<void> _saveBottling() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('🍷 [BOTTLING] Iniciando guardado de embotellado - Modo: ${_isEdit ? "Editar" : "Crear"}');
      
      final bottlingData = {
        'batchId': widget.batchId,
        'bottlingLine': _bottlingLineController.text.trim(),
        'bottlesFilled': int.tryParse(_bottlesFilledController.text.trim()) ?? 0,
        'bottleVolumeMl': int.tryParse(_bottleVolumeMlController.text.trim()) ?? 0,
        'totalVolumeLiters': double.tryParse(_totalVolumeLitersController.text.trim()) ?? 0.0,
        'sealType': _sealTypeController.text.trim(),
        'code': _codeController.text.trim(),
        'temperature': double.tryParse(_temperatureController.text.trim()) ?? 0.0,
        'wasFiltered': _wasFiltered,
        'wereLabelsApplied': _wereLabelsApplied,
        'wereCapsulesApplied': _wereCapsulesApplied,
        'startedAt': _formatDateForApi(_startedAtController.text.trim()),
        'completedAt': _formatDateForApi(_completedAtController.text.trim()),
        'completedBy': _completedByController.text.trim(),
        'observations': _observationsController.text.trim(),
        'isCompleted': _isCompleted,
      };

      debugPrint('📤 [BOTTLING] Datos a enviar: $bottlingData');

      BottlingStageDto result;
      if (_isEdit) {
        result = await _bottlingService.update(
          widget.batchId,
          bottlingData,
        );
        debugPrint('✅ [BOTTLING] Embotellado actualizado exitosamente');
      } else {
        result = await _bottlingService.create(widget.batchId, bottlingData);
        debugPrint('✅ [BOTTLING] Embotellado creado exitosamente');
      }

      Navigator.of(context).pop(result);
    } catch (e) {
      debugPrint('❌ [BOTTLING] Error al ${_isEdit ? 'actualizar' : 'crear'} embotellado: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al ${_isEdit ? 'actualizar' : 'crear'} el embotellado: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
          title: Text(
            _isEdit ? 'Editar Embotellado' : 'Crear Embotellado',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Volver',
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
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
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _bottlingLineController,
                          decoration: InputDecoration(
                            labelText: 'Línea Utilizada',
                            hintText: 'Ej: Línea Manual #2',
                            prefixIcon: const Icon(Icons.settings),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _temperatureController,
                                decoration: InputDecoration(
                                  labelText: 'Temperatura (°C)',
                                  hintText: 'Ej: 18.3',
                                  prefixIcon: const Icon(Icons.thermostat),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _codeController,
                                decoration: InputDecoration(
                                  labelText: 'Código de Lote',
                                  hintText: 'Ej: EMB-2025-007',
                                  prefixIcon: const Icon(Icons.qr_code),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Card de Datos de Producción
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
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _bottlesFilledController,
                                decoration: InputDecoration(
                                  labelText: 'Botellas Llenadas',
                                  hintText: 'Ej: 800',
                                  prefixIcon: const Icon(Icons.local_drink),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _bottleVolumeMlController,
                                decoration: InputDecoration(
                                  labelText: 'Volumen por Botella (ml)',
                                  hintText: 'Ej: 750',
                                  prefixIcon: const Icon(Icons.science),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _totalVolumeLitersController,
                                decoration: InputDecoration(
                                  labelText: 'Volumen Total (L)',
                                  hintText: 'Ej: 600.0',
                                  prefixIcon: const Icon(Icons.water_drop),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _sealTypeController,
                                decoration: InputDecoration(
                                  labelText: 'Tipo de Sellado',
                                  hintText: 'Ej: Corcho natural',
                                  prefixIcon: const Icon(Icons.lock),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            children: [
                              SwitchListTile(
                                title: const Text(
                                  'Filtrado Previo',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: const Text('¿Se filtró el vino antes del embotellado?'),
                                value: _wasFiltered,
                                onChanged: (value) {
                                  setState(() {
                                    _wasFiltered = value;
                                  });
                                },
                                activeColor: ColorPalette.vinoTinto,
                                secondary: Icon(
                                  _wasFiltered ? Icons.check_circle : Icons.cancel,
                                  color: _wasFiltered ? Colors.green : Colors.grey,
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey.shade300),
                              SwitchListTile(
                                title: const Text(
                                  'Etiquetas Aplicadas',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: const Text('¿Se aplicaron las etiquetas?'),
                                value: _wereLabelsApplied,
                                onChanged: (value) {
                                  setState(() {
                                    _wereLabelsApplied = value;
                                  });
                                },
                                activeColor: ColorPalette.vinoTinto,
                                secondary: Icon(
                                  _wereLabelsApplied ? Icons.check_circle : Icons.cancel,
                                  color: _wereLabelsApplied ? Colors.green : Colors.grey,
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey.shade300),
                              SwitchListTile(
                                title: const Text(
                                  'Cápsulas Aplicadas',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: const Text('¿Se aplicaron las cápsulas?'),
                                value: _wereCapsulesApplied,
                                onChanged: (value) {
                                  setState(() {
                                    _wereCapsulesApplied = value;
                                  });
                                },
                                activeColor: ColorPalette.vinoTinto,
                                secondary: Icon(
                                  _wereCapsulesApplied ? Icons.check_circle : Icons.cancel,
                                  color: _wereCapsulesApplied ? Colors.green : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Card de Fechas y Control
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
                              Icons.schedule,
                              color: Colors.blue.shade600,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Fechas y Control',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _startedAtController,
                          decoration: InputDecoration(
                            labelText: 'Fecha de Inicio *',
                            hintText: 'DD/MM/AAAA',
                            prefixIcon: const Icon(Icons.calendar_today),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.date_range),
                              onPressed: () => _selectDate(_startedAtController),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'La fecha de inicio es obligatoria';
                            }
                            return null;
                          },
                          readOnly: true,
                          onTap: () => _selectDate(_startedAtController),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _completedAtController,
                                decoration: InputDecoration(
                                  labelText: 'Fecha de Finalización',
                                  hintText: 'DD/MM/AAAA',
                                  prefixIcon: const Icon(Icons.calendar_month),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.date_range),
                                    onPressed: () => _selectDate(_completedAtController),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                readOnly: true,
                                onTap: () => _selectDate(_completedAtController),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _completedByController,
                                decoration: InputDecoration(
                                  labelText: 'Responsable',
                                  hintText: 'Nombre del operador',
                                  prefixIcon: const Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: SwitchListTile(
                            title: const Text(
                              'Marcar como completada',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              _isCompleted
                                  ? 'La etapa está marcada como completada'
                                  : 'La etapa aún no está completada',
                            ),
                            value: _isCompleted,
                            onChanged: (value) {
                              setState(() {
                                _isCompleted = value;
                              });
                            },
                            activeColor: ColorPalette.vinoTinto,
                            secondary: Icon(
                              _isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: _isCompleted ? Colors.green : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Card de Observaciones
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
                              Icons.description,
                              color: Colors.purple.shade600,
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
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _observationsController,
                          decoration: InputDecoration(
                            labelText: 'Observaciones Adicionales',
                            hintText: 'Cualquier observación relevante sobre el embotellado...',
                            prefixIcon: const Icon(Icons.note),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          maxLines: 4,
                          textInputAction: TextInputAction.newline,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Botón Guardar
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveBottling,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.vinoTinto,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            _isEdit ? 'Actualizar Embotellado' : 'Crear Embotellado',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
