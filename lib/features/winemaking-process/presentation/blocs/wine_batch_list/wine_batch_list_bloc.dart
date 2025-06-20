import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/wine_batch.dart';
import '../../../data/repositories/wine_batch_repository_impl.dart';

// Events
abstract class WineBatchListEvent extends Equatable {
  const WineBatchListEvent();

  @override
  List<Object> get props => [];
}

class LoadWineBatches extends WineBatchListEvent {}

class SearchWineBatches extends WineBatchListEvent {
  final String query;

  const SearchWineBatches(this.query);

  @override
  List<Object> get props => [query];
}

// States
abstract class WineBatchListState extends Equatable {
  const WineBatchListState();

  @override
  List<Object> get props => [];
}

class WineBatchListInitial extends WineBatchListState {}

class WineBatchListLoading extends WineBatchListState {}

class WineBatchListLoaded extends WineBatchListState {
  final List<WineBatch> batches;
  final List<WineBatch> filteredBatches;
  final String searchQuery;

  const WineBatchListLoaded({
    required this.batches,
    required this.filteredBatches,
    this.searchQuery = '',
  });

  WineBatchListLoaded copyWith({
    List<WineBatch>? batches,
    List<WineBatch>? filteredBatches,
    String? searchQuery,
  }) {
    return WineBatchListLoaded(
      batches: batches ?? this.batches,
      filteredBatches: filteredBatches ?? this.filteredBatches,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [batches, filteredBatches, searchQuery];
}

class WineBatchListError extends WineBatchListState {
  final String message;

  const WineBatchListError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class WineBatchListBloc extends Bloc<WineBatchListEvent, WineBatchListState> {
  final WineBatchRepository repository;

  WineBatchListBloc({required this.repository}) : super(WineBatchListInitial()) {
    on<LoadWineBatches>(_onLoadWineBatches);
    on<SearchWineBatches>(_onSearchWineBatches);
  }

  Future<void> _onLoadWineBatches(
    LoadWineBatches event,
    Emitter<WineBatchListState> emit,
  ) async {
    emit(WineBatchListLoading());
    try {
      final batches = await repository.getWineBatches();
      emit(WineBatchListLoaded(
        batches: batches,
        filteredBatches: batches,
      ));
    } catch (e) {
      emit(WineBatchListError(e.toString()));
    }
  }

  Future<void> _onSearchWineBatches(
    SearchWineBatches event,
    Emitter<WineBatchListState> emit,
  ) async {
    if (state is WineBatchListLoaded) {
      final currentState = state as WineBatchListLoaded;
      final filteredBatches = event.query.isEmpty
          ? currentState.batches
          : currentState.batches
              .where((batch) =>
                  batch.internalCode.toLowerCase().contains(event.query.toLowerCase()) ||
                  batch.grapeVariety.toLowerCase().contains(event.query.toLowerCase()) ||
                  batch.vineyardOrigin.toLowerCase().contains(event.query.toLowerCase()))
              .toList();

      emit(currentState.copyWith(
        filteredBatches: filteredBatches,
        searchQuery: event.query,
      ));
    }
  }
}
