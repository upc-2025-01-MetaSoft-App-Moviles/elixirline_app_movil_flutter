import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../blocs/wine_batch_detail/wine_batch_detail_bloc.dart';
import '../widgets/wine_batch_detail_card_widget.dart';
import '../widgets/stage_card_widget.dart';
import '../../../supply-management/presentation/widgets/app_logo_widget.dart';
import '../../data/datasources/wine_batch_remote_datasource.dart';
import '../../data/repositories/wine_batch_repository_impl.dart';

class WineBatchDetailPage extends StatelessWidget {
  final String batchId;
  final VoidCallback onBack;
  final VoidCallback onAddStage;

  const WineBatchDetailPage({
    super.key,
    required this.batchId,
    required this.onBack,
    required this.onAddStage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WineBatchDetailBloc(
        repository: WineBatchRepositoryImpl(
          remoteDataSource: WineBatchRemoteDataSourceImpl(
            client: http.Client(),
          ),
        ),
      )..add(LoadWineBatchDetail(batchId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalle de lote'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBack,
          ),
        ),
        body: BlocBuilder<WineBatchDetailBloc, WineBatchDetailState>(
          builder: (context, state) {
            if (state is WineBatchDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WineBatchDetailLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const AppLogoWidget(),
                    WineBatchDetailCardWidget(batch: state.batch),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Etapas de vinificación',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: onAddStage,
                            icon: const Icon(Icons.add),
                            label: const Text('Agregar'),
                          ),
                        ],
                      ),
                    ),
                    if (state.stages.isNotEmpty) ...[
                      ...state.stages.map((stages) => Column(
                        children: [
                          if (stages.receptionStage != null)
                            StageCardWidget(
                              title: 'Recepción',
                              stage: stages.receptionStage!,
                              icon: Icons.input,
                            ),
                          if (stages.correctionStage != null)
                            StageCardWidget(
                              title: 'Corrección',
                              stage: stages.correctionStage!,
                              icon: Icons.tune,
                            ),
                          if (stages.fermentationStage != null)
                            StageCardWidget(
                              title: 'Fermentación',
                              stage: stages.fermentationStage!,
                              icon: Icons.science,
                            ),
                          if (stages.pressingStage != null)
                            StageCardWidget(
                              title: 'Prensado',
                              stage: stages.pressingStage!,
                              icon: Icons.compress,
                            ),
                          if (stages.clarificationStage != null)
                            StageCardWidget(
                              title: 'Clarificación',
                              stage: stages.clarificationStage!,
                              icon: Icons.filter_alt,
                            ),
                          if (stages.agingStage != null)
                            StageCardWidget(
                              title: 'Añejamiento',
                              stage: stages.agingStage!,
                              icon: Icons.wine_bar,
                            ),
                          if (stages.filtrationStage != null)
                            StageCardWidget(
                              title: 'Filtración',
                              stage: stages.filtrationStage!,
                              icon: Icons.filter_list,
                            ),
                          if (stages.bottlingStage != null)
                            StageCardWidget(
                              title: 'Embotellado',
                              stage: stages.bottlingStage!,
                              icon: Icons.local_drink,
                            ),
                        ],
                      )),
                    ] else
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No hay etapas de vinificación registradas para este lote.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              );
            } else if (state is WineBatchDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<WineBatchDetailBloc>().add(LoadWineBatchDetail(batchId));
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
