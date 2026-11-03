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

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] as String,
      name: json['name'] as String,
      latinName: json['latinName'] as String,
      category: PlantCategory.values.byName(json['category'] as String),
      feature: json['feature'] as String,
      image: json['image'] as String,
      description: json['description'] as String?,
    );
  }

  final String id;
  final String name;
  final String latinName;
  final PlantCategory category;
  final String feature;
  final String image;
  final String? description;

  // id не отправляем: его выдаёт сервер
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