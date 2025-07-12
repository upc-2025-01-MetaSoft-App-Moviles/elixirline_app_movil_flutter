import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/supply.dart';
import '../../../data/repositories/supply_repository_impl.dart';

// Events
abstract class SupplyListEvent extends Equatable {
  const SupplyListEvent();

  @override
  List<Object> get props => [];
}

class LoadSupplies extends SupplyListEvent {}

class SearchSupplies extends SupplyListEvent {
  final String query;

  const SearchSupplies(this.query);

  @override
  List<Object> get props => [query];
}

// States
abstract class SupplyListState extends Equatable {
  const SupplyListState();

  @override
  List<Object> get props => [];
}

class SupplyListInitial extends SupplyListState {}

class SupplyListLoading extends SupplyListState {}

class SupplyListLoaded extends SupplyListState {
  final List<Supply> supplies;
  final List<Supply> filteredSupplies;
  final String searchQuery;

  const SupplyListLoaded({
    required this.supplies,
    required this.filteredSupplies,
    this.searchQuery = '',
  });

  SupplyListLoaded copyWith({
    List<Supply>? supplies,
    List<Supply>? filteredSupplies,
    String? searchQuery,
  }) {
    return SupplyListLoaded(
      supplies: supplies ?? this.supplies,
      filteredSupplies: filteredSupplies ?? this.filteredSupplies,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [supplies, filteredSupplies, searchQuery];
}

class SupplyListError extends SupplyListState {
  final String message;

  const SupplyListError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class SupplyListBloc extends Bloc<SupplyListEvent, SupplyListState> {
  final SupplyRepository repository;

  SupplyListBloc({required this.repository}) : super(SupplyListInitial()) {
    on<LoadSupplies>(_onLoadSupplies);
    on<SearchSupplies>(_onSearchSupplies);
  }

  Future<void> _onLoadSupplies(
    LoadSupplies event,
    Emitter<SupplyListState> emit,
  ) async {
    emit(SupplyListLoading());
    try {
      final supplies = await repository.getAllSupplies();
      emit(SupplyListLoaded(
        supplies: supplies,
        filteredSupplies: supplies,
      ));
    } catch (e) {
      emit(SupplyListError(e.toString()));
    }
  }

  Future<void> _onSearchSupplies(
    SearchSupplies event,
    Emitter<SupplyListState> emit,
  ) async {
    if (state is SupplyListLoaded) {
      final currentState = state as SupplyListLoaded;
      final filteredSupplies = event.query.isEmpty
          ? currentState.supplies
          : currentState.supplies
              .where((supply) =>
                  supply.name.toLowerCase().contains(event.query.toLowerCase()) ||
                  supply.category.toLowerCase().contains(event.query.toLowerCase()))
              .toList();

      emit(currentState.copyWith(
        filteredSupplies: filteredSupplies,
        searchQuery: event.query,
      ));
    }
  }
}
