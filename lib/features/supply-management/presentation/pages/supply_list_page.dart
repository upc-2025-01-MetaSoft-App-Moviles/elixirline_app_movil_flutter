import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/supply_list/supply_list_bloc.dart';
import '../widgets/supply_item_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/app_logo_widget.dart';
import '../../data/datasources/supply_local_datasource.dart';
import '../../data/repositories/supply_repository_impl.dart';

class SupplyListPage extends StatelessWidget {
  final VoidCallback onAddSupply;
  final Function(String) onEditSupply;
  final Function(String) onRegisterUsage;

  const SupplyListPage({
    super.key,
    required this.onAddSupply,
    required this.onEditSupply,
    required this.onRegisterUsage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupplyListBloc(
        repository: SupplyRepositoryImpl(
          localDataSource: SupplyLocalDataSourceImpl(),
        ),
      )..add(LoadSupplies()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registro de insumos'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: onAddSupply,
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            const AppLogoWidget(),
            SearchBarWidget(
              onSearchChanged: (query) {
                context.read<SupplyListBloc>().add(SearchSupplies(query));
              },
            ),
            Expanded(
              child: BlocBuilder<SupplyListBloc, SupplyListState>(
                builder: (context, state) {
                  if (state is SupplyListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SupplyListLoaded) {
                    if (state.filteredSupplies.isEmpty) {
                      return const Center(
                        child: Text('No hay insumos registrados'),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.filteredSupplies.length,
                      itemBuilder: (context, index) {
                        final supply = state.filteredSupplies[index];
                        return SupplyItemWidget(
                          supply: supply,
                          onEdit: () => onEditSupply(supply.id),
                          onRegisterUsage: () => onRegisterUsage(supply.id),
                        );
                      },
                    );
                  } else if (state is SupplyListError) {
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
