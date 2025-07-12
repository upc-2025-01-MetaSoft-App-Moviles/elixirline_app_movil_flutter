
import 'package:elixirline_app_movil_flutter/features/winemaking-process/domain/entities/wine_batch.dart';

/*
{
  "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "campaignId": "string",
  "internalCode": "string",
  "campaign": "string",
  "vineyard": "string",
  "grapeVariety": "string",
  "createdBy": "string"
}
*/

class WineBatchDTO {
  final String id;
  final String campaignId;
  final String internalCode;
  final String campaign;
  final String vineyard;
  final String grapeVariety;
  final String createdBy;

  WineBatchDTO({
    required this.id,
    required this.campaignId,
    required this.internalCode,
    required this.campaign,
    required this.vineyard,
    required this.grapeVariety,
    required this.createdBy,
  });

  factory WineBatchDTO.fromJson(Map<String, dynamic> json) {
    return WineBatchDTO(
      id: json['id'] as String,
      campaignId: json['campaignId'] as String,
      internalCode: json['internalCode'] as String,
      campaign: json['campaign'] as String,
      vineyard: json['vineyard'] as String,
      grapeVariety: json['grapeVariety'] as String,
      createdBy: json['createdBy'] as String,
    );
  }

  WineBatch toDomain() {
    return WineBatch(
      id: id,
      campaignId: campaignId,
      internalCode: internalCode,
      campaign: campaign,
      vineyard: vineyard,
      grapeVariety: grapeVariety,
      createdBy: createdBy,
    );
  }

  
}






