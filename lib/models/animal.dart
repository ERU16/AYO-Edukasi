class Animal {
  final String name;
  final String origin;
  final String length;
  final String imageLink;
  final double familyFriendly;
  final double shedding;
  final double generalHealth;
  final double playfulness;
  final double childrenFriendly;
  final double grooming;
  final double intelligence;
  final double otherPetsFriendly;
  final double minWeight;
  final double maxWeight;
  final double minLifeExpectancy;
  final double maxLifeExpectancy;

  Animal({
    required this.name,
    required this.origin,
    required this.length,
    required this.imageLink,
    required this.familyFriendly,
    required this.shedding,
    required this.generalHealth,
    required this.playfulness,
    required this.childrenFriendly,
    required this.grooming,
    required this.intelligence,
    required this.otherPetsFriendly,
    required this.minWeight,
    required this.maxWeight,
    required this.minLifeExpectancy,
    required this.maxLifeExpectancy,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return Animal(
      name: json['name'] ?? '-',
      origin: json['origin'] ?? '-',
      length: json['length'] ?? '-',
      imageLink: json['image_link'] ?? '',
      familyFriendly: parseDouble(json['family_friendly']),
      shedding: parseDouble(json['shedding']),
      generalHealth: parseDouble(json['general_health']),
      playfulness: parseDouble(json['playfulness']),
      childrenFriendly: parseDouble(json['children_friendly']),
      grooming: parseDouble(json['grooming']),
      intelligence: parseDouble(json['intelligence']),
      otherPetsFriendly: parseDouble(json['other_pets_friendly']),
      minWeight: parseDouble(json['min_weight']),
      maxWeight: parseDouble(json['max_weight']),
      minLifeExpectancy: parseDouble(json['min_life_expectancy']),
      maxLifeExpectancy: parseDouble(json['max_life_expectancy']),
    );
  }
}
