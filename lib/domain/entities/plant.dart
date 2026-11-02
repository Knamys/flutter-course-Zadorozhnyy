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
    required this.imagePath,
    this.description,
  });

  final int id;
  final String name;
  final String latinName;
  final PlantCategory category;
  final String feature;
  final String imagePath;
  final String? description;
}