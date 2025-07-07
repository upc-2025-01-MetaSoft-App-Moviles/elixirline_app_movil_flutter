import 'package:flutter/material.dart';
import 'package:elixirline_app_movil_flutter/features/fieldlog/domain/field_log_entry.dart';

class FieldLogEntryDetailPage extends StatelessWidget {
  const FieldLogEntryDetailPage({super.key, required this.entry});

  final FieldLogEntry entry;

  @override
  Widget build(BuildContext context) {
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
              Text('Descripción: ${entry.description}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Tipo: ${entry.entryType}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Lote: ${entry.parcelId}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Autor: ${entry.authorId}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Fecha: ${entry.timestamp.toLocal()}', style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
