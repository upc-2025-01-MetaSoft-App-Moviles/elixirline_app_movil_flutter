import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elixirline_app_movil_flutter/features/fieldlog/domain/field_log_entry.dart';


class FieldLogEntryDetailPage extends StatefulWidget {
  const FieldLogEntryDetailPage({super.key, required this.entry});

  final FieldLogEntry entry;

  @override
  State<FieldLogEntryDetailPage> createState() => _FieldLogEntryDetailPageState();
}

class _FieldLogEntryDetailPageState extends State<FieldLogEntryDetailPage> {
  final List<String> _statuses = ['Pendiente', 'Validado', 'Requiere acción'];
  late String _selectedStatus;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _selectedStatus = 'Pendiente';
    _commentController = TextEditingController();
    _loadLocalData();
  }

  Future<void> _loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedStatus = prefs.getString('status-${widget.entry.entryId}') ?? 'Pendiente';
      _commentController.text = prefs.getString('comment-${widget.entry.entryId}') ?? '';
    });
  }

  Future<void> _saveStatus(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('status-${widget.entry.entryId}', value);
  }

  Future<void> _saveComment(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('comment-${widget.entry.entryId}', value);
  }

  Color _getChipColor(String status) {
    switch (status) {
      case 'Validado':
        return Colors.green.shade100;
      case 'Requiere acción':
        return Colors.red.shade100;
      default:
        return Colors.yellow.shade100;
    }
  }

  Color _getChipTextColor(String status) {
    switch (status) {
      case 'Validado':
        return Colors.green.shade800;
      case 'Requiere acción':
        return Colors.red.shade800;
      default:
        return Colors.orange.shade800;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Bitácora')),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          if (entry.photoUrls.isNotEmpty)
            SliverAppBar(
              pinned: true,
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                background: PageView.builder(
                  itemCount: entry.photoUrls.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      entry.photoUrls[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                    );
                  },
                ),
              ),
            ),
        ],
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Row(
                children: [
                  Chip(
                    label: Text(_selectedStatus),
                    backgroundColor: _getChipColor(_selectedStatus),
                    labelStyle: TextStyle(color: _getChipTextColor(_selectedStatus)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(labelText: 'Cambiar estado'),
                      items: _statuses.map((status) {
                        return DropdownMenuItem(value: status, child: Text(status));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedStatus = value);
                          _saveStatus(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Descripción'),
                subtitle: Text(entry.description),
              ),
              ListTile(
                title: const Text('Tipo'),
                subtitle: Text(entry.entryType),
              ),
              ListTile(
                title: const Text('Lote'),
                subtitle: Text(entry.parcelId),
              ),
              ListTile(
                title: const Text('Autor'),
                subtitle: Text(entry.authorId),
              ),
              ListTile(
                title: const Text('Fecha'),
                subtitle: Text(entry.timestamp.toLocal().toString()),
              ),
              const Divider(height: 32),
              const Text('Comentario del Vinicultor:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _commentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Escribe aquí una observación o indicación...',
                ),
                onChanged: _saveComment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
