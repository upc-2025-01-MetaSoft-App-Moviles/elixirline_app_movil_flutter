import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/supply.dart';
import '../../domain/entities/supply_usage.dart';
import '../blocs/supply_usage/supply_usage_bloc.dart';

class SupplyUsageFormWidget extends StatefulWidget {
  final List<Supply> supplies;
  final String? preselectedSupplyId;

  const SupplyUsageFormWidget({
    super.key,
    required this.supplies,
    this.preselectedSupplyId,
  });

  @override
  State<SupplyUsageFormWidget> createState() => _SupplyUsageFormWidgetState();
}

class _SupplyUsageFormWidgetState extends State<SupplyUsageFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _operatorController = TextEditingController();
  final _dateController = TextEditingController();

  Supply? _selectedSupply;
  String _selectedActivity = '';

  final List<String> _activities = [
    'Fertilización',
    'Fumigación',
    'Riego',
    'Poda',
    'Cosecha',
    'Otro'
  ];

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    
    if (widget.preselectedSupplyId != null) {
      _selectedSupply = widget.supplies.firstWhere(
        (supply) => supply.id == widget.preselectedSupplyId,
        orElse: () => widget.supplies.first,
      );
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _operatorController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedSupply != null) {
      final quantity = double.parse(_quantityController.text);
      
      if (quantity > _selectedSupply!.quantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay suficiente cantidad disponible'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final usage = SupplyUsage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        supplyId: _selectedSupply!.id,
        batchId: 'B2024-VINEYARD01',
        quantity: quantity,
        activity: _selectedActivity,
        date: _dateController.text,
        operatorName: _operatorController.text,
      );

      context.read<SupplyUsageBloc>().add(RegisterUsage(usage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            DropdownButtonFormField<Supply>(
              value: _selectedSupply,
              decoration: const InputDecoration(
                labelText: 'Insumo',
                border: OutlineInputBorder(),
              ),
              items: widget.supplies.map((supply) {
                return DropdownMenuItem(
                  value: supply,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(supply.name),
                      Text(
                        'Disponible: ${supply.quantity} ${supply.unit}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSupply = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Seleccione un insumo';
                }
                return null;
              },
            ),
            if (_selectedSupply != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Categoría',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          _selectedSupply!.category,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B0000),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Disponible',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          '${_selectedSupply!.quantity} ${_selectedSupply!.unit}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
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
            DropdownButtonFormField<String>(
              value: _selectedActivity.isEmpty ? null : _selectedActivity,
              decoration: const InputDecoration(
                labelText: 'Actividad',
                border: OutlineInputBorder(),
              ),
              items: _activities.map((activity) {
                return DropdownMenuItem(
                  value: activity,
                  child: Text(activity),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedActivity = value ?? '';
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Fecha',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _operatorController,
              decoration: const InputDecoration(
                labelText: 'Operario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('REGISTRAR'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
