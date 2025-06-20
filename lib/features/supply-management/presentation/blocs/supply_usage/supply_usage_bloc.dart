import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/supply.dart';
import '../../../domain/entities/supply_usage.dart';
import '../../../data/repositories/supply_repository_impl.dart';

// Events
abstract class SupplyUsageEvent extends Equatable {
  const SupplyUsageEvent();

  @override
  List<Object> get props => [];
}

class LoadSuppliesForUsage extends SupplyUsageEvent {}

class RegisterUsage extends SupplyUsageEvent {
  final SupplyUsage usage;

  const RegisterUsage(this.usage);

  @override
  List<Object> get props => [usage];
}

class LoadUsageHistory extends SupplyUsageEvent {}

class SearchUsageHistory extends SupplyUsageEvent {
  final String query;

  const SearchUsageHistory(this.query);

  @override
  List<Object> get props => [query];
}

// States
abstract class SupplyUsageState extends Equatable {
  const SupplyUsageState();

  @override
  List<Object> get props => [];
}

class SupplyUsageInitial extends SupplyUsageState {}

class SupplyUsageLoading extends SupplyUsageState {}

class SuppliesForUsageLoaded extends SupplyUsageState {
  final List<Supply> supplies;

  const SuppliesForUsageLoaded(this.supplies);

  @override
  List<Object> get props => [supplies];
}

class UsageRegistered extends SupplyUsageState {
  final String message;

  const UsageRegistered(this.message);

  @override
  List<Object> get props => [message];
}

class UsageHistoryLoaded extends SupplyUsageState {
  final List<SupplyUsageWithDetails> usages;
  final List<SupplyUsageWithDetails> filteredUsages;
  final String searchQuery;

  const UsageHistoryLoaded({
    required this.usages,
    required this.filteredUsages,
    this.searchQuery = '',
  });

  UsageHistoryLoaded copyWith({
    List<SupplyUsageWithDetails>? usages,
    List<SupplyUsageWithDetails>? filteredUsages,
    String? searchQuery,
  }) {
    return UsageHistoryLoaded(
      usages: usages ?? this.usages,
      filteredUsages: filteredUsages ?? this.filteredUsages,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [usages, filteredUsages, searchQuery];
}

class SupplyUsageError extends SupplyUsageState {
  final String message;

  const SupplyUsageError(this.message);

  @override
  List<Object> get props => [message];
}

// Helper class
class SupplyUsageWithDetails extends Equatable {
  final SupplyUsage usage;
  final String supplyName;
  final String supplyCategory;
  final String supplyUnit;

  const SupplyUsageWithDetails({
    required this.usage,
    required this.supplyName,
    required this.supplyCategory,
    required this.supplyUnit,
  });

  @override
  List<Object> get props => [usage, supplyName, supplyCategory, supplyUnit];
}

// Bloc
class SupplyUsageBloc extends Bloc<SupplyUsageEvent, SupplyUsageState> {
  final SupplyRepository repository;

  SupplyUsageBloc({required this.repository}) : super(SupplyUsageInitial()) {
    on<LoadSuppliesForUsage>(_onLoadSuppliesForUsage);
    on<RegisterUsage>(_onRegisterUsage);
    on<LoadUsageHistory>(_onLoadUsageHistory);
    on<SearchUsageHistory>(_onSearchUsageHistory);
  }

  Future<void> _onLoadSuppliesForUsage(
    LoadSuppliesForUsage event,
    Emitter<SupplyUsageState> emit,
  ) async {
    emit(SupplyUsageLoading());
    try {
      final supplies = await repository.getAllSupplies();
      emit(SuppliesForUsageLoaded(supplies));
    } catch (e) {
      emit(SupplyUsageError(e.toString()));
    }
  }

  Future<void> _onRegisterUsage(
    RegisterUsage event,
    Emitter<SupplyUsageState> emit,
  ) async {
    emit(SupplyUsageLoading());
    try {
      final success = await repository.registerSupplyUsage(event.usage);
      if (success) {
        emit(const UsageRegistered('Uso registrado correctamente'));
      } else {
        emit(const SupplyUsageError('No se pudo registrar el uso'));
      }
    } catch (e) {
      emit(SupplyUsageError(e.toString()));
    }
  }

  Future<void> _onLoadUsageHistory(
    LoadUsageHistory event,
    Emitter<SupplyUsageState> emit,
  ) async {
    emit(SupplyUsageLoading());
    try {
      final usages = await repository.getAllSupplyUsages();
      final supplies = await repository.getAllSupplies();
      
      final usagesWithDetails = <SupplyUsageWithDetails>[];
      
      for (final usage in usages) {
        final supply = supplies.firstWhere(
          (s) => s.id == usage.supplyId,
          orElse: () => const Supply(
            id: '',
            name: 'Desconocido',
            category: 'Desconocido',
            quantity: 0,
            unit: '',
            location: '',
            expirationDate: '',
            status: '',
          ),
        );
        
        usagesWithDetails.add(SupplyUsageWithDetails(
          usage: usage,
          supplyName: supply.name,
          supplyCategory: supply.category,
          supplyUnit: supply.unit,
        ));
      }
      
      emit(UsageHistoryLoaded(
        usages: usagesWithDetails,
        filteredUsages: usagesWithDetails,
      ));
    } catch (e) {
      emit(SupplyUsageError(e.toString()));
    }
  }

  Future<void> _onSearchUsageHistory(
    SearchUsageHistory event,
    Emitter<SupplyUsageState> emit,
  ) async {
    if (state is UsageHistoryLoaded) {
      final currentState = state as UsageHistoryLoaded;
      final filteredUsages = event.query.isEmpty
          ? currentState.usages
          : currentState.usages
              .where((usageWithDetails) =>
                  usageWithDetails.supplyName.toLowerCase().contains(event.query.toLowerCase()) ||
                  usageWithDetails.supplyCategory.toLowerCase().contains(event.query.toLowerCase()) ||
                  usageWithDetails.usage.activity.toLowerCase().contains(event.query.toLowerCase()) ||
                  usageWithDetails.usage.date.toLowerCase().contains(event.query.toLowerCase()))
              .toList();

      emit(currentState.copyWith(
        filteredUsages: filteredUsages,
        searchQuery: event.query,
      ));
    }
  }
}
