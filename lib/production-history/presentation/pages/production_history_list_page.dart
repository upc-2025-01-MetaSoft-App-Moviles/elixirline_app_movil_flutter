import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
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
  
  final TextEditingController _searchController = TextEditingController();
  String _filterType = 'recordId';
  
  List<ProductionHistory>? _productionHistories;
  List<ProductionHistory>? _filteredHistories;
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
        _filteredHistories = histories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterHistories() {
    if (_productionHistories == null) return;
    
    final query = _searchController.text.toLowerCase().trim();
    
    if (query.isEmpty) {
      setState(() {
        _filteredHistories = _productionHistories;
      });
      return;
    }
    
    setState(() {
      _filteredHistories = _productionHistories!.where((history) {
        if (_filterType == 'recordId') {
          return history.recordId.toLowerCase().contains(query);
        } else {
          return history.batchId.toLowerCase().contains(query);
        }
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _filteredHistories = _productionHistories;
    });
  }

  void _showCreateRecordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => const CreateRecordDialog(),
    ).then((result) {
      if (result == true) {
        _loadProductionHistories();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    repository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildLogo(),
          _buildSearchSection(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Historial de Producción',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateRecordDialog,
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/logo.png',
        height: 80,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B0000),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.science,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'ELIXIRLINE',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B0000),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.filter_list, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  const Text(
                    'Filtrar por:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _filterType,
                      isExpanded: true,
                      underline: Container(),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'recordId',
                          child: Text('Record ID'),
                        ),
                        DropdownMenuItem(
                          value: 'batchId',
                          child: Text('Batch ID'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _filterType = value!;
                          _searchController.clear();
                          _filteredHistories = _productionHistories;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: _filterType == 'recordId' 
                            ? 'Buscar por Record ID...' 
                            : 'Buscar por Batch ID...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      ),
                      onChanged: (_) => _filterHistories(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDC143C), Color(0xFFB22222)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _filterHistories,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Buscar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _clearFilters,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    side: BorderSide(color: Colors.grey.withOpacity(0.4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.clear, size: 18),
                      SizedBox(width: 4),
                      Text('Limpiar'),
                    ],
                  ),
                ),
              ],
            ),
          ],
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

    if (_filteredHistories == null || _filteredHistories!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty
                  ? 'No se encontraron resultados para "${_searchController.text}"'
                  : 'No hay historiales de producción disponibles',
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProductionHistories,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _filteredHistories!.length,
        itemBuilder: (context, index) {
          final history = _filteredHistories![index];
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
            const SizedBox(height: 4),
            Text(
              'Record ID: ${history.recordId}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
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

class CreateRecordDialog extends StatefulWidget {
  const CreateRecordDialog({Key? key}) : super(key: key);

  @override
  State<CreateRecordDialog> createState() => _CreateRecordDialogState();
}

class _CreateRecordDialogState extends State<CreateRecordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();
  
  late final TextEditingController _batchIdController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late final TextEditingController _volumeController;
  late final TextEditingController _brixController;
  late final TextEditingController _phController;
  late final TextEditingController _temperatureController;
  
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _batchIdController = TextEditingController(text: _uuid.v4());
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _volumeController = TextEditingController();
    _brixController = TextEditingController();
    _phController = TextEditingController();
    _temperatureController = TextEditingController();
  }

  @override
  void dispose() {
    _batchIdController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _volumeController.dispose();
    _brixController.dispose();
    _phController.dispose();
    _temperatureController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (picked != null) {
      final formattedDate = "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
      controller.text = formattedDate;
    }
  }

  Future<void> _createRecord() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final service = ProductionHistoryService();
      
      final data = {
        'batchId': _batchIdController.text,
        'startDate': _startDateController.text,
        'endDate': _endDateController.text,
        'volumeProduced': double.parse(_volumeController.text),
        'brix': double.parse(_brixController.text),
        'ph': double.parse(_phController.text),
        'temperature': double.parse(_temperatureController.text),
      };
      
      await service.createProductionRecord(data);
      
      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro creado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear registro: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Crear Nuevo Registro'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _batchIdController,
                  decoration: const InputDecoration(
                    labelText: 'ID del lote',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _startDateController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de inicio (mm/dd/yyyy)',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(_startDateController),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _endDateController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de fin (mm/dd/yyyy)',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(_endDateController),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _volumeController,
                  decoration: const InputDecoration(
                    labelText: 'Volumen producido (L)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Ingrese un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _brixController,
                  decoration: const InputDecoration(
                    labelText: 'Brix',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Ingrese un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _phController,
                  decoration: const InputDecoration(
                    labelText: 'pH',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Ingrese un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _temperatureController,
                  decoration: const InputDecoration(
                    labelText: 'Temperatura (°C)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Ingrese un número válido';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createRecord,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Crear'),
        ),
      ],
    );
  }
}