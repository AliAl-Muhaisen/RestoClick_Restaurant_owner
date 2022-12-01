import 'package:flutter/material.dart';

import '../../models/restaurant.dart';
import '../../models/screen.dart';
import '../../screens/restaurant/competitorRestaurantDetail.dart';

class RestaurantCardItem extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCardItem({Key? key, required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 18 / 2,
              child: Material(
                child: Ink.image(
                  image: NetworkImage(restaurant.imageProfileUrl.toString()),
                  fit: BoxFit.cover,
                  child: InkWell(
                      onTap: () => Screen().pushNamedWithData(
                          context, CompetitorRestaurantDetail.routeName, restaurant)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            restaurant.restaurantName.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            restaurant.address.toString(),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
