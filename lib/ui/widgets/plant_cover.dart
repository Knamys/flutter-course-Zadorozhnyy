import 'package:flutter/material.dart';
import '../../domain/entities/plant.dart';

class PlantCover extends StatelessWidget {
  const PlantCover({
    super.key,
    required this.plant,
    required this.width,
    required this.height,
  });

  final Plant plant;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      plant.image,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: const Color(0xFF4B6C50),
          alignment: Alignment.center,
          child: Text(
            plant.name.isEmpty ? '?' : plant.name[0].toUpperCase(),
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: Color(0xFF193126),
            ),
          ),
        );
      },
    );
  }
}