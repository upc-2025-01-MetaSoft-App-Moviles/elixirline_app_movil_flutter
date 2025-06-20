// ignore_for_file: unnecessary_null_comparison, cast_from_null_always_fails

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../../domain/entities/parcel.dart';
import '../../domain/entities/task.dart';
import '../providers/parcel_provider.dart';
import '../providers/task_provider.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime currentMonth = DateTime.now();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final parcelsAsync = ref.watch(parcelProvider);
    final tasksAsync = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Actividades'),
        backgroundColor: const Color(0xFF8B0000),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8B0000),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(context, '/newTask');
        },
      ),
      body: tasksAsync.when(
        data: (tasks) {
          final weeks = _generateCalendar(currentMonth);

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      setState(() {
                        currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
                      });
                    },
                  ),
                  Text(
                    DateFormat.yMMMM('es').format(currentMonth),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['Do','Lu','Ma','Mi','Ju','Vi','Sa'].map((d)=>Text(d)).toList(),
              ),
              const SizedBox(height: 10),
              ...weeks.map((week) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: week.map((day) {
                  if (day == null) {
                    return const SizedBox(width: 40, height: 40);
                  }

                  final taskForDay = tasks.firstWhereOrNull((task) {
                    final taskDate = DateTime.parse(task.scheduledDate);
                    return taskDate.year == day.year &&
                          taskDate.month == day.month &&
                          taskDate.day == day.day;
                  });

                  final hasTask = taskForDay != null;

                  return GestureDetector(
                    onTap: hasTask ? () => setState(() => selectedDate = day) : null,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: hasTask ? Colors.orange[200] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text('${day.day}'),
                    ),
                  );
                }).toList(),
              )),
              if (selectedDate != null)
                Expanded(
                  child: _buildTaskDetails(selectedDate!, tasks, parcelsAsync),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  List<List<DateTime?>> _generateCalendar(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final totalDays = lastDayOfMonth.day;

    final days = List<DateTime?>.filled(firstWeekday, null, growable: true)
      ..addAll(List.generate(totalDays, (i) => DateTime(month.year, month.month, i + 1)));

    return List.generate((days.length / 7).ceil(),
        (i) => days.skip(i * 7).take(7).toList());
  }

  Widget _buildTaskDetails(DateTime date, List<Task> tasks, AsyncValue<List<Parcel>> parcelsAsync) {
    final tasksOfDay = tasks.where((task) {
      final taskDate = DateTime.parse(task.scheduledDate);
      return taskDate.year == date.year &&
             taskDate.month == date.month &&
             taskDate.day == date.day;
    }).toList();

  Card(
    margin: const EdgeInsets.all(12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: const Color(0xFFEFEFEF),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Leyenda de Actividades:", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("💧 Riego", style: TextStyle(color: Colors.black)),
          Text("✂️ Poda", style: TextStyle(color: Colors.black)),
          Text("🧪 Aplicación (fertilizante/pesticida)", style: TextStyle(color: Colors.black)),
          Text("🍇 Cosecha", style: TextStyle(color: Colors.black)),
          Text("🌱 Siembra o plantación nueva", style: TextStyle(color: Colors.black)),
          Text("📌 2 o más Actividades", style: TextStyle(color: Colors.black)),
        ],
      ),
    ),
  );

    return parcelsAsync.when(
      data: (parcels) => ListView.builder(
        itemCount: tasksOfDay.length,
        itemBuilder: (context, index) {
          final task = tasksOfDay[index];
          final parcel = parcels.firstWhereOrNull((p) => p.id == task.parcelId);

          return Card(
            margin: const EdgeInsets.all(8),
            color: const Color(0xFFD9D9D9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text('Actividad: ${task.title}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Responsable: ${task.responsible}'),
                  Text('Notas: ${task.description}'),
                  if (parcel != null) ...[
                    Text('Lote: ${parcel.name}'),
                    Text('Variedad: ${parcel.cropType}'),
                  ] else
                    const Text('Lote no encontrado'),
                ],
              ),
            ),
          );
        },
      ),
      loading: () => const CircularProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
    );
  }
}