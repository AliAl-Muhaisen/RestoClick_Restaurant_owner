class Category {
  // ignore: slash_for_doc_comments
  /**
  *? info
  *? void = - and get = + setAndGet =
  *# Functions
  *$ + mealCategories
  *$ + _categories
  *$ + restaurantMenu
  *$ + restaurantCategories
  */
  static final Category _category = Category._internal();

  /// It contains the meals and places categories
  factory Category() {
    return _category;
  }

  Category._internal();

  final List<String> _restaurantCategories = [
    "Restaurant",
    "Coffee House",
    "Farm"
  ];
  final List<String> _mealCategories = [
    'Arabic Food'
        'Italian',
    'Hamburgers',
    'German',
    'Breakfast',
    'Asian',
    'French',
    'SeaFood',
  ];
  /// places category
  List<String> get restaurantCategories {
    return [..._restaurantCategories];
  }

  /// meals category
  List<String> get mealCategories {
    return [..._mealCategories];
  }
}
