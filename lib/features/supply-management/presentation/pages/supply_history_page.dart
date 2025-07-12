import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/supply_usage/supply_usage_bloc.dart';
import '../widgets/supply_usage_item_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/app_logo_widget.dart';
import '../../data/datasources/supply_local_datasource.dart';
import '../../data/repositories/supply_repository_impl.dart';

class SupplyHistoryPage extends StatelessWidget {
  final VoidCallback onBack;

  const SupplyHistoryPage({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupplyUsageBloc(
        repository: SupplyRepositoryImpl(
          localDataSource: SupplyLocalDataSourceImpl(),
        ),
      )..add(LoadUsageHistory()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Historial de Insumos'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBack,
          ),
        ),
        body: Column(
          children: [
            const AppLogoWidget(),
            SearchBarWidget(
              placeholder: 'Buscar por insumo, actividad o fecha',
              onSearchChanged: (query) {
                context.read<SupplyUsageBloc>().add(SearchUsageHistory(query));
              },
            ),
            Expanded(
              child: BlocBuilder<SupplyUsageBloc, SupplyUsageState>(
                builder: (context, state) {
                  if (state is SupplyUsageLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is UsageHistoryLoaded) {
                    if (state.filteredUsages.isEmpty) {
                      return const Center(
                        child: Text('No hay registros de uso de insumos'),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.filteredUsages.length,
                      itemBuilder: (context, index) {
                        final usageWithDetails = state.filteredUsages[index];
                        return SupplyUsageItemWidget(
                          usageWithDetails: usageWithDetails,
                        );
                      },
                    );
                  } else if (state is SupplyUsageError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
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
