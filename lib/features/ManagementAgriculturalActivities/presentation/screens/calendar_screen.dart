// ignore_for_file: unnecessary_null_comparison, cast_from_null_always_fails, curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'package:elixirline_app_movil_flutter/features/ManagementAgriculturalActivities/presentation/screens/new_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
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

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Actividades'),
        backgroundColor: const Color(0xFF8B0000),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8B0000),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NewTaskScreen()),
          );
          ref.refresh(taskProvider);
        },
      ),
      body: tasksAsync.when(
        data: (tasks) {
          final weeks = _generateCalendar(currentMonth, tasks);

          return Column(
            children: [
              _buildMonthSelector(),
              const SizedBox(height: 10),
              _buildWeekDays(),
              const SizedBox(height: 10),
              ...weeks.map((week) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: week.map((dayInfo) {
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: dayInfo == null
                          ? const SizedBox.shrink()
                          : _buildDayCell(dayInfo['date'], dayInfo['tasks']),
                    ),
                  );
                }).toList(),
              )),
              const SizedBox(height: 10),
              _buildLegend(),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Row(
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
    );
  }

  Widget _buildWeekDays() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ['Do', 'Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa'].map((d) {
        return SizedBox(
          width: 44,
          child: Center(
            child: Text(d, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        );
      }).toList(),
    );
  }

  List<List<Map<String, dynamic>?>> _generateCalendar(DateTime month, List<Task> tasks) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final totalDays = lastDayOfMonth.day;

    final days = List<Map<String, dynamic>?>.filled(firstWeekday, null, growable: true)
      ..addAll(List.generate(totalDays, (i) {
        final date = DateTime(month.year, month.month, i + 1);
        final tasksForDay = tasks.where((task) {
          final taskDate = DateTime.parse(task.scheduledDate);
          return taskDate.year == date.year &&
              taskDate.month == date.month &&
              taskDate.day == date.day;
        }).toList();
        return {'date': date, 'tasks': tasksForDay};
      }));

    return List.generate((days.length / 7).ceil(), (i) {
      final week = days.skip(i * 7).take(7).toList();
      if (week.length < 7) {
        week.addAll(List.filled(7 - week.length, null));
      }
      return week;
    });
  }

  Widget _buildDayCell(DateTime date, List<Task> tasksForDay) {
    String? emoji;
    if (tasksForDay.length > 1) {
      emoji = '📌';
    } else if (tasksForDay.length == 1) {
      final type = tasksForDay.first.title.toLowerCase();
      if (type.contains('riego')) emoji = '💧';
      else if (type.contains('poda')) emoji = '✂️';
      else if (type.contains('fertil')) emoji = '🧪';
      else if (type.contains('cosecha')) emoji = '🍇';
      else if (type.contains('siembra')) emoji = '🌱';
    }

    return GestureDetector(
      onTap: () {
        if (tasksForDay.isEmpty) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Sin actividades'),
              content: const Text('No hay actividades agendadas para este día.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                )
              ],
            ),
          );
        } else {
          _showTasksBottomSheet(date, tasksForDay);
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: tasksForDay.isNotEmpty ? Colors.orange[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${date.day}', style: const TextStyle(fontSize: 12)),
            if (emoji != null) Text(emoji, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  void _showTasksBottomSheet(DateTime date, List<Task> tasksOfDay) async {
    final parcels = await ref.read(parcelProvider.future);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Detalles de ${DateFormat('dd/MM/yyyy').format(date)}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tasksOfDay.length,
            itemBuilder: (context, index) {
              final task = tasksOfDay[index];
              final parcel = parcels.firstWhereOrNull((p) => p.id == task.parcelId);
              final taskDate = DateTime.parse(task.scheduledDate);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Actividad:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Título: ${task.title}'),
                    Text('Notas: ${task.description}'),
                    Text('Fecha: ${DateFormat('dd/MM/yyyy').format(taskDate)}'),
                    Text('Hora: ${DateFormat('HH:mm').format(taskDate)}'),
                    Text('Responsable: ${task.responsible}'),
                    const SizedBox(height: 8),
                    const Text('Lote vinculado:', style: TextStyle(fontWeight: FontWeight.bold)),
                    if (parcel != null) ...[
                      Text('Nombre: ${parcel.name}'),
                      Text('Variedad: ${parcel.cropType}'),
                      Text('Localización: ${parcel.location}'),
                      Text('Rendimiento estimado: ${parcel.yieldEstimate}'),
                      Text('Estado: ${parcel.status}'),
                      Text('Etapa actual: ${parcel.growthStage}'),
                    ] else
                      const Text('No se encontró información del lote'),
                    const Divider(),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          )
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "📌 Leyenda de Actividades:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: const [
              Text("💧 Riego"),
              Text("✂️ Poda"),
              Text("🧪 Fertilización"),
              Text("🍇 Cosecha"),
              Text("🌱 Siembra"),
              Text("📌 2 o más Actividades"),
            ],
          ),
        ],
      ),
    );
  }
}