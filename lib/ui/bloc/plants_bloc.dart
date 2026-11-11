import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/plants_repository.dart';
import '../../domain/entities/plant.dart';
import 'plants_event.dart';
import 'plants_state.dart';

class PlantsBloc extends Bloc<PlantsEvent, PlantsState> {
  PlantsBloc(this._repository, this._uid) : super(PlantsLoadInProgress()) {
    on<PlantsLoadRequested>(_onLoadRequested);
    on<PlantsLikeToggled>(_onLikeToggled);
    on<PlantsOnlyLikedToggled>(_onOnlyLikedToggled);
    on<PlantsSearchChanged>(_onSearchChanged);
    on<PlantsAdded>((event, emit) => _repository.addPlant(event.plant));
    on<PlantsUpdated>((event, emit) => _repository.updatePlant(event.plant));
    on<PlantsDeleted>((event, emit) => _repository.deletePlant(event.plantId));
  }

  final PlantsRepository _repository;
  final String _uid;

  List<Plant>? _plants;
  Set<String> _liked = {};
  bool _onlyLiked = false;
  String _query = '';

  Future<void> _onLoadRequested(
    PlantsLoadRequested event,
    Emitter<PlantsState> emit,
  ) async {
    emit(PlantsLoadInProgress());
    _plants = null;
    // два потока: каталог и избранное пользователя
    await Future.wait([
      emit.forEach<List<Plant>>(
        _repository.watchPlants(),
        onData: (plants) {
          _plants = plants;
          return _buildState();
        },
        onError: _onError,
      ),
      emit.forEach<Set<String>>(
        _repository.watchFavorites(_uid),
        onData: (liked) {
          _liked = liked;
          return _buildState();
        },
        onError: _onError,
      ),
    ]);
  }

  PlantsState _buildState() {
    final plants = _plants;
    if (plants == null) return state;
    return PlantsLoadSuccess(
      plants: plants,
      likedIds: _liked,
      onlyLiked: _onlyLiked,
      query: _query,
    );
  }

  PlantsState _onError(Object error, StackTrace stackTrace) {
    return PlantsLoadFailure('Не удалось загрузить каталог');
  }

  Future<void> _onLikeToggled(
    PlantsLikeToggled event,
    Emitter<PlantsState> emit,
  ) {
    final liked = _liked.contains(event.plantId);
    return _repository.setFavorite(_uid, event.plantId, !liked);
  }

  void _onOnlyLikedToggled(
    PlantsOnlyLikedToggled event,
    Emitter<PlantsState> emit,
  ) {
    _onlyLiked = !_onlyLiked;
    final current = state;
    if (current is PlantsLoadSuccess) {
      emit(current.copyWith(onlyLiked: _onlyLiked));
    }
  }

  void _onSearchChanged(
    PlantsSearchChanged event,
    Emitter<PlantsState> emit,
  ) {
    _query = event.query;
    final current = state;
    if (current is PlantsLoadSuccess) {
      emit(current.copyWith(query: _query));
    }
  }
}