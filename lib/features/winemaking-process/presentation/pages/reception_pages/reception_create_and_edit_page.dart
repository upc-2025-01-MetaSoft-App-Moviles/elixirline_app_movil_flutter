import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/datasources/reception_stage_service.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/reception_stage_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReceptionCreateAndEditPage extends StatefulWidget {
  final String batchId;
  final ReceptionStageDto? initialData;

  const ReceptionCreateAndEditPage({
    super.key,
    required this.batchId,
    this.initialData,
  });

  @override
  State<ReceptionCreateAndEditPage> createState() => _ReceptionCreateAndEditPageState();
}

class _ReceptionCreateAndEditPageState extends State<ReceptionCreateAndEditPage> {
  final _receptionStageService = ReceptionStageService('/wine-batch');
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _sugarLevelController;
  late final TextEditingController _pHController;
  late final TextEditingController _temperatureController;
  late final TextEditingController _quantityKgController;
  late final TextEditingController _startedAtController;
  late final TextEditingController _completedAtController;
  late final TextEditingController _completedByController;
  late final TextEditingController _observationsController;

  DateTime? _selectedDate;
  DateTime? _selectedCompletedDate;
  bool _isLoading = false;
  bool _isCompleted = true; // Estado de completado para edición

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (kDebugMode) {
      print('🎬 === INICIALIZANDO CONTROLADORES ===');
      print('🎬 Datos iniciales: ${widget.initialData?.toString()}');
    }

    _sugarLevelController = TextEditingController(
      text: widget.initialData?.sugarLevel != null && widget.initialData!.sugarLevel > 0 
          ? widget.initialData!.sugarLevel.toString() 
          : '',
    );
    _pHController = TextEditingController(
      text: widget.initialData?.pH != null && widget.initialData!.pH > 0 
          ? widget.initialData!.pH.toString() 
          : '',
    );
    _temperatureController = TextEditingController(
      text: widget.initialData?.temperature != null 
          ? widget.initialData!.temperature.toString() 
          : '',
    );
    _quantityKgController = TextEditingController(
      text: widget.initialData?.quantityKg != null && widget.initialData!.quantityKg > 0 
          ? widget.initialData!.quantityKg.toString() 
          : '',
    );
    _startedAtController = TextEditingController();
    _completedAtController = TextEditingController();
    _completedByController = TextEditingController(
      text: widget.initialData?.completedBy ?? '',
    );
    _observationsController = TextEditingController(
      text: widget.initialData?.observations ?? '',
    );

    if (kDebugMode) {
      print('📝 Controladores inicializados:');
      print('   - Sugar Level: "${_sugarLevelController.text}"');
      print('   - pH: "${_pHController.text}"');
      print('   - Temperature: "${_temperatureController.text}"');
      print('   - Quantity: "${_quantityKgController.text}"');
      print('   - Completed By: "${_completedByController.text}"');
      print('   - Observations: "${_observationsController.text}"');
    }

    // Parseamos la fecha inicial si existe y mostrarla en formato legible
    if (widget.initialData != null && widget.initialData!.startedAt.isNotEmpty) {
      final dateStr = widget.initialData!.startedAt;
      if (kDebugMode) {
        print('🗓️ Fecha de inicio recibida del backend: "$dateStr"');
      }
      
      _selectedDate = _parseDate(dateStr);
      if (_selectedDate != null) {
        _startedAtController.text = _formatDate(_selectedDate!);
        if (kDebugMode) {
          print('🗓️ Fecha de inicio parseada y formateada: ${_formatDate(_selectedDate!)}');
        }
      } else {
        if (kDebugMode) {
          print('❌ No se pudo parsear la fecha de inicio: "$dateStr"');
        }
        // Si no se puede parsear, usar fecha actual como fallback
        _selectedDate = DateTime.now();
        _startedAtController.text = _formatDate(_selectedDate!);
      }
    } else {
      if (kDebugMode) {
        print('🗓️ No hay fecha de inicio, usando fecha actual');
      }
      // Para nuevas etapas, usar fecha actual
      _selectedDate = DateTime.now();
      _startedAtController.text = _formatDate(_selectedDate!);
    }

    // Parseamos la fecha de completado si existe
    if (widget.initialData != null && widget.initialData!.completedAt.isNotEmpty) {
      final dateStr = widget.initialData!.completedAt;
      if (kDebugMode) {
        print('🗓️ Fecha de completado recibida del backend: "$dateStr"');
      }
      
      _selectedCompletedDate = _parseDate(dateStr);
      if (_selectedCompletedDate != null) {
        _completedAtController.text = _formatDate(_selectedCompletedDate!);
        if (kDebugMode) {
          print('🗓️ Fecha de completado parseada y formateada: ${_formatDate(_selectedCompletedDate!)}');
        }
      }
    } else {
      if (kDebugMode) {
        print('🗓️ No hay fecha de completado');
      }
      // Para ediciones, usar fecha actual como completado por defecto
      if (widget.initialData != null) {
        _selectedCompletedDate = DateTime.now();
        _completedAtController.text = _formatDate(_selectedCompletedDate!);
      }
    }

    // Inicializar estado de completado
    _isCompleted = widget.initialData?.isCompleted ?? true;
    
    if (kDebugMode) {
      print('✅ Estado completado inicializado: $_isCompleted');
      print('🎬 === INICIALIZACIÓN COMPLETADA ===');
    }
  }

  @override
  void dispose() {
    _sugarLevelController.dispose();
    _pHController.dispose();
    _temperatureController.dispose();
    _quantityKgController.dispose();
    _startedAtController.dispose();
    _completedAtController.dispose();
    _completedByController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  // Función para parsear fecha desde diferentes formatos
  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) {
      if (kDebugMode) {
        print('🗓️ dateStr está vacío');
      }
      return null;
    }
    
    try {
      if (kDebugMode) {
        print('🗓️ Intentando parsear: "$dateStr"');
      }
      
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
            if (kDebugMode) {
              print('🗓️ Fecha parseada con formato dd/MM/yyyy: $result');
            }
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
            if (kDebugMode) {
              print('🗓️ Fecha parseada con formato dd-MM-yyyy: $result');
            }
            return result;
          }
        }
      }
      
      // Intentar formato ISO (yyyy-MM-dd o yyyy-MM-ddTHH:mm:ss)
      if (cleanedDateStr.contains('-')) {
        final result = DateTime.parse(cleanedDateStr);
        if (kDebugMode) {
          print('🗓️ Fecha parseada con formato ISO: $result');
        }
        return result;
      }
      
      // Intentar parse directo
      final result = DateTime.parse(cleanedDateStr);
      if (kDebugMode) {
        print('🗓️ Fecha parseada con parse directo: $result');
      }
      return result;
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

  Future<void> _selectStartDate() async {
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
        _startedAtController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _selectCompletedDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedCompletedDate ?? DateTime.now(),
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

    if (picked != null && picked != _selectedCompletedDate) {
      setState(() {
        _selectedCompletedDate = picked;
        _completedAtController.text = _formatDate(picked);
      });
    }
  }

  // Función utilitaria para validar y parsear números de forma segura
  double _parseDouble(String value, String fieldName) {
    if (kDebugMode) {
      print('🔢 Parseando "$fieldName": valor = "$value"');
    }
    
    if (value.trim().isEmpty) {
      if (kDebugMode) {
        print('❌ $fieldName está vacío');
      }
      throw Exception('$fieldName es requerido');
    }
    
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      if (kDebugMode) {
        print('❌ No se pudo parsear "$value" como double para $fieldName');
      }
      throw Exception('$fieldName debe ser un número válido');
    }
    
    if (kDebugMode) {
      print('✅ $fieldName parseado correctamente: $parsed');
    }
    
    return parsed;
  }

  Future<void> _onSave() async {
    if (kDebugMode) {
      print('🚀 === INICIO DEL PROCESO DE GUARDADO ===');
      print('📝 Es edición: ${widget.initialData != null}');
      print('📝 BatchId: ${widget.batchId}');
    }

    if (!_formKey.currentState!.validate()) {
      if (kDebugMode) {
        print('❌ Validación del formulario falló');
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (kDebugMode) {
        print('📊 === VALIDANDO CAMPOS NUMÉRICOS ===');
        print('📊 Sugar Level (texto): "${_sugarLevelController.text}"');
        print('📊 pH (texto): "${_pHController.text}"');
        print('📊 Temperature (texto): "${_temperatureController.text}"');
        print('📊 Quantity (texto): "${_quantityKgController.text}"');
      }

      // Validar que los campos numéricos tengan valores válidos
      double sugarLevel;
      double pHValue;
      double temperature;
      double quantityKg;

      try {
        sugarLevel = _parseDouble(_sugarLevelController.text, 'Nivel de azúcar');
        pHValue = _parseDouble(_pHController.text, 'pH');
        temperature = _parseDouble(_temperatureController.text, 'Temperatura');
        quantityKg = _parseDouble(_quantityKgController.text, 'Cantidad en Kg');
        
        if (kDebugMode) {
          print('✅ Valores parseados:');
          print('   - Sugar Level: $sugarLevel');
          print('   - pH: $pHValue');
          print('   - Temperature: $temperature');
          print('   - Quantity: $quantityKg');
        }
        
        // Validaciones adicionales
        if (pHValue < 0 || pHValue > 14) {
          throw Exception('El pH debe estar entre 0 y 14');
        }
        if (quantityKg <= 0) {
          throw Exception('La cantidad debe ser mayor a 0');
        }
        if (sugarLevel < 0) {
          throw Exception('El nivel de azúcar debe ser mayor o igual a 0');
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error en validación numérica: $e');
        }
        throw Exception(e.toString().replaceFirst('Exception: ', ''));
      }

      // Validar campos de texto requeridos
      final completedBy = _completedByController.text.trim();
      final observations = _observationsController.text.trim();

      if (kDebugMode) {
        print('📝 === VALIDANDO CAMPOS DE TEXTO ===');
        print('📝 Completed By: "$completedBy"');
        print('📝 Observations: "$observations"');
        print('📝 Selected Start Date: $_selectedDate');
        print('📝 Selected Completed Date: $_selectedCompletedDate');
      }

      if (_selectedDate == null) {
        throw Exception('La fecha de inicio es requerida');
      }
      if (completedBy.isEmpty) {
        throw Exception('El campo "Realizado por" es requerido');
      }

      // Convertir las fechas al formato requerido por el backend (dd/MM/yyyy)
      String startedAt = _formatDate(_selectedDate!);
      String completedAt = '';

      if (widget.initialData != null) {
        // Para ediciones, si no hay fecha de completado y está marcado como completado, usar fecha actual
        if (_isCompleted && _selectedCompletedDate == null) {
          _selectedCompletedDate = DateTime.now();
        }
        
        if (_selectedCompletedDate != null) {
          completedAt = _formatDate(_selectedCompletedDate!);
        }
      }

      if (kDebugMode) {
        print('📅 Fecha de inicio formateada: "$startedAt"');
        print('📅 Fecha de completado formateada: "$completedAt"');
      }

      Map<String, dynamic> data;
      
      if (widget.initialData == null) {
        if (kDebugMode) {
          print('🆕 === PREPARANDO DATOS PARA CREAR ===');
        }
        // Estructura para CREAR nueva etapa
        data = {
          'sugarLevel': sugarLevel,
          'pH': pHValue,
          'temperature': temperature,
          'quantityKg': quantityKg,
          'startedAt': startedAt,
          'completedBy': completedBy,
          'observations': observations,
        };
      } else {
        if (kDebugMode) {
          print('=== PREPARANDO DATOS PARA EDITAR ===');
          print('Estado completado: $_isCompleted');
        }
        // Estructura para EDITAR etapa existente - incluir campos requeridos según el error
        data = {
          'batchId': widget.batchId, // ✅ Campo requerido agregado
          'stageType': 'reception',  // ✅ Campo requerido agregado
          'startedAt': startedAt,
          'completedAt': completedAt.isNotEmpty ? completedAt : _formatDate(DateTime.now()), // ✅ Campo requerido agregado
          'completedBy': completedBy,
          'isCompleted': _isCompleted,
          'sugarLevel': sugarLevel,
          'pH': pHValue, // Cambié de 'Ph' a 'pH' para consistencia
          'temperature': temperature,
          'quantityKg': quantityKg,
          'observations': observations,
        };
      }


      ReceptionStageDto result;
      if (widget.initialData == null) {
        if (kDebugMode) {
          print('🔄 Llamando a _receptionStageService.create()...');
        }
        // Crear nueva etapa
        result = await _receptionStageService.create(widget.batchId, data);
      
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Etapa de recepción creada correctamente'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (kDebugMode) {
          print('🔄 Llamando a _receptionStageService.update()...');
        }
        // Actualizar etapa existente
        result = await _receptionStageService.update(widget.batchId, data);
        if (kDebugMode) {
          print('✅ Etapa actualizada exitosamente: ${result.toString()}');
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Etapa de recepción actualizada correctamente'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }

      if (kDebugMode) {
        print('🎉 === PROCESO COMPLETADO EXITOSAMENTE ===');
        print('🔄 Navegando de vuelta con resultado actualizado');
      }

      // ✅ CLAVE: Devolver el resultado actualizado para que la vista anterior se actualice
      if (mounted) {
        // Pequeño delay para que el usuario vea el mensaje de éxito
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pop(context, result); // ✅ Devolver el resultado actualizado
      }
    } catch (e) {
      if (kDebugMode) {
        print('💥 === ERROR DURANTE EL GUARDADO ===');
        print('❌ Error completo: $e');
        print('❌ Tipo de error: ${e.runtimeType}');
        print('❌ StackTrace: ${StackTrace.current}');
        
        // Log adicional para errores de servicio
        if (e.toString().contains('HttpException') || 
            e.toString().contains('Response') ||
            e.toString().contains('status')) {
          print('🌐 Error relacionado con HTTP/API');
        }
        if (e.toString().contains('SocketException')) {
          print('📡 Error de red/conexión');
        }
        if (e.toString().contains('FormatException')) {
          print('📝 Error de formato de datos');
        }
      }
      
      String errorMessage = 'Error desconocido';
      if (e.toString().contains('es requerido') || 
          e.toString().contains('debe ser') ||
          e.toString().contains('debe estar')) {
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
      if (kDebugMode) {
        print('🏁 === FINALIZANDO PROCESO ===');
        print('🏁 Cambiando _isLoading a false');
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialData != null;

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorPalette.vinoTinto,
            foregroundColor: Colors.white,
            title: Text(
              isEditing ? 'Editar Etapa de Recepción' : 'Crear Etapa de Recepción',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card con información
                  _buildHeaderCard(isEditing),
                  
                  const SizedBox(height: 20),
                  
                  // Card de información general
                  _buildGeneralInfoCard(),
                  
                  const SizedBox(height: 20),
                  
                  // Card de parámetros técnicos
                  _buildTechnicalParametersCard(),
                  
                  const SizedBox(height: 20),
                  
                  // Card de observaciones
                  _buildObservationsCard(),
                  
                  const SizedBox(height: 32),
                  
                  // Botón de guardar
                  _buildSaveButton(isEditing),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(bool isEditing) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: ColorPalette.vinoTinto.withOpacity(0.2),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
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
                    isEditing ? 'Editando Etapa de Recepción' : 'Nueva Etapa de Recepción',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.vinoTinto,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isEditing 
                        ? 'Modifica los datos de la etapa de recepción'
                        : 'Completa la información para registrar la etapa',
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
      ),
    );
  }

  Widget _buildGeneralInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: ColorPalette.vinoTinto.withOpacity(0.2),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Información General',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _startedAtController,
                    label: 'Fecha de Inicio',
                    icon: Icons.calendar_today_outlined,
                    readOnly: true,
                    onTap: _selectStartDate,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'La fecha de inicio es requerida';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _completedByController,
                    label: 'Realizado por',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Este campo es requerido';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            
            // Mostrar fecha de completado solo en modo edición
            if (widget.initialData != null) ...[
              const SizedBox(height: 16),
              _buildTextField(
                controller: _completedAtController,
                label: 'Fecha de Completado',
                icon: Icons.event_available_outlined,
                readOnly: true,
                onTap: _selectCompletedDate,
                validator: (value) {
                  if (_isCompleted && (value == null || value.trim().isEmpty)) {
                    return 'La fecha de completado es requerida si está marcada como completada';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Estado de la Etapa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: _isCompleted,
                          onChanged: (value) {
                            setState(() {
                              _isCompleted = value ?? true;
                              // Si se marca como completado y no hay fecha, usar fecha actual
                              if (_isCompleted && _selectedCompletedDate == null) {
                                _selectedCompletedDate = DateTime.now();
                                _completedAtController.text = _formatDate(_selectedCompletedDate!);
                              }
                            });
                          },
                          activeColor: ColorPalette.vinoTinto,
                        ),
                        Text(
                          'Completada',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicalParametersCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: ColorPalette.vinoTinto.withOpacity(0.2),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.science_outlined,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Parámetros Técnicos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _sugarLevelController,
                    label: 'Nivel de Azúcar (g/L)',
                    icon: Icons.opacity_outlined,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Este campo es requerido';
                      }
                      final number = double.tryParse(value);
                      if (number == null || number < 0) {
                        return 'Ingrese un número válido';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _pHController,
                    label: 'pH',
                    icon: Icons.science_outlined,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Este campo es requerido';
                      }
                      final number = double.tryParse(value);
                      if (number == null || number < 0 || number > 14) {
                        return 'Ingrese un pH válido (0-14)';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _temperatureController,
                    label: 'Temperatura (°C)',
                    icon: Icons.thermostat_outlined,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^-?\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Este campo es requerido';
                      }
                      final number = double.tryParse(value);
                      if (number == null) {
                        return 'Ingrese un número válido';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _quantityKgController,
                    label: 'Cantidad (Kg)',
                    icon: Icons.scale_outlined,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Este campo es requerido';
                      }
                      final number = double.tryParse(value);
                      if (number == null || number <= 0) {
                        return 'Ingrese una cantidad válida';
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
    );
  }

  Widget _buildObservationsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: ColorPalette.vinoTinto.withOpacity(0.2),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.comment_outlined,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Observaciones',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            TextFormField(
              controller: _observationsController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Observaciones adicionales',
                hintText: 'Ingrese cualquier observación relevante sobre la recepción...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ColorPalette.vinoTinto, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: ColorPalette.vinoTinto),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorPalette.vinoTinto, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildSaveButton(bool isEditing) {
    return SizedBox(
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
                  Icon(isEditing ? Icons.update : Icons.save),
                  const SizedBox(width: 8),
                  Text(
                    isEditing ? 'Actualizar Etapa' : 'Crear Etapa',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
