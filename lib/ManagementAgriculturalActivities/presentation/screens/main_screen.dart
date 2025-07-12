import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FF),
      appBar: AppBar(
        title: const Text('Actividades Agrícolas'),
        backgroundColor: const Color(0xFF8B0000),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoCard(
              title: 'Clima Actual',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('25°C – Soleado'),
                  Text('Humedad: 60%'),
                  Text('Viento: 10 km/h')
                ],
              ),
            ),
            const SizedBox(height: 16),
            InfoCard(
              title: 'Próximas actividades agendadas',
              content: tasks.when(
                data: (data) => data.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data.map((task) {
                          return Text(
                            '${formatDateTime(task.scheduledDate)}: ${task.title}',
                          );
                        }).toList(),
                      )
                    : const Text('No hay actividades agendadas.'),
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Accesos rápidos:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                QuickAccessButton(
                  text: 'Nueva actividad',
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/newTask');
                    // ignore: unused_result
                    ref.refresh(taskProvider);
                  },
                ),
                QuickAccessButton(
                  text: 'Calendario',
                  onPressed: () {
                    Navigator.pushNamed(context, '/calendar');
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: QuickAccessButton(
                text: 'Mis Lotes',
                onPressed: () {
                  Navigator.pushNamed(context, '/parcels');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final Widget content;

  const InfoCard({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFD9D9D9),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }
}

class QuickAccessButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const QuickAccessButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF2F8FF),
        side: const BorderSide(color: Color(0xFF8B0000), width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
    );
  }
}

String formatDateTime(String isoDate) {
  final date = DateTime.parse(isoDate).toLocal();
  final formatter = DateFormat('dd MMM yyyy, HH:mm', 'es_ES');
  return formatter.format(date);
}
