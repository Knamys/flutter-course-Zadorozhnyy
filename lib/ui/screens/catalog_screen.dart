import 'package:flutter/material.dart';

import '../../domain/entities/plant.dart';
import '../widgets/plant_card.dart';

const _plants = [
  Plant(
    id: 1,
    name: 'Венерина мухоловка',
    latinName: 'Dionaea muscipula',
    category: PlantCategory.swamp,
    feature: 'Солнцелюбивое',
    imagePath: 'assets/ВенеринаМухоловка.jpg',
  ),
  Plant(
    id: 2,
    name: 'Непентес',
    latinName: 'Nepenthes',
    category: PlantCategory.tropics,
    feature: 'Лиана',
    imagePath: 'assets/Непентес.jpg',
  ),
  Plant(
    id: 3,
    name: 'Росянка',
    latinName: 'Drosera rotundifolia',
    category: PlantCategory.swamp,
    feature: 'Липкие ловушки',
    imagePath: 'assets/Росянка.jpg',
  ),
  Plant(
    id: 4,
    name: 'Саррацения',
    latinName: 'Sarracenia',
    category: PlantCategory.northAmerica,
    feature: 'Кувшинчатые ловушки',
    imagePath: 'assets/Саррацения.jpg',
  ),
  Plant(
    id: 5,
    name: 'Жирянка',
    latinName: 'Pinguicula vulgaris',
    category: PlantCategory.swamp,
    feature: 'Липкие листья',
    imagePath: 'assets/Жирянка.jpg',
  ),
  Plant(
    id: 6,
    name: 'Дарлингтония',
    latinName: 'Darlingtonia californica',
    category: PlantCategory.northAmerica,
    feature: 'Кувшинчатые ловушки',
    imagePath: 'assets/Дарлингтония.jpg',
  ),
  Plant(
    id: 7,
    name: 'Пузырчатка',
    latinName: 'Utricularia',
    category: PlantCategory.water,
    feature: 'Ловушки-пузырьки',
    imagePath: 'assets/Пузырчатка.jpg',
  ),
  Plant(
    id: 8,
    name: 'Цефалотус',
    latinName: 'Cephalotus follicularis',
    category: PlantCategory.australia,
    feature: 'Кувшинчатые ловушки',
    imagePath: 'assets/Цефалотус.jpg',
  ),
];

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final Set<int> _likedIds = {};
  bool _onlyLiked = false;

void _toggleLike(int id) {
  setState(() {
    if (_likedIds.contains(id)) {
      _likedIds.remove(id);
    } else {
      _likedIds.add(id);
    }
  });
}

  @override
  Widget build(BuildContext context) {
    final visible = _onlyLiked ? _plants.where((p) => _likedIds.contains(p.id)).toList() : _plants;

    return Scaffold(
      backgroundColor: const Color(0xFFE8EEE7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8EEE7),
        scrolledUnderElevation: 0,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Каталог растений-хищников', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('В каталоге: ${_plants.length} · В избранном: ${_likedIds.length}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: FilterChip(
                avatar: Icon(
                  _onlyLiked ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: _onlyLiked ? const Color(0xFFE84D59) : null,
                ),
                label: const Text('Только избранные'),
                selected: _onlyLiked,
                showCheckmark: false,
                selectedColor: const Color(0xFFCFE3D2),
                onSelected: (value) => setState(() => _onlyLiked = value),
              ),
            ),
          ),
        ),
      ),
      body: visible.isEmpty ? const Center(child: Text('Ничего не нашлось')) : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: visible.length,
        itemBuilder: (context, index) {
        final plant = visible[index];
        return PlantCard(
          plant: plant,
          isLiked: _likedIds.contains(plant.id),
          onLikeTap: () => _toggleLike(plant.id),
        );},
      ),
    );
  }
}
