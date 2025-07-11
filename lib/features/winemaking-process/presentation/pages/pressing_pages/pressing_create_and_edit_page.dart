import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/utils/color_pallet.dart';
import '../../../data/models/pressing_stage_dto.dart';
import '../../../data/datasources/pressing_stage_service.dart';

class PressingCreateAndEditPage extends StatefulWidget {
  final String batchId;
  final PressingStageDto? initialData;

  const PressingCreateAndEditPage({
    super.key,
    required this.batchId,
    this.initialData,
  });

  @override
  State<PressingCreateAndEditPage> createState() => _PressingCreateAndEditPageState();
}

class _PressingCreateAndEditPageState extends State<PressingCreateAndEditPage> {
  final _formKey = GlobalKey<FormState>();
  final PressingStageService _stageService = PressingStageService('/wine-batch');

  // Controllers
  late final TextEditingController _startedAtController;
  late final TextEditingController _completedByController;
  late final TextEditingController _pressTypeController;
  late final TextEditingController _pressPressureBarsController;
  late final TextEditingController _durationMinutesController;
  late final TextEditingController _pomaceKgController;
  late final TextEditingController _yieldLitersController;
  late final TextEditingController _mustUsageController;
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
    _pressTypeController = TextEditingController();
    _pressPressureBarsController = TextEditingController();
    _durationMinutesController = TextEditingController();
    _pomaceKgController = TextEditingController();
    _yieldLitersController = TextEditingController();
    _mustUsageController = TextEditingController();
    _observationsController = TextEditingController();
  }

  void _loadInitialData() {
    if (widget.initialData != null) {
      final data = widget.initialData!;
      
      // Procesar fecha preservando la existente con mejor manejo de errores
      if (data.startedAt.isNotEmpty) {
        debugPrint('🗓️ [PRESSING] Fecha recibida del backend: "${data.startedAt}"');
        final parsedDate = _parseDate(data.startedAt);
        if (parsedDate != null) {
          _selectedDate = parsedDate;
          _startedAtController.text = _formatDate(parsedDate);
          debugPrint('🗓️ [PRESSING] Fecha parseada y formateada: ${_formatDate(parsedDate)}');
        } else {
          debugPrint('❌ [PRESSING] No se pudo parsear la fecha: "${data.startedAt}"');
          // Si no se puede parsear, usar fecha actual como fallback
          _selectedDate = DateTime.now();
          _startedAtController.text = _formatDate(_selectedDate!);
        }
      } else {
        debugPrint('🗓️ [PRESSING] No hay fecha inicial, usando fecha actual');
        _selectedDate = DateTime.now();
        _startedAtController.text = _formatDate(_selectedDate!);
      }

      // Cargar datos existentes
      _completedByController.text = data.completedBy;
      _pressTypeController.text = data.pressType;
      _pressPressureBarsController.text = data.pressPressureBars > 0 ? data.pressPressureBars.toString() : '';
      _durationMinutesController.text = data.durationMinutes > 0 ? data.durationMinutes.toString() : '';
      _pomaceKgController.text = data.pomaceKg > 0 ? data.pomaceKg.toString() : '';
      _yieldLitersController.text = data.yieldLiters > 0 ? data.yieldLiters.toString() : '';
      _mustUsageController.text = data.mustUsage;
      _observationsController.text = data.observations;
      _isCompleted = data.isCompleted;
    } else {
      // Datos por defecto para nueva etapa
      debugPrint('🗓️ [PRESSING] Nueva etapa, usando fecha actual');
      _selectedDate = DateTime.now();
      _startedAtController.text = _formatDate(_selectedDate!);
    }
  }

  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) {
      debugPrint('🗓️ [PRESSING] dateStr está vacío');
      return null;
    }
    
    try {
      debugPrint('🗓️ [PRESSING] Intentando parsear: "$dateStr"');
      
      // Intentar formato dd/MM/yyyy
      if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final year = int.tryParse(parts[2]);
          if (day != null && month != null && year != null) {
            final result = DateTime(year, month, day);
            debugPrint('🗓️ [PRESSING] Fecha parseada con formato dd/MM/yyyy: $result');
            return result;
          }
        }
      }
      
      // Intentar formato ISO o con T
      if (dateStr.contains('T') || dateStr.contains('-')) {
        final result = DateTime.parse(dateStr);
        debugPrint('🗓️ [PRESSING] Fecha parseada con formato ISO: $result');
        return result;
      }
      
    } catch (e) {
      debugPrint('❌ [PRESSING] Error parseando fecha "$dateStr": $e');
    }
    
    return null;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  void dispose() {
    _startedAtController.dispose();
    _completedByController.dispose();
    _pressTypeController.dispose();
    _pressPressureBarsController.dispose();
    _durationMinutesController.dispose();
    _pomaceKgController.dispose();
    _yieldLitersController.dispose();
    _mustUsageController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorPalette.vinoTinto,
              onPrimary: Colors.white,
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
          'wineBatchId': widget.batchId,
          'startedAt': startedAt,
          'completedBy': _completedByController.text.trim().isEmpty ? null : _completedByController.text.trim(),
          'pressType': _pressTypeController.text.trim().isEmpty ? null : _pressTypeController.text.trim(),
          'pressPressureBars': _pressPressureBarsController.text.trim().isEmpty ? null : double.tryParse(_pressPressureBarsController.text.trim()),
          'durationMinutes': _durationMinutesController.text.trim().isEmpty ? null : int.tryParse(_durationMinutesController.text.trim()),
          'pomaceKg': _pomaceKgController.text.trim().isEmpty ? null : double.tryParse(_pomaceKgController.text.trim()),
          'yieldLiters': _yieldLitersController.text.trim().isEmpty ? null : double.tryParse(_yieldLitersController.text.trim()),
          'mustUsage': _mustUsageController.text.trim().isEmpty ? null : _mustUsageController.text.trim(),
          'observations': _observationsController.text.trim().isEmpty ? null : _observationsController.text.trim(),
          'isCompleted': _isCompleted,
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
            debugPrint('⚠️ [PRESSING] Error parseando completedAt: $e');
            formattedCompletedAt = _formatDate(DateTime.now());
          }
        } else {
          // Si no hay fecha de completado, usar la fecha actual
          formattedCompletedAt = _formatDate(DateTime.now());
        }
        
        // Estructura para EDITAR etapa existente (incluir todos los campos requeridos)
        stageMap = {
          'batchId': widget.batchId,
          'stageType': 'pressing',
          'startedAt': startedAt,
          'completedAt': formattedCompletedAt,
          'completedBy': _completedByController.text.trim(),
          'isCompleted': _isCompleted,
          'pressType': _pressTypeController.text.trim(),
          'pressPressureBars': _pressPressureBarsController.text.trim().isEmpty ? 0.0 : double.tryParse(_pressPressureBarsController.text.trim()) ?? 0.0,
          'durationMinutes': _durationMinutesController.text.trim().isEmpty ? 0 : int.tryParse(_durationMinutesController.text.trim()) ?? 0,
          'pomaceKg': _pomaceKgController.text.trim().isEmpty ? 0.0 : double.tryParse(_pomaceKgController.text.trim()) ?? 0.0,
          'yieldLiters': _yieldLitersController.text.trim().isEmpty ? 0.0 : double.tryParse(_yieldLitersController.text.trim()) ?? 0.0,
          'mustUsage': _mustUsageController.text.trim(),
          'observations': _observationsController.text.trim(),
        };
      }

      debugPrint('📤 [PRESSING] Datos a enviar: $stageMap');
      debugPrint('📤 [PRESSING] BatchId: ${widget.batchId}');
      debugPrint('📤 [PRESSING] Es edición: ${widget.initialData != null}');
      debugPrint('📤 [PRESSING] Fecha seleccionada: $_selectedDate');
      debugPrint('📤 [PRESSING] Fecha formateada startedAt: $startedAt');
      if (widget.initialData != null) {
        debugPrint('📤 [PRESSING] CompletedAt original: ${widget.initialData?.completedAt}');
        debugPrint('📤 [PRESSING] CompletedAt formateado: ${stageMap['completedAt']}');
      }

      PressingStageDto result;
      if (widget.initialData == null) {
        // Crear nueva etapa
        result = await _stageService.create(widget.batchId, stageMap);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Etapa de prensado creada correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Actualizar etapa existente
        debugPrint('🔄 [PRESSING] Iniciando actualización de etapa existente...');
        debugPrint('🔄 [PRESSING] Payload completo: $stageMap');
        
        result = await _stageService.update(widget.batchId, stageMap);
        
        debugPrint('✅ [PRESSING] Etapa actualizada correctamente');
        debugPrint('✅ [PRESSING] StartedAt=${result.startedAt}, IsCompleted=${result.isCompleted}');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Prensado actualizado exitosamente'),
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
      debugPrint('❌ [PRESSING] Error al guardar la etapa de prensado: $e');
      debugPrint('❌ [PRESSING] Tipo de error: ${e.runtimeType}');
      
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPalette.vinoTinto,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            widget.initialData != null ? 'Editar Prensado' : 'Crear Prensado',
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
                // Card de Fecha de Inicio
                _buildSectionCard(
                  title: 'Fecha de Inicio',
                  icon: Icons.calendar_today,
                  color: Colors.blue,
                  children: [
                    _buildDateField(
                      controller: _startedAtController,
                      label: 'Fecha de Inicio del Prensado',
                      icon: Icons.play_arrow,
                      onTap: _selectDate,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Card de Responsable
                _buildSectionCard(
                  title: 'Responsable',
                  icon: Icons.person,
                  color: Colors.green,
                  children: [
                    _buildTextField(
                      controller: _completedByController,
                      label: 'Responsable del Prensado',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El responsable es obligatorio';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Card de Configuración de Prensa
                _buildSectionCard(
                  title: 'Configuración de Prensa',
                  icon: Icons.settings,
                  color: Colors.purple,
                  children: [
                    _buildTextField(
                      controller: _pressTypeController,
                      label: 'Tipo de Prensa',
                      icon: Icons.category,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El tipo de prensa es obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildNumericField(
                      controller: _pressPressureBarsController,
                      label: 'Presión (bar)',
                      icon: Icons.speed,
                      allowDecimal: true,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          final number = double.tryParse(value.trim());
                          if (number == null || number < 0) {
                            return 'Ingrese una presión válida (≥ 0)';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildNumericField(
                      controller: _durationMinutesController,
                      label: 'Duración (minutos)',
                      icon: Icons.timer,
                      allowDecimal: false,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          final number = int.tryParse(value.trim());
                          if (number == null || number < 0) {
                            return 'Ingrese una duración válida (≥ 0)';
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Card de Resultados
                _buildSectionCard(
                  title: 'Resultados del Prensado',
                  icon: Icons.analytics,
                  color: Colors.orange,
                  children: [
                    _buildNumericField(
                      controller: _pomaceKgController,
                      label: 'Orujo Obtenido (kg)',
                      icon: Icons.grain,
                      allowDecimal: true,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          final number = double.tryParse(value.trim());
                          if (number == null || number < 0) {
                            return 'Ingrese un peso válido (≥ 0)';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildNumericField(
                      controller: _yieldLitersController,
                      label: 'Rendimiento (L)',
                      icon: Icons.local_drink,
                      allowDecimal: true,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          final number = double.tryParse(value.trim());
                          if (number == null || number < 0) {
                            return 'Ingrese un rendimiento válido (≥ 0)';
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Card de Uso del Mosto
                _buildSectionCard(
                  title: 'Uso del Mosto',
                  icon: Icons.wine_bar,
                  color: Colors.indigo,
                  children: [
                    _buildTextField(
                      controller: _mustUsageController,
                      label: 'Destino del Mosto',
                      icon: Icons.assignment,
                      maxLines: 3,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Card de Observaciones
                _buildSectionCard(
                  title: 'Observaciones',
                  icon: Icons.description,
                  color: Colors.teal,
                  children: [
                    _buildTextField(
                      controller: _observationsController,
                      label: 'Observaciones Generales',
                      icon: Icons.note,
                      maxLines: 4,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Card del estado de completado
                if (widget.initialData != null) ...[
                  _buildSectionCard(
                    title: 'Estado de la Etapa',
                    icon: Icons.check_circle_outline,
                    color: Colors.green,
                    children: [
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
                  const SizedBox(height: 16),
                ],

                // Botón de Guardar
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.vinoTinto,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: ColorPalette.vinoTinto.withOpacity(0.4),
                    ),
                    child: _isLoading
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Guardando...',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          )
                        : Text(
                            widget.initialData != null ? 'Actualizar Prensado' : 'Crear Prensado',
                            style: const TextStyle(
                              fontSize: 18,
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

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required MaterialColor color,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.05),
              color.withOpacity(0.02),
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
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color.shade600,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
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
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
    );
  }

  Widget _buildNumericField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool allowDecimal = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: [
        if (allowDecimal)
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
        else
          FilteringTextInputFormatter.digitsOnly,
      ],
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
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: ColorPalette.vinoTinto),
        suffixIcon: Icon(Icons.calendar_today, color: ColorPalette.vinoTinto),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      onTap: onTap,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'La fecha de inicio es obligatoria';
        }
        return null;
      },
    );
  }
}
