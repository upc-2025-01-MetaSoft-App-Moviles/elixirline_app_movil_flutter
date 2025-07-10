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
        builder: (_) => CreateAndEditWineBatchPage(initialData: _batch.toDomain()),
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
              const SizedBox(height: 20),
              _buildStagesHeader(),
              const Divider(),
              // Aquí podrías agregar la lista de etapas
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
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: ColorPalette.vinoTinto),
                  onPressed: _navigateToEditBatch,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            _infoRow(icon: Icons.landscape, label: 'Viñedo', value: _batch.vineyard),
            _infoRow(icon: Icons.calendar_today, label: 'Campaña', value: _batch.campaign),
            _infoRow(icon: Icons.eco, label: 'Variedad de uva', value: _batch.grapeVariety),
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
        const Text(
          'Etapas registradas:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // Lógica para agregar etapa
            print('Agregar nueva etapa');
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



