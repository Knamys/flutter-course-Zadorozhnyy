import '../../domain/entities/plant.dart';

sealed class PlantsState {}

class PlantsLoadInProgress extends PlantsState {}

class PlantsLoadFailure extends PlantsState {
  PlantsLoadFailure(this.message);
  final String message;
}

class PlantsLoadSuccess extends PlantsState {
  PlantsLoadSuccess({
    required this.plants,
    required this.likedIds,
    required this.onlyLiked,
    required this.query,
  });

  final List<Plant> plants;
  final Set<String> likedIds;
  final bool onlyLiked;
  final String query;

  int get likedCount => plants.where((p) => likedIds.contains(p.id)).length;

  List<Plant> get visible {
    final q = query.trim().toLowerCase();
    return plants
        .where((p) =>
            (!onlyLiked || likedIds.contains(p.id)) &&
            p.name.toLowerCase().contains(q))
        .toList();
  }

  PlantsLoadSuccess copyWith({bool? onlyLiked, String? query}) {
    return PlantsLoadSuccess(
      plants: plants,
      likedIds: likedIds,
      onlyLiked: onlyLiked ?? this.onlyLiked,
      query: query ?? this.query,
    );
  }
}