
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/fermentation_stage_dto.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/fermentation_pages/fermentation_create_and_edit_page.dart';
import 'package:flutter/material.dart';


/*
{
  "startedAt": "string",
  "completedAt": "string",
  "completedBy": "string",
  "isCompleted": true,
  "yeastUsed": "string",
  "initialSugarLevel": 0,
  "finalSugarLevel": 0,
  "initialPh": 0,
  "finalPh": 0,
  "temperatureMax": 0,
  "temperatureMin": 0,
  "fermentationType": "string",
  "tankCode": "string",
  "observations": "string"
}
*/


class FermentationDetailsPage extends StatefulWidget {
  final FermentationStageDto fermentationDto;
  final String batchId;

  const FermentationDetailsPage({
    super.key, 
    required this.fermentationDto,
    required this.batchId,
  });

  @override
  State<FermentationDetailsPage> createState() => _FermentationDetailsPageState();
}

class _FermentationDetailsPageState extends State<FermentationDetailsPage> {

  late FermentationStageDto _fermentationDto;

  @override
  void initState() {
    super.initState();
    _fermentationDto = widget.fermentationDto;
  }

  Future<void> _navigateToEditFermentation() async {
    final result = await Navigator.push<FermentationStageDto>(
      context,
      MaterialPageRoute(
        builder: (context) => FermentationCreateAndEditPage(
          batchId: widget.batchId,
          initialData: _fermentationDto,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _fermentationDto = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Etapa de fermentación actualizada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detalles de Fermentación'),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _navigateToEditFermentation,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información de Fermentación',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 12),
                  _buildDetailRow(Icons.calendar_today, 'Fecha de Inicio', _fermentationDto.startedAt),
                  _buildDetailRow(Icons.calendar_month, 'Fecha de Finalización', _fermentationDto.completedAt.isNotEmpty ? _fermentationDto.completedAt : "N/A"),
                  _buildDetailRow(Icons.person, 'Realizado por', _fermentationDto.completedBy),
                  _buildDetailRow(
                    _fermentationDto.isCompleted ? Icons.check_circle : Icons.cancel,
                    '¿Completado?',
                    _fermentationDto.isCompleted ? "Sí" : "No",
                  ),
                  _buildDetailRow(Icons.comment, 'Observaciones', _fermentationDto.observations.isNotEmpty ? _fermentationDto.observations : "N/A"),
                  Divider(height: 32),

                  // Detalles de Fermentación
                  Text(
                    'Detalles de Fermentación',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 12),
                  _buildDetailRow(Icons.opacity, 'Azúcar Inicial', '${_fermentationDto.initialSugarLevel} g/L'),
                  _buildDetailRow(Icons.opacity, 'Azúcar Final', '${_fermentationDto.finalSugarLevel} g/L'),
                  _buildDetailRow(Icons.local_cafe, 'Tipo de Levadura', _fermentationDto.yeastUsed),
                  _buildDetailRow(Icons.science, 'pH Inicial', '${_fermentationDto.initialPh}'),
                  _buildDetailRow(Icons.science_outlined, 'pH Final', '${_fermentationDto.finalPh}'),
                  _buildDetailRow(Icons.thermostat, 'Temperatura Máxima', '${_fermentationDto.temperatureMax} °C'),
                  _buildDetailRow(Icons.thermostat_outlined, 'Temperatura Mínima', '${_fermentationDto.temperatureMin} °C'),
                  _buildDetailRow(Icons.local_drink, 'Tipo de Fermentación', _fermentationDto.fermentationType),
                  _buildDetailRow(Icons.takeout_dining_sharp, 'Código de Tanque', _fermentationDto.tankCode),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.teal),
          SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

  
