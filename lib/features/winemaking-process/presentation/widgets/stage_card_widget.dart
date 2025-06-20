import 'package:flutter/material.dart';
import '../../domain/entities/stages.dart';

class StageCardWidget extends StatelessWidget {
  final String title;
  final dynamic stage;
  final IconData icon;

  const StageCardWidget({
    super.key,
    required this.title,
    required this.stage,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.grey, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF8B0000)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildStageContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildStageContent() {
    if (stage is ReceptionStage) {
      final receptionStage = stage as ReceptionStage;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📅 Inicio: ${receptionStage.startDate}'),
          Text('🍇 Cantidad: ${receptionStage.quantityKg} kg | 🌡️ Temp: ${receptionStage.temperature}°C'),
          Text('👤 Registrado por: ${receptionStage.registeredBy}'),
          Text(
            receptionStage.isCompleted ? '✔ Completado' : '❌ No completado',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      );
    } else if (stage is CorrectionStage) {
      final correctionStage = stage as CorrectionStage;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📅 Inicio: ${correctionStage.startDate}'),
          Text('Brix: ${correctionStage.initialBrix} → ${correctionStage.finalBrix}'),
          Text('pH: ${correctionStage.initialPH} → ${correctionStage.finalPH}'),
          Text('Azúcar añadida: ${correctionStage.addedSugarKg} kg'),
          Text('👤 Registrado por: ${correctionStage.registeredBy}'),
          Text(
            correctionStage.isCompleted ? '✔ Completado' : '❌ No completado',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      );
    } else if (stage is FermentationStage) {
      final fermentationStage = stage as FermentationStage;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📅 ${fermentationStage.startDate}'),
          Text('Brix: ${fermentationStage.initialBrix} → ${fermentationStage.finalBrix} | pH: ${fermentationStage.initialpH} → ${fermentationStage.finalpH}'),
          Text('Temp: ${fermentationStage.temperatureMin}°C – ${fermentationStage.temperatureMax}°C | Levadura: ${fermentationStage.yeastUsedMgL} mg/L'),
          Text('Tanque: ${fermentationStage.tankCode} | ${fermentationStage.registeredBy}'),
          Text(
            fermentationStage.isCompleted ? '✔ Completado' : '❌ No completado',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      );
    } else if (stage is PressingStage) {
      final pressingStage = stage as PressingStage;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📅 Inicio: ${pressingStage.startDate}'),
          Text('Tipo: ${pressingStage.pressType} | Presión: ${pressingStage.pressPressureBars} bar'),
          Text('Rendimiento: ${pressingStage.yieldLiters} L | Orujo: ${pressingStage.pomaceKg} kg'),
          Text('👤 Registrado por: ${pressingStage.registeredBy}'),
          Text(
            pressingStage.isCompleted ? '✔ Completado' : '❌ No completado',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      );
    } else if (stage is ClarificationStage) {
      final clarificationStage = stage as ClarificationStage;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📅 ${clarificationStage.startDate}'),
          Text('Método: ${clarificationStage.method} | Temp: ${clarificationStage.temperature}°C'),
          Text('Turbidez: ${clarificationStage.turbidityBeforeNTU} → ${clarificationStage.turbidityAfterNTU} NTU'),
          Text('Volumen: ${clarificationStage.volumeLiters} L'),
          Text('👤 Registrado por: ${clarificationStage.registeredBy}'),
          Text(
            clarificationStage.isCompleted ? '✔ Completado' : '❌ No completado',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      );
    } else if (stage is AgingStage) {
      final agingStage = stage as AgingStage;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📅 ${agingStage.startDate}'),
          Text('Contenedor: ${agingStage.containerType} (${agingStage.material})'),
          Text('Volumen: ${agingStage.volumeLiters} L | Tiempo: ${agingStage.durationMonths} meses'),
          Text('👤 Registrado por: ${agingStage.registeredBy}'),
          Text(
            agingStage.isCompleted ? '✔ Completado' : '❌ No completado',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      );
    } else if (stage is FiltrationStage) {
      final filtrationStage = stage as FiltrationStage;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📅 ${filtrationStage.startDate}'),
          Text('Tipo: ${filtrationStage.filtrationType} | Medio: ${filtrationStage.filterMedia}'),
          Text('Turbidez: ${filtrationStage.turbidityBefore} → ${filtrationStage.turbidityAfter} NTU'),
          Text('Volumen: ${filtrationStage.filteredVolumeLiters} L | Temp: ${filtrationStage.temperature}°C'),
          Text('👤 Registrado por: ${filtrationStage.registeredBy}'),
          Text(
            filtrationStage.isCompleted ? '✔ Completado' : '❌ No completado',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      );
    } else if (stage is BottlingStage) {
      final bottlingStage = stage as BottlingStage;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📅 ${bottlingStage.startDate}'),
          Text('Línea: ${bottlingStage.bottlingLine} | Botellas: ${bottlingStage.bottlesFilled}'),
          Text('Volumen total: ${bottlingStage.totalVolumeLiters} L (${bottlingStage.bottleVolumeMl} ml por botella)'),
          Text('Tipo de sello: ${bottlingStage.sealType}'),
          Text('👤 Registrado por: ${bottlingStage.registeredBy}'),
          Text(
            bottlingStage.isCompleted ? '✔ Completado' : '❌ No completado',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      );
    }
    
    return const Text('Información de etapa no disponible');
  }
}
