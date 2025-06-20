import 'package:equatable/equatable.dart';

class Stages extends Equatable {
  final String id;
  final String batchId;
  final ReceptionStage? receptionStage;
  final CorrectionStage? correctionStage;
  final FermentationStage? fermentationStage;
  final PressingStage? pressingStage;
  final ClarificationStage? clarificationStage;
  final AgingStage? agingStage;
  final FiltrationStage? filtrationStage;
  final BottlingStage? bottlingStage;

  const Stages({
    required this.id,
    required this.batchId,
    this.receptionStage,
    this.correctionStage,
    this.fermentationStage,
    this.pressingStage,
    this.clarificationStage,
    this.agingStage,
    this.filtrationStage,
    this.bottlingStage,
  });

  @override
  List<Object?> get props => [
        id,
        batchId,
        receptionStage,
        correctionStage,
        fermentationStage,
        pressingStage,
        clarificationStage,
        agingStage,
        filtrationStage,
        bottlingStage,
      ];
}

class ReceptionStage extends Equatable {
  final String stage;
  final String registeredBy;
  final String startDate;
  final String endDate;
  final double sugarLevelBrix;
  final double pH;
  final double temperature;
  final double quantityKg;
  final String comments;
  final bool isCompleted;

  const ReceptionStage({
    required this.stage,
    required this.registeredBy,
    required this.startDate,
    required this.endDate,
    required this.sugarLevelBrix,
    required this.pH,
    required this.temperature,
    required this.quantityKg,
    required this.comments,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [
        stage,
        registeredBy,
        startDate,
        endDate,
        sugarLevelBrix,
        pH,
        temperature,
        quantityKg,
        comments,
        isCompleted,
      ];
}

class CorrectionStage extends Equatable {
  final String stage;
  final String registeredBy;
  final String startDate;
  final String endDate;
  final double initialBrix;
  final double finalBrix;
  final double addedSugarKg;
  final double initialPH;
  final double finalPH;
  final String acidType;
  final double acidAddedGL;
  final int SO2AddedMgL;
  final List<Nutrient> nutrientsAdded;
  final String justification;
  final String comments;
  final bool isCompleted;

  const CorrectionStage({
    required this.stage,
    required this.registeredBy,
    required this.startDate,
    required this.endDate,
    required this.initialBrix,
    required this.finalBrix,
    required this.addedSugarKg,
    required this.initialPH,
    required this.finalPH,
    required this.acidType,
    required this.acidAddedGL,
    required this.SO2AddedMgL,
    required this.nutrientsAdded,
    required this.justification,
    required this.comments,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [
        stage,
        registeredBy,
        startDate,
        endDate,
        initialBrix,
        finalBrix,
        addedSugarKg,
        initialPH,
        finalPH,
        acidType,
        acidAddedGL,
        SO2AddedMgL,
        nutrientsAdded,
        justification,
        comments,
        isCompleted,
      ];
}

class FermentationStage extends Equatable {
  final String stage;
  final String registeredBy;
  final String startDate;
  final String endDate;
  final double yeastUsedMgL;
  final double pH;
  final double initialBrix;
  final double finalBrix;
  final double initialpH;
  final double finalpH;
  final double temperatureMax;
  final double temperatureMin;
  final String fermentationType;
  final String tankCode;
  final bool isFinalized;
  final String comments;
  final bool isCompleted;

  const FermentationStage({
    required this.stage,
    required this.registeredBy,
    required this.startDate,
    required this.endDate,
    required this.yeastUsedMgL,
    required this.pH,
    required this.initialBrix,
    required this.finalBrix,
    required this.initialpH,
    required this.finalpH,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.fermentationType,
    required this.tankCode,
    required this.isFinalized,
    required this.comments,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [
        stage,
        registeredBy,
        startDate,
        endDate,
        yeastUsedMgL,
        pH,
        initialBrix,
        finalBrix,
        initialpH,
        finalpH,
        temperatureMax,
        temperatureMin,
        fermentationType,
        tankCode,
        isFinalized,
        comments,
        isCompleted,
      ];
}

class PressingStage extends Equatable {
  final String stage;
  final String registeredBy;
  final String startDate;
  final String endDate;
  final String pressType;
  final double pressPressureBars;
  final int durationMinutes;
  final double pomaceKg;
  final double yieldLiters;
  final String mustUsage;
  final String comments;
  final bool isCompleted;

  const PressingStage({
    required this.stage,
    required this.registeredBy,
    required this.startDate,
    required this.endDate,
    required this.pressType,
    required this.pressPressureBars,
    required this.durationMinutes,
    required this.pomaceKg,
    required this.yieldLiters,
    required this.mustUsage,
    required this.comments,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [
        stage,
        registeredBy,
        startDate,
        endDate,
        pressType,
        pressPressureBars,
        durationMinutes,
        pomaceKg,
        yieldLiters,
        mustUsage,
        comments,
        isCompleted,
      ];
}

class ClarificationStage extends Equatable {
  final String stage;
  final String registeredBy;
  final String startDate;
  final String endDate;
  final String method;
  final List<ClarifyingAgent> clarifyingAgents;
  final double turbidityBeforeNTU;
  final double turbidityAfterNTU;
  final double volumeLiters;
  final double temperature;
  final int durationHours;
  final String comments;
  final bool isCompleted;

  const ClarificationStage({
    required this.stage,
    required this.registeredBy,
    required this.startDate,
    required this.endDate,
    required this.method,
    required this.clarifyingAgents,
    required this.turbidityBeforeNTU,
    required this.turbidityAfterNTU,
    required this.volumeLiters,
    required this.temperature,
    required this.durationHours,
    required this.comments,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [
        stage,
        registeredBy,
        startDate,
        endDate,
        method,
        clarifyingAgents,
        turbidityBeforeNTU,
        turbidityAfterNTU,
        volumeLiters,
        temperature,
        durationHours,
        comments,
        isCompleted,
      ];
}

class AgingStage extends Equatable {
  final String stage;
  final String registeredBy;
  final String startDate;
  final String endDate;
  final String containerType;
  final String material;
  final String containerCode;
  final double avgTemperature;
  final double volumeLiters;
  final int durationMonths;
  final int frequencyDays;
  final int refilled;
  final int batonnage;
  final int rackings;
  final String purpose;
  final String comments;
  final bool isCompleted;

  const AgingStage({
    required this.stage,
    required this.registeredBy,
    required this.startDate,
    required this.endDate,
    required this.containerType,
    required this.material,
    required this.containerCode,
    required this.avgTemperature,
    required this.volumeLiters,
    required this.durationMonths,
    required this.frequencyDays,
    required this.refilled,
    required this.batonnage,
    required this.rackings,
    required this.purpose,
    required this.comments,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [
        stage,
        registeredBy,
        startDate,
        endDate,
        containerType,
        material,
        containerCode,
        avgTemperature,
        volumeLiters,
        durationMonths,
        frequencyDays,
        refilled,
        batonnage,
        rackings,
        purpose,
        comments,
        isCompleted,
      ];
}

class FiltrationStage extends Equatable {
  final String stage;
  final String registeredBy;
  final String startDate;
  final String endDate;
  final String filtrationType;
  final String filterMedia;
  final double poreMicrons;
  final double turbidityBefore;
  final double turbidityAfter;
  final double temperature;
  final double pressureBars;
  final double filteredVolumeLiters;
  final bool isSterile;
  final bool filterChanged;
  final String changeReason;
  final String comments;
  final bool isCompleted;

  const FiltrationStage({
    required this.stage,
    required this.registeredBy,
    required this.startDate,
    required this.endDate,
    required this.filtrationType,
    required this.filterMedia,
    required this.poreMicrons,
    required this.turbidityBefore,
    required this.turbidityAfter,
    required this.temperature,
    required this.pressureBars,
    required this.filteredVolumeLiters,
    required this.isSterile,
    required this.filterChanged,
    required this.changeReason,
    required this.comments,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [
        stage,
        registeredBy,
        startDate,
        endDate,
        filtrationType,
        filterMedia,
        poreMicrons,
        turbidityBefore,
        turbidityAfter,
        temperature,
        pressureBars,
        filteredVolumeLiters,
        isSterile,
        filterChanged,
        changeReason,
        comments,
        isCompleted,
      ];
}

class BottlingStage extends Equatable {
  final String stage;
  final String registeredBy;
  final String startDate;
  final String endDate;
  final String bottlingLine;
  final int bottlesFilled;
  final int bottleVolumeMl;
  final double totalVolumeLiters;
  final String sealType;
  final String code;
  final double temperature;
  final bool wasFiltered;
  final bool wereLabelsApplied;
  final bool wereCapsulesApplied;
  final String comments;
  final bool isCompleted;

  const BottlingStage({
    required this.stage,
    required this.registeredBy,
    required this.startDate,
    required this.endDate,
    required this.bottlingLine,
    required this.bottlesFilled,
    required this.bottleVolumeMl,
    required this.totalVolumeLiters,
    required this.sealType,
    required this.code,
    required this.temperature,
    required this.wasFiltered,
    required this.wereLabelsApplied,
    required this.wereCapsulesApplied,
    required this.comments,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [
        stage,
        registeredBy,
        startDate,
        endDate,
        bottlingLine,
        bottlesFilled,
        bottleVolumeMl,
        totalVolumeLiters,
        sealType,
        code,
        temperature,
        wasFiltered,
        wereLabelsApplied,
        wereCapsulesApplied,
        comments,
        isCompleted,
      ];
}

class Nutrient extends Equatable {
  final String name;
  final double quantityMgL;
  final String unit;

  const Nutrient({
    required this.name,
    required this.quantityMgL,
    required this.unit,
  });

  @override
  List<Object> get props => [name, quantityMgL, unit];
}

class ClarifyingAgent extends Equatable {
  final String name;
  final double dose;
  final String unit;

  const ClarifyingAgent({
    required this.name,
    required this.dose,
    required this.unit,
  });

  @override
  List<Object> get props => [name, dose, unit];
}
