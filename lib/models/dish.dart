class Dish {
  final String id;
  final String name;
  final String tag;
  final String portion;
  final double price;
  final String description;
  final String? chefNote;
  final String imageUrl;
  final List<String> accompaniments;
  final List<SauceOption> extraSauces;

  const Dish({
    required this.id,
    required this.name,
    required this.tag,
    required this.portion,
    required this.price,
    required this.description,
    this.chefNote,
    required this.imageUrl,
    this.accompaniments = const [],
    this.extraSauces = const [],
  });
}

class SauceOption {
  final String name;
  final double price;

  const SauceOption({
    required this.name,
    required this.price,
  });
}
