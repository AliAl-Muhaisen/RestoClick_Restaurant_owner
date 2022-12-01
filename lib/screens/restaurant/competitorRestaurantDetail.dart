import 'dart:developer';

import 'package:flutter/material.dart';

import '../../models/provider/restaurant/meal.dart';
import '../../models/restaurant.dart';
import '../../widgets/loadingSpin.dart';
import '../../widgets/ui/menuCardItem.dart';

class CompetitorRestaurantDetail extends StatefulWidget {
  static const String routeName = '/competitorRestaurantDetail';

  const CompetitorRestaurantDetail({Key? key}) : super(key: key);

  @override
  State<CompetitorRestaurantDetail> createState() => _CompetitorRestaurantDetailState();
}

class _CompetitorRestaurantDetailState extends State<CompetitorRestaurantDetail> {
 

  @override
  Widget build(BuildContext context) {
    final restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.network(
                restaurant.imageProfileUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: <Widget>[
                const Text(
                  'Menu',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                ),
                FutureBuilder(
                    future: restaurant.menu,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: spinKitLoading());
                      }

                      if (snapshot.hasData) {
                        List<Meal> menu = snapshot.data as List<Meal>;
                        if (menu.isEmpty) return const Text("NO Data");
                        return Column(
                          children: [
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                  itemCount: menu.length,
                                  itemBuilder: (context, index) {
                                    return SingleChildScrollView(
                                      child: MenuCardItem(meal: menu[index]),
                                    );
                                  }),
                            ),
                          ],
                        );
                      }

                      return const Text("NO Data");
                    }),
              
              ],
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(restaurant.restaurantName!),
        centerTitle: true,
      ),
    );
  }
}
