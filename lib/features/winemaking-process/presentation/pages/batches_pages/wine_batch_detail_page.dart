import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/datasources/aging_stage_service.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/datasources/bottling_stage_service.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/datasources/clarification_stage_service.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/datasources/correction_stage_service.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/datasources/fermentation_stage_service.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/datasources/filtration_stage_service.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/datasources/pressing_stage_service.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/datasources/reception_stage_service.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/aging_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/bottling_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/clarification_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/correction_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/fermentation_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/filtration_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/pressing_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/reception_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/wine_batch_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/aging_pages/aging_create_and_edit_page.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/aging_pages/aging_details_page.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/batches_pages/wine_batch_create_and_edit.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/bottling_pages/bottling_create_and_edit_page.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/bottling_pages/bottling_details_page.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/clarification_pages/clarification_create_and_edit_page.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/clarification_pages/clarification_details_page.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/correction_pages/correction_create_and_edit_page.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/correction_pages/correction_details_page.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/fermentation_pages/fermentation_create_and_edit_page.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/fermentation_pages/fermentation_details_page.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/filtration_pages/filtration_create_and_edit_page.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/filtration_pages/filtration_details_page.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/reception_pages/reception_create_and_edit_page.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/reception_pages/reception_details_page.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/pressing_pages/pressing_create_and_edit_page.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/pressing_pages/pressing_details_page.dart';
import 'package:flutter/material.dart';

class WineBatchDetailsPage extends StatefulWidget {
  final WineBatchDTO batch;

  const WineBatchDetailsPage({super.key, required this.batch});

  @override
  State<WineBatchDetailsPage> createState() => _WineBatchDetailsPageState();
}

class _WineBatchDetailsPageState extends State<WineBatchDetailsPage> {
  late WineBatchDTO _batch;

  late final ReceptionStageService _receptionStageService;
  late final CorrectionStageService _correctionStageService;
  late final FermentationStageService _fermentationStageService;
  late final PressingStageService _pressingStageService;
  late final ClarificationStageService _clarificationStageService;
  late final AgingStageService _agingStageService;
  late final FiltrationStageService _filtrationStageService;
  late final BottlingStageService _bottlingStageService;

  // Etapas de vinificación nullable
  ReceptionStageDto? receptionStageDto;
  CorrectionStageDto? correctionStageDto;
  FermentationStageDto? fermentationStageDto;
  PressingStageDto? pressingStageDto;
  ClarificationStageDto? clarificationStageDto;
  AgingStageDto? agingStageDto;
  FiltrationStageDto? filtrationStageDto;
  BottlingStageDto? bottlingStageDto;

  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  Future<void> _loadStages() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });
    
    try {
      debugPrint('🚀 Iniciando carga de etapas para el lote: ${_batch.id}');

      // Cargar etapas secuencialmente con timeouts para evitar bloqueos
      await _loadStageWithTimeout('recepción', () async {
        receptionStageDto = await _receptionStageService.getReceptionStage(_batch.id);
      });

      await _loadStageWithTimeout('corrección', () async {
        correctionStageDto = await _correctionStageService.getCorrectionStage(_batch.id);
      });

      await _loadStageWithTimeout('fermentación', () async {
        fermentationStageDto = await _fermentationStageService.getFermentationStage(_batch.id);
        if (fermentationStageDto != null) {
          debugPrint('✅ Fermentación cargada - Tanque: ${fermentationStageDto!.tankCode}');
        }
      });

      await _loadStageWithTimeout('prensado', () async {
        pressingStageDto = await _pressingStageService.getPressingStage(_batch.id);
      });

      await _loadStageWithTimeout('clarificación', () async {
        clarificationStageDto = await _clarificationStageService.getClarificationStage(_batch.id);
      });

      await _loadStageWithTimeout('maduración', () async {
        agingStageDto = await _agingStageService.getAgingStage(_batch.id);
      });

      await _loadStageWithTimeout('filtración', () async {
        filtrationStageDto = await _filtrationStageService.getFiltrationStage(_batch.id);
      });

      await _loadStageWithTimeout('embotellado', () async {
        bottlingStageDto = await _bottlingStageService.getBottlingStage(_batch.id);
      });

      debugPrint('🎉 Todas las etapas han sido procesadas exitosamente');
    } catch (e) {
      debugPrint('❌ Error al cargar etapas: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar algunas etapas: $e'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'Reintentar',
              onPressed: _loadStages,
              textColor: Colors.white,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        debugPrint('🏁 Carga de etapas completada');
      }
    }
  }

  Future<void> _loadStageWithTimeout(String stageName, Future<void> Function() loader) async {
    if (!mounted) return;
    
    try {
      debugPrint('⏳ Cargando etapa de $stageName...');
      
      // Timeout de 10 segundos por etapa para evitar bloqueos indefinidos
      await loader().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('⚠️ Timeout al cargar etapa de $stageName');
          throw Exception('Timeout al cargar etapa de $stageName');
        },
      );
      
      debugPrint('✅ Etapa de $stageName cargada exitosamente');
      
      // Pequeña pausa para permitir que la UI responda
      await Future.delayed(const Duration(milliseconds: 50));
      
    } catch (e) {
      debugPrint('⚠️ Etapa de $stageName no encontrada o error: $e');
      // No propagar el error, solo registrarlo
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('🚀 WineBatchDetailsPage initState started');
    
    try {
      _batch = widget.batch;
      debugPrint('✅ Batch assigned: ${_batch.id}');
      
      // Inicializar servicios de manera segura
      _receptionStageService = ReceptionStageService('/wine-batch');
      
      _correctionStageService = CorrectionStageService('/wine-batch');
      
      _fermentationStageService = FermentationStageService('/wine-batch');
      
      _pressingStageService = PressingStageService('/wine-batch');

      _clarificationStageService = ClarificationStageService('/wine-batch');
      
      _agingStageService = AgingStageService('/wine-batch');
      
      _filtrationStageService = FiltrationStageService('/wine-batch');
      
      _bottlingStageService = BottlingStageService('/wine-batch');
      
      debugPrint('🎯 All services initialized, starting stage loading...');
      
      // Dar un pequeño delay para asegurar que la UI se renderice primero
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _loadStages();
        }
      });
      
    } catch (e, stackTrace) {
      debugPrint('❌ Error in initState: $e');
      debugPrint('❌ StackTrace: $stackTrace');
      
      setState(() {
        _isLoading = false;
      });
      
      // Mostrar error al usuario
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al inicializar la página: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      });
    }
    
    debugPrint('🏁 WineBatchDetailsPage initState completed');
  }

  Future<void> _navigateToEditBatch() async {
    final result = await Navigator.push<WineBatchDTO>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CreateAndEditWineBatchPage(initialData: _batch.toDomain()),
      ),
    );

    if (result != null) {
      setState(() {
        _batch = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lote actualizado correctamente')),
      );
    }
  }

  Future<void> _navigateToCreateNextStage() async {
    final nextStageType = _getNextStageType();
    if (nextStageType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todas las etapas ya han sido completadas'),
        ),
      );
      return;
    }

    dynamic result;
    
    switch (nextStageType) {
      case 'reception':
        result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReceptionCreateAndEditPage(
              batchId: _batch.id,
            ),
          ),
        );
        break;
      case 'correction':
        result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CorrectionCreateAndEditPage(
              batchId: _batch.id,
            ),
          ),
        );
        break;
      case 'fermentation':
        result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FermentationCreateAndEditPage(
              wineBatchId: _batch.id,
            ),
          ),
        );
        break;
      case 'pressing':
        result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PressingCreateAndEditPage(
              batchId: _batch.id,
            ),
          ),
        );
        break;
      case 'clarification':
        result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ClarificationCreateAndEditPage(
              batchId: _batch.id,
            ),
          ),
        );
        break;
      case 'aging':
        result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AgingCreateAndEditPage(
              batchId: _batch.id,
            ),
          ),
        );
        break;
      case 'filtration':
        result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FiltrationCreateAndEditPage(
              batchId: _batch.id,
            ),
          ),
        );
        break;
      case 'bottling':
        result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BottlingCreateAndEditPage(
              batchId: _batch.id,
            ),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tipo de etapa no reconocido: $nextStageType'),
          ),
        );
    }

    // Si se creó una nueva etapa, recargar los datos
    if (result != null) {
      setState(() {
        _isLoading = true;
      });
      await _loadStages();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Etapa creada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _navigateToStageDetails(String stageType) async {
    // navegar a ReceptionDetailsPage y mandar el DTO correspondiente
    dynamic result;
    switch (stageType) {
      case 'reception':
        if (receptionStageDto != null) {
          result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReceptionDetailsPage(
                receptionDto: receptionStageDto!,
                batchId: _batch.id,
              ),
            ),
          );
        }
        break;
      case 'correction':
        if (correctionStageDto != null) {
          result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CorrectionDetailsPage(
                correctionDto: correctionStageDto!,
                batchId: _batch.id,
              ),
            ),
          );
        }
        break;
      case 'fermentation':
        if (fermentationStageDto != null) {
          result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FermentationDetailsPage(
                fermentationDto: fermentationStageDto!,
                batchId: _batch.id,
              ),
            ),
          );
        }
        break;
      case 'pressing':
        if (pressingStageDto != null) {
          result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PressingDetailsPage(
                pressingDto: pressingStageDto!,
                batchId: _batch.id,
              ),
            ),
          );
        }
        break;
      case 'clarification':
        if (clarificationStageDto != null) {
          result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ClarificationDetailsPage(
                clarificationDto: clarificationStageDto!,
                batchId: _batch.id,
              ),
            ),
          );
        }
        break;
      case 'aging':
        if (agingStageDto != null) {
          result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AgingDetailsPage(
                agingDto: agingStageDto!,
                batchId: _batch.id,
              ),
            ),
          );
        }
        break;
      case 'filtration':
        if (filtrationStageDto != null) {
          result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FiltrationDetailsPage(
                filtrationDto: filtrationStageDto!,
                batchId: _batch.id,
              ),
            ),
          );
        }
        break;
      case 'bottling':
        if (bottlingStageDto != null) {
          result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BottlingDetailsPage(
                bottlingDto: bottlingStageDto!,
                batchId: _batch.id,
              ),
            ),
          );
        }
        break;
    }
    
    // Si se regresó un resultado (indicando que hubo cambios), recargar las etapas
    if (result != null) {
      setState(() {
        _isLoading = true;
      });
      await _loadStages();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Etapa actualizada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String? _getNextStageName() {
    final stages = [
      {'name': 'Recepción', 'data': receptionStageDto},
      {'name': 'Corrección', 'data': correctionStageDto},
      {'name': 'Fermentación', 'data': fermentationStageDto},
      {'name': 'Prensado', 'data': pressingStageDto},
      {'name': 'Clarificación', 'data': clarificationStageDto},
      {'name': 'Maduración', 'data': agingStageDto},
      {'name': 'Filtración', 'data': filtrationStageDto},
      {'name': 'Embotellado', 'data': bottlingStageDto},
    ];

    final next = stages.firstWhere((s) => s['data'] == null, orElse: () => {});

    return next.isNotEmpty ? next['name'] as String : null;
  }

  List<Map<String, dynamic>> _getCompletedStages() {
    final stages = [
      {'name': 'Recepción', 'data': receptionStageDto, 'type': 'reception'},
      {'name': 'Corrección', 'data': correctionStageDto, 'type': 'correction'},
      {'name': 'Fermentación', 'data': fermentationStageDto, 'type': 'fermentation'},
      {'name': 'Prensado', 'data': pressingStageDto, 'type': 'pressing'},
      {'name': 'Clarificación', 'data': clarificationStageDto, 'type': 'clarification'},
      {'name': 'Maduración', 'data': agingStageDto, 'type': 'aging'},
      {'name': 'Filtración', 'data': filtrationStageDto, 'type': 'filtration'},
      {'name': 'Embotellado', 'data': bottlingStageDto, 'type': 'bottling'},
    ];

    final completed = stages.where((stage) => stage['data'] != null).toList();
    
    // Debug específico para fermentación
    debugPrint('🔍 DEBUG ETAPAS:');
    debugPrint('  - Recepción: ${receptionStageDto != null}');
    debugPrint('  - Corrección: ${correctionStageDto != null}');  
    debugPrint('  - Fermentación: ${fermentationStageDto != null}');
    debugPrint('  - Prensado: ${pressingStageDto != null}');
    debugPrint('  - Total completadas: ${completed.length}');
    
    return completed;
  }

  String? _getNextStageType() {
    final stages = [
      {'name': 'Recepción', 'data': receptionStageDto, 'type': 'reception'},
      {'name': 'Corrección', 'data': correctionStageDto, 'type': 'correction'},
      {'name': 'Fermentación', 'data': fermentationStageDto, 'type': 'fermentation'},
      {'name': 'Prensado', 'data': pressingStageDto, 'type': 'pressing'},
      {'name': 'Clarificación', 'data': clarificationStageDto, 'type': 'clarification'},
      {'name': 'Maduración', 'data': agingStageDto, 'type': 'aging'},
      {'name': 'Filtración', 'data': filtrationStageDto, 'type': 'filtration'},
      {'name': 'Embotellado', 'data': bottlingStageDto, 'type': 'bottling'},
    ];

    final next = stages.firstWhere((s) => s['data'] == null, orElse: () => {});

    return next.isNotEmpty ? next['type'] as String : null;
  }

  /// Formatea la fecha para mostrarla en formato dd/MM/yyyy
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'No especificada';
    }
    
    try {
      DateTime date;
      
      // Limpiar la fecha removiendo componentes de tiempo si existen
      String cleanedDateString = dateString.trim();
      
      // Si contiene espacio (fecha con hora), tomar solo la parte de la fecha
      if (cleanedDateString.contains(' ')) {
        cleanedDateString = cleanedDateString.split(' ')[0];
      }
      
      // Parsear diferentes formatos de entrada
      if (cleanedDateString.contains('-') && cleanedDateString.split('-').length == 3) {
        final parts = cleanedDateString.split('-');
        if (parts[0].length == 4) {
          // yyyy-MM-dd o yyyy-M-d
          date = DateTime.parse(cleanedDateString);
        } else {
          // dd-MM-yyyy o d-M-yyyy
          date = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } else if (cleanedDateString.contains('/') && cleanedDateString.split('/').length == 3) {
        final parts = cleanedDateString.split('/');
        // dd/MM/yyyy o d/M/yyyy
        date = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      } else if (cleanedDateString.contains('T')) {
        // Formato ISO con T
        date = DateTime.parse(cleanedDateString);
      } else {
        // Intentar parseo directo
        date = DateTime.parse(cleanedDateString);
      }
      
      // Formatear como dd/MM/yyyy
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      debugPrint('Error al formatear fecha: $dateString - $e');
      return dateString;
    }
  }

  /// Construye información específica para cada tipo de etapa
  List<Widget> _buildStageSpecificInfo(String stageType, dynamic stageData) {
    switch (stageType) {
      case 'reception':
        if (receptionStageDto != null) {
          return [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'pH ${receptionStageDto!.pH.toStringAsFixed(1)}',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${receptionStageDto!.quantityKg.toStringAsFixed(0)}kg',
                style: TextStyle(
                  color: Colors.purple.shade700,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ];
        }
        break;
      case 'fermentation':
        if (fermentationStageDto != null) {
          return [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${fermentationStageDto!.temperatureMax.toStringAsFixed(1)}°C',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              constraints: const BoxConstraints(maxWidth: 120),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  fermentationStageDto!.yeastUsed.length > 10 
                      ? '${fermentationStageDto!.yeastUsed.substring(0, 10)}...'
                      : fermentationStageDto!.yeastUsed,
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ];
        }
        break;
      case 'correction':
        if (correctionStageDto != null) {
          return [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Corregido',
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ];
        }
        break;
      case 'pressing':
        if (pressingStageDto != null) {
          return [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.indigo.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${pressingStageDto!.pressPressureBars.toStringAsFixed(1)} bar',
                style: TextStyle(
                  color: Colors.indigo.shade700,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (pressingStageDto!.yieldLiters > 0) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${pressingStageDto!.yieldLiters.toStringAsFixed(0)}L',
                  style: TextStyle(
                    color: Colors.teal.shade700,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ];
        }
        break;
      case 'clarification':
        if (clarificationStageDto != null) {
          return [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.cyan.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                clarificationStageDto!.method.length > 8 
                    ? '${clarificationStageDto!.method.substring(0, 8)}...'
                    : clarificationStageDto!.method,
                style: TextStyle(
                  color: Colors.cyan.shade700,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (clarificationStageDto!.initialTurbidityNtu > 0) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${clarificationStageDto!.initialTurbidityNtu.toStringAsFixed(1)} NTU',
                  style: TextStyle(
                    color: Colors.amber.shade700,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ];
        }
        break;
      case 'aging':
        if (agingStageDto != null) {
          return [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.brown.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                agingStageDto!.containerType.length > 8 
                    ? '${agingStageDto!.containerType.substring(0, 8)}...'
                    : agingStageDto!.containerType,
                style: TextStyle(
                  color: Colors.brown.shade700,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (agingStageDto!.volumeLiters > 0) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${agingStageDto!.volumeLiters.toStringAsFixed(0)}L',
                  style: TextStyle(
                    color: Colors.deepOrange.shade700,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ];
        }
        break;
      case 'filtration':
        if (filtrationStageDto != null) {
          return [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                filtrationStageDto!.filterType.length > 8 
                    ? '${filtrationStageDto!.filterType.substring(0, 8)}...'
                    : filtrationStageDto!.filterType,
                style: TextStyle(
                  color: Colors.lightBlue.shade700,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (filtrationStageDto!.poreMicrons > 0) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${filtrationStageDto!.poreMicrons.toStringAsFixed(1)}μm',
                  style: TextStyle(
                    color: Colors.pink.shade700,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ];
        }
        break;
      case 'bottling':
        if (bottlingStageDto != null) {
          return [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.lime.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${bottlingStageDto!.bottlesFilled.toStringAsFixed(0)} bot.',
                style: TextStyle(
                  color: Colors.lime.shade700,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (bottlingStageDto!.bottleVolumeMl > 0) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${bottlingStageDto!.bottleVolumeMl.toStringAsFixed(0)}ml',
                  style: TextStyle(
                    color: Colors.deepPurple.shade700,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ];
        }
        break;
      default:
        return [];
    }
    return [];
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
            'Detalles del Lote de Vino',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context, _batch),
          ),
        ),
        body: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Cargando etapas de vinificación...',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : _hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar las etapas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _loadStages,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalette.vinoTinto,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBatchInfoCard(),
                    SizedBox(height: 20),
                    _buildStagesHeader(),
                    Divider(),
                    SizedBox(height: 10),
                    _buildNextStageMessage(),
                    SizedBox(height: 10),
                    ..._buildCompletedStagesList(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildBatchInfoCard() {
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
            // Header con código y botón de editar
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
                          Icons.local_drink,
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
                              _batch.internalCode,
                              style: TextStyle(
                                fontSize: 24,
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
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                'Lote Activo',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700,
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
                    onPressed: _navigateToEditBatch,
                    tooltip: 'Editar lote',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Grid de información principal
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    Icons.landscape_outlined,
                    'Viñedo',
                    _batch.vineyard,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(
                    Icons.calendar_today_outlined,
                    'Campaña',
                    _batch.campaign,
                    Colors.green,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    Icons.eco_outlined,
                    'Variedad de Uva',
                    _batch.grapeVariety,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(
                    Icons.person_outline,
                    'Creado por',
                    _batch.createdBy.split('@').first,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

  Widget _buildStagesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Etapas de Vinificación',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorPalette.vinoTinto,
          ),
        ),
        ElevatedButton.icon(
          onPressed: _navigateToCreateNextStage,
          icon: const Icon(Icons.add),
          label: const Text('Agregar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPalette.vinoTinto,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildNextStageMessage() {
    final nextStage = _getNextStageName();
    if (nextStage == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '¡Felicidades! Todas las etapas de vinificación han sido completadas.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.green.shade700,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPalette.vinoTinto.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorPalette.vinoTinto.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: ColorPalette.vinoTinto),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Próxima etapa a registrar: $nextStage',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: ColorPalette.vinoTinto,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCompletedStagesList() {
    final completedStages = _getCompletedStages();
    
    if (completedStages.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Aún no se han registrado etapas',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Comience agregando la primera etapa del proceso',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    return completedStages.map((stage) {
      return _buildCompletedStageCard(
        stageName: stage['name'] as String,
        stageType: stage['type'] as String,
        stageData: stage['data'],
      );
    }).toList();
  }

  Widget _buildCompletedStageCard({
    required String stageName,
    required String stageType,
    required dynamic stageData,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ColorPalette.vinoTinto.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.check_circle,
            color: ColorPalette.vinoTinto,
            size: 24,
          ),
        ),
        title: Text(
          stageName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Fecha de inicio: ${_formatDate(stageData?.startedAt)}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Realizado por: ${stageData?.completedBy ?? 'No especificado'}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: (stageData?.isCompleted ?? false) 
                        ? Colors.green.shade100 
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    (stageData?.isCompleted ?? false) ? 'Completado' : 'En progreso',
                    style: TextStyle(
                      color: (stageData?.isCompleted ?? false) 
                          ? Colors.green.shade700 
                          : Colors.orange.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ..._buildStageSpecificInfo(stageType, stageData),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: ColorPalette.vinoTinto,
          size: 16,
        ),
        onTap: () => _navigateToStageDetails(stageType),
      ),
    );
  }

}
