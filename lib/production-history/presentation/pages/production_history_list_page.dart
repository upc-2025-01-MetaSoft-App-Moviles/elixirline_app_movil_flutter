import 'package:flutter/material.dart';
import '../../domain/entities/production_history.dart';
import '../../data/repositories/production_history_repositoryImpl.dart';
import '../../data/datasources/production_history_service.dart';

class ProductionHistoryListPage extends StatefulWidget {
  const ProductionHistoryListPage({Key? key}) : super(key: key);

  @override
  State<ProductionHistoryListPage> createState() => _ProductionHistoryListPageState();
}

class _ProductionHistoryListPageState extends State<ProductionHistoryListPage> {
  final repository = ProductionHistoryRepositoryImpl(
    productionHistoryService: ProductionHistoryService(),
  );
  
  List<ProductionHistory>? _productionHistories;
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProductionHistories();
  }

  Future<void> _loadProductionHistories() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      final histories = await repository.getAllProductionHistories();
      
      setState(() {
        _productionHistories = histories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    repository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Producción'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildLogo(),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
       child: const Text(
        'ElixirLine',
         style: TextStyle(
         fontSize: 28,
          fontWeight: FontWeight.bold,
         color: Color.fromARGB(255, 216, 20, 20),
        ),
       ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProductionHistories,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_productionHistories == null || _productionHistories!.isEmpty) {
      return const Center(
        child: Text('No hay historiales de producción disponibles'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProductionHistories,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _productionHistories!.length,
        itemBuilder: (context, index) {
          final history = _productionHistories![index];
          return _buildProductionHistoryCard(history);
        },
      ),
    );
  }

  Widget _buildProductionHistoryCard(ProductionHistory history) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lote: ${history.batchId}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Fecha inicio:', 
                '${history.startDate.day}/${history.startDate.month}/${history.startDate.year}'),
            _buildInfoRow('Fecha fin:', 
                '${history.endDate.day}/${history.endDate.month}/${history.endDate.year}'),
            _buildInfoRow('Volumen producido:', '${history.volumeProduced} lt'),
            const Divider(),
            const Text(
              'Métricas de calidad:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Brix:', '${history.qualityMetrics.brix}'),
            _buildInfoRow('pH:', '${history.qualityMetrics.ph}'),
            _buildInfoRow('Temperatura:', '${history.qualityMetrics.temperature}°C'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}