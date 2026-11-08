import 'package:flutter/material.dart';
import 'package:hw1/hw5/domain/entities/plant.dart';

class PlantCard extends StatelessWidget {
  const PlantCard({
    super.key,
    required this.plant,
    required this.isLiked,
    required this.onLikeTap,
  });

  final Plant plant;
  final bool isLiked;
  final VoidCallback onLikeTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                Image.asset(plant.image, width: 280, height: 200, fit: BoxFit.cover),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
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
                    Text(plant.name, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFF0F0E7))),
                    const SizedBox(height: 4),
                    Text(plant.latinName, style: const TextStyle(fontSize: 16, color: Color(0xFF999E99), fontStyle: FontStyle.italic)),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: ['Хищное', plant.category.label, plant.feature].map(_tag).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF193126)),
      ),
    );
  }
}