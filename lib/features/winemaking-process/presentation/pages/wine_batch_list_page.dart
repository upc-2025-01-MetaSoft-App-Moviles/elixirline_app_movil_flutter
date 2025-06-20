import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../blocs/wine_batch_list/wine_batch_list_bloc.dart';
import '../widgets/wine_batch_card_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../../../supply-management/presentation/widgets/app_logo_widget.dart';
import '../../data/datasources/wine_batch_remote_datasource.dart';
import '../../data/repositories/wine_batch_repository_impl.dart';

class WineBatchListPage extends StatelessWidget {
  final Function(String) onBatchSelected;
  final VoidCallback onAddBatch;

  const WineBatchListPage({
    super.key,
    required this.onBatchSelected,
    required this.onAddBatch,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WineBatchListBloc(
        repository: WineBatchRepositoryImpl(
          remoteDataSource: WineBatchRemoteDataSourceImpl(
            client: http.Client(),
          ),
        ),
      )..add(LoadWineBatches()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registro de lotes'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: onAddBatch,
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            const AppLogoWidget(),
            SearchBarWidget(
              placeholder: 'Buscar lote',
              onSearchChanged: (query) {
                context.read<WineBatchListBloc>().add(SearchWineBatches(query));
              },
            ),
            Expanded(
              child: BlocBuilder<WineBatchListBloc, WineBatchListState>(
                builder: (context, state) {
                  if (state is WineBatchListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is WineBatchListLoaded) {
                    if (state.filteredBatches.isEmpty) {
                      return const Center(
                        child: Text('No hay lotes de vino registrados'),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.filteredBatches.length,
                      itemBuilder: (context, index) {
                        final batch = state.filteredBatches[index];
                        return WineBatchCardWidget(
                          batch: batch,
                          onTap: () => onBatchSelected(batch.id),
                          onEdit: () {
                            // TODO: Implementar edición
                          },
                        );
                      },
                    );
                  } else if (state is WineBatchListError) {
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
                              context.read<WineBatchListBloc>().add(LoadWineBatches());
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
          ],
        ),
      ),
    );
  }
}
