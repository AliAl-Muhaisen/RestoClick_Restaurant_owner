// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:restaurant_owner_app/models/provider/restaurant/meal.dart';
import 'package:restaurant_owner_app/models/provider/restaurant/restaurantMenu.dart';
import 'package:restaurant_owner_app/models/screen.dart';
import 'package:restaurant_owner_app/screens/restaurant/addMealPage.dart';
import 'package:restaurant_owner_app/widgets/utils/addSpace.dart';

import '../../themes/stander/colors.dart';
import '../../widgets/loadingSpin.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);
  static const routeName = '/menu';

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("your menu"),
        actions: [
          IconButton(
              onPressed: () {
                Screen().pushNamed(context, MealPage.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AddVerticalSpace(20),
              FutureBuilder(
                future:
                    Provider.of<RestaurantMenu>(context, listen: false).menu,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: spinKitLoading());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return Flexible(
                      child: Consumer<RestaurantMenu>(
                        builder: (context, menuData, _) {
                          if (menuData.restaurantMenu.isEmpty) {
                            return const Center(
                              child: Text(
                                "You did not add any meal yet",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: menuData.restaurantMenu.length,
                            itemBuilder: (context, index) =>
                                SingleChildScrollView(
                              child: ChangeNotifierProvider<Meal>.value(
                                value: menuData.restaurantMenu[index],
                                child: const MealMenuItem(),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const Center(child: Text("Error"));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MealMenuItem extends StatelessWidget {
  const MealMenuItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final meal = Provider.of<Meal>(context, listen: false);
    return Dismissible(
      key: ValueKey(meal.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text(
              'Do you want to remove the meal from the menu?',
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        meal.deleteMeal(meal.id);
      },
      child: CardMenuItem(
        meal: meal,
        onTap: () {
          Screen().navigatorPush(
              context,
              MealPage(
                oldMeal: meal,
              ));
        },
      ),
    );
  }
}

class CardMenuItem extends StatelessWidget {
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
  CardMenuItem({
    Key? key,
    required this.meal,
    this.borderRadius = 12,
    this.paddingVertical = 8,
    this.paddingHorizontal = 10,
    this.marginVertical = 4,
    this.marginHorizontal = 15,
    this.elevation = 20,
    this.onTap,
    this.imageBorderRadius = 12,
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
