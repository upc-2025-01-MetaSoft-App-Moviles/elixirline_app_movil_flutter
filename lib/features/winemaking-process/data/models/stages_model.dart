import '../../domain/entities/stages.dart';

class StagesModel extends Stages {
  const StagesModel({
    required super.id,
    required super.batchId,
    super.receptionStage,
    super.correctionStage,
    super.fermentationStage,
    super.pressingStage,
    super.clarificationStage,
    super.agingStage,
    super.filtrationStage,
    super.bottlingStage,
  });

  factory StagesModel.fromJson(Map<String, dynamic> json) {
    return StagesModel(
      id: json['id'] ?? '',
      batchId: json['batchId'] ?? '',
      receptionStage: json['receptionStage'] != null
          ? ReceptionStageModel.fromJson(json['receptionStage'])
          : null,
      correctionStage: json['correctionStage'] != null
          ? CorrectionStageModel.fromJson(json['correctionStage'])
          : null,
      fermentationStage: json['fermentationStage'] != null
          ? FermentationStageModel.fromJson(json['fermentationStage'])
          : null,
      pressingStage: json['pressingStage'] != null
          ? PressingStageModel.fromJson(json['pressingStage'])
          : null,
      clarificationStage: json['clarificationStage'] != null
          ? ClarificationStageModel.fromJson(json['clarificationStage'])
          : null,
      agingStage: json['agingStage'] != null
          ? AgingStageModel.fromJson(json['agingStage'])
          : null,
      filtrationStage: json['filtrationStage'] != null
          ? FiltrationStageModel.fromJson(json['filtrationStage'])
          : null,
      bottlingStage: json['bottlingStage'] != null
          ? BottlingStageModel.fromJson(json['bottlingStage'])
          : null,
    );
  }

  factory StagesModel.fromEntity(Stages stages) {
    return StagesModel(
      id: stages.id,
      batchId: stages.batchId,
      receptionStage: stages.receptionStage,
      correctionStage: stages.correctionStage,
      fermentationStage: stages.fermentationStage,
      pressingStage: stages.pressingStage,
      clarificationStage: stages.clarificationStage,
      agingStage: stages.agingStage,
      filtrationStage: stages.filtrationStage,
      bottlingStage: stages.bottlingStage,
    );
  }
}

class ReceptionStageModel extends ReceptionStage {
  const ReceptionStageModel({
    required super.stage,
    required super.registeredBy,
    required super.startDate,
    required super.endDate,
    required super.sugarLevelBrix,
    required super.pH,
    required super.temperature,
    required super.quantityKg,
    required super.comments,
    required super.isCompleted,
  });

  factory ReceptionStageModel.fromJson(Map<String, dynamic> json) {
    return ReceptionStageModel(
      stage: json['stage'] ?? '',
      registeredBy: json['registeredBy'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      sugarLevelBrix: (json['sugarLevelBrix'] ?? 0).toDouble(),
      pH: (json['pH'] ?? 0).toDouble(),
      temperature: (json['temperature'] ?? 0).toDouble(),
      quantityKg: (json['quantityKg'] ?? 0).toDouble(),
      comments: json['comments'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class CorrectionStageModel extends CorrectionStage {
  const CorrectionStageModel({
    required super.stage,
    required super.registeredBy,
    required super.startDate,
    required super.endDate,
    required super.initialBrix,
    required super.finalBrix,
    required super.addedSugarKg,
    required super.initialPH,
    required super.finalPH,
    required super.acidType,
    required super.acidAddedGL,
    required super.SO2AddedMgL,
    required super.nutrientsAdded,
    required super.justification,
    required super.comments,
    required super.isCompleted,
  });

  factory CorrectionStageModel.fromJson(Map<String, dynamic> json) {
    return CorrectionStageModel(
      stage: json['stage'] ?? '',
      registeredBy: json['registeredBy'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      initialBrix: (json['initialBrix'] ?? 0).toDouble(),
      finalBrix: (json['finalBrix'] ?? 0).toDouble(),
      addedSugarKg: (json['addedSugarKg'] ?? 0).toDouble(),
      initialPH: (json['initialPH'] ?? 0).toDouble(),
      finalPH: (json['finalPH'] ?? 0).toDouble(),
      acidType: json['acidType'] ?? '',
      acidAddedGL: (json['acidAddedGL'] ?? 0).toDouble(),
      SO2AddedMgL: json['SO2AddedMgL'] ?? 0,
      nutrientsAdded: (json['nutrientsAdded'] as List<dynamic>?)
              ?.map((e) => NutrientModel.fromJson(e))
              .toList() ??
          [],
      justification: json['justification'] ?? '',
      comments: json['comments'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class FermentationStageModel extends FermentationStage {
  const FermentationStageModel({
    required super.stage,
    required super.registeredBy,
    required super.startDate,
    required super.endDate,
    required super.yeastUsedMgL,
    required super.pH,
    required super.initialBrix,
    required super.finalBrix,
    required super.initialpH,
    required super.finalpH,
    required super.temperatureMax,
    required super.temperatureMin,
    required super.fermentationType,
    required super.tankCode,
    required super.isFinalized,
    required super.comments,
    required super.isCompleted,
  });

  factory FermentationStageModel.fromJson(Map<String, dynamic> json) {
    return FermentationStageModel(
      stage: json['stage'] ?? '',
      registeredBy: json['registeredBy'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      yeastUsedMgL: (json['yeastUsedMgL'] ?? 0).toDouble(),
      pH: (json['pH'] ?? 0).toDouble(),
      initialBrix: (json['initialBrix'] ?? 0).toDouble(),
      finalBrix: (json['finalBrix'] ?? 0).toDouble(),
      initialpH: (json['initialpH'] ?? 0).toDouble(),
      finalpH: (json['finalpH'] ?? 0).toDouble(),
      temperatureMax: (json['temperatureMax'] ?? 0).toDouble(),
      temperatureMin: (json['temperatureMin'] ?? 0).toDouble(),
      fermentationType: json['fermentationType'] ?? '',
      tankCode: json['tankCode'] ?? '',
      isFinalized: json['isFinalized'] ?? false,
      comments: json['comments'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class PressingStageModel extends PressingStage {
  const PressingStageModel({
    required super.stage,
    required super.registeredBy,
    required super.startDate,
    required super.endDate,
    required super.pressType,
    required super.pressPressureBars,
    required super.durationMinutes,
    required super.pomaceKg,
    required super.yieldLiters,
    required super.mustUsage,
    required super.comments,
    required super.isCompleted,
  });

  factory PressingStageModel.fromJson(Map<String, dynamic> json) {
    return PressingStageModel(
      stage: json['stage'] ?? '',
      registeredBy: json['registeredBy'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      pressType: json['pressType'] ?? '',
      pressPressureBars: (json['pressPressureBars'] ?? 0).toDouble(),
      durationMinutes: json['durationMinutes'] ?? 0,
      pomaceKg: (json['pomaceKg'] ?? 0).toDouble(),
      yieldLiters: (json['yieldLiters'] ?? 0).toDouble(),
      mustUsage: json['mustUsage'] ?? '',
      comments: json['comments'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class ClarificationStageModel extends ClarificationStage {
  const ClarificationStageModel({
    required super.stage,
    required super.registeredBy,
    required super.startDate,
    required super.endDate,
    required super.method,
    required super.clarifyingAgents,
    required super.turbidityBeforeNTU,
    required super.turbidityAfterNTU,
    required super.volumeLiters,
    required super.temperature,
    required super.durationHours,
    required super.comments,
    required super.isCompleted,
  });

  factory ClarificationStageModel.fromJson(Map<String, dynamic> json) {
    return ClarificationStageModel(
      stage: json['stage'] ?? '',
      registeredBy: json['registeredBy'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      method: json['method'] ?? '',
      clarifyingAgents: (json['clarifyingAgents'] as List<dynamic>?)
              ?.map((e) => ClarifyingAgentModel.fromJson(e))
              .toList() ??
          [],
      turbidityBeforeNTU: (json['turbidityBeforeNTU'] ?? 0).toDouble(),
      turbidityAfterNTU: (json['turbidityAfterNTU'] ?? 0).toDouble(),
      volumeLiters: (json['volumeLiters'] ?? 0).toDouble(),
      temperature: (json['temperature'] ?? 0).toDouble(),
      durationHours: json['durationHours'] ?? 0,
      comments: json['comments'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class AgingStageModel extends AgingStage {
  const AgingStageModel({
    required super.stage,
    required super.registeredBy,
    required super.startDate,
    required super.endDate,
    required super.containerType,
    required super.material,
    required super.containerCode,
    required super.avgTemperature,
    required super.volumeLiters,
    required super.durationMonths,
    required super.frequencyDays,
    required super.refilled,
    required super.batonnage,
    required super.rackings,
    required super.purpose,
    required super.comments,
    required super.isCompleted,
  });

  factory AgingStageModel.fromJson(Map<String, dynamic> json) {
    return AgingStageModel(
      stage: json['stage'] ?? '',
      registeredBy: json['registeredBy'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      containerType: json['containerType'] ?? '',
      material: json['material'] ?? '',
      containerCode: json['containerCode'] ?? '',
      avgTemperature: (json['avgTemperature'] ?? 0).toDouble(),
      volumeLiters: (json['volumeLiters'] ?? 0).toDouble(),
      durationMonths: json['durationMonths'] ?? 0,
      frequencyDays: json['frequencyDays'] ?? 0,
      refilled: json['refilled'] ?? 0,
      batonnage: json['batonnage'] ?? 0,
      rackings: json['rackings'] ?? 0,
      purpose: json['purpose'] ?? '',
      comments: json['comments'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class FiltrationStageModel extends FiltrationStage {
  const FiltrationStageModel({
    required super.stage,
    required super.registeredBy,
    required super.startDate,
    required super.endDate,
    required super.filtrationType,
    required super.filterMedia,
    required super.poreMicrons,
    required super.turbidityBefore,
    required super.turbidityAfter,
    required super.temperature,
    required super.pressureBars,
    required super.filteredVolumeLiters,
    required super.isSterile,
    required super.filterChanged,
    required super.changeReason,
    required super.comments,
    required super.isCompleted,
  });

  factory FiltrationStageModel.fromJson(Map<String, dynamic> json) {
    return FiltrationStageModel(
      stage: json['stage'] ?? '',
      registeredBy: json['registeredBy'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      filtrationType: json['filtrationType'] ?? '',
      filterMedia: json['filterMedia'] ?? '',
      poreMicrons: (json['poreMicrons'] ?? 0).toDouble(),
      turbidityBefore: (json['turbidityBefore'] ?? 0).toDouble(),
      turbidityAfter: (json['turbidityAfter'] ?? 0).toDouble(),
      temperature: (json['temperature'] ?? 0).toDouble(),
      pressureBars: (json['pressureBars'] ?? 0).toDouble(),
      filteredVolumeLiters: (json['filteredVolumeLiters'] ?? 0).toDouble(),
      isSterile: json['isSterile'] ?? false,
      filterChanged: json['filterChanged'] ?? false,
      changeReason: json['changeReason'] ?? '',
      comments: json['comments'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class BottlingStageModel extends BottlingStage {
  const BottlingStageModel({
    required super.stage,
    required super.registeredBy,
    required super.startDate,
    required super.endDate,
    required super.bottlingLine,
    required super.bottlesFilled,
    required super.bottleVolumeMl,
    required super.totalVolumeLiters,
    required super.sealType,
    required super.code,
    required super.temperature,
    required super.wasFiltered,
    required super.wereLabelsApplied,
    required super.wereCapsulesApplied,
    required super.comments,
    required super.isCompleted,
  });

  factory BottlingStageModel.fromJson(Map<String, dynamic> json) {
    return BottlingStageModel(
      stage: json['stage'] ?? '',
      registeredBy: json['registeredBy'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      bottlingLine: json['bottlingLine'] ?? '',
      bottlesFilled: json['bottlesFilled'] ?? 0,
      bottleVolumeMl: json['bottleVolumeMl'] ?? 0,
      totalVolumeLiters: (json['totalVolumeLiters'] ?? 0).toDouble(),
      sealType: json['sealType'] ?? '',
      code: json['code'] ?? '',
      temperature: (json['temperature'] ?? 0).toDouble(),
      wasFiltered: json['wasFiltered'] ?? false,
      wereLabelsApplied: json['wereLabelsApplied'] ?? false,
      wereCapsulesApplied: json['wereCapsulesApplied'] ?? false,
      comments: json['comments'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class NutrientModel extends Nutrient {
  const NutrientModel({
    required super.name,
    required super.quantityMgL,
    required super.unit,
  });

  factory NutrientModel.fromJson(Map<String, dynamic> json) {
    return NutrientModel(
      name: json['name'] ?? '',
      quantityMgL: (json['quantityMgL'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
    );
  }
}

class ClarifyingAgentModel extends ClarifyingAgent {
  const ClarifyingAgentModel({
    required super.name,
    required super.dose,
    required super.unit,
  });

  factory ClarifyingAgentModel.fromJson(Map<String, dynamic> json) {
    return ClarifyingAgentModel(
      name: json['name'] ?? '',
      dose: (json['dose'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
    );
  }
}
