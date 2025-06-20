import '../../domain/entities/wine_batch.dart';

class WineBatchModel extends WineBatch {
  const WineBatchModel({
    required super.id,
    required super.internalCode,
    required super.receptionDate,
    required super.harvestCampaign,
    required super.vineyardOrigin,
    required super.grapeVariety,
    required super.initialGrapeQuantityKg,
    required super.createdBy,
    required super.status,
    required super.currentStage,
    super.urlImage,
  });

  factory WineBatchModel.fromJson(Map<String, dynamic> json) {
    return WineBatchModel(
      id: json['id'] ?? '',
      internalCode: json['internal_code'] ?? '',
      receptionDate: json['reception_date'] ?? '',
      harvestCampaign: json['harvest_campaign'] ?? '',
      vineyardOrigin: json['vineyard_origin'] ?? '',
      grapeVariety: json['grape_variety'] ?? '',
      initialGrapeQuantityKg: (json['initial_grape_quantity_kg'] ?? 0).toDouble(),
      createdBy: json['created_by'] ?? '',
      status: json['status'] ?? '',
      currentStage: json['current_stage'] ?? '',
      urlImage: json['url_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'internal_code': internalCode,
      'reception_date': receptionDate,
      'harvest_campaign': harvestCampaign,
      'vineyard_origin': vineyardOrigin,
      'grape_variety': grapeVariety,
      'initial_grape_quantity_kg': initialGrapeQuantityKg,
      'created_by': createdBy,
      'status': status,
      'current_stage': currentStage,
      'url_image': urlImage,
    };
  }

  factory WineBatchModel.fromEntity(WineBatch batch) {
    return WineBatchModel(
      id: batch.id,
      internalCode: batch.internalCode,
      receptionDate: batch.receptionDate,
      harvestCampaign: batch.harvestCampaign,
      vineyardOrigin: batch.vineyardOrigin,
      grapeVariety: batch.grapeVariety,
      initialGrapeQuantityKg: batch.initialGrapeQuantityKg,
      createdBy: batch.createdBy,
      status: batch.status,
      currentStage: batch.currentStage,
      urlImage: batch.urlImage,
    );
  }
}
