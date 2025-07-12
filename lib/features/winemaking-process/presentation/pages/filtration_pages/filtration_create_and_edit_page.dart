import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/filtration_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/datasources/filtration_stage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FiltrationCreateAndEditPage extends StatefulWidget {
  final String batchId;
  final FiltrationStageDto? initialData;

  const FiltrationCreateAndEditPage({
    super.key,
    required this.batchId,
    this.initialData,
  });

  @override
  State<FiltrationCreateAndEditPage> createState() =>
      _FiltrationCreateAndEditPageState();
}

class _FiltrationCreateAndEditPageState
    extends State<FiltrationCreateAndEditPage> {
  final FiltrationStageService _filtrationService = FiltrationStageService('/wine-batch');
  final _formKey = GlobalKey<FormState>();

  // Controllers para filtro
  late TextEditingController _filterTypeController;
  late TextEditingController _filtrationTypeController;
  late TextEditingController _filterMediaController;
  late TextEditingController _poreMicronsController;

  // Controllers para condiciones
  late TextEditingController _turbidityBeforeController;
  late TextEditingController _turbidityAfterController;
  late TextEditingController _temperatureController;
  late TextEditingController _pressureBarsController;
  late TextEditingController _filteredVolumeLitersController;

  // Controllers para fechas y observaciones
  late TextEditingController _startedAtController;
  late TextEditingController _completedAtController;
  late TextEditingController _completedByController;
  late TextEditingController _observationsController;
  late TextEditingController _changeReasonController;

  // Estados
  bool _isSterile = false;
  bool _filterChanged = false;
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
    _filterTypeController = TextEditingController();
    _filtrationTypeController = TextEditingController();
    _filterMediaController = TextEditingController();
    _poreMicronsController = TextEditingController();
    _turbidityBeforeController = TextEditingController();
    _turbidityAfterController = TextEditingController();
    _temperatureController = TextEditingController();
    _pressureBarsController = TextEditingController();
    _filteredVolumeLitersController = TextEditingController();
    _startedAtController = TextEditingController();
    _completedAtController = TextEditingController();
    _completedByController = TextEditingController();
    _observationsController = TextEditingController();
    _changeReasonController = TextEditingController();
  }

  void _loadInitialData() {
    if (_isEdit && widget.initialData != null) {
      final data = widget.initialData!;
      debugPrint('📊 [FILTRATION] Cargando datos iniciales: ${data.toString()}');
      
      _filterTypeController.text = data.filterType;
      _filtrationTypeController.text = data.filtrationType;
      _filterMediaController.text = data.filterMedia;
      _poreMicronsController.text = data.poreMicrons.toString();
      _turbidityBeforeController.text = data.turbidityBefore.toString();
      _turbidityAfterController.text = data.turbidityAfter.toString();
      _temperatureController.text = data.temperature.toString();
      _pressureBarsController.text = data.pressureBars.toString();
      _filteredVolumeLitersController.text = data.filteredVolumeLiters.toString();
      _changeReasonController.text = data.changeReason;
      
      _startedAtController.text = _formatDateForInput(data.startedAt);
      _completedAtController.text = _formatDateForInput(data.completedAt);
      _completedByController.text = data.completedBy;
      _observationsController.text = data.observations;
      
      _isSterile = data.isSterile;
      _filterChanged = data.filterChanged;
      _isCompleted = data.isCompleted;
    } else {
      // Valores por defecto para nueva etapa
      _startedAtController.text = _formatDate(DateTime.now());
      _poreMicronsController.text = '0.0';
      _turbidityBeforeController.text = '0.0';
      _turbidityAfterController.text = '0.0';
      _temperatureController.text = '0.0';
      _pressureBarsController.text = '0.0';
      _filteredVolumeLitersController.text = '0.0';
    }
  }

  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) {
      debugPrint('🗓️ [FILTRATION] dateStr está vacío');
      return null;
    }
    
    try {
      debugPrint('🗓️ [FILTRATION] Intentando parsear: "$dateStr"');
      
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
            debugPrint('🗓️ [FILTRATION] Fecha parseada con formato dd/MM/yyyy: $result');
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
            debugPrint('🗓️ [FILTRATION] Fecha parseada con formato dd-MM-yyyy: $result');
            return result;
          }
        }
      }
      
      // Intentar formato ISO o con T
      if (cleanedDateStr.contains('T')) {
        final result = DateTime.parse(cleanedDateStr);
        debugPrint('🗓️ [FILTRATION] Fecha parseada con formato ISO: $result');
        return result;
      }
      
    } catch (e) {
      debugPrint('❌ [FILTRATION] Error parseando fecha "$dateStr": $e');
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
      debugPrint('❌ [FILTRATION] Error formateando fecha para input: $e');
      return dateString;
    }
  }

  String _formatDateForApi(String dateString) {
    if (dateString.isEmpty) return '';
    
    try {
      DateTime? date = _parseDate(dateString);
      if (date != null) {
        String formatted = _formatDate(date);
        debugPrint('🔄 [FILTRATION] Formateando para API: "$dateString" -> "$formatted"');
        return formatted;
      }
      debugPrint('⚠️ [FILTRATION] No se pudo parsear fecha: "$dateString", devolviendo original');
      return dateString;
    } catch (e) {
      debugPrint('❌ [FILTRATION] Error formateando fecha para API: $e');
      return dateString;
    }
  }

  @override
  void dispose() {
    _filterTypeController.dispose();
    _filtrationTypeController.dispose();
    _filterMediaController.dispose();
    _poreMicronsController.dispose();
    _turbidityBeforeController.dispose();
    _turbidityAfterController.dispose();
    _temperatureController.dispose();
    _pressureBarsController.dispose();
    _filteredVolumeLitersController.dispose();
    _startedAtController.dispose();
    _completedAtController.dispose();
    _completedByController.dispose();
    _observationsController.dispose();
    _changeReasonController.dispose();
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

  Future<void> _saveFiltration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('🔄 [FILTRATION] Iniciando guardado de filtración...');
      debugPrint('🔄 [FILTRATION] Es edición: $_isEdit');

      Map<String, dynamic> filtrationMap;

      if (_isEdit) {
        // Payload para EDITAR - estructura específica para edición
        final String formattedCompletedAt = _isCompleted 
            ? _formatDateForApi(_completedAtController.text.isNotEmpty 
                ? _completedAtController.text 
                : _formatDate(DateTime.now()))
            : '';

        debugPrint('🗓️ [FILTRATION] CompletedAt original: "${widget.initialData?.completedAt ?? ''}"');
        debugPrint('🗓️ [FILTRATION] CompletedAt formateado: "$formattedCompletedAt"');

        filtrationMap = {
          'batchId': widget.batchId,
          'stageType': 'filtration',
          'startedAt': _formatDateForApi(_startedAtController.text.trim()),
          'completedAt': formattedCompletedAt,
          'completedBy': _completedByController.text.trim(),
          'observations': _observationsController.text.trim(),
          'isCompleted': _isCompleted,
          'filterType': _filterTypeController.text.trim(),
          'filtrationType': _filtrationTypeController.text.trim(),
          'filterMedia': _filterMediaController.text.trim(),
          'poreMicrons': double.tryParse(_poreMicronsController.text.trim()) ?? 0.0,
          'turbidityBefore': double.tryParse(_turbidityBeforeController.text.trim()) ?? 0.0,
          'turbidityAfter': double.tryParse(_turbidityAfterController.text.trim()) ?? 0.0,
          'temperature': double.tryParse(_temperatureController.text.trim()) ?? 0.0,
          'pressureBars': double.tryParse(_pressureBarsController.text.trim()) ?? 0.0,
          'filteredVolumeLiters': double.tryParse(_filteredVolumeLitersController.text.trim()) ?? 0.0,
          'isSterile': _isSterile,
          'filterChanged': _filterChanged,
          'changeReason': _changeReasonController.text.trim(),
        };
      } else {
        // Payload para CREAR - estructura específica para creación
        filtrationMap = {
          'wineBatchId': widget.batchId,
          'filtrationType': _filtrationTypeController.text.trim(),
          'filterMedia': _filterMediaController.text.trim(),
          'poreMicrons': double.tryParse(_poreMicronsController.text.trim()) ?? 0.0,
          'turbidityBefore': double.tryParse(_turbidityBeforeController.text.trim()) ?? 0.0,
          'turbidityAfter': double.tryParse(_turbidityAfterController.text.trim()) ?? 0.0,
          'temperature': double.tryParse(_temperatureController.text.trim()) ?? 0.0,
          'pressureBars': double.tryParse(_pressureBarsController.text.trim()) ?? 0.0,
          'filteredVolumeLiters': double.tryParse(_filteredVolumeLitersController.text.trim()) ?? 0.0,
          'isSterile': _isSterile,
          'filterChanged': _filterChanged,
          'changeReason': _changeReasonController.text.trim(),
          'startedAt': _formatDateForApi(_startedAtController.text.trim()),
          'completedBy': _completedByController.text.trim(),
          'observations': _observationsController.text.trim(),
        };
      }

      debugPrint('📦 [FILTRATION] Payload completo: $filtrationMap');

      FiltrationStageDto result;
      if (_isEdit) {
        debugPrint('🔄 [FILTRATION] Llamando updateFiltrationStage service');
        result = await _filtrationService.update(widget.batchId, filtrationMap);
        debugPrint('✅ [FILTRATION] Etapa actualizada exitosamente: ${result.toString()}');
      } else {
        debugPrint('🔄 [FILTRATION] Llamando createFiltrationStage service');
        result = await _filtrationService.create(widget.batchId, filtrationMap);
        debugPrint('✅ [FILTRATION] Nueva etapa creada exitosamente: ${result.toString()}');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEdit 
                  ? 'Etapa de filtración actualizada correctamente'
                  : 'Etapa de filtración creada correctamente',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        
        debugPrint('🔄 [FILTRATION] Navegando de vuelta con resultado: ${result.toString()}');
        Navigator.of(context).pop(result);
      }
    } catch (e) {
      debugPrint('❌ [FILTRATION] Error al guardar la etapa de filtración: $e');
      debugPrint('❌ [FILTRATION] Tipo de error: ${e.runtimeType}');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al ${_isEdit ? 'actualizar' : 'crear'} la etapa: ${e.toString()}'),
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPalette.vinoTinto,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            _isEdit ? 'Editar Filtración' : 'Crear Filtración',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              debugPrint('🔄 [FILTRATION] Saliendo sin guardar cambios');
              Navigator.of(context).pop();
            },
            tooltip: 'Volver sin guardar',
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Card de Configuración del Filtro
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
                              Icons.tune,
                              color: Colors.indigo.shade600,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Configuración del Filtro',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Campo filterType solo para edición
                        if (_isEdit) ...[
                          TextFormField(
                            controller: _filterTypeController,
                            decoration: InputDecoration(
                              labelText: 'Tipo de Filtro',
                              hintText: 'Ej: Cartucho, Membrana, Placa',
                              prefixIcon: const Icon(Icons.category),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                        
                        TextFormField(
                          controller: _filtrationTypeController,
                          decoration: InputDecoration(
                            labelText: 'Método de Filtración',
                            hintText: 'Ej: Microfiltración, Ultrafiltración',
                            prefixIcon: const Icon(Icons.settings),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Este campo es obligatorio';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _filterMediaController,
                          decoration: InputDecoration(
                            labelText: 'Medio Filtrante',
                            hintText: 'Ej: Celulosa, PVDF, Nylon',
                            prefixIcon: const Icon(Icons.layers),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Este campo es obligatorio';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _poreMicronsController,
                          decoration: InputDecoration(
                            labelText: 'Tamaño de Poro (μm)',
                            hintText: 'Ej: 0.22, 0.45, 1.0',
                            prefixIcon: const Icon(Icons.grain),
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
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Este campo es obligatorio';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Card de Condiciones de Proceso
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
                              Icons.speed,
                              color: Colors.teal.shade600,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Condiciones de Proceso',
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
                                controller: _turbidityBeforeController,
                                decoration: InputDecoration(
                                  labelText: 'Turbidez Inicial (NTU)',
                                  hintText: 'Ej: 5.2',
                                  prefixIcon: const Icon(Icons.trending_up),
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
                                controller: _turbidityAfterController,
                                decoration: InputDecoration(
                                  labelText: 'Turbidez Final (NTU)',
                                  hintText: 'Ej: 0.8',
                                  prefixIcon: const Icon(Icons.trending_down),
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
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _temperatureController,
                                decoration: InputDecoration(
                                  labelText: 'Temperatura (°C)',
                                  hintText: 'Ej: 18.5',
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
                                controller: _pressureBarsController,
                                decoration: InputDecoration(
                                  labelText: 'Presión (bar)',
                                  hintText: 'Ej: 2.5',
                                  prefixIcon: const Icon(Icons.compress),
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
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _filteredVolumeLitersController,
                          decoration: InputDecoration(
                            labelText: 'Volumen Filtrado (L)',
                            hintText: 'Ej: 1500.5',
                            prefixIcon: const Icon(Icons.local_drink),
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
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Card de Configuración de Calidad
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
                              Icons.analytics,
                              color: Colors.green.shade600,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Configuración de Calidad',
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
                          child: SwitchListTile(
                            title: const Text(
                              'Filtración Estéril',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: const Text('Filtro con capacidad de esterilización'),
                            value: _isSterile,
                            onChanged: (value) {
                              setState(() {
                                _isSterile = value;
                              });
                            },
                            activeColor: ColorPalette.vinoTinto,
                            secondary: Icon(
                              _isSterile ? Icons.shield : Icons.shield_outlined,
                              color: _isSterile ? Colors.green : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Card de Mantenimiento
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
                              Icons.build,
                              color: Colors.orange.shade600,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Mantenimiento del Filtro',
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
                          child: SwitchListTile(
                            title: const Text(
                              'Filtro Cambiado',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: const Text('¿Se cambió el filtro durante el proceso?'),
                            value: _filterChanged,
                            onChanged: (value) {
                              setState(() {
                                _filterChanged = value;
                              });
                            },
                            activeColor: ColorPalette.vinoTinto,
                            secondary: Icon(
                              _filterChanged ? Icons.check_circle : Icons.cancel,
                              color: _filterChanged ? Colors.green : Colors.grey,
                            ),
                          ),
                        ),
                        if (_filterChanged) ...[
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _changeReasonController,
                            decoration: InputDecoration(
                              labelText: 'Razón del Cambio',
                              hintText: 'Describe por qué se cambió el filtro',
                              prefixIcon: const Icon(Icons.info),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            maxLines: 3,
                          ),
                        ],
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
                            hintText: 'Cualquier observación relevante sobre la filtración...',
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
                    onPressed: _isLoading ? null : _saveFiltration,
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
                            _isEdit ? 'Actualizar Filtración' : 'Crear Filtración',
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
