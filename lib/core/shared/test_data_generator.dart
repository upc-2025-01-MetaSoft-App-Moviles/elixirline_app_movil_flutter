import 'package:flutter/foundation.dart';
import '../../features/winemaking-process/data/datasources/wine_batch_service.dart';
import '../../features/winemaking-process/data/datasources/reception_stage_service.dart';
import '../../features/winemaking-process/data/datasources/correction_stage_service.dart';
import '../../features/winemaking-process/data/datasources/fermentation_stage_service.dart';
import '../../features/winemaking-process/data/datasources/pressing_stage_service.dart';
import '../../features/winemaking-process/data/datasources/clarification_stage_service.dart';
import '../../features/winemaking-process/data/datasources/aging_stage_service.dart';
import '../../features/winemaking-process/data/datasources/filtration_stage_service.dart';
import '../../features/winemaking-process/data/datasources/bottling_stage_service.dart';

class TestDataGenerator {
  static const String _basePath = '/wine-batch';
  
  // Servicio para lotes de vino
  static final _wineBatchService = WineBatchService(_basePath);
  
  // Servicios para cada etapa
  static final _receptionService = ReceptionStageService(_basePath);
  static final _correctionService = CorrectionStageService(_basePath);
  static final _fermentationService = FermentationStageService(_basePath);
  static final _pressingService = PressingStageService(_basePath);
  static final _clarificationService = ClarificationStageService(_basePath);
  static final _agingService = AgingStageService(_basePath);
  static final _filtrationService = FiltrationStageService(_basePath);
  static final _bottlingService = BottlingStageService(_basePath);

  /// Genera y almacena lotes de prueba en el backend
  /// [batchCount] - Número de lotes a crear (1-4, por defecto 4)
  static Future<void> generateAndStoreTestData({int batchCount = 4}) async {
    if (batchCount < 1 || batchCount > 4) {
      throw ArgumentError('batchCount debe estar entre 1 y 4');
    }

    if (kDebugMode) {
      print('🍷 === INICIANDO GENERACIÓN DE $batchCount LOTES DE PRUEBA ===');
    }

    try {
      final List<dynamic> createdBatches = [];

      // 1. Lote completo (todas las etapas) - Siempre se crea primero
      if (batchCount >= 1) {
        final premiumBatch = await _createWineBatch('', {
          'campaignId': 'premium-campaign-2025',
          'internalCode': 'PREM-CAB-2025',
          'campaign': 'Premium Harvest 2025',
          'vineyard': 'Viñedo Premium Norte',
          'grapeVariety': 'Cabernet Sauvignon',
          'createdBy': 'Master Winemaker Juan Pérez',
        });
        await _createCompleteBatch(premiumBatch.id, 'cabernet');
        createdBatches.add({'batch': premiumBatch, 'stages': 8, 'type': 'Premium Cabernet'});
      }
      
      // 2. Lote parcial - hasta fermentación (3 etapas)
      if (batchCount >= 2) {
        final reservaBatch = await _createWineBatch('', {
          'campaignId': 'reserva-campaign-2025',
          'internalCode': 'RES-MER-2025',
          'campaign': 'Reserva Collection 2025',
          'vineyard': 'Viñedo Reserva Sur',
          'grapeVariety': 'Merlot',
          'createdBy': 'Enólogo Junior Pedro Ramírez',
        });
        await _createPartialBatch(reservaBatch.id, stages: ['reception', 'correction', 'fermentation'], batchType: 'merlot');
        createdBatches.add({'batch': reservaBatch, 'stages': 3, 'type': 'Reserva Merlot'});
      }
      
      // 3. Lote parcial - hasta prensado (4 etapas)
      if (batchCount >= 3) {
        final economicoBatch = await _createWineBatch('', {
          'campaignId': 'economic-campaign-2025',
          'internalCode': 'ECO-BLD-2025',
          'campaign': 'Línea Económica 2025',
          'vineyard': 'Viñedo Comercial Este',
          'grapeVariety': 'Blend Comercial',
          'createdBy': 'Técnico de Producción Ana Silva',
        });
        await _createPartialBatch(economicoBatch.id, stages: ['reception', 'correction', 'fermentation', 'pressing'], batchType: 'blend');
        createdBatches.add({'batch': economicoBatch, 'stages': 4, 'type': 'Blend Económico'});
      }
      
      // 4. Lote inicial - solo recepción (1 etapa)
      if (batchCount >= 4) {
        final experimentalBatch = await _createWineBatch('', {
          'campaignId': 'research-campaign-2025',
          'internalCode': 'EXP-SYR-2025',
          'campaign': 'Investigación y Desarrollo 2025',
          'vineyard': 'Viñedo Experimental',
          'grapeVariety': 'Syrah',
          'createdBy': 'Investigadora Dr. Elena Vega',
        });
        await _createPartialBatch(experimentalBatch.id, stages: ['reception'], batchType: 'syrah');
        createdBatches.add({'batch': experimentalBatch, 'stages': 1, 'type': 'Experimental Syrah'});
      }

      if (kDebugMode) {
        print('🎉 === $batchCount LOTES DE PRUEBA GENERADOS EXITOSAMENTE ===');
        for (var batch in createdBatches) {
          print('✅ ${batch['type']} (${batch['batch'].id}): ${batch['stages']}/8 etapas');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error generando datos de prueba: $e');
      }
      rethrow;
    }
  }

  /// Crea un lote de vino en el backend y retorna el DTO
  static Future<dynamic> _createWineBatch(String batchId, Map<String, String> batchData) async {
    if (kDebugMode) {
      print('📦 Creando lote de vino con datos: ${batchData['grapeVariety']}');
    }
    
    // No incluir 'id' en el payload, dejar que el backend lo genere
    final result = await _wineBatchService.createWineBatch({
      'campaignId': batchData['campaignId'] ?? 'campaign-2025',
      'internalCode': batchData['internalCode'] ?? 'BATCH-2025',
      'campaign': batchData['campaign'] ?? 'Cosecha 2025',
      'vineyard': batchData['vineyard'] ?? 'Viñedo Principal',
      'grapeVariety': batchData['grapeVariety'] ?? 'Variedad Mixta',
      'createdBy': batchData['createdBy'] ?? 'Sistema Automatizado',
    });
    
    if (kDebugMode) {
      print('✅ Lote creado con ID: ${result.id}');
    }
    
    return result;
  }

  /// Crea un lote completo con todas las 8 etapas
  static Future<void> _createCompleteBatch(String batchId, [String batchType = 'cabernet']) async {
    if (kDebugMode) {
      print('🍇 Creando etapas para lote completo: $batchId ($batchType)');
    }

    // 1. Recepción
    if (kDebugMode) print('📤 ======================= Creando Reception Stage');
    await _receptionService.create(batchId, {
      'sugarLevel': 24.8,
      'pH': 3.65,
      'temperature': 18.0,
      'quantityKg': 2500.0,
      'startedAt': '15/09/2025',
      'completedBy': 'Master Winemaker Juan Pérez',
      'observations': 'Uvas Cabernet Sauvignon de viñedo premium, excelente estado sanitario, madurez óptima. Cosecha manual en horas frescas de la mañana.',
    });
    if (kDebugMode) print('✅ Reception Stage completada');

    // 2. Corrección
    if (kDebugMode) print('📤 ======================= Creando Correction Stage');
    await _correctionService.create(batchId, {
      'initialSugarLevel': 24.8,
      'finalSugarLevel': 25.2,
      'addedSugarKg': 10.0,
      'initialPh': 3.65,
      'finalPh': 3.6,
      'acidType': 'Ácido tartárico',
      'acidAddedGl': 2.5,
      'so2AddedMgL': 45.0,
      'justification': 'Corrección preventiva para asegurar fermentación óptima y estabilidad del producto final',
      'startedAt': '16/09/2025',
      'completedBy': 'Enólogo Senior María González',
      'observations': 'Ligero ajuste de acidez para optimizar el balance. Parámetros dentro de rangos ideales.',
    });
    if (kDebugMode) print('✅ Correction Stage completada');

    // 3. Fermentación
    if (kDebugMode) print('📤 ======================= Creando Fermentation Stage');
    await _fermentationService.create(batchId, {
      'yeastUsed': 'Saccharomyces cerevisiae EC-1118',
      'initialBrix': 24.8,
      'finalBrix': 2.1,
      'initialPh': 3.65,
      'finalPh': 3.55,
      'temperatureMax': 28.0,
      'temperatureMin': 24.0,
      'fermentationType': 'Fermentación controlada',
      'tankCode': 'TANK-PREM-001',
      'startedAt': '17/09/2025',
      'completedBy': 'Especialista en Fermentación Carlos Ruiz',
      'observations': 'Fermentación controlada a temperatura constante. Excelente desarrollo aromático y color intenso.',
    });
    if (kDebugMode) print('✅ Fermentation Stage completada');

    // 4. Prensado
    if (kDebugMode) print('📤 ======================= Creando Pressing Stage');
    await _pressingService.create(batchId, {
      'pressType': 'Prensa neumática',
      'pressPressureBars': 2.0,
      'durationMinutes': 180,
      'pomaceKg': 625.0,
      'yieldLiters': 1875.0,
      'mustUsage': 'Vino premium',
      'startedAt': '06/10/2025',
      'completedBy': 'Técnico de Prensado Luis Martín',
      'observations': 'Prensado suave para preservar taninos finos. Excelente rendimiento y calidad del mosto.',
    });

    // 5. Clarificación
    await _clarificationService.create(batchId, {
      'method': 'Bentonita + Filtración',
      'turbidityBeforeNtu': 85.0,
      'turbidityAfterNtu': 12.0,
      'volumeLiters': 1875.0,
      'temperature': 16.0,
      'durationHours': 168,
      'startedAt': '07/10/2025',
      'completedBy': 'Especialista en Clarificación Ana Torres',
      'observations': 'Clarificación natural seguida de filtración suave. Vino limpio y brillante.',
    });

    // 6. Envejecimiento
    await _agingService.create(batchId, {
      'containerType': 'Barrica',
      'material': 'Roble francés',
      'containerCode': 'BAR-FR-001',
      'avgTemperature': 16.0,
      'volumeLiters': 225.0,
      'durationMonths': 12,
      'frequencyDays': 30,
      'refilled': 3,
      'batonnage': 6,
      'rackings': 4,
      'purpose': 'Desarrollo de complejidad aromática y estabilización',
      'startedAt': '15/10/2025',
      'completedBy': 'Master Winemaker Juan Pérez',
      'observations': 'Envejecimiento en barricas de roble francés de 225L. Desarrollo de complejidad aromática excepcional.',
    });

    // 7. Filtración
    await _filtrationService.create(batchId, {
      'filtrationType': 'Esterilizante',
      'filterMedia': 'Placas de celulosa',
      'poreMicrons': 0.45,
      'turbidityBefore': 12.0,
      'turbidityAfter': 1.5,
      'temperature': 18.0,
      'pressureBars': 2.5,
      'filteredVolumeLiters': 1850.0,
      'isSterile': true,
      'filterChanged': false,
      'changeReason': 'No requerido',
      'startedAt': '16/10/2026',
      'completedBy': 'Técnico de Filtración Roberto Silva',
      'observations': 'Filtración final con placas esterilizantes. Vino estable y listo para embotellado.',
    });

    // 8. Embotellado
    await _bottlingService.create(batchId, {
      'bottlingLine': 'Línea Premium A',
      'bottlesFilled': 2450,
      'bottleVolumeMl': 750,
      'totalVolumeLiters': 1837.5,
      'sealType': 'Corcho natural portugués',
      'code': 'PREM-CAB-2025-001',
      'temperature': 18.0,
      'wasFiltered': true,
      'wereLabelsApplied': true,
      'wereCapsulesApplied': true,
      'startedAt': '18/10/2026',
      'completedBy': 'Jefe de Línea Carmen López',
      'observations': 'Embotellado premium con corcho natural y cápsula dorada. Etiquetado de lujo aplicado.',
    });

    if (kDebugMode) {
      print('✅ Lote completo creado: $batchId (8/8 etapas)');
    }
  }

  /// Crea un lote parcial con solo algunas etapas
  static Future<void> _createPartialBatch(String batchId, {required List<String> stages, String batchType = 'default'}) async {
    if (kDebugMode) {
      print('🍇 Creando etapas para lote parcial: $batchId ($batchType) (${stages.length} etapas)');
    }

    // Datos base para diferentes tipos de lotes
    Map<String, dynamic> batchConfig = _getBatchConfiguration(batchType);

    for (String stage in stages) {
      switch (stage) {
        case 'reception':
          await _receptionService.create(batchId, {
            'sugarLevel': batchConfig['reception']['sugarLevel'],
            'pH': batchConfig['reception']['pH'],
            'temperature': batchConfig['reception']['temperature'],
            'quantityKg': batchConfig['reception']['quantityKg'],
            'startedAt': batchConfig['dates']['reception']['start'],
            'completedBy': batchConfig['staff']['reception'],
            'observations': batchConfig['observations']['reception'],
          });
          break;

        case 'correction':
          await _correctionService.create(batchId, {
            'initialSugarLevel': batchConfig['correction']['initialSugarLevel'],
            'finalSugarLevel': batchConfig['correction']['finalSugarLevel'],
            'addedSugarKg': batchConfig['correction']['addedSugarKg'],
            'initialPh': batchConfig['correction']['initialPh'],
            'finalPh': batchConfig['correction']['finalPh'],
            'acidType': batchConfig['correction']['acidType'],
            'acidAddedGl': batchConfig['correction']['acidAddedGl'],
            'so2AddedMgL': batchConfig['correction']['so2AddedMgL'],
            'justification': batchConfig['correction']['justification'],
            'startedAt': batchConfig['dates']['correction']['start'],
            'completedBy': batchConfig['staff']['correction'],
            'observations': batchConfig['observations']['correction'],
          });
          break;

        case 'fermentation':
          await _fermentationService.create(batchId, {
            'yeastUsed': batchConfig['fermentation']['yeastUsed'],
            'initialBrix': batchConfig['fermentation']['initialBrix'],
            'finalBrix': batchConfig['fermentation']['finalBrix'],
            'initialPh': batchConfig['fermentation']['initialPh'],
            'finalPh': batchConfig['fermentation']['finalPh'],
            'temperatureMax': batchConfig['fermentation']['temperatureMax'],
            'temperatureMin': batchConfig['fermentation']['temperatureMin'],
            'fermentationType': batchConfig['fermentation']['fermentationType'],
            'tankCode': batchConfig['fermentation']['tankCode'],
            'startedAt': batchConfig['dates']['fermentation']['start'],
            'completedBy': batchConfig['staff']['fermentation'],
            'observations': batchConfig['observations']['fermentation'],
          });
          break;

        case 'pressing':
          await _pressingService.create(batchId, {
            'pressType': batchConfig['pressing']['pressType'] ?? 'Prensa neumática',
            'pressPressureBars': batchConfig['pressing']['pressure'],
            'durationMinutes': batchConfig['pressing']['duration'],
            'pomaceKg': batchConfig['pressing']['pomaceKg'] ?? 500.0,
            'yieldLiters': batchConfig['pressing']['extractedQuantityL'],
            'mustUsage': batchConfig['pressing']['mustUsage'] ?? 'Comercial',
            'startedAt': batchConfig['dates']['pressing']['start'],
            'completedBy': batchConfig['staff']['pressing'],
            'observations': batchConfig['observations']['pressing'],
          });
          break;
      }
    }

    if (kDebugMode) {
      print('✅ Lote parcial creado: $batchId (${stages.length}/${stages.length} etapas)');
    }
  }

  /// Configuraciones específicas para cada tipo de lote
  static Map<String, dynamic> _getBatchConfiguration(String batchType) {
    switch (batchType) {
      case 'merlot':
        return {
          'dates': {
            'reception': {'start': '20/09/2025', 'end': '20/09/2025'},
            'correction': {'start': '21/09/2025', 'end': '21/09/2025'},
            'fermentation': {'start': '22/09/2025', 'end': '10/10/2025'},
          },
          'staff': {
            'reception': 'Enólogo Junior Pedro Ramírez',
            'correction': 'Técnico de Corrección Sofia Méndez',
            'fermentation': 'Especialista en Fermentación Carlos Ruiz',
          },
          'observations': {
            'reception': 'Uvas Merlot de parcela reserva, excelente concentración y madurez fenólica ideal.',
            'correction': 'Mínima corrección requerida. Parámetros naturales muy buenos.',
            'fermentation': 'Fermentación en progreso con características aromáticas prometedoras.',
          },
          'reception': {
            'sugarLevel': 23.5,
            'pH': 3.7,
            'temperature': 19.0,
            'quantityKg': 1800.0,
          },
          'correction': {
            'initialSugarLevel': 23.5,
            'finalSugarLevel': 23.8,
            'addedSugarKg': 5.4,
            'initialPh': 3.7,
            'finalPh': 3.68,
            'acidType': 'Ácido málico',
            'acidAddedGl': 1.2,
            'so2AddedMgL': 35.0,
            'justification': 'Ajuste mínimo para optimización de fermentación',
          },
          'fermentation': {
            'yeastUsed': 'Saccharomyces cerevisiae D254',
            'initialBrix': 23.5,
            'finalBrix': 2.3,
            'initialPh': 3.7,
            'finalPh': 3.62,
            'temperatureMax': 26.0,
            'temperatureMin': 22.0,
            'fermentationType': 'Fermentación controlada',
            'tankCode': 'TANK-RES-002',
          },
        };

      case 'blend-economico-2025':
        return {
          'dates': {
            'reception': {'start': '25/09/2025', 'end': '25/09/2025'},
            'correction': {'start': '26/09/2025', 'end': '26/09/2025'},
            'fermentation': {'start': '27/09/2025', 'end': '12/10/2025'},
            'pressing': {'start': '13/10/2025', 'end': '13/10/2025'},
          },
          'staff': {
            'reception': 'Técnico Viticultor Ana García',
            'correction': 'Asistente de Enología Miguel Santos',
            'fermentation': 'Operario de Fermentación José López',
            'pressing': 'Técnico de Prensado Luis Martín',
          },
          'observations': {
            'reception': 'Blend de variedades para línea económica, calidad estándar según especificaciones.',
            'correction': 'Corrección estándar para blend comercial, ajustes según protocolo.',
            'fermentation': 'Fermentación masiva controlada, parámetros dentro de rangos comerciales.',
            'pressing': 'Prensado eficiente para maximizar rendimiento del blend comercial.',
          },
          'reception': {
            'sugarLevel': 22.0,
            'pH': 3.85,
            'temperature': 22.0,
            'quantityKg': 5000.0,
          },
          'correction': {
            'initialSugarLevel': 22.0,
            'finalSugarLevel': 22.8,
            'addedSugarKg': 40.0,
            'initialPh': 3.85,
            'finalPh': 3.75,
            'acidType': 'Ácido tartárico',
            'acidAddedGl': 5.0,
            'so2AddedMgL': 50.0,
            'justification': 'Corrección estándar para blend comercial según protocolo establecido',
          },
          'fermentation': {
            'yeastUsed': 'Saccharomyces cerevisiae EC-1118',
            'initialBrix': 22.0,
            'finalBrix': 1.8,
            'initialPh': 3.85,
            'finalPh': 3.68,
            'temperatureMax': 24.0,
            'temperatureMin': 20.0,
            'fermentationType': 'Fermentación comercial',
            'tankCode': 'TANK-ECO-003',
          },
          'pressing': {
            'pressType': 'Prensa neumática ecológica',
            'pressure': 2.8,
            'duration': 240,
            'pomaceKg': 520.0,
            'extractedQuantityL': 3750.0,
            'mustUsage': 'Comercial',
          },
        };

      case 'experimental-syrah-2025':
        return {
          'dates': {
            'reception': {'start': '30/09/2025', 'end': '30/09/2025'},
          },
          'staff': {
            'reception': 'Investigador Principal Dr. Elena Vega',
          },
          'observations': {
            'reception': 'Lote experimental Syrah para investigación de nuevas técnicas de vinificación. Parámetros registrados para estudio.',
          },
          'reception': {
            'sugarLevel': 26.2,
            'pH': 3.45,
            'temperature': 17.0,
            'quantityKg': 500.0,
          },
        };

      case 'blend':
        return {
          'dates': {
            'reception': {'start': '25/09/2025', 'end': '25/09/2025'},
            'correction': {'start': '26/09/2025', 'end': '26/09/2025'},
            'fermentation': {'start': '27/09/2025', 'end': '15/10/2025'},
            'pressing': {'start': '16/10/2025', 'end': '16/10/2025'},
          },
          'staff': {
            'reception': 'Técnico de Recepción Miguel Santos',
            'correction': 'Enólogo Comercial Laura Fernández',
            'fermentation': 'Técnico de Fermentación Roberto García',
            'pressing': 'Operador de Prensa José Morales',
          },
          'observations': {
            'reception': 'Blend de variedades para línea económica, calidad estándar según especificaciones.',
            'correction': 'Corrección estándar para blend comercial, ajustes según protocolo.',
            'fermentation': 'Fermentación controlada para blend comercial, perfil aromático balanceado.',
            'pressing': 'Prensado eficiente para maximizar rendimiento del blend comercial.',
          },
          'reception': {
            'sugarLevel': 23.2,
            'pH': 3.8,
            'temperature': 22.0,
            'quantityKg': 3200.0,
          },
          'correction': {
            'initialSugarLevel': 23.2,
            'finalSugarLevel': 23.8,
            'addedSugarKg': 12.8,
            'initialPh': 3.8,
            'finalPh': 3.7,
            'acidType': 'Ácido tartárico',
            'acidAddedGl': 1.8,
            'so2AddedMgL': 40.0,
            'justification': 'Corrección estándar para blend comercial según protocolo establecido',
          },
          'fermentation': {
            'yeastUsed': 'Levadura comercial blend',
            'initialBrix': 23.8,
            'finalBrix': 2.2,
            'initialPh': 3.7,
            'finalPh': 3.65,
            'temperatureMax': 26.0,
            'temperatureMin': 22.0,
            'fermentationType': 'Fermentación comercial',
            'tankCode': 'TANK-BLEND-001',
          },
          'pressing': {
            'pressType': 'Prensa neumática comercial',
            'pressure': 2.5,
            'duration': 210,
            'pomaceKg': 480.0,
            'extractedQuantityL': 2800.0,
            'mustUsage': 'Comercial',
          },
        };

      case 'syrah':
        return {
          'dates': {
            'reception': {'start': '30/09/2025', 'end': '30/09/2025'},
          },
          'staff': {
            'reception': 'Investigador Principal Dr. Elena Vega',
          },
          'observations': {
            'reception': 'Lote experimental Syrah para investigación de nuevas técnicas de vinificación. Parámetros registrados para estudio.',
          },
          'reception': {
            'sugarLevel': 26.2,
            'pH': 3.45,
            'temperature': 17.0,
            'quantityKg': 500.0,
          },
        };

      default:
        throw Exception('Configuración no encontrada para el tipo de lote: $batchType');
    }
  }
}
