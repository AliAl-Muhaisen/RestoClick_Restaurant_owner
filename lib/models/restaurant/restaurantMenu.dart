class RestaurantMenu {
  List<Meal>? _mealList;
}

class Meal {
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> categories;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final bool isVegan;
  final bool isVegetarian;

  const Meal({
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.categories,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.isVegan,
    required this.isVegetarian,
  });
}
// class Category {
//   // static int countId = 1;
//   // final int id = countId++;
//   final String id;
//   final String title;
//   final Color color;

//   const Category({
//     required this.title,
//     required this.id,
//     this.color = Colors.orange,
//   });
// }
