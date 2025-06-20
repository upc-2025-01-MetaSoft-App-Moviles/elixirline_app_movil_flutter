import 'package:equatable/equatable.dart';

class WineBatch extends Equatable {
  final String id;
  final String internalCode;
  final String receptionDate;
  final String harvestCampaign;
  final String vineyardOrigin;
  final String grapeVariety;
  final double initialGrapeQuantityKg;
  final String createdBy;
  final String status;
  final String currentStage;
  final String? urlImage;

  const WineBatch({
    required this.id,
    required this.internalCode,
    required this.receptionDate,
    required this.harvestCampaign,
    required this.vineyardOrigin,
    required this.grapeVariety,
    required this.initialGrapeQuantityKg,
    required this.createdBy,
    required this.status,
    required this.currentStage,
    this.urlImage,
  });

  WineBatch copyWith({
    String? id,
    String? internalCode,
    String? receptionDate,
    String? harvestCampaign,
    String? vineyardOrigin,
    String? grapeVariety,
    double? initialGrapeQuantityKg,
    String? createdBy,
    String? status,
    String? currentStage,
    String? urlImage,
  }) {
    return WineBatch(
      id: id ?? this.id,
      internalCode: internalCode ?? this.internalCode,
      receptionDate: receptionDate ?? this.receptionDate,
      harvestCampaign: harvestCampaign ?? this.harvestCampaign,
      vineyardOrigin: vineyardOrigin ?? this.vineyardOrigin,
      grapeVariety: grapeVariety ?? this.grapeVariety,
      initialGrapeQuantityKg: initialGrapeQuantityKg ?? this.initialGrapeQuantityKg,
      createdBy: createdBy ?? this.createdBy,
      status: status ?? this.status,
      currentStage: currentStage ?? this.currentStage,
      urlImage: urlImage ?? this.urlImage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        internalCode,
        receptionDate,
        harvestCampaign,
        vineyardOrigin,
        grapeVariety,
        initialGrapeQuantityKg,
        createdBy,
        status,
        currentStage,
        urlImage,
      ];
}
