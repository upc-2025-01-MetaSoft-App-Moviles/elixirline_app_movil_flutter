import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/utils/color_pallet.dart';
import '../../../data/models/fermentation_stage_dto.dart';
import '../../../data/datasources/fermentation_stage_service.dart';

class FermentationCreateAndEditPage extends StatefulWidget {
  final FermentationStageDto? initialData;
  final String wineBatchId;

  const FermentationCreateAndEditPage({
    super.key,
    this.initialData,
    required this.wineBatchId,
  });

  @override
  State<FermentationCreateAndEditPage> createState() =>
      _FermentationCreateAndEditPageState();
}

class _FermentationCreateAndEditPageState
    extends State<FermentationCreateAndEditPage> {
  final _formKey = GlobalKey<FormState>();
  final FermentationStageService _stageService = FermentationStageService('/wine-batch');

  // Controllers
  late final TextEditingController _startedAtController;
  late final TextEditingController _completedByController;
  late final TextEditingController _fermentationTypeController;
  late final TextEditingController _tankCodeController;
  late final TextEditingController _yeastUsedController;
  late final TextEditingController _temperatureMinController;
  late final TextEditingController _temperatureMaxController;
  late final TextEditingController _initialPhController;
  late final TextEditingController _finalPhController;
  late final TextEditingController _initialSugarLevelController;
  late final TextEditingController _finalSugarLevelController;
  late final TextEditingController _observationsController;

  bool _isLoading = false;
  bool _isCompleted = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadInitialData();
  }

  void _initializeControllers() {
    _startedAtController = TextEditingController();
    _completedByController = TextEditingController();
    _fermentationTypeController = TextEditingController();
    _tankCodeController = TextEditingController();
    _yeastUsedController = TextEditingController();
    _temperatureMinController = TextEditingController();
    _temperatureMaxController = TextEditingController();
    _initialPhController = TextEditingController();
    _finalPhController = TextEditingController();
    _initialSugarLevelController = TextEditingController();
    _finalSugarLevelController = TextEditingController();
    _observationsController = TextEditingController();
  }

  void _loadInitialData() {
    if (widget.initialData != null) {
      final data = widget.initialData!;
      
      // Procesar fecha preservando la existente con mejor manejo de errores
      if (data.startedAt.isNotEmpty) {
        if (kDebugMode) {
          print('🗓️ [FERMENTATION] Fecha recibida del backend: "${data.startedAt}"');
        }
        final parsedDate = _parseDate(data.startedAt);
        if (parsedDate != null) {
          _selectedDate = parsedDate;
          _startedAtController.text = _formatDate(parsedDate);
          if (kDebugMode) {
            print('🗓️ [FERMENTATION] Fecha parseada y formateada: ${_formatDate(parsedDate)}');
          }
        } else {
          if (kDebugMode) {
            print('❌ [FERMENTATION] No se pudo parsear la fecha: "${data.startedAt}"');
          }
          // Si no se puede parsear, usar fecha actual como fallback
          _selectedDate = DateTime.now();
          _startedAtController.text = _formatDate(_selectedDate!);
        }
      } else {
        if (kDebugMode) {
          print('🗓️ [FERMENTATION] No hay fecha inicial, usando fecha actual');
        }
        _selectedDate = DateTime.now();
        _startedAtController.text = _formatDate(_selectedDate!);
      }

      // Cargar datos existentes
      _completedByController.text = data.completedBy;
      _fermentationTypeController.text = data.fermentationType;
      _tankCodeController.text = data.tankCode;
      _yeastUsedController.text = data.yeastUsed;
      _temperatureMinController.text = data.temperatureMin.toString();
      _temperatureMaxController.text = data.temperatureMax.toString();
      _initialPhController.text = data.initialPh.toString();
      _finalPhController.text = data.finalPh.toString();
      _initialSugarLevelController.text = data.initialSugarLevel.toString();
      _finalSugarLevelController.text = data.finalSugarLevel.toString();
      _observationsController.text = data.observations;
      _isCompleted = data.isCompleted;
    } else {
      // Datos por defecto para nueva etapa
      if (kDebugMode) {
        print('🗓️ [FERMENTATION] Nueva etapa, usando fecha actual');
      }
      _selectedDate = DateTime.now();
      _startedAtController.text = _formatDate(_selectedDate!);
    }
  }

  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) {
      if (kDebugMode) {
        print('🗓️ [FERMENTATION] dateStr está vacío');
      }
      return null;
    }
    
    try {
      if (kDebugMode) {
        print('🗓️ [FERMENTATION] Intentando parsear: "$dateStr"');
      }
      
      // Intentar formato dd/MM/yyyy
      if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final year = int.tryParse(parts[2]);
          if (day != null && month != null && year != null) {
            final result = DateTime(year, month, day);
            if (kDebugMode) {
              print('🗓️ [FERMENTATION] Fecha parseada con formato dd/MM/yyyy: $result');
            }
            return result;
          }
        }
      }
      
      // Intentar formato ISO (yyyy-MM-dd o yyyy-MM-ddTHH:mm:ss)
      if (dateStr.contains('-')) {
        final result = DateTime.parse(dateStr);
        if (kDebugMode) {
          print('🗓️ [FERMENTATION] Fecha parseada con formato ISO: $result');
        }
        return result;
      }
      
      // Intentar parse directo
      final result = DateTime.parse(dateStr);
      if (kDebugMode) {
        print('🗓️ [FERMENTATION] Fecha parseada con parse directo: $result');
      }
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('❌ [FERMENTATION] Error parseando fecha "$dateStr": $e');
      }
      return null;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
      setState(() {
        _selectedDate = picked;
        _startedAtController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Validar fecha requerida
      if (_selectedDate == null) {
        throw Exception('La fecha de inicio es requerida');
      }

      // Convertir la fecha al formato requerido por el backend (dd/MM/yyyy)
      String startedAt = _formatDate(_selectedDate!);

      Map<String, dynamic> stageMap;
      
      if (widget.initialData == null) {
        // Estructura para CREAR nueva etapa
        stageMap = {
          'yeastUsed': _yeastUsedController.text.trim().isEmpty ? null : _yeastUsedController.text.trim(),
          'initialBrix': _initialSugarLevelController.text.trim().isEmpty ? null : double.tryParse(_initialSugarLevelController.text.trim()),
          'finalBrix': _finalSugarLevelController.text.trim().isEmpty ? null : double.tryParse(_finalSugarLevelController.text.trim()),
          'initialPh': _initialPhController.text.trim().isEmpty ? null : double.tryParse(_initialPhController.text.trim()),
          'finalPh': _finalPhController.text.trim().isEmpty ? null : double.tryParse(_finalPhController.text.trim()),
          'temperatureMax': _temperatureMaxController.text.trim().isEmpty ? null : double.tryParse(_temperatureMaxController.text.trim()),
          'temperatureMin': _temperatureMinController.text.trim().isEmpty ? null : double.tryParse(_temperatureMinController.text.trim()),
          'fermentationType': _fermentationTypeController.text.trim().isEmpty ? null : _fermentationTypeController.text.trim(),
          'tankCode': _tankCodeController.text.trim().isEmpty ? null : _tankCodeController.text.trim(),
          'startedAt': startedAt,
          'completedBy': _completedByController.text.trim().isEmpty ? null : _completedByController.text.trim(),
          'observations': _observationsController.text.trim().isEmpty ? null : _observationsController.text.trim(),
        };
      } else {
        // Parsear y formatear correctamente la fecha completedAt 
        String formattedCompletedAt = '';
        if (widget.initialData?.completedAt != null && widget.initialData!.completedAt.isNotEmpty) {
          try {
            // Intentar parsear la fecha existente y convertirla al formato correcto
            DateTime? completedDate = _parseDate(widget.initialData!.completedAt);
            if (completedDate != null) {
              formattedCompletedAt = _formatDate(completedDate);
            } else {
              // Si no se puede parsear, usar la fecha actual
              formattedCompletedAt = _formatDate(DateTime.now());
            }
          } catch (e) {
            debugPrint('⚠️ [FERMENTATION] Error parseando completedAt: $e');
            formattedCompletedAt = _formatDate(DateTime.now());
          }
        } else {
          // Si no hay fecha de completado, usar la fecha actual
          formattedCompletedAt = _formatDate(DateTime.now());
        }
        
        // Estructura para EDITAR etapa existente (incluir todos los campos requeridos)
        stageMap = {
          'startedAt': startedAt,
          'completedAt': formattedCompletedAt,
          'completedBy': _completedByController.text.trim(),
          'isCompleted': _isCompleted,
          'yeastUsed': _yeastUsedController.text.trim(),
          'initialSugarLevel': _initialSugarLevelController.text.trim().isEmpty ? 0.0 : double.tryParse(_initialSugarLevelController.text.trim()) ?? 0.0,
          'finalSugarLevel': _finalSugarLevelController.text.trim().isEmpty ? 0.0 : double.tryParse(_finalSugarLevelController.text.trim()) ?? 0.0,
          'initialPh': _initialPhController.text.trim().isEmpty ? 0.0 : double.tryParse(_initialPhController.text.trim()) ?? 0.0,
          'finalPh': _finalPhController.text.trim().isEmpty ? 0.0 : double.tryParse(_finalPhController.text.trim()) ?? 0.0,
          'temperatureMin': _temperatureMinController.text.trim().isEmpty ? 0.0 : double.tryParse(_temperatureMinController.text.trim()) ?? 0.0,
          'temperatureMax': _temperatureMaxController.text.trim().isEmpty ? 0.0 : double.tryParse(_temperatureMaxController.text.trim()) ?? 0.0,
          'fermentationType': _fermentationTypeController.text.trim(),
          'tankCode': _tankCodeController.text.trim(),
          'observations': _observationsController.text.trim(),
        };
      }

      if (kDebugMode) {
        print('📤 [FERMENTATION] Datos a enviar: $stageMap');
        print('📤 [FERMENTATION] WineBatchId: ${widget.wineBatchId}');
        print('📤 [FERMENTATION] Es edición: ${widget.initialData != null}');
        print('📤 [FERMENTATION] Fecha seleccionada: $_selectedDate');
        print('📤 [FERMENTATION] Fecha formateada startedAt: $startedAt');
        if (widget.initialData != null) {
          print('📤 [FERMENTATION] CompletedAt original: ${widget.initialData?.completedAt}');
          print('📤 [FERMENTATION] CompletedAt formateado: ${stageMap['completedAt']}');
        }
        print('📤 [FERMENTATION] URL base del servicio: /wine-batch');
        print('📤 [FERMENTATION] URL completa para update: /wine-batch/${widget.wineBatchId}/fermentation');
      }

      FermentationStageDto result;
      if (widget.initialData == null) {
        // Crear nueva etapa
        result = await _stageService.create(widget.wineBatchId, stageMap);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Etapa de fermentación creada correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Actualizar etapa existente
        if (kDebugMode) {
          print('🔄 [FERMENTATION] Iniciando actualización de etapa existente...');
          print('🔄 [FERMENTATION] Payload completo: $stageMap');
        }
        
        result = await _stageService.update(widget.wineBatchId, stageMap);
        
        if (kDebugMode) {
          print('✅ [FERMENTATION] Etapa actualizada correctamente');
          print('✅ [FERMENTATION] StartedAt=${result.startedAt}, IsCompleted=${result.isCompleted}');
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fermentación actualizada exitosamente'),
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
      if (kDebugMode) {
        print('❌ [FERMENTATION] Error al guardar la etapa de fermentación: $e');
        print('❌ [FERMENTATION] Tipo de error: ${e.runtimeType}');
      }
      
      String errorMessage = 'Error desconocido';
      if (e.toString().contains('es requerido') || 
          e.toString().contains('debe ser') ||
          e.toString().contains('debe estar') ||
          e.toString().contains('no puede ser')) {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      } else if (e.toString().contains('HttpException')) {
        errorMessage = 'Error de conexión con el servidor';
      } else if (e.toString().contains('SocketException')) {
        errorMessage = 'Error de red. Verifique su conexión a internet';
      } else if (e.toString().contains('FormatException')) {
        errorMessage = 'Error en el formato de los datos';
      } else {
        errorMessage = 'Error al guardar la etapa: ${e.toString()}';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
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
    _completedByController.dispose();
    _fermentationTypeController.dispose();
    _tankCodeController.dispose();
    _yeastUsedController.dispose();
    _temperatureMinController.dispose();
    _temperatureMaxController.dispose();
    _initialPhController.dispose();
    _finalPhController.dispose();
    _initialSugarLevelController.dispose();
    _finalSugarLevelController.dispose();
    _observationsController.dispose();
    super.dispose();
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
            widget.initialData == null 
                ? 'Nueva Etapa de Fermentación'
                : 'Editar Fermentación',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                // Card de información general
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  shadowColor: ColorPalette.vinoTinto.withOpacity(0.2),
                  color: Colors.grey.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header de la sección
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: ColorPalette.vinoTinto.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.info_outline,
                                color: ColorPalette.vinoTinto,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Información General',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: ColorPalette.vinoTinto,
                                    ),
                                  ),
                                  Text(
                                    'Datos básicos de la fermentación',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Fecha de inicio
                        _buildInputField(
                          controller: _startedAtController,
                          label: 'Fecha de Inicio',
                          isRequired: true,
                          icon: Icons.calendar_today_outlined,
                          readOnly: true,
                          onTap: _selectDate,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.date_range, color: ColorPalette.vinoTinto),
                            onPressed: _selectDate,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'La fecha de inicio es requerida';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Responsable
                        _buildInputField(
                          controller: _completedByController,
                          label: 'Responsable',
                          isRequired: true,
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El responsable es requerido';
                            }
                            return null;
                          },
                        ),
                        
                        // Estado de completado (solo al editar)
                        if (widget.initialData != null) ...[
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _isCompleted 
                                  ? Colors.green.withOpacity(0.1) 
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _isCompleted 
                                    ? Colors.green.withOpacity(0.3) 
                                    : Colors.orange.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _isCompleted ? Icons.check_circle : Icons.access_time,
                                  color: _isCompleted ? Colors.green : Colors.orange,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Estado de la Etapa',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _isCompleted ? Colors.green.shade700 : Colors.orange.shade700,
                                        ),
                                      ),
                                      Text(
                                        _isCompleted ? 'Etapa completada' : 'En progreso',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _isCompleted ? Colors.green.shade600 : Colors.orange.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: _isCompleted,
                                  onChanged: (value) {
                                    setState(() {
                                      _isCompleted = value;
                                    });
                                  },
                                  activeColor: Colors.green,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Card de parámetros de fermentación
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  shadowColor: ColorPalette.vinoTinto.withOpacity(0.2),
                  color: Colors.grey.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header de la sección
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
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Parámetros de Fermentación',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: ColorPalette.vinoTinto,
                                    ),
                                  ),
                                  Text(
                                    'Configuración técnica del proceso',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Tipo de fermentación y tanque
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputField(
                                controller: _fermentationTypeController,
                                label: 'Tipo de Fermentación',
                                icon: Icons.bubble_chart,
                                isRequired: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'El tipo es requerido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInputField(
                                controller: _tankCodeController,
                                label: 'Código del Tanque',
                                icon: Icons.storage,
                                isRequired: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'El código es requerido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Levadura
                        _buildInputField(
                          controller: _yeastUsedController,
                          label: 'Levadura Utilizada',
                          icon: Icons.grain,
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'La levadura es requerida';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Temperaturas
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputField(
                                controller: _temperatureMinController,
                                label: 'Temperatura Mín. (°C)',
                                icon: Icons.thermostat,
                                isNumber: true,
                                validator: (value) {
                                  if (value != null && value.trim().isNotEmpty) {
                                    final temp = double.tryParse(value.trim());
                                    if (temp == null) return 'Número inválido';
                                    if (temp < 0 || temp > 50) return 'Temperatura inválida';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInputField(
                                controller: _temperatureMaxController,
                                label: 'Temperatura Máx. (°C)',
                                icon: Icons.thermostat,
                                isNumber: true,
                                validator: (value) {
                                  if (value != null && value.trim().isNotEmpty) {
                                    final temp = double.tryParse(value.trim());
                                    if (temp == null) return 'Número inválido';
                                    if (temp < 0 || temp > 50) return 'Temperatura inválida';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // pH valores
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputField(
                                controller: _initialPhController,
                                label: 'pH Inicial',
                                icon: Icons.science,
                                isNumber: true,
                                validator: (value) {
                                  if (value != null && value.trim().isNotEmpty) {
                                    final ph = double.tryParse(value.trim());
                                    if (ph == null) return 'Número inválido';
                                    if (ph < 0 || ph > 14) return 'pH debe estar entre 0-14';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInputField(
                                controller: _finalPhController,
                                label: 'pH Final',
                                icon: Icons.science,
                                isNumber: true,
                                validator: (value) {
                                  if (value != null && value.trim().isNotEmpty) {
                                    final ph = double.tryParse(value.trim());
                                    if (ph == null) return 'Número inválido';
                                    if (ph < 0 || ph > 14) return 'pH debe estar entre 0-14';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Niveles de azúcar
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputField(
                                controller: _initialSugarLevelController,
                                label: 'Azúcar Inicial (°Brix)',
                                icon: Icons.water_drop,
                                isNumber: true,
                                validator: (value) {
                                  if (value != null && value.trim().isNotEmpty) {
                                    final sugar = double.tryParse(value.trim());
                                    if (sugar == null) return 'Número inválido';
                                    if (sugar < 0) return 'Debe ser positivo';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInputField(
                                controller: _finalSugarLevelController,
                                label: 'Azúcar Final (°Brix)',
                                icon: Icons.water_drop,
                                isNumber: true,
                                validator: (value) {
                                  if (value != null && value.trim().isNotEmpty) {
                                    final sugar = double.tryParse(value.trim());
                                    if (sugar == null) return 'Número inválido';
                                    if (sugar < 0) return 'Debe ser positivo';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Card de observaciones
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  shadowColor: ColorPalette.vinoTinto.withOpacity(0.2),
                  color: Colors.grey.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header de la sección
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: ColorPalette.vinoTinto.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.note_outlined,
                                color: ColorPalette.vinoTinto,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Observaciones',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: ColorPalette.vinoTinto,
                                    ),
                                  ),
                                  Text(
                                    'Notas adicionales del proceso',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Campo de observaciones
                        TextFormField(
                          controller: _observationsController,
                          decoration: InputDecoration(
                            labelText: 'Observaciones (opcional)',
                            labelStyle: TextStyle(color: ColorPalette.vinoTinto),
                            hintText: 'Describa cualquier observación relevante del proceso...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: ColorPalette.vinoTinto, width: 2),
                            ),
                            prefixIcon: Icon(Icons.notes, color: ColorPalette.vinoTinto),
                          ),
                          maxLines: 4,
                          maxLength: 500,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Botones de acción
                if (widget.initialData == null) 
                  // Para creación: mostrar ambos botones
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: ColorPalette.vinoTinto),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              color: ColorPalette.vinoTinto,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _onSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalette.vinoTinto,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
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
                              : const Text(
                                  'Crear Etapa',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  )
                else
                  // Para edición: solo mostrar botón de actualizar
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.vinoTinto,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
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
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.update),
                                const SizedBox(width: 8),
                                Text(
                                  'Actualizar Fermentación',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isRequired = false,
    bool isNumber = false,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        labelStyle: TextStyle(color: ColorPalette.vinoTinto),
        prefixIcon: Icon(icon, color: ColorPalette.vinoTinto),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorPalette.vinoTinto, width: 2),
        ),
        filled: readOnly,
        fillColor: readOnly ? Colors.grey.shade100 : null,
      ),
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: isNumber 
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      inputFormatters: isNumber 
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))]
          : null,
      validator: validator,
    );
  }
}
