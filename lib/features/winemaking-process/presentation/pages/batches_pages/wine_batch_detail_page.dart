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
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/batches_pages/wine_batch_create_and_edit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WineBatchDetailsPage extends StatefulWidget {
  final WineBatchDTO batch;

  const WineBatchDetailsPage({super.key, required this.batch});

  @override
  State<WineBatchDetailsPage> createState() => _WineBatchDetailsPageState();
}

class _WineBatchDetailsPageState extends State<WineBatchDetailsPage> {
  // Servicio de la primera etapa de vinificación
  late WineBatchDTO _batch;

  // Servicios para las etapas de vinificación
  final ReceptionStageService _receptionStageService = ReceptionStageService(
    'wine-batch',
  );
  final CorrectionStageService _correctionStageService = CorrectionStageService(
    'wine-batch',
  );
  final FermentationStageService _fermentationStageService =
      FermentationStageService('wine-batch');
  final PressingStageService _pressingStageService = PressingStageService(
    'wine-batch',
  );
  final ClarificationStageService _clarificationStageService =
      ClarificationStageService('wine-batch');
  final AgingStageService _agingStageService = AgingStageService('wine-batch');
  final FiltrationStageService _filtrationStageService = FiltrationStageService(
    'wine-batch',
  );
  final BottlingStageService _bottlingStageService = BottlingStageService(
    'wine-batch',
  );

  // Instancias de las etapas de vinificación
  late ReceptionStageDto receptionStageDto;
  late CorrectionStageDto correctionStageDto;
  late FermentationStageDto fermentationStageDto;
  late PressingStageDto pressingStageDto;
  late ClarificationStageDto clarificationStageDto;
  late AgingStageDto agingStageDto;
  late FiltrationStageDto filtrationStageDto;
  late BottlingStageDto bottlingStageDto;

  Future<void> _loadStages() async {

    // Cargar las etapas de vinificación desde los servicios
    try {
      receptionStageDto = await _receptionStageService.getReceptionStage(_batch.id);
      correctionStageDto = await _correctionStageService.getCorrectionStage(_batch.id);
      fermentationStageDto = await _fermentationStageService.getFermentationStage(_batch.id);
      pressingStageDto = await _pressingStageService.getPressingStage(_batch.id);
      clarificationStageDto = await _clarificationStageService.getClarificationStage(_batch.id);
      agingStageDto = await _agingStageService.getAgingStage(_batch.id);
      filtrationStageDto = await _filtrationStageService.getFiltrationStage(_batch.id);
      bottlingStageDto = await _bottlingStageService.getBottlingStage(_batch.id);
    } catch (e) {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar las etapas: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _batch = widget.batch;
    _loadStages(); // ← nuevo método para traer etapas
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

  // Método para navegar a la vista de deatalles de la etapa de vinificación
  Future<void> _navigateToStageDetails(String stageType) async {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPalette.vinoTinto,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Text(
            'Detalles del Lote de Vino',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context, _batch),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBatchInfoCard(),
              SizedBox(height: 20),
              _buildStagesHeader(),
              Divider(),
              SizedBox(height: 10),

              // Tarjetas de las etapas de vinificación
              _buildStageCard(
                stageType: 'Recepción',
                stageData: receptionStageDto,
                onTap: () => _navigateToStageDetails('reception'),
              ),

              _buildStageCard(
                stageType: 'Corrección',
                stageData: correctionStageDto,
                onTap: () => _navigateToStageDetails('correction'),
              ),

              _buildStageCard(
                stageType: 'Fermentación',
                stageData: fermentationStageDto,
                onTap: () => _navigateToStageDetails('fermentation'),
              ),

              _buildStageCard(
                stageType: 'Prensado',
                stageData: pressingStageDto,
                onTap: () => _navigateToStageDetails('pressing'),
              ),

              _buildStageCard(
                stageType: 'Clarificación',
                stageData: clarificationStageDto,
                onTap: () => _navigateToStageDetails('clarification'),
              ),

              _buildStageCard(
                stageType: 'Aging',
                stageData: agingStageDto,
                onTap: () => _navigateToStageDetails('aging'),
              ),

              _buildStageCard(
                stageType: 'Filtración',
                stageData: filtrationStageDto,
                onTap: () => _navigateToStageDetails('filtration'),
              ),

              _buildStageCard(
                stageType: 'Embotellado',
                stageData: bottlingStageDto,
                onTap: () => _navigateToStageDetails('bottling'),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBatchInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _batch.internalCode,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: ColorPalette.vinoTinto),
                  onPressed: _navigateToEditBatch,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            _infoRow(
              icon: Icons.landscape,
              label: 'Viñedo',
              value: _batch.vineyard,
            ),
            _infoRow(
              icon: Icons.calendar_today,
              label: 'Campaña',
              value: _batch.campaign,
            ),
            _infoRow(
              icon: Icons.eco,
              label: 'Variedad de uva',
              value: _batch.grapeVariety,
            ),
            _infoRow(
              iconData: FontAwesomeIcons.user,
              label: 'Creado por',
              value: _batch.createdBy.split('@').first,
              iconSize: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    IconData? icon,
    IconData? iconData,
    required String label,
    required String value,
    double iconSize = 20,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        children: [
          Icon(icon ?? iconData, size: iconSize, color: Colors.black54),
          const SizedBox(width: 8),
          Text('$label: $value', style: const TextStyle(fontSize: 16)),
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
          onPressed: () {
            // Agregar un nuevo registro de la etapa que sigue en el proceso de vinificación son o etapas de vinificación
          },
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


  Widget _buildStageCard({
    required String stageType,
    required dynamic stageData,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        title: Text(stageType, style: const TextStyle(fontSize: 18)),
        subtitle: stageData != null
            ? Text('Fecha de inicio: ${stageData.startDate ?? 'No disponible'}\n'
                'Estado: ${stageData.isCompleted ? 'Completado' : 'En progreso'}')
            : const Text('No disponible'),
        trailing: Icon(Icons.arrow_forward_ios, color: ColorPalette.vinoTinto),
        onTap: onTap,
      ),
    );
  }

}
