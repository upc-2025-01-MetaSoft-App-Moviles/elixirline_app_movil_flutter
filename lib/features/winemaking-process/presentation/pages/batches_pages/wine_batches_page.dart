import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/datasources/wine_batch_service.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/wine_batch_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/batches_pages/wine_batch_create_and_edit.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/batches_pages/wine_batch_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WineBatchesPage extends StatefulWidget {
  const WineBatchesPage({super.key});

  @override
  State<WineBatchesPage> createState() => _WineBatchesPageState();
}

class _WineBatchesPageState extends State<WineBatchesPage> {
  // Lista de lotes de vino
  List<WineBatchDTO> wineBatches = [];

  // Lista de lotes de vino filtrados
  List<WineBatchDTO> filteredBatches = [];

  // Controlador de búsqueda para filtrar lotes por código interno
  final TextEditingController searchController = TextEditingController();

  // Variable del servicio para consumir la API
  final wineBatchService = WineBatchService('/wine-batch');

  @override
  void initState() {
    super.initState();
    // Cargar los lotes de vino al iniciar la página
    loadWineBatches();
  }

  void _filterBatches() {
    final query = searchController.text
        .toLowerCase(); // Obtener la consulta de búsqueda
    // Filtrar lotes | por código de loteo por nombre de viñedo
    // Si el campo de búsqueda está vacío, mostrar todos los lotes
    if (query.isEmpty) {
      setState(() {
        filteredBatches = wineBatches;
      });
    } else {
      // Filtrar lotes por código
      setState(() {
        filteredBatches = wineBatches.where((batch) {
          return batch.vineyard.toLowerCase().contains(query) ||
              batch.internalCode.toLowerCase().contains(query);
        }).toList();
      });
    }
  }

  void _addNewBatch(WineBatchDTO batch) {
    setState(() {
      wineBatches.insert(0, batch);
      _filterBatches();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Lote creado exitosamente')));
  }

  void _updateBatch(WineBatchDTO updatedBatch) {
    setState(() {
      final index1 = wineBatches.indexWhere((b) => b.id == updatedBatch.id);
      if (index1 != -1) wineBatches[index1] = updatedBatch;

      final index2 = filteredBatches.indexWhere((b) => b.id == updatedBatch.id);
      if (index2 != -1) filteredBatches[index2] = updatedBatch;
    });
  }

  Future<void> _handleCreateOrEditResult() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateAndEditWineBatchPage()),
    );

    if (result != null) {
      if (result is WineBatchDTO) {
        _addNewBatch(result);
      } else if (result == 'updated') {
        await loadWineBatches();
        _filterBatches();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lote actualizado exitosamente')),
        );
      }
    }
  }

  Future<void> loadWineBatches() async {
    try {
      // Llamar al servicio para obtener los lotes de vino
      final batches = await wineBatchService.getWineBatches();
      setState(() {
        wineBatches = batches;
        filteredBatches = batches; // Inicialmente mostrar todos los lotes
      });

      // Mostrar en consola los datos obtenidos
      print('Wine batches loaded: ${wineBatches.length} batches found.');
    } catch (e) {
      // Manejar errores al cargar los lotes
      print('Error loading wine batches: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),

        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorPalette.vinoTinto,
            foregroundColor: Colors.white,
            title: const Center(
              child: Text(
                'Wine Batches',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          body: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 16.0),
                _buildTotalBatches(),
                const Divider(),
                _buildFilteredBatches(),
              ],
            ),
          ),

          // Botón flotante para crear nuevo lote
          floatingActionButton: FloatingActionButton(
            backgroundColor: ColorPalette.vinoTinto,
            onPressed: _handleCreateOrEditResult,
            child: const Icon(Icons.add, color: Colors.white),
            tooltip: 'Crear nuevo lote',
          ),
        ),
      ),
    );
  }

  // Widget para la barra de búsqueda
  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Buscar por viñedo de origen',
        prefixIcon: const Icon(Icons.search),
        labelText: 'Buscar por viñedo de origen',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      onChanged: (value) => _filterBatches(),
    );
  }

  /// Widget para mostrar el total de lotes de vino
  Widget _buildTotalBatches() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Total de lotes de vino: ${filteredBatches.length}',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Widget para mostrar los lotes filtrados en cards
  Widget _buildFilteredBatches() {
    return Expanded(
      child: filteredBatches.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8.0),
              itemCount: filteredBatches.length,
              itemBuilder: (context, index) {
                var batch = filteredBatches[index];
                return _buildBatchCard(batch, index);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorPalette.vinoTinto.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.wine_bar_outlined,
              size: 64,
              color: ColorPalette.vinoTinto.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No se encontraron lotes de vino',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea tu primer lote o ajusta los filtros de búsqueda',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBatchCard(WineBatchDTO batch, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        shadowColor: ColorPalette.vinoTinto,
        color: Colors.grey.shade50,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: ColorPalette.vinoTinto.withOpacity(0.1),
            highlightColor: ColorPalette.vinoTinto.withOpacity(0.05),
            onTap: () async {
              final updatedBatch = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WineBatchDetailsPage(batch: batch),
                ),
              );

              if (updatedBatch != null && updatedBatch is WineBatchDTO) {
                _updateBatch(updatedBatch);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header con código y badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: ColorPalette.vinoTinto.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.local_drink_outlined,
                                color: ColorPalette.vinoTinto,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    batch.internalCode,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: ColorPalette.vinoTinto,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.green.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      'Lote #${index + 1}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: ColorPalette.vinoTinto.withOpacity(0.6),
                        size: 16,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Información principal en grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          Icons.calendar_today_outlined,
                          'Campaña',
                          batch.campaign,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoItem(
                          Icons.eco_outlined,
                          'Variedad',
                          batch.grapeVariety,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Información secundaria
                  _buildDetailRow(
                    Icons.landscape_outlined,
                    'Viñedo',
                    batch.vineyard,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  _buildDetailRow(
                    FontAwesomeIcons.user,
                    'Creado por',
                    batch.createdBy.split('@').first,
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}