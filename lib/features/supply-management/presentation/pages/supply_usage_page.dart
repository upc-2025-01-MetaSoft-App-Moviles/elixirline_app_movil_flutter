import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/supply_usage/supply_usage_bloc.dart';
import '../widgets/supply_usage_form_widget.dart';
import '../widgets/app_logo_widget.dart';
import '../../data/datasources/supply_local_datasource.dart';
import '../../data/repositories/supply_repository_impl.dart';

class SupplyUsagePage extends StatelessWidget {
  final String? preselectedSupplyId;
  final VoidCallback onSuccess;
  final VoidCallback onCancel;

  const SupplyUsagePage({
    super.key,
    this.preselectedSupplyId,
    required this.onSuccess,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupplyUsageBloc(
        repository: SupplyRepositoryImpl(
          localDataSource: SupplyLocalDataSourceImpl(),
        ),
      )..add(LoadSuppliesForUsage()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registrar Uso'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onCancel,
          ),
        ),
        body: BlocListener<SupplyUsageBloc, SupplyUsageState>(
          listener: (context, state) {
            if (state is UsageRegistered) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              onSuccess();
            } else if (state is SupplyUsageError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Column(
            children: [
              const AppLogoWidget(),
              Expanded(
                child: BlocBuilder<SupplyUsageBloc, SupplyUsageState>(
                  builder: (context, state) {
                    if (state is SupplyUsageLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is SuppliesForUsageLoaded) {
                      return SupplyUsageFormWidget(
                        supplies: state.supplies,
                        preselectedSupplyId: preselectedSupplyId,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
