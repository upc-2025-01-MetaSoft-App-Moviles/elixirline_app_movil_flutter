import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/supply.dart';
import '../blocs/supply_form/supply_form_bloc.dart';

class SupplyFormWidget extends StatefulWidget {
  final Supply? initialSupply;
  final bool isEditing;

  const SupplyFormWidget({
    super.key,
    this.initialSupply,
    this.isEditing = false,
  });

  @override
  State<SupplyFormWidget> createState() => _SupplyFormWidgetState();
}

class _SupplyFormWidgetState extends State<SupplyFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _expirationDateController = TextEditingController();

  String _selectedCategory = '';
  String _selectedUnit = '';
  String _selectedLocation = '';

  final List<String> _categories = [
    'Fertilizante',
    'Pesticida',
    'Herramientas',
    'Maquinaria',
    'Otro'
  ];

  final List<String> _units = ['kg', 'lt', 'unidades', 'pares', 'cajas'];

  final List<String> _locations = [
    'Bodega Principal',
    'Almacén',
    'Campo',
    'Otro'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialSupply != null) {
      _nameController.text = widget.initialSupply!.name;
      _quantityController.text = widget.initialSupply!.quantity.toString();
      _expirationDateController.text = widget.initialSupply!.expirationDate;
      _selectedCategory = widget.initialSupply!.category;
      _selectedUnit = widget.initialSupply!.unit;
      _selectedLocation = widget.initialSupply!.location;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _expirationDateController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final supply = Supply(
        id: widget.initialSupply?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        category: _selectedCategory,
        quantity: double.parse(_quantityController.text),
        unit: _selectedUnit,
        location: _selectedLocation,
        expirationDate: _expirationDateController.text,
        status: widget.initialSupply?.status ?? 'Disponible',
      );

      if (widget.isEditing) {
        context.read<SupplyFormBloc>().add(UpdateSupply(supply));
      } else {
        context.read<SupplyFormBloc>().add(CreateSupply(supply));
      }
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
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
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
            DropdownButtonFormField<String>(
              value: _selectedCategory.isEmpty ? null : _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value ?? '';
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
              value: _selectedUnit.isEmpty ? null : _selectedUnit,
              decoration: const InputDecoration(
                labelText: 'Unidad',
                border: OutlineInputBorder(),
              ),
              items: _units.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedUnit = value ?? '';
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
            DropdownButtonFormField<String>(
              value: _selectedLocation.isEmpty ? null : _selectedLocation,
              decoration: const InputDecoration(
                labelText: 'Ubicación',
                border: OutlineInputBorder(),
              ),
              items: _locations.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLocation = value ?? '';
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _expirationDateController,
              decoration: const InputDecoration(
                labelText: 'Fecha de Vencimiento',
                hintText: 'DD/MM/AAAA',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(widget.isEditing ? 'GUARDAR CAMBIOS' : 'GUARDAR'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
