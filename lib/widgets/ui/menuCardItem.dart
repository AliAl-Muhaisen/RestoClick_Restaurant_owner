import 'package:flutter/material.dart';

import '../../models/provider/restaurant/meal.dart';
import '../../themes/stander/colors.dart';

// class MenuCardItem extends StatelessWidget {
//   final Meal meal;
//   const MenuCardItem({
//     Key? key,
//     required this.meal,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         title: Text(meal.title!),
//         onTap: () {},
//         subtitle: Text(meal.categories),
//         leading: ClipRect(
//           child: Image.network(meal.imageUrl),
//         ),
       
//       ),
//     );
//   }
// }

class MenuCardItem extends StatelessWidget {
  final Meal meal;
  double borderRadius;
  // padding
  double paddingVertical;
  double paddingHorizontal;

  double marginVertical;
  double marginHorizontal;
  double elevation;
  void Function()? onTap;
  double imageBorderRadius;
  MenuCardItem({
    Key? key,
    required this.meal,
    this.borderRadius = 5,
    this.paddingVertical = 2,
    this.paddingHorizontal = 2,
    this.marginVertical = 2,
    this.marginHorizontal = 4,
    this.elevation = 5,
    this.onTap,
    this.imageBorderRadius = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius), // <-- Radius
      ),
      margin: EdgeInsets.symmetric(
        horizontal: marginHorizontal,
        vertical: marginVertical,
      ),
      elevation: elevation,
      color: cardMealItem,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal, vertical: paddingVertical),
        child: ListTile(
          onTap: () {
            if (onTap != null) {
              try {
                onTap!();
              } catch (e) {}
            }
          },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          trailing: Text(
            "\$${meal.price}",
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
          leading: ClipRRect(
            child: Image.network(
              meal.imageUrl,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(imageBorderRadius),
          ),
          title: Text(meal.title!),
          subtitle: Text(meal.categories),
        ),
      ),
    );
  }
}
