import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/supply_form/supply_form_bloc.dart';
import '../widgets/supply_form_widget.dart';
import '../widgets/app_logo_widget.dart';
import '../../data/datasources/supply_local_datasource.dart';
import '../../data/repositories/supply_repository_impl.dart';

class SupplyFormPage extends StatelessWidget {
  final String? supplyId;
  final VoidCallback onSuccess;
  final VoidCallback onCancel;

  const SupplyFormPage({
    super.key,
    this.supplyId,
    required this.onSuccess,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = SupplyFormBloc(
          repository: SupplyRepositoryImpl(
            localDataSource: SupplyLocalDataSourceImpl(),
          ),
        );
        if (supplyId != null) {
          bloc.add(LoadSupplyForEdit(supplyId!));
        }
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(supplyId != null ? 'Editar Insumo' : 'Agregar Insumo'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onCancel,
          ),
        ),
        body: BlocListener<SupplyFormBloc, SupplyFormState>(
          listener: (context, state) {
            if (state is SupplyFormSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              onSuccess();
            } else if (state is SupplyFormError) {
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
                child: BlocBuilder<SupplyFormBloc, SupplyFormState>(
                  builder: (context, state) {
                    if (state is SupplyFormLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return SupplyFormWidget(
                      initialSupply: state is SupplyFormLoaded ? state.supply : null,
                      isEditing: supplyId != null,
                    );
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
