import 'package:flutter/material.dart';
import '../../domain/models/worker_attendance.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/data/repositories/worker_attendance_repository.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

enum GroupingOption { week, month }

enum RemarksFilterOption { all, withRemarks, withoutRemarks }

class WorkerAttendanceScreen extends StatefulWidget {
  final String workerId;
  final String workerName;

  const WorkerAttendanceScreen({
    super.key,
    required this.workerId,
    required this.workerName,
  });

  @override
  State<WorkerAttendanceScreen> createState() => _WorkerAttendanceScreenState();
}

class _WorkerAttendanceScreenState extends State<WorkerAttendanceScreen> {
  final WorkerAttendanceRepository _repository = WorkerAttendanceRepository();
  List<WorkerAttendance> _attendances = [];
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showOnlyIncomplete = false;
  final bool _showOnlyWithRemarks = false;
  DateTimeRange? _selectedRange;

  GroupingOption _grouping = GroupingOption.week;
  RemarksFilterOption _remarksFilter = RemarksFilterOption.all;
  @override
  void initState() {
    super.initState();
    _loadAttendances();
  }

  Future<void> _loadAttendances() async {
    final all = await _repository.getAllAttendances();
    setState(() {
      _attendances = all.where((a) => a.workerId == widget.workerId).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    });
  }

  Future<void> _markCheckIn() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Validación: ya hay una entrada sin salida hoy
    final hasOpenEntry = _attendances.any((a) {
      final date = DateTime(a.date.year, a.date.month, a.date.day);
      return date == today && a.checkOut == null;
    });

    if (hasOpenEntry) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ya hay una entrada registrada sin salida para hoy.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final remarkController = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Marcar entrada'),
        content: TextField(
          controller: remarkController,
          decoration: const InputDecoration(
            labelText: 'Observación (opcional)',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Registrar'),
            onPressed: () =>
                Navigator.pop(context, remarkController.text.trim()),
          ),
        ],
      ),
    );

    if (result != null) {
      final newAttendance = WorkerAttendance.create(
        workerId: widget.workerId,
        checkIn: now,
        remarks: result.isEmpty ? null : result,
      );
      await _repository.addAttendance(newAttendance);
      await _loadAttendances();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entrada registrada exitosamente.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _markCheckOut(WorkerAttendance attendance) async {
    final remarkController = TextEditingController(
      text: attendance.remarks ?? '',
    );

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Marcar salida'),
        content: TextField(
          controller: remarkController,
          decoration: const InputDecoration(
            labelText: 'Observación (opcional)',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Registrar salida'),
            onPressed: () =>
                Navigator.pop(context, remarkController.text.trim()),
          ),
        ],
      ),
    );

    if (result != null) {
      final now = DateTime.now();

      // Validación: la salida no puede ser antes que la entrada
      if (now.isBefore(attendance.checkIn)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'La hora de salida no puede ser anterior a la hora de entrada.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final updated = attendance.copyWith(
        checkOut: now,
        remarks: result.isEmpty ? null : result,
      );
      await _repository.updateAttendance(updated);
      await _loadAttendances();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Salida registrada exitosamente.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _editAttendance(WorkerAttendance attendance) async {
    final controller = TextEditingController(text: attendance.remarks ?? '');

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar observación'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Nueva observación'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (result != null) {
      final trimmed = result.trim();
      final wasDeleted = trimmed.isEmpty;

      final updated = attendance.copyWith(remarks: wasDeleted ? null : trimmed);
      await _repository.updateAttendance(updated);
      final confirmList = await _repository.getAllAttendances();
      final debugItem = confirmList.firstWhere((a) => a.id == updated.id);
      print(
        '🧪 Verificación post-update del ID ${debugItem.id}: "${debugItem.remarks}"',
      );

      final newList = confirmList;
      setState(() {
        _attendances = newList;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            wasDeleted
                ? 'Observación eliminada correctamente.'
                : 'Observación actualizada correctamente.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _deleteAttendance(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar registro?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _repository.deleteAttendance(id);
      await _loadAttendances();
    }
  }

  Future<void> exportGroupedToCsv() async {
    final grouped = getGroupedSummaries(getFilteredAttendances());
    final List<List<String>> rows = [];

    grouped.forEach((group, data) {
      final summary = data['summary'];
      final items = data['items'] as List<WorkerAttendance>;

      rows.add(['Grupo: $group']);
      rows.add(['Días trabajados', 'Horas totales']);
      rows.add([
        '${summary['days']}',
        '${summary['hours'].toStringAsFixed(1)}',
      ]);
      rows.add([]);
      rows.add(['Fecha', 'Entrada', 'Salida', 'Observación']);

      for (var att in items) {
        rows.add([
          '${att.date.day}/${att.date.month}/${att.date.year}',
          _formatTime(att.checkIn),
          att.checkOut != null ? _formatTime(att.checkOut!) : '',
          att.remarks ?? '',
        ]);
      }

      rows.add([]);
    });

    final csvData = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/asistencia_grupal.csv';
    final file = File(path);
    await file.writeAsString(csvData);

    await OpenFile.open(path);
  }

  Future<void> exportGroupedToPdf() async {
    final pdf = pw.Document();
    final grouped = getGroupedSummaries(getFilteredAttendances());

    grouped.forEach((group, data) {
      final summary = data['summary'];
      final items = data['items'] as List<WorkerAttendance>;

      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Grupo: $group',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text('Días trabajados: ${summary['days']}'),
              pw.Text(
                'Horas totales: ${summary['hours'].toStringAsFixed(1)} h',
              ),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                headers: ['Fecha', 'Entrada', 'Salida', 'Observación'],
                data: items.map((att) {
                  return [
                    '${att.date.day}/${att.date.month}/${att.date.year}',
                    _formatTime(att.checkIn),
                    att.checkOut != null ? _formatTime(att.checkOut!) : '',
                    att.remarks ?? '',
                  ];
                }).toList(),
              ),
            ],
          ),
        ),
      );
    });

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/asistencia_grupal.pdf");
    await file.writeAsBytes(await pdf.save());

    await OpenFile.open(file.path);
  }

  Map<String, Map<String, dynamic>> getGroupedSummaries(
    List<WorkerAttendance> data,
  ) {
    final Map<String, List<WorkerAttendance>> grouped = {};

    for (var att in data) {
      String key;
      if (_grouping == GroupingOption.month) {
        key = '${att.date.year}-${att.date.month.toString().padLeft(2, '0')}';
      } else {
        final weekStart = att.date.subtract(
          Duration(days: att.date.weekday - 1),
        );
        final weekEnd = weekStart.add(const Duration(days: 6));
        key =
            'Del ${weekStart.day}/${weekStart.month} al ${weekEnd.day}/${weekEnd.month}';
      }
      grouped.putIfAbsent(key, () => []).add(att);
    }

    final result = <String, Map<String, dynamic>>{};
    grouped.forEach((key, items) {
      final uniqueDays = items
          .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
          .toSet()
          .length;
      final totalHours =
          items
              .where((e) => e.checkOut != null)
              .map((e) => e.checkOut!.difference(e.checkIn).inMinutes)
              .fold<int>(0, (sum, min) => sum + min) /
          60;

      result[key] = {
        'summary': {'days': uniqueDays, 'hours': totalHours},
        'items': items,
      };
    });

    return result;
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  List<WorkerAttendance> getFilteredAttendances() {
    var filtered = _attendances;

    if (_showOnlyIncomplete) {
      filtered = filtered.where((e) => e.checkOut == null).toList();
    }

    if (_remarksFilter == RemarksFilterOption.withRemarks) {
      filtered = filtered
          .where((e) => e.remarks != null && e.remarks!.trim().isNotEmpty)
          .toList();
    } else if (_remarksFilter == RemarksFilterOption.withoutRemarks) {
      filtered = filtered
          .where((e) => e.remarks == null || e.remarks!.trim().isEmpty)
          .toList();
    }

    if (_selectedRange != null) {
      filtered = filtered
          .where(
            (e) =>
                e.date.isAfter(
                  _selectedRange!.start.subtract(const Duration(days: 1)),
                ) &&
                e.date.isBefore(
                  _selectedRange!.end.add(const Duration(days: 1)),
                ),
          )
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = getGroupedSummaries(getFilteredAttendances());

    return Scaffold(
      appBar: AppBar(
        title: Text('Asistencia - ${widget.workerName}'),
        actions: [
          DropdownButton<GroupingOption>(
            value: _grouping,
            onChanged: (GroupingOption? newValue) {
              if (newValue != null) {
                setState(() => _grouping = newValue);
              }
            },
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(
                value: GroupingOption.week,
                child: Text('Por semana'),
              ),
              DropdownMenuItem(
                value: GroupingOption.month,
                child: Text('Por mes'),
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == 'incomplete') {
                setState(() => _showOnlyIncomplete = !_showOnlyIncomplete);
              } else if (value == 'remarks') {
                setState(() {
                  if (_remarksFilter == RemarksFilterOption.withRemarks) {
                    _remarksFilter = RemarksFilterOption.all;
                  } else {
                    _remarksFilter = RemarksFilterOption.withRemarks;
                  }
                });
              } else if (value == 'range') {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2024, 1),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  setState(() => _selectedRange = picked);
                }
              } else if (value == 'export_pdf') {
                await exportGroupedToPdf();
              } else if (value == 'export_csv') {
                await exportGroupedToCsv();
              }
            },
            itemBuilder: (context) => [
              CheckedPopupMenuItem(
                value: 'incomplete',
                checked: _showOnlyIncomplete,
                child: const Text('Solo sin salida'),
              ),
              CheckedPopupMenuItem(
                value: 'remarks',
                checked: _remarksFilter == RemarksFilterOption.withRemarks,
                child: const Text('Solo con observación'),
              ),
              const PopupMenuItem(
                value: 'range',
                child: Text('Seleccionar rango de fechas'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'export_pdf',
                child: Text('📄 Exportar como PDF'),
              ),
              const PopupMenuItem(
                value: 'export_csv',
                child: Text('📑 Exportar como CSV'),
              ),
            ],
          ),

          const SizedBox(width: 12),
        ],
      ),
      body: _attendances.isEmpty
          ? const Center(child: Text('Sin registros de asistencia.'))
          : ListView(
              children: grouped.entries.map((entry) {
                final title = entry.key;
                final summary = entry.value['summary'];
                final items = entry.value['items'] as List<WorkerAttendance>;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Días trabajados: ${summary['days']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Horas totales: ${summary['hours'].toStringAsFixed(1)} h',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    ...items.map((att) {
                      print(
                        "🧪 Observación actual del ID ${att.id}: '${att.remarks}'",
                      );

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          title: Text(
                            '${att.date.day}/${att.date.month}/${att.date.year}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Entrada: ${_formatTime(att.checkIn)}'),
                              Text(
                                'Salida: ${att.checkOut != null ? _formatTime(att.checkOut!) : "No registrada"}',
                              ),
                              if (att.remarks != null &&
                                  att.remarks!.trim().isNotEmpty)
                                Text('📝 Observación: ${att.remarks}'),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'checkOut' && att.checkOut == null) {
                                _markCheckOut(att);
                              } else if (value == 'edit') {
                                _editAttendance(att);
                              } else if (value == 'delete') {
                                _deleteAttendance(att.id);
                              }
                            },
                            itemBuilder: (context) => [
                              if (att.checkOut == null)
                                const PopupMenuItem(
                                  value: 'checkOut',
                                  child: Text('Marcar salida'),
                                ),
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Editar observación'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Eliminar registro'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _markCheckIn,
        icon: const Icon(Icons.login),
        label: const Text('Marcar entrada'),
      ),
    );
  }
}
