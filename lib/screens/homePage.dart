import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../models/restaurant.dart';

import '../widgets/loadingSpin.dart';
import '../widgets/ui/restaurantCardItem.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homePage';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Competitors")),
      body: SafeArea(
        child: FutureBuilder(
            future: Restaurant.getRestaurants(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return spinKitLoading();
              }
              if (snapshot.hasData) {
                List<Restaurant> restaurants =
                    snapshot.data as List<Restaurant>;

                if (restaurants.isEmpty) {
                  return const Center(
                    child: Text("No competitor yet"),
                  );
                }
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      child: SizedBox(
                        height: 300,
                        // width: 300,
                        child:
                            RestaurantCardItem(restaurant: restaurants[index]),
                      ),
                    );
                  },
                  itemCount: restaurants.length,
                );
              }

              return const Center(
                child: Text("No competitor yet"),
              );
              // return spinKitLoading();
            }),
      ),
    );
  }
}
