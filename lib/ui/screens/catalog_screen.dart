import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/plants_bloc.dart';
import '../bloc/plants_event.dart';
import '../bloc/plants_state.dart';
import '../widgets/plant_card.dart';
import '../widgets/plant_form_sheet.dart';
import 'plant_details_screen.dart';
import 'profile_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddSheet() {
    final bloc = context.read<PlantsBloc>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => PlantFormSheet(onSave: (p) => bloc.add(PlantsAdded(p))),
    );
  }

  void _openDetails(String id) {
    final bloc = context.read<PlantsBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: PlantDetailsScreen(plantId: id),
        ),
      ),
    );
  }

  void _openProfile() {
    final bloc = context.read<PlantsBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: const ProfileScreen(),
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () =>
                context.read<PlantsBloc>().add(PlantsLoadRequested()),
            child: const Text('Обновить'),
          ),
        ],
      ),
    );
  }

  Widget _buildList(PlantsLoadSuccess state) {
    final visible = state.visible;
    if (visible.isEmpty) {
      final text = state.onlyLiked && state.query.isEmpty
          ? 'В избранном пока пусто'
          : 'Ничего не нашлось';
      return Center(child: Text(text));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: visible.length,
      itemBuilder: (context, index) {
        final plant = visible[index];
        return PlantCard(
          plant: plant,
          isLiked: state.likedIds.contains(plant.id),
          onLikeTap: () =>
              context.read<PlantsBloc>().add(PlantsLikeToggled(plant.id)),
          onTap: () => _openDetails(plant.id),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlantsBloc, PlantsState>(
      builder: (context, state) {
        final success = state is PlantsLoadSuccess ? state : null;
        final total = success?.plants.length ?? 0;
        final liked = success?.likedCount ?? 0;

        final content = switch (state) {
          PlantsLoadInProgress() =>
            const Center(child: CircularProgressIndicator()),
          PlantsLoadFailure f => _buildError(f.message),
          PlantsLoadSuccess s => _buildList(s),
        };

        return Scaffold(
          backgroundColor: const Color(0xFFE8EEE7),
          appBar: AppBar(
            backgroundColor: const Color(0xFFE8EEE7),
            scrolledUnderElevation: 0,
            toolbarHeight: 80,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Каталог растений-хищников',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(
                  'В каталоге: $total · В избранном: $liked',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: _openProfile,
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => FirebaseAuth.instance.signOut(),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _openAddSheet,
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (q) =>
                      context.read<PlantsBloc>().add(PlantsSearchChanged(q)),
                  decoration: InputDecoration(
                    hintText: 'Поиск по названию',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: FilterChip(
                    avatar: Icon(
                      success?.onlyLiked == true
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 18,
                      color: success?.onlyLiked == true
                          ? const Color(0xFFE84D59)
                          : null,
                    ),
                    label: const Text('Только избранные'),
                    selected: success?.onlyLiked ?? false,
                    showCheckmark: false,
                    selectedColor: const Color(0xFFCFE3D2),
                    onSelected: (_) =>
                        context.read<PlantsBloc>().add(PlantsOnlyLikedToggled()),
                  ),
                ),
              ),
              Expanded(child: content),
            ],
          ),
        );
      },
    );
  }
}