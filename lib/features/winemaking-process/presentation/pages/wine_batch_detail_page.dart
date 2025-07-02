import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/wine_batch_dto.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WineBatchDetailsPage extends StatelessWidget {
  const WineBatchDetailsPage({super.key, required this.batch});

  final WineBatchDTO batch;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPalette.vinoTinto,
          foregroundColor: Colors.white,
          title: Text('Detalles del Lote de Vino'),
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // ⚠️ Ajusta al contenido
                    children: [
                      Text(
                        batch.internalCode,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Divider(),
                      Row(
                        children: [
                          Icon(
                            Icons.landscape,
                            size: 20,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Viñedo: ${batch.vineyard}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Campaña: ${batch.campaign}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.eco,
                            size: 20,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Variedad de uva: ${batch.grapeVariety}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.user,
                            size: 18,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Creado por: ${batch.createdBy.split('@').first}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Etapas registradas: ', // ⚠️ Cambiado de "Etapas" a "Etapas registradas" ${batch.stages.length}
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // ⚠️ Botón para agregar una nueva etapa
                  ElevatedButton.icon(
                    onPressed: () {
                      // Aquí puedes implementar la lógica para agregar una nueva etapa
                      print('Agregar nueva etapa');
                    },
                    icon: Icon(Icons.add),
                    label: Text('Agregar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.vinoTinto,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),

              Divider(),

            ],
          ),
        ),
      ),
    );
  }
}
