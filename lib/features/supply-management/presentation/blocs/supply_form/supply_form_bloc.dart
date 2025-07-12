import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/supply.dart';
import '../../../data/repositories/supply_repository_impl.dart';

// Events
abstract class SupplyFormEvent extends Equatable {
  const SupplyFormEvent();

  @override
  List<Object> get props => [];
}

class CreateSupply extends SupplyFormEvent {
  final Supply supply;

  const CreateSupply(this.supply);

  @override
  List<Object> get props => [supply];
}

class UpdateSupply extends SupplyFormEvent {
  final Supply supply;

  const UpdateSupply(this.supply);

  @override
  List<Object> get props => [supply];
}

class LoadSupplyForEdit extends SupplyFormEvent {
  final String id;

  const LoadSupplyForEdit(this.id);

  @override
  List<Object> get props => [id];
}

class ResetForm extends SupplyFormEvent {}

// States
abstract class SupplyFormState extends Equatable {
  const SupplyFormState();

  @override
  List<Object> get props => [];
}

class SupplyFormInitial extends SupplyFormState {}

class SupplyFormLoading extends SupplyFormState {}

class SupplyFormLoaded extends SupplyFormState {
  final Supply supply;

  const SupplyFormLoaded(this.supply);

  @override
  List<Object> get props => [supply];
}

class SupplyFormSuccess extends SupplyFormState {
  final String message;

  const SupplyFormSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class SupplyFormError extends SupplyFormState {
  final String message;

  const SupplyFormError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class SupplyFormBloc extends Bloc<SupplyFormEvent, SupplyFormState> {
  final SupplyRepository repository;

  SupplyFormBloc({required this.repository}) : super(SupplyFormInitial()) {
    on<CreateSupply>(_onCreateSupply);
    on<UpdateSupply>(_onUpdateSupply);
    on<LoadSupplyForEdit>(_onLoadSupplyForEdit);
    on<ResetForm>(_onResetForm);
  }

  Future<void> _onCreateSupply(
    CreateSupply event,
    Emitter<SupplyFormState> emit,
  ) async {
    emit(SupplyFormLoading());
    try {
      final success = await repository.createSupply(event.supply);
      if (success) {
        emit(const SupplyFormSuccess('Insumo creado correctamente'));
      } else {
        emit(const SupplyFormError('No se pudo crear el insumo'));
      }
    } catch (e) {
      emit(SupplyFormError(e.toString()));
    }
  }

  Future<void> _onUpdateSupply(
    UpdateSupply event,
    Emitter<SupplyFormState> emit,
  ) async {
    emit(SupplyFormLoading());
    try {
      final success = await repository.updateSupply(event.supply);
      if (success) {
        emit(const SupplyFormSuccess('Insumo actualizado correctamente'));
      } else {
        emit(const SupplyFormError('No se pudo actualizar el insumo'));
      }
    } catch (e) {
      emit(SupplyFormError(e.toString()));
    }
  }

  Future<void> _onLoadSupplyForEdit(
    LoadSupplyForEdit event,
    Emitter<SupplyFormState> emit,
  ) async {
    emit(SupplyFormLoading());
    try {
      final supply = await repository.getSupplyById(event.id);
      if (supply != null) {
        emit(SupplyFormLoaded(supply));
      } else {
        emit(const SupplyFormError('Insumo no encontrado'));
      }
    } catch (e) {
      emit(SupplyFormError(e.toString()));
    }
  }

  Future<void> _onResetForm(
    ResetForm event,
    Emitter<SupplyFormState> emit,
  ) async {
    emit(SupplyFormInitial());
  }
}
