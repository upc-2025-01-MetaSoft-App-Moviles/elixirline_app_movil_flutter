// ignore_for_file: unnecessary_this

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/domain/models/worker.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/domain/models/worker_evaluation.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/presentation/viewmodels/worker_viewmodel.dart';

class WorkerEvaluationScreen extends StatefulWidget {
  final Worker worker;

  const WorkerEvaluationScreen({super.key, required this.worker});

  @override
  State<WorkerEvaluationScreen> createState() => _WorkerEvaluationScreenState();
}

class _WorkerEvaluationScreenState extends State<WorkerEvaluationScreen> {
  int? _minScore;
  DateTime? _startDate;
  DateTime? _endDate;
  String _sortBy = 'date';
  bool _ascending = false;

  void _clearFilters() {
    setState(() {
      _minScore = null;
      _startDate = null;
      _endDate = null;
      _sortBy = 'date';
      _ascending = false;
    });
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final initial = isStart ? _startDate : _endDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _showChartDialog(List<WorkerEvaluation> evaluations) {
    print("Evaluaciones recibidas para el gráfico: ${evaluations.length}");
    if (evaluations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay evaluaciones para mostrar en el gráfico.'),
        ),
      );
      return;
    }

    // ✅ ORDENAR EVALUACIONES POR FECHA ASCENDENTE
    final sortedEvaluations =
        [...evaluations] // crea una copia
          ..sort((a, b) => a.date.compareTo(b.date));

    final spots = sortedEvaluations
        .asMap()
        .entries
        .map(
          (entry) => FlSpot(entry.key.toDouble(), entry.value.score.toDouble()),
        )
        .toList();

    final avg = _calculateAverageScore(sortedEvaluations);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("📊 Evolución del Desempeño"),
        content: SizedBox(
          height: 300,
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        dotData: FlDotData(show: true),
                        color: Colors.blueAccent,
                        barWidth: 3,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Promedio: ${avg.toStringAsFixed(1)} / 10',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getAverageColor(avg),
                ),
              ),
              Text(
                _getAverageLabel(avg),
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar"),
          ),
        ],
      ),
    );
  }

  void _showEvaluationDialog(
    BuildContext context, {
    WorkerEvaluation? existing,
  }) {
    final evaluatorCtrl = TextEditingController(
      text: existing?.evaluator ?? '',
    );
    final commentCtrl = TextEditingController(text: existing?.comment ?? '');
    int selectedScore = existing?.score ?? 5;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          existing == null ? 'Nueva Evaluación' : 'Editar Evaluación',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: evaluatorCtrl,
                decoration: const InputDecoration(labelText: 'Evaluador'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: commentCtrl,
                decoration: const InputDecoration(labelText: 'Comentario'),
              ),
              const SizedBox(height: 8),
              StatefulBuilder(
                builder: (context, setState) => DropdownButtonFormField<int>(
                  value: selectedScore,
                  items: List.generate(10, (i) => i + 1)
                      .map(
                        (val) =>
                            DropdownMenuItem(value: val, child: Text('$val')),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => selectedScore = val ?? 5),
                  decoration: const InputDecoration(
                    labelText: 'Puntaje (1-10)',
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () {
              final evaluator = evaluatorCtrl.text.trim();
              final comment = commentCtrl.text.trim();

              if (evaluator.isEmpty ||
                  comment.isEmpty ||
                  selectedScore < 1 ||
                  selectedScore > 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Completa todos los campos con datos válidos',
                    ),
                  ),
                );
                return;
              }

              final vm = context.read<WorkerViewModel>();

              if (existing == null) {
                final eval = WorkerEvaluation.create(
                  workerId: widget.worker.id,
                  evaluator: evaluator,
                  comment: comment,
                  score: selectedScore,
                );
                vm.addEvaluation(eval);
              } else {
                final updated = existing.copyWith(
                  evaluator: evaluator,
                  comment: comment,
                  score: selectedScore,
                );
                vm.updateEvaluation(widget.worker.id, updated);
              }

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  double _calculateAverageScore(List<WorkerEvaluation> evaluations) {
    if (evaluations.isEmpty) return 0;
    return evaluations.map((e) => e.score).reduce((a, b) => a + b) /
        evaluations.length;
  }

  Color _getScoreColor(int score) {
    if (score >= 8) return Colors.green.shade200;
    if (score >= 5) return Colors.orange.shade200;
    return Colors.red.shade200;
  }

  Color _getAverageColor(double avg) {
    if (avg >= 8) return Colors.green.shade300;
    if (avg >= 5) return Colors.orange.shade300;
    return Colors.red.shade300;
  }

  String _getAverageLabel(double avg) {
    if (avg >= 8) return "Excelente";
    if (avg >= 5) return "Bueno";
    return "Deficiente";
  }

  Future<void> exportToPdf(List<WorkerEvaluation> evaluations) async {
    final font = await PdfGoogleFonts.robotoRegular();
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Evaluaciones de ${widget.worker.fullName}',
              style: pw.TextStyle(fontSize: 18, font: font),
            ),
            pw.SizedBox(height: 12),
            ...evaluations.map(
              (e) => pw.Text(
                "${e.date.day}/${e.date.month}/${e.date.year} - ${e.evaluator}: ${e.score}/10 (${e.comment})",
                style: pw.TextStyle(font: font),
              ),
            ),
          ],
        ),
      ),
    );

    // Mostrar diálogo de impresión como antes
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());

    // Guardar archivo local y abrirlo con open_file
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/evaluaciones_${widget.worker.fullName}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      print("✅ PDF exportado y guardado en: $filePath");

      await OpenFile.open(filePath); // usa 'open_file'
    } catch (e) {
      print("❌ Error al exportar PDF: $e");
    }
  }

  Future<void> exportToCsv(List<WorkerEvaluation> evaluations) async {
    List<List<String>> rows = [
      ["Fecha", "Evaluador", "Puntaje", "Comentario"],
    ];

    for (var e in evaluations) {
      rows.add([
        "${e.date.day}/${e.date.month}/${e.date.year}",
        e.evaluator,
        "${e.score}",
        e.comment,
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);

    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/evaluaciones_${widget.worker.fullName}.csv";
    final file = File(path);
    await file.writeAsString(csvData);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Archivo CSV guardado: $path')));

    try {
      await OpenFile.open(path); // usa 'open_file'
      print("✅ CSV abierto correctamente.");
    } catch (e) {
      print("❌ Error al abrir CSV: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final allEvaluations = context.watch<WorkerViewModel>().getEvaluations(
      widget.worker.id,
    );

    // 🔥 VERIFICACIÓN REAL DE SI TIENE EVALUACIONES (no depende de filtros)
    final hasRealEvaluations = allEvaluations
        .where((e) => e.score >= 1)
        .isNotEmpty;
    print('Evaluaciones actuales: ${allEvaluations.length}');

    // APLICAR FILTROS
    List<WorkerEvaluation> evaluations = allEvaluations.where((e) {
      final passScore = _minScore == null || e.score >= _minScore!;
      final passStart =
          _startDate == null ||
          e.date.isAfter(_startDate!.subtract(const Duration(days: 1)));
      final passEnd =
          _endDate == null ||
          e.date.isBefore(_endDate!.add(const Duration(days: 1)));
      return passScore && passStart && passEnd;
    }).toList();

    // ORDENAMIENTO
    evaluations.sort((a, b) {
      int cmp;
      if (_sortBy == 'score') {
        cmp = a.score.compareTo(b.score);
      } else {
        cmp = a.date.compareTo(b.date);
      }
      return _ascending ? cmp : -cmp;
    });

    // CALCULOS
    final avg = _calculateAverageScore(allEvaluations);
    final lastEvalDate = allEvaluations.isNotEmpty
        ? (allEvaluations..sort((a, b) => b.date.compareTo(a.date))).first.date
        : null;

    // ALERTAS
    Duration? timeSinceLastEval;
    if (lastEvalDate != null) {
      timeSinceLastEval = DateTime.now().difference(lastEvalDate);
    }

    MaterialBanner? evaluationReminder;
    if (!hasRealEvaluations) {
      evaluationReminder = MaterialBanner(
        content: const Text('📢 Este trabajador aún no ha sido evaluado.'),
        leading: const Icon(Icons.info_outline, color: Colors.blue),
        actions: [
          TextButton(
            onPressed: () => _showEvaluationDialog(context),
            child: const Text('Evaluar ahora'),
          ),
          TextButton(
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            child: const Text('Cerrar'),
          ),
        ],
        backgroundColor: Colors.blue.shade50,
      );
    } else if (timeSinceLastEval != null) {
      final monthsPassed = timeSinceLastEval.inDays ~/ 30;
      if (monthsPassed >= 6) {
        evaluationReminder = MaterialBanner(
          content: const Text(
            '⚠️ Este trabajador no ha sido evaluado en más de 6 meses.',
          ),
          leading: const Icon(Icons.warning_amber_rounded, color: Colors.red),
          actions: [
            TextButton(
              onPressed: () => _showEvaluationDialog(context),
              child: const Text('Agregar evaluación'),
            ),
            TextButton(
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: const Text('Cerrar'),
            ),
          ],
          backgroundColor: Colors.red.shade50,
        );
      } else if (monthsPassed >= 3) {
        evaluationReminder = MaterialBanner(
          content: const Text(
            '⏳ Han pasado más de 3 meses desde la última evaluación.',
          ),
          leading: const Icon(Icons.info_outline, color: Colors.orange),
          actions: [
            TextButton(
              onPressed: () => _showEvaluationDialog(context),
              child: const Text('Evaluar ahora'),
            ),
            TextButton(
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: const Text('Cerrar'),
            ),
          ],
          backgroundColor: Colors.orange.shade50,
        );
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).clearMaterialBanners();

      if (evaluationReminder != null) {
        ScaffoldMessenger.of(context).showMaterialBanner(evaluationReminder);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Evaluaciones de ${widget.worker.fullName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart),
            tooltip: "Ver gráfico",
            onPressed: () {
              print("📊 Ícono presionado");
              final validEvals = allEvaluations
                  .where((e) => e.score > 0)
                  .toList();
              if (validEvals.isNotEmpty) {
                _showChartDialog(validEvals);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "No hay evaluaciones suficientes para mostrar el gráfico.",
                    ),
                  ),
                );
              }
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (evaluations.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'No hay evaluaciones dentro del rango seleccionado',
                    ),
                  ),
                );
                return;
              }

              if (value == 'pdf') exportToPdf(evaluations);
              if (value == 'csv') exportToCsv(evaluations);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'pdf',
                child: Text('Exportar PDF (rango filtrado)'),
              ),
              PopupMenuItem(
                value: 'csv',
                child: Text('Exportar CSV (rango filtrado)'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEvaluationDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          if (hasRealEvaluations)
            Container(
              width: double.infinity,
              color: _getAverageColor(avg),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Promedio de desempeño: ${avg.toStringAsFixed(1)} / 10',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getAverageLabel(avg),
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  if (lastEvalDate != null)
                    Text(
                      'Última evaluación: ${lastEvalDate.day}/${lastEvalDate.month}/${lastEvalDate.year}',
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
            ),
          ExpansionTile(
            title: const Text('🔍 Filtros avanzados'),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text("Puntaje mínimo: "),
                        DropdownButton<int>(
                          value: _minScore,
                          hint: const Text("Todos"),
                          items: List.generate(10, (i) => i + 1)
                              .map(
                                (val) => DropdownMenuItem(
                                  value: val,
                                  child: Text('$val'),
                                ),
                              )
                              .toList(),
                          onChanged: (val) => setState(() => _minScore = val),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: _clearFilters,
                          child: const Text('Limpiar filtros'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Desde: "),
                        TextButton(
                          onPressed: () => _pickDate(context, true),
                          child: Text(
                            _startDate == null
                                ? "Elegir"
                                : "${_startDate!.day}/${_startDate!.month}/${_startDate!.year}",
                          ),
                        ),
                        const Text("Hasta: "),
                        TextButton(
                          onPressed: () => _pickDate(context, false),
                          child: Text(
                            _endDate == null
                                ? "Elegir"
                                : "${_endDate!.day}/${_endDate!.month}/${_endDate!.year}",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Ordenar por: "),
                        DropdownButton<String>(
                          value: _sortBy,
                          items: const [
                            DropdownMenuItem(
                              value: 'date',
                              child: Text('Fecha'),
                            ),
                            DropdownMenuItem(
                              value: 'score',
                              child: Text('Puntaje'),
                            ),
                          ],
                          onChanged: (val) =>
                              setState(() => _sortBy = val ?? 'date'),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: Icon(
                            _ascending
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                          ),
                          onPressed: () =>
                              setState(() => _ascending = !_ascending),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
          if (evaluations.isEmpty)
            const Expanded(
              child: Center(
                child: Text('Sin evaluaciones que cumplan el filtro.'),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: evaluations.length,
                itemBuilder: (_, index) {
                  final e = evaluations[index];
                  return Dismissible(
                    key: ValueKey(e.id),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) async {
                      return await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('¿Eliminar evaluación?'),
                          content: const Text(
                            'Esta acción no se puede deshacer.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (_) {
                      context.read<WorkerViewModel>().deleteEvaluation(
                        widget.worker.id,
                        e,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Evaluación eliminada')),
                      );
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      color: _getScoreColor(e.score),
                      child: ListTile(
                        onTap: () =>
                            _showEvaluationDialog(context, existing: e),
                        leading: const Icon(Icons.bar_chart_rounded),
                        title: Text('${e.score}/10 - ${e.evaluator}'),
                        subtitle: Text(e.comment),
                        trailing: Text(
                          '${e.date.day}/${e.date.month}/${e.date.year}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
