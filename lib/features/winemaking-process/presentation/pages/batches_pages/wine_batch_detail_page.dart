import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
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
  
  /*
  Etapas de vinificación:
  1. "stages-reception": 
  2. "stages-correction"
  3. "stages-fermentation":
  4. "stages-pressing":
  5. "stages-clarification":
  6. "stages-aging":
  7. "stages-filtration":
  8. "stages-bottling":
  */

  // Servicio de la primera etapa de vinificación 
  late WineBatchDTO _batch;

  @override
  void initState() {
    super.initState();
    _batch = widget.batch;
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

              // Lista de etapas de vinificación
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Etapas de Vinificación',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.vinoTinto,
                  ),
                ),
              ),
              // Aquí se mostrarían las etapas registradas
              // Por ahora, solo un texto de ejemplo
              Text(
                'No hay etapas registradas aún.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
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
}
