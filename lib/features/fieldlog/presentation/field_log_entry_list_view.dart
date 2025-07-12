import 'package:flutter/material.dart';
import 'package:elixirline_app_movil_flutter/features/fieldlog/data/field_log_entry_service.dart';
import 'package:elixirline_app_movil_flutter/features/fieldlog/domain/field_log_entry.dart';
import 'package:elixirline_app_movil_flutter/features/fieldlog/presentation/field_log_entry_detail_page.dart';
import 'package:elixirline_app_movil_flutter/features/fieldlog/presentation/field_log_entry_form_view.dart';

class FieldLogEntryListView extends StatefulWidget {
  const FieldLogEntryListView({super.key});

  @override
  State<FieldLogEntryListView> createState() => _FieldLogEntryListViewState();
}

class _FieldLogEntryListViewState extends State<FieldLogEntryListView> {
  List<FieldLogEntry> _entries = [];

  Future<void> _loadEntries() async {
    final entries = await FieldLogEntryService().fetchAll();
    setState(() {
      _entries = entries;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bitácora de Campo')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const FieldLogEntryFormView(),
            ),
          );
          if (result == true) {
            _loadEntries(); // refrescar después de registrar
          }
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _entries.length,
        itemBuilder: (context, index) {
          final entry = _entries[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FieldLogEntryDetailPage(entry: entry),
                ),
              );
            },
            child: Card(
              child: ListTile(
                title: Text(entry.description),
                subtitle: Text(entry.timestamp.toLocal().toString()),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
