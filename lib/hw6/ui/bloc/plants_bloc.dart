import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/plant.dart';
import 'plants_event.dart';
import 'plants_state.dart';

class PlantsBloc extends Bloc<PlantsEvent, PlantsState> {
  PlantsBloc() : super(PlantsLoadInProgress()) {
    on<PlantsLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    PlantsLoadRequested event,
    Emitter<PlantsState> emit,
  ) async {
    emit(PlantsLoadInProgress());
    await emit.forEach(
      FirebaseFirestore.instance.collection('plants').snapshots(),
      onData: (snapshot) =>
          PlantsLoadSuccess(snapshot.docs.map(Plant.fromFirestore).toList()),
      onError: (error, stackTrace) =>
          PlantsLoadFailure('Не удалось загрузить каталог'),
    );
  }
}