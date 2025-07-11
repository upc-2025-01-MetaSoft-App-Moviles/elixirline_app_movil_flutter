import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/datasources/fermentation_stage_service.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/fermentation_stage_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FermentationCreateAndEditPage extends StatefulWidget {
  final String batchId;
  final FermentationStageDto? initialData;

  const FermentationCreateAndEditPage({
    super.key,
    required this.batchId,
    this.initialData,
  });

  @override
  State<FermentationCreateAndEditPage> createState() => _FermentationCreateAndEditPageState();
}

class _FermentationCreateAndEditPageState extends State<FermentationCreateAndEditPage> {
  final _fermentationStageService = FermentationStageService('/wine-batch');
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _yeastUsedController;
  late final TextEditingController _initialSugarLevelController;
  late final TextEditingController _finalSugarLevelController;
  late final TextEditingController _initialPhController;
  late final TextEditingController _finalPhController;
  late final TextEditingController _temperatureMaxController;
  late final TextEditingController _temperatureMinController;
  late final TextEditingController _fermentationTypeController;
  late final TextEditingController _tankCodeController;
  late final TextEditingController _startedAtController;
  late final TextEditingController _completedByController;
  late final TextEditingController _observationsController;

  DateTime? _selectedDate;
  bool _isLoading = false;
  bool _isCompleted = true; // Estado de completado para edición

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _yeastUsedController = TextEditingController(
      text: widget.initialData?.yeastUsed ?? '',
    );
    _initialSugarLevelController = TextEditingController(
      text: widget.initialData?.initialSugarLevel != null && widget.initialData!.initialSugarLevel > 0 
          ? widget.initialData!.initialSugarLevel.toString() 
          : '',
    );
    _finalSugarLevelController = TextEditingController(
      text: widget.initialData?.finalSugarLevel != null && widget.initialData!.finalSugarLevel > 0 
          ? widget.initialData!.finalSugarLevel.toString() 
          : '',
    );
    _initialPhController = TextEditingController(
      text: widget.initialData?.initialPh != null && widget.initialData!.initialPh > 0 
          ? widget.initialData!.initialPh.toString() 
          : '',
    );
    _finalPhController = TextEditingController(
      text: widget.initialData?.finalPh != null && widget.initialData!.finalPh > 0 
          ? widget.initialData!.finalPh.toString() 
          : '',
    );
    _temperatureMaxController = TextEditingController(
      text: widget.initialData?.temperatureMax != null 
          ? widget.initialData!.temperatureMax.toString() 
          : '',
    );
    _temperatureMinController = TextEditingController(
      text: widget.initialData?.temperatureMin != null 
          ? widget.initialData!.temperatureMin.toString() 
          : '',
    );
    _fermentationTypeController = TextEditingController(
      text: widget.initialData?.fermentationType ?? '',
    );
    _tankCodeController = TextEditingController(
      text: widget.initialData?.tankCode ?? '',
    );
    _startedAtController = TextEditingController(
      text: widget.initialData?.startedAt ?? '',
    );
    _completedByController = TextEditingController(
      text: widget.initialData?.completedBy ?? '',
    );
    _observationsController = TextEditingController(
      text: widget.initialData?.observations ?? '',
    );

    // Parseamos la fecha inicial si existe y mostrarla en formato legible
    if (widget.initialData?.startedAt.isNotEmpty == true) {
      final dateStr = widget.initialData!.startedAt;
      if (kDebugMode) {
        print('🗓️ [FERMENTATION] Fecha recibida del backend: "$dateStr"');
      }
      
      _selectedDate = _parseDate(dateStr);
      if (_selectedDate != null) {
        _startedAtController.text = _formatDate(_selectedDate!);
        if (kDebugMode) {
          print('🗓️ [FERMENTATION] Fecha parseada y formateada: ${_formatDate(_selectedDate!)}');
        }
      } else {
        if (kDebugMode) {
          print('❌ [FERMENTATION] No se pudo parsear la fecha');
        }
        _startedAtController.text = '';
      }
    }

    // Inicializar estado de completado
    _isCompleted = widget.initialData?.isCompleted ?? true;
  }

  @override
  void dispose() {
    _yeastUsedController.dispose();
    _initialSugarLevelController.dispose();
    _finalSugarLevelController.dispose();
    _initialPhController.dispose();
    _finalPhController.dispose();
    _temperatureMaxController.dispose();
    _temperatureMinController.dispose();
    _fermentationTypeController.dispose();
    _tankCodeController.dispose();
    _startedAtController.dispose();
    _completedByController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  // Función para parsear fecha desde diferentes formatos
  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) return null;
    
    try {
      // Intentar formato dd/MM/yyyy
      if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      }
      
      // Intentar formato ISO (yyyy-MM-dd o yyyy-MM-ddTHH:mm:ss)
      if (dateStr.contains('-')) {
        return DateTime.parse(dateStr);
      }
      
      // Intentar parse directo
      return DateTime.parse(dateStr);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error parseando fecha "$dateStr": $e');
      }
      return null;
    }
  }

  // Función para formatear fecha para mostrar al usuario (dd/MM/yyyy)
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
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

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Mostrar la fecha en formato legible al usuario
        _startedAtController.text = _formatDate(picked);
      });
    }
  }

  // Función utilitaria para validar y parsear números de forma segura
  double _parseDouble(String value, String fieldName) {
    if (value.trim().isEmpty) {
      throw Exception('$fieldName es requerido');
    }
    
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      throw Exception('$fieldName debe ser un número válido');
    }
    
    return parsed;
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Validar que los campos numéricos tengan valores válidos
      double initialSugarLevel;
      double finalSugarLevel;
      double initialPh;
      double finalPh;
      double temperatureMax;
      double temperatureMin;

      try {
        initialSugarLevel = _parseDouble(_initialSugarLevelController.text, 'Nivel inicial de azúcar');
        finalSugarLevel = _parseDouble(_finalSugarLevelController.text, 'Nivel final de azúcar');
        initialPh = _parseDouble(_initialPhController.text, 'pH inicial');
        finalPh = _parseDouble(_finalPhController.text, 'pH final');
        temperatureMax = _parseDouble(_temperatureMaxController.text, 'Temperatura máxima');
        temperatureMin = _parseDouble(_temperatureMinController.text, 'Temperatura mínima');
        
        // Validaciones adicionales
        if (initialPh < 0 || initialPh > 14) {
          throw Exception('El pH inicial debe estar entre 0 y 14');
        }
        if (finalPh < 0 || finalPh > 14) {
          throw Exception('El pH final debe estar entre 0 y 14');
        }
        if (initialSugarLevel < 0) {
          throw Exception('El nivel inicial de azúcar debe ser mayor o igual a 0');
        }
        if (finalSugarLevel < 0) {
          throw Exception('El nivel final de azúcar debe ser mayor o igual a 0');
        }
        if (temperatureMin > temperatureMax) {
          throw Exception('La temperatura mínima no puede ser mayor que la máxima');
        }
      } catch (e) {
        throw Exception(e.toString().replaceFirst('Exception: ', ''));
      }

      // Validar campos de texto requeridos
      final yeastUsed = _yeastUsedController.text.trim();
      final fermentationType = _fermentationTypeController.text.trim();
      final tankCode = _tankCodeController.text.trim();
      final startedAtRaw = _startedAtController.text.trim();
      final completedBy = _completedByController.text.trim();
      final observations = _observationsController.text.trim();

      if (yeastUsed.isEmpty) {
        throw Exception('El campo "Levadura utilizada" es requerido');
      }
      if (fermentationType.isEmpty) {
        throw Exception('El tipo de fermentación es requerido');
      }
      if (tankCode.isEmpty) {
        throw Exception('El código del tanque es requerido');
      }
      if (startedAtRaw.isEmpty) {
        throw Exception('La fecha de inicio es requerida');
      }
      if (completedBy.isEmpty) {
        throw Exception('El campo "Realizado por" es requerido');
      }

      // Convertir la fecha al formato requerido por el backend (dd/MM/yyyy)
      String startedAt;
      if (_selectedDate != null) {
        startedAt = _formatDate(_selectedDate!);
      } else {
        throw Exception('Debe seleccionar una fecha válida');
      }

      Map<String, dynamic> data;
      
      if (widget.initialData == null) {
        // Estructura para CREAR nueva etapa
        data = {
          'yeastUsed': yeastUsed,
          'initialSugarLevel': initialSugarLevel,
          'finalSugarLevel': finalSugarLevel,
          'initialPh': initialPh,
          'finalPh': finalPh,
          'temperatureMax': temperatureMax,
          'temperatureMin': temperatureMin,
          'fermentationType': fermentationType,
          'tankCode': tankCode,
          'startedAt': startedAt,
          'completedBy': completedBy,
          'observations': observations,
        };
      } else {
        // Estructura para EDITAR etapa existente (usar PascalCase)
        data = {
          'YeastUsed': yeastUsed,
          'InitialSugarLevel': initialSugarLevel,
          'FinalSugarLevel': finalSugarLevel,
          'InitialPh': initialPh,
          'FinalPh': finalPh,
          'TemperatureMax': temperatureMax,
          'TemperatureMin': temperatureMin,
          'FermentationType': fermentationType,
          'TankCode': tankCode,
          'StartedAt': startedAt,
          'CompletedBy': completedBy,
          'IsCompleted': _isCompleted,
          'Observations': observations,
        };
      }

      if (kDebugMode) {
        print('📤 Datos a enviar: $data');
        print('📤 BatchId: ${widget.batchId}');
        print('📤 Es edición: ${widget.initialData != null}');
      }

      FermentationStageDto result;
      if (widget.initialData == null) {
        // Crear nueva etapa
        result = await _fermentationStageService.create(widget.batchId, data);
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
        result = await _fermentationStageService.update(widget.batchId, data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Etapa de fermentación actualizada correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context, result);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al guardar la etapa de fermentación: $e');
        print('❌ Tipo de error: ${e.runtimeType}');
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: ColorPalette.vinoTinto,
        foregroundColor: Colors.white,
        title: Text(
          widget.initialData == null 
              ? 'Crear Etapa de Fermentación' 
              : 'Editar Etapa de Fermentación',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ColorPalette.vinoTinto.withOpacity(0.1), Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.science_outlined,
                        size: 48,
                        color: ColorPalette.vinoTinto,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.initialData == null 
                            ? 'Nueva Etapa de Fermentación'
                            : 'Editando Etapa de Fermentación',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.vinoTinto,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Complete la información técnica de la fermentación',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Información General Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: ColorPalette.vinoTinto,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Información General',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorPalette.vinoTinto,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Fecha de inicio
                      TextFormField(
                        controller: _startedAtController,
                        decoration: InputDecoration(
                          labelText: 'Fecha de Inicio *',
                          labelStyle: TextStyle(color: ColorPalette.vinoTinto),
                          prefixIcon: Icon(Icons.calendar_today, color: ColorPalette.vinoTinto),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.date_range, color: ColorPalette.vinoTinto),
                            onPressed: _selectDate,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: ColorPalette.vinoTinto, width: 2),
                          ),
                        ),
                        readOnly: true,
                        onTap: _selectDate,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La fecha de inicio es requerida';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Realizado por
                      TextFormField(
                        controller: _completedByController,
                        decoration: InputDecoration(
                          labelText: 'Realizado por *',
                          labelStyle: TextStyle(color: ColorPalette.vinoTinto),
                          prefixIcon: Icon(Icons.person, color: ColorPalette.vinoTinto),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: ColorPalette.vinoTinto, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Este campo es requerido';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Tipo de fermentación
                      TextFormField(
                        controller: _fermentationTypeController,
                        decoration: InputDecoration(
                          labelText: 'Tipo de Fermentación *',
                          labelStyle: TextStyle(color: ColorPalette.vinoTinto),
                          prefixIcon: Icon(Icons.category, color: ColorPalette.vinoTinto),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: ColorPalette.vinoTinto, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El tipo de fermentación es requerido';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Código del tanque
                      TextFormField(
                        controller: _tankCodeController,
                        decoration: InputDecoration(
                          labelText: 'Código del Tanque *',
                          labelStyle: TextStyle(color: ColorPalette.vinoTinto),
                          prefixIcon: Icon(Icons.storage, color: ColorPalette.vinoTinto),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: ColorPalette.vinoTinto, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El código del tanque es requerido';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Levadura utilizada
                      TextFormField(
                        controller: _yeastUsedController,
                        decoration: InputDecoration(
                          labelText: 'Levadura Utilizada *',
                          labelStyle: TextStyle(color: ColorPalette.vinoTinto),
                          prefixIcon: Icon(Icons.biotech, color: ColorPalette.vinoTinto),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: ColorPalette.vinoTinto, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La levadura utilizada es requerida';
                          }
                          return null;
                        },
                      ),

                      // Checkbox para marcar como completada (solo en edición)
                      if (widget.initialData != null) ...[
                        const SizedBox(height: 20),
                        CheckboxListTile(
                          title: const Text('Etapa completada'),
                          subtitle: const Text('Marque si la etapa ya fue finalizada'),
                          value: _isCompleted,
                          onChanged: (bool? value) {
                            setState(() {
                              _isCompleted = value ?? false;
                            });
                          },
                          activeColor: ColorPalette.vinoTinto,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Parámetros Técnicos Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.science,
                            color: ColorPalette.vinoTinto,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Parámetros Técnicos',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorPalette.vinoTinto,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Niveles de azúcar
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _initialSugarLevelController,
                              decoration: InputDecoration(
                                labelText: 'Azúcar Inicial (°Brix) *',
                                labelStyle: TextStyle(color: ColorPalette.vinoTinto),
                                prefixIcon: Icon(Icons.water_drop, color: ColorPalette.vinoTinto),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: ColorPalette.vinoTinto, width: 2),
                                ),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Requerido';
                                }
                                if (double.tryParse(value.trim()) == null) {
                                  return 'Número inválido';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _finalSugarLevelController,
                              decoration: InputDecoration(
                                labelText: 'Azúcar Final (°Brix) *',
                                labelStyle: TextStyle(color: ColorPalette.vinoTinto),
                                prefixIcon: Icon(Icons.water_drop_outlined, color: ColorPalette.vinoTinto),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: ColorPalette.vinoTinto, width: 2),
                                ),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Requerido';
                                }
                                if (double.tryParse(value.trim()) == null) {
                                  return 'Número inválido';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Niveles de pH
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _initialPhController,
                              decoration: InputDecoration(
                                labelText: 'pH Inicial *',
                                labelStyle: TextStyle(color: ColorPalette.vinoTinto),
                                prefixIcon: Icon(Icons.analytics, color: ColorPalette.vinoTinto),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: ColorPalette.vinoTinto, width: 2),
                                ),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Requerido';
                                }
                                final pH = double.tryParse(value.trim());
                                if (pH == null) {
                                  return 'Número inválido';
                                }
                                if (pH < 0 || pH > 14) {
                                  return 'pH entre 0-14';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _finalPhController,
                              decoration: InputDecoration(
                                labelText: 'pH Final *',
                                labelStyle: TextStyle(color: ColorPalette.vinoTinto),
                                prefixIcon: Icon(Icons.analytics_outlined, color: ColorPalette.vinoTinto),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: ColorPalette.vinoTinto, width: 2),
                                ),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Requerido';
                                }
                                final pH = double.tryParse(value.trim());
                                if (pH == null) {
                                  return 'Número inválido';
                                }
                                if (pH < 0 || pH > 14) {
                                  return 'pH entre 0-14';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Temperaturas
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _temperatureMinController,
                              decoration: InputDecoration(
                                labelText: 'Temp. Mínima (°C) *',
                                labelStyle: TextStyle(color: ColorPalette.vinoTinto),
                                prefixIcon: Icon(Icons.thermostat, color: ColorPalette.vinoTinto),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: ColorPalette.vinoTinto, width: 2),
                                ),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\-]')),
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Requerido';
                                }
                                if (double.tryParse(value.trim()) == null) {
                                  return 'Número inválido';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _temperatureMaxController,
                              decoration: InputDecoration(
                                labelText: 'Temp. Máxima (°C) *',
                                labelStyle: TextStyle(color: ColorPalette.vinoTinto),
                                prefixIcon: Icon(Icons.device_thermostat, color: ColorPalette.vinoTinto),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: ColorPalette.vinoTinto, width: 2),
                                ),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\-]')),
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Requerido';
                                }
                                if (double.tryParse(value.trim()) == null) {
                                  return 'Número inválido';
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

              // Observaciones Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.note_alt,
                            color: ColorPalette.vinoTinto,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Observaciones',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorPalette.vinoTinto,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _observationsController,
                        decoration: InputDecoration(
                          labelText: 'Observaciones adicionales',
                          labelStyle: TextStyle(color: ColorPalette.vinoTinto),
                          hintText: 'Registre cualquier observación relevante sobre el proceso de fermentación...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: ColorPalette.vinoTinto, width: 2),
                          ),
                        ),
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: ColorPalette.vinoTinto),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: ColorPalette.vinoTinto,
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
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
                              widget.initialData == null ? 'Crear Etapa' : 'Guardar Cambios',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
