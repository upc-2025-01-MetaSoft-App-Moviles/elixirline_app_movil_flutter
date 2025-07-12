import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/parcel_provider.dart';
import '../widgets/parcel_card.dart';
import 'new_parcel_screen.dart';

class ParcelsScreen extends ConsumerWidget {
  const ParcelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parcelsAsync = ref.watch(parcelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Lotes')),
      body: parcelsAsync.when(
        data: (parcels) => ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: parcels.length,
          itemBuilder: (context, index) => ParcelCard(parcel: parcels[index]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NewParcelScreen(),
            ),
          );
          final _ = ref.refresh(parcelProvider);
        },
        backgroundColor: const Color(0xFF8B0000),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
