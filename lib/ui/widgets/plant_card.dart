import 'package:flutter/material.dart';
import '../../domain/entities/plant.dart';
import 'plant_cover.dart';

IconData iconFor(PlantCategory category) {
  return switch (category) {
    PlantCategory.swamp => Icons.grass,
    PlantCategory.tropics => Icons.wb_sunny,
    PlantCategory.northAmerica => Icons.terrain,
    PlantCategory.water => Icons.waves,
    PlantCategory.australia => Icons.public,
  };
}

class PlantCard extends StatelessWidget {
  const PlantCard({
    super.key,
    required this.plant,
    required this.isLiked,
    required this.onLikeTap,
    required this.onTap,
  });

  final Plant plant;
  final bool isLiked;
  final VoidCallback onLikeTap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFF080A08),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  PlantCover(plant: plant, width: 280, height: 200),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: onLikeTap,
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: const Color(0xFFE84D59),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              plant.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFF0F0E7),
                              ),
                            ),
                          ),
                          Icon(iconFor(plant.category),
                              color: const Color(0xFF999E99)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plant.latinName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF999E99),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          'Хищное',
                          plant.category.label,
                          if (plant.feature.isNotEmpty) plant.feature,
                        ].map(_tag).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tag(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF4B6C50),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF193126),
        ),
      ),
    );
  }
}