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
      // Filtrar lotes por código de loteo 2025
      setState(() {
        filteredBatches = wineBatches.where((batch) {
          return batch.vineyard.toLowerCase().contains(query) ||
              batch.internalCode.toLowerCase().contains(query);
        }).toList();
      });
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
            onPressed: () async {
              final newBatch = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateWineBatchPage()),
              );

              if (newBatch != null) {
                if (newBatch is WineBatchDTO) {
                  // Insertar directamente si es creación
                  setState(() {
                    wineBatches.insert(0, newBatch);
                    _filterBatches();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lote creado exitosamente')),
                  );
                } else if (newBatch == 'updated') {
                  // Volver a cargar si fue edición
                  await loadWineBatches();
                  _filterBatches();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lote actualizado exitosamente'),
                    ),
                  );
                }
              }
            },
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
          ? const Center(
              child: Text(
                'No se encontraron lotes de vino.',
                style: TextStyle(fontSize: 16, color: ColorPalette.grisPizarra),
              ),
            )
          : ListView.builder(
              itemCount: filteredBatches.length,
              itemBuilder: (context, index) {
                final batch = filteredBatches[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),

                  child: InkWell(
                    splashColor: ColorPalette.vinoTinto.withOpacity(0.2),
                    highlightColor: ColorPalette.vinoTinto.withOpacity(0.1),
                    onTap: () {
                      // Navegar a la página de detalles del lote de vino
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WineBatchDetailsPage(batch: batch),
                        ),
                      );
                    },

                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Código: ${batch.internalCode}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Divider(
                            thickness: 1.0,
                            color: ColorPalette.grisPizarra,
                          ),

                          _buildIconTextRow(
                            Icons.calendar_today,
                            'Campaña: ${batch.campaign}',
                          ),
                          _buildIconTextRow(
                            Icons.landscape,
                            'Viñedo: ${batch.vineyard}',
                          ),
                          _buildIconTextRow(
                            Icons.eco,
                            'Variedad de uva: ${batch.grapeVariety}',
                          ),

                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.user,
                                size: 16,
                                color: ColorPalette.grisPizarra,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Creado por: ${batch.createdBy.split('@').first}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: ColorPalette.grisPizarra,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Widget para mostrar icono y texto uno al lado de otro
  Widget _buildIconTextRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black54),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
