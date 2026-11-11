import 'package:cloud_firestore/cloud_firestore.dart';

enum PlantCategory {
  swamp('Болота'),
  tropics('Тропики'),
  northAmerica('Северная Америка'),
  water('Водоёмы'),
  australia('Австралия');

  const PlantCategory(this.label);
  final String label;
}

class Plant {
  const Plant({
    required this.id,
    required this.name,
    required this.latinName,
    required this.category,
    required this.feature,
    required this.image,
    this.description,
  });

  factory Plant.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Plant(
      id: doc.id,
      name: data['name'] as String? ?? '',
      latinName: data['latinName'] as String? ?? '',
      category:
          PlantCategory.values.byName(data['category'] as String? ?? 'swamp'),
      feature: data['feature'] as String? ?? '',
      image: data['image'] as String? ?? '',
      description: data['description'] as String?,
    );
  }

  final String id;
  final String name;
  final String latinName;
  final PlantCategory category;
  final String feature;
  final String image;
  final String? description;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latinName': latinName,
      'category': category.name,
      'feature': feature,
      'image': image,
      'description': description ?? '',
    };
  }
}