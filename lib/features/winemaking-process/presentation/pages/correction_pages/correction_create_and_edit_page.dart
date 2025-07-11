import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/datasources/correction_stage_service.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/correction_stage_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CorrectionCreateAndEditPage extends StatefulWidget {
  final String batchId;
  final CorrectionStageDto? initialData;

  const CorrectionCreateAndEditPage({
    super.key,
    required this.batchId,
    this.initialData,
  });

  @override
  State<CorrectionCreateAndEditPage> createState() => _CorrectionCreateAndEditPageState();
}

class _CorrectionCreateAndEditPageState extends State<CorrectionCreateAndEditPage> {
  final _correctionStageService = CorrectionStageService('/wine-batch');
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _initialSugarLevelController;
  late final TextEditingController _finalSugarLevelController;
  late final TextEditingController _addedSugarKgController;
  late final TextEditingController _initialPhController;
  late final TextEditingController _finalPhController;
  late final TextEditingController _acidTypeController;
  late final TextEditingController _acidAddedGlController;
  late final TextEditingController _so2AddedMgLController;
  late final TextEditingController _justificationController;
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
    _addedSugarKgController = TextEditingController(
      text: widget.initialData?.addedSugarKg != null && widget.initialData!.addedSugarKg > 0 
          ? widget.initialData!.addedSugarKg.toString() 
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
    _acidTypeController = TextEditingController(
      text: widget.initialData?.acidType ?? '',
    );
    _acidAddedGlController = TextEditingController(
      text: widget.initialData?.acidAddedGl != null && widget.initialData!.acidAddedGl > 0 
          ? widget.initialData!.acidAddedGl.toString() 
          : '',
    );
    _so2AddedMgLController = TextEditingController(
      text: widget.initialData?.so2AddedMgL != null && widget.initialData!.so2AddedMgL > 0 
          ? widget.initialData!.so2AddedMgL.toString() 
          : '',
    );
    _justificationController = TextEditingController(
      text: widget.initialData?.justification ?? '',
    );
    _startedAtController = TextEditingController();
    _completedByController = TextEditingController(
      text: widget.initialData?.completedBy ?? '',
    );
    _observationsController = TextEditingController(
      text: widget.initialData?.observations ?? '',
    );

    // Parseamos la fecha inicial si existe y mostrarla en formato legible
    if (widget.initialData != null && widget.initialData!.startedAt.isNotEmpty) {
      final dateStr = widget.initialData!.startedAt;
      if (kDebugMode) {
        print('🗓️ [CORRECTION] Fecha recibida del backend: "$dateStr"');
      }
      
      _selectedDate = _parseDate(dateStr);
      if (_selectedDate != null) {
        _startedAtController.text = _formatDate(_selectedDate!);
        if (kDebugMode) {
          print('🗓️ [CORRECTION] Fecha parseada y formateada: ${_formatDate(_selectedDate!)}');
        }
      } else {
        if (kDebugMode) {
          print('❌ [CORRECTION] No se pudo parsear la fecha: "$dateStr"');
        }
        // Si no se puede parsear, usar fecha actual como fallback
        _selectedDate = DateTime.now();
        _startedAtController.text = _formatDate(_selectedDate!);
      }
    } else {
      if (kDebugMode) {
        print('🗓️ [CORRECTION] No hay fecha inicial, usando fecha actual');
      }
      // Para nuevas etapas, usar fecha actual
      _selectedDate = DateTime.now();
      _startedAtController.text = _formatDate(_selectedDate!);
    }

    // Inicializar estado de completado
    _isCompleted = widget.initialData?.isCompleted ?? true;
  }

  @override
  void dispose() {
    _initialSugarLevelController.dispose();
    _finalSugarLevelController.dispose();
    _addedSugarKgController.dispose();
    _initialPhController.dispose();
    _finalPhController.dispose();
    _acidTypeController.dispose();
    _acidAddedGlController.dispose();
    _so2AddedMgLController.dispose();
    _justificationController.dispose();
    _startedAtController.dispose();
    _completedByController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  // Función para parsear fecha desde diferentes formatos
  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) {
      if (kDebugMode) {
        print('🗓️ [CORRECTION] dateStr está vacío');
      }
      return null;
    }
    
    try {
      if (kDebugMode) {
        print('🗓️ [CORRECTION] Intentando parsear: "$dateStr"');
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
              print('🗓️ [CORRECTION] Fecha parseada con formato dd/MM/yyyy: $result');
            }
            return result;
          }
        }
      }
      
      // Intentar formato ISO (yyyy-MM-dd o yyyy-MM-ddTHH:mm:ss)
      if (dateStr.contains('-')) {
        final result = DateTime.parse(dateStr);
        if (kDebugMode) {
          print('🗓️ [CORRECTION] Fecha parseada con formato ISO: $result');
        }
        return result;
      }
      
      // Intentar parse directo
      final result = DateTime.parse(dateStr);
      if (kDebugMode) {
        print('🗓️ [CORRECTION] Fecha parseada con parse directo: $result');
      }
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('❌ [CORRECTION] Error parseando fecha "$dateStr": $e');
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

  // Función utilitaria para parsear números opcionales
  double? _parseOptionalDouble(String value) {
    if (value.trim().isEmpty) return null;
    return double.tryParse(value.trim());
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Validar fecha requerida
      if (_selectedDate == null) {
        throw Exception('La fecha de inicio es requerida');
      }

      // Parsear campos opcionales (pueden estar vacíos)
      final initialSugarLevel = _parseOptionalDouble(_initialSugarLevelController.text) ?? 0.0;
      final finalSugarLevel = _parseOptionalDouble(_finalSugarLevelController.text) ?? 0.0;
      final addedSugarKg = _parseOptionalDouble(_addedSugarKgController.text) ?? 0.0;
      final initialPh = _parseOptionalDouble(_initialPhController.text) ?? 0.0;
      final finalPh = _parseOptionalDouble(_finalPhController.text) ?? 0.0;
      final acidAddedGl = _parseOptionalDouble(_acidAddedGlController.text) ?? 0.0;
      final so2AddedMgL = _parseOptionalDouble(_so2AddedMgLController.text) ?? 0.0;

      // Validaciones adicionales para pH si se proporciona
      if (initialPh > 0 && (initialPh < 0 || initialPh > 14)) {
        throw Exception('El pH inicial debe estar entre 0 y 14');
      }
      if (finalPh > 0 && (finalPh < 0 || finalPh > 14)) {
        throw Exception('El pH final debe estar entre 0 y 14');
      }

      // Validaciones para valores negativos
      if (addedSugarKg < 0) {
        throw Exception('La cantidad de azúcar agregada no puede ser negativa');
      }
      if (acidAddedGl < 0) {
        throw Exception('La cantidad de ácido agregada no puede ser negativa');
      }
      if (so2AddedMgL < 0) {
        throw Exception('La cantidad de SO2 agregada no puede ser negativa');
      }

      // Campos de texto
      final acidType = _acidTypeController.text.trim();
      final justification = _justificationController.text.trim();
      final completedBy = _completedByController.text.trim();
      final observations = _observationsController.text.trim();

      // Convertir la fecha al formato requerido por el backend (dd/MM/yyyy)
      String startedAt = _formatDate(_selectedDate!);

      Map<String, dynamic> data;
      
      if (widget.initialData == null) {
        // Estructura para CREAR nueva etapa
        data = {
          'initialSugarLevel': initialSugarLevel,
          'finalSugarLevel': finalSugarLevel,
          'addedSugarKg': addedSugarKg,
          'initialPh': initialPh,
          'finalPh': finalPh,
          'acidType': acidType,
          'acidAddedGl': acidAddedGl,
          'so2AddedMgL': so2AddedMgL,
          'justification': justification,
          'startedAt': startedAt,
          'completedBy': completedBy,
          'observations': observations,
        };
      } else {
        // Estructura para EDITAR etapa existente (usar PascalCase)
        data = {
          'StartedAt': startedAt,
          'CompletedBy': completedBy,
          'Observations': observations,
          'IsCompleted': _isCompleted,
          'InitialSugarLevel': initialSugarLevel,
          'FinalSugarLevel': finalSugarLevel,
          'AddedSugarKg': addedSugarKg,
          'InitialPh': initialPh,
          'FinalPh': finalPh,
          'AcidType': acidType,
          'AcidAddedGl': acidAddedGl,
          'So2AddedMgL': so2AddedMgL,
          'Justification': justification,
        };
      }

      if (kDebugMode) {
        print('📤 [CORRECTION] Datos a enviar: $data');
        print('📤 [CORRECTION] BatchId: ${widget.batchId}');
        print('📤 [CORRECTION] Es edición: ${widget.initialData != null}');
        print('📤 [CORRECTION] Fecha seleccionada: $_selectedDate');
        print('📤 [CORRECTION] Fecha formateada: $startedAt');
      }

      CorrectionStageDto result;
      if (widget.initialData == null) {
        // Crear nueva etapa
        result = await _correctionStageService.create(widget.batchId, data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Etapa de corrección creada correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Actualizar etapa existente
        if (kDebugMode) {
          print('🔄 [CORRECTION] Iniciando actualización de etapa existente...');
        }
        result = await _correctionStageService.update(widget.batchId, data);
        if (kDebugMode) {
          print('✅ [CORRECTION] Etapa actualizada correctamente: ${result.toString()}');
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Etapa de corrección actualizada correctamente'),
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
        print('❌ [CORRECTION] Error al guardar la etapa de corrección: $e');
        print('❌ [CORRECTION] Tipo de error: ${e.runtimeType}');
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
    final isEditing = widget.initialData != null;

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorPalette.vinoTinto,
            foregroundColor: Colors.white,
            title: Text(
              isEditing ? 'Editar Etapa de Corrección' : 'Crear Etapa de Corrección',
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
                  
                  // Card de parámetros de azúcar
                  _buildSugarParametersCard(),
                  
                  const SizedBox(height: 20),
                  
                  // Card de parámetros de pH y acidez
                  _buildAcidityParametersCard(),
                  
                  const SizedBox(height: 20),
                  
                  // Card de aditivos
                  _buildAdditivesCard(),
                  
                  const SizedBox(height: 20),
                  
                  // Card de justificación y observaciones
                  _buildNotesCard(),
                  
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
                Icons.tune,
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
                    isEditing ? 'Editando Etapa de Corrección' : 'Nueva Etapa de Corrección',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.vinoTinto,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isEditing 
                        ? 'Modifica los parámetros de corrección'
                        : 'Registra las correcciones aplicadas al vino',
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
                    label: 'Fecha de Inicio *',
                    icon: Icons.calendar_today_outlined,
                    readOnly: true,
                    onTap: _selectDate,
                    validator: (value) {
                      if (_selectedDate == null) {
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
                  ),
                ),
              ],
            ),
            
            // Mostrar checkbox de completado solo en modo edición
            if (widget.initialData != null) ...[
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

  Widget _buildSugarParametersCard() {
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
                    Icons.opacity_outlined,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Parámetros de Azúcar',
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
                    controller: _initialSugarLevelController,
                    label: 'Azúcar Inicial (g/L)',
                    icon: Icons.water_drop_outlined,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _finalSugarLevelController,
                    label: 'Azúcar Final (g/L)',
                    icon: Icons.water_drop,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildTextField(
              controller: _addedSugarKgController,
              label: 'Azúcar Agregada (Kg)',
              icon: Icons.add_circle_outline,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcidityParametersCard() {
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
                  'Parámetros de pH y Acidez',
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
                    controller: _initialPhController,
                    label: 'pH Inicial',
                    icon: Icons.analytics_outlined,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _finalPhController,
                    label: 'pH Final',
                    icon: Icons.analytics,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _acidTypeController,
                    label: 'Tipo de Ácido',
                    icon: Icons.local_pharmacy_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _acidAddedGlController,
                    label: 'Ácido Agregado (g/L)',
                    icon: Icons.add_circle,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditivesCard() {
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
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.science,
                    color: Colors.purple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Aditivos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            _buildTextField(
              controller: _so2AddedMgLController,
              label: 'SO2 Agregado (mg/L)',
              icon: Icons.bubble_chart_outlined,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard() {
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
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.note_alt_outlined,
                    color: Colors.teal,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Justificación y Observaciones',
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
              controller: _justificationController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Justificación de la corrección',
                hintText: 'Explique por qué se realizó esta corrección...',
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
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _observationsController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Observaciones adicionales',
                hintText: 'Ingrese cualquier observación relevante sobre la corrección...',
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
