import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/wine_batch.dart';
import '../../../domain/entities/stages.dart';
import '../../../data/repositories/wine_batch_repository_impl.dart';

// Events
abstract class WineBatchDetailEvent extends Equatable {
  const WineBatchDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadWineBatchDetail extends WineBatchDetailEvent {
  final String batchId;

  const LoadWineBatchDetail(this.batchId);

  @override
  List<Object> get props => [batchId];
}

class LoadStagesByBatch extends WineBatchDetailEvent {
  final String batchId;

  const LoadStagesByBatch(this.batchId);

  @override
  List<Object> get props => [batchId];
}

// States
abstract class WineBatchDetailState extends Equatable {
  const WineBatchDetailState();

  @override
  List<Object> get props => [];
}

class WineBatchDetailInitial extends WineBatchDetailState {}

class WineBatchDetailLoading extends WineBatchDetailState {}

class WineBatchDetailLoaded extends WineBatchDetailState {
  final WineBatch batch;
  final List<Stages> stages;

  const WineBatchDetailLoaded({
    required this.batch,
    required this.stages,
  });

  WineBatchDetailLoaded copyWith({
    WineBatch? batch,
    List<Stages>? stages,
  }) {
    return WineBatchDetailLoaded(
      batch: batch ?? this.batch,
      stages: stages ?? this.stages,
    );
  }

  @override
  List<Object> get props => [batch, stages];
}

class WineBatchDetailError extends WineBatchDetailState {
  final String message;

  const WineBatchDetailError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class WineBatchDetailBloc extends Bloc<WineBatchDetailEvent, WineBatchDetailState> {
  final WineBatchRepository repository;

  WineBatchDetailBloc({required this.repository}) : super(WineBatchDetailInitial()) {
    on<LoadWineBatchDetail>(_onLoadWineBatchDetail);
    on<LoadStagesByBatch>(_onLoadStagesByBatch);
  }

  Future<void> _onLoadWineBatchDetail(
    LoadWineBatchDetail event,
    Emitter<WineBatchDetailState> emit,
  ) async {
    emit(WineBatchDetailLoading());
    try {
      final batch = await repository.getWineBatchById(event.batchId);
      if (batch != null) {
        final stages = await repository.getStagesByBatchId(event.batchId);
        emit(WineBatchDetailLoaded(batch: batch, stages: stages));
      } else {
        emit(const WineBatchDetailError('Lote de vino no encontrado'));
      }
    } catch (e) {
      emit(WineBatchDetailError(e.toString()));
    }
  }

  Future<void> _onLoadStagesByBatch(
    LoadStagesByBatch event,
    Emitter<WineBatchDetailState> emit,
  ) async {
    if (state is WineBatchDetailLoaded) {
      try {
        final currentState = state as WineBatchDetailLoaded;
        final stages = await repository.getStagesByBatchId(event.batchId);
        emit(currentState.copyWith(stages: stages));
      } catch (e) {
        emit(WineBatchDetailError(e.toString()));
      }
    }
  }
}
