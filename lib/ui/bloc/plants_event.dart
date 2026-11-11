import '../../domain/entities/plant.dart';

sealed class PlantsEvent {}

class PlantsLoadRequested extends PlantsEvent {}

class PlantsLikeToggled extends PlantsEvent {
  PlantsLikeToggled(this.plantId);
  final String plantId;
}

class PlantsOnlyLikedToggled extends PlantsEvent {}

class PlantsSearchChanged extends PlantsEvent {
  PlantsSearchChanged(this.query);
  final String query;
}

class PlantsAdded extends PlantsEvent {
  PlantsAdded(this.plant);
  final Plant plant;
}

class PlantsUpdated extends PlantsEvent {
  PlantsUpdated(this.plant);
  final Plant plant;
}

class PlantsDeleted extends PlantsEvent {
  PlantsDeleted(this.plantId);
  final String plantId;
}