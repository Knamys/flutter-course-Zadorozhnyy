import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/plant.dart';
import '../bloc/plants_bloc.dart';
import '../bloc/plants_event.dart';
import '../bloc/plants_state.dart';
import '../widgets/plant_card.dart';
import '../widgets/plant_cover.dart';
import '../widgets/plant_form_sheet.dart';

class PlantDetailsScreen extends StatelessWidget {
  const PlantDetailsScreen({super.key, required this.plantId});

  final String plantId;

  void _edit(BuildContext context, Plant plant) {
    final bloc = context.read<PlantsBloc>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => PlantFormSheet(
        plant: plant,
        onSave: (p) => bloc.add(PlantsUpdated(p)),
      ),
    );
  }

  Future<void> _delete(BuildContext context, Plant plant) async {
    final bloc = context.read<PlantsBloc>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Удалить «${plant.name}»?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      bloc.add(PlantsDeleted(plant.id));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlantsBloc, PlantsState>(
      builder: (context, state) {
        if (state is! PlantsLoadSuccess) return const Scaffold();
        final plant = state.plants.where((p) => p.id == plantId).firstOrNull;
        if (plant == null) return const Scaffold(); // элемент удалён
        final isLiked = state.likedIds.contains(plant.id);
        final description = plant.description;

        return Scaffold(
          backgroundColor: const Color(0xFFE8EEE7),
          appBar: AppBar(
            backgroundColor: const Color(0xFFE8EEE7),
            actions: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: const Color(0xFFE84D59),
                ),
                onPressed: () =>
                    context.read<PlantsBloc>().add(PlantsLikeToggled(plant.id)),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _edit(context, plant),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _delete(context, plant),
              ),
            ],
          ),
          body: ListView(
            children: [
              PlantCover(plant: plant, width: double.infinity, height: 260),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plant.name,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(plant.latinName,
                        style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(iconFor(plant.category)),
                        const SizedBox(width: 8),
                        Text(plant.category.label),
                      ],
                    ),
                    if (plant.feature.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('Тег: ${plant.feature}'),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      description == null || description.isEmpty
                          ? 'Описания пока нет'
                          : description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}