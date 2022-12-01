import 'package:flutter/material.dart';

import '../../models/provider/restaurant/meal.dart';

class MenuCardItem extends StatelessWidget {
  final Meal meal;
  const MenuCardItem({
    Key? key,
    required this.meal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(meal.title!),
        onTap: () {},
        subtitle: Text(meal.categories),
        leading: ClipRect(
          child: Image.network(meal.imageUrl),
        ),
       
      ),
    );
  }
}
