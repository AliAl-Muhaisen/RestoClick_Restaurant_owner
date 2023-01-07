import 'dart:developer';

// import 'package:customer_app/screens/restaurant/reservationPage.dart';

import '../../models/reservation.dart';
import 'package:flutter/material.dart';
// import '../../models/restaurantReserveFacade.dart';
import '../../models/screen.dart';
import '../../widgets/loadingSpin.dart';
import '../../widgets/utils/addSpace.dart';
// import 'restaurantMenu.dart';
import '../../widgets/utils/showDialog.dart';

class MyReservationPage extends StatelessWidget {
  static String routeName = "/myReservationPage";

  const MyReservationPage({Key? key}) : super(key: key);
  Future<List<Reservation>> get reserveWithRestaurant async {
    List<Reservation> result = await Reservation.restaurantReservations;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(237, 247, 241, 241),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(237, 247, 241, 241),
        foregroundColor: Colors.black,
        title: const Text("Your Reservations"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AddVerticalSpace(20),
                FutureBuilder(
                  future: reserveWithRestaurant,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: spinKitLoading());
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      List<Reservation> result =
                          snapshot.data as List<Reservation>;
                      if (!snapshot.hasData || result.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              "You did not make any reservations yet",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }

                      return Flexible(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: result.length,
                            itemBuilder: (context, index) {
                              return SingleChildScrollView(
                                child: ReservationItem(
                                    restaurantReserveFacade: result[index]),
                              );
                            }),
                      );
                    }
                    return const Center(
                      child: Text(
                          "Something went wrong please check your internet connection"),
                    );
                  },
                ),
                AddVerticalSpace(10)
              ]),
        ),
      ),
    );
  }
}

class ReservationItem extends StatelessWidget {
  final Reservation restaurantReserveFacade;
  const ReservationItem({
    Key? key,
    required this.restaurantReserveFacade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(restaurantReserveFacade.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Color.fromARGB(237, 247, 241, 241),
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
              'Do you want to remove this reservation?',
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
        restaurantReserveFacade.delete();
      },
      child: ReservationCardItem(
        restaurantReserveFacade: restaurantReserveFacade,
        borderRadius: 30,
        elevation: 5,
        imageBorderRadius: 100,
        marginHorizontal: 15,
        marginVertical: 4,
        paddingHorizontal: 8,
        paddingVertical: 5,
        key: Key(restaurantReserveFacade.id!),
        onTap: () {},
      ),
    );
  }
}

class ReservationCardItem extends StatelessWidget {
  final Reservation restaurantReserveFacade;
  double borderRadius;
  // padding
  double paddingVertical;
  double paddingHorizontal;

  double marginVertical;
  double marginHorizontal;
  double elevation;
  void Function()? onTap;
  double imageBorderRadius;

  final dateNow = DateTime.now();
  ReservationCardItem({
    Key? key,
    required this.restaurantReserveFacade,
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
      key: Key(restaurantReserveFacade.id!),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius), // <-- Radius
      ),
      margin: EdgeInsets.symmetric(
        horizontal: marginHorizontal,
        vertical: marginVertical,
      ),
      elevation: elevation,
      color: Color.fromARGB(251, 255, 255, 255),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal, vertical: paddingVertical),
        child: ListTile(
          onTap: () {
            if (onTap != null) {
              onTap!();
            }
          },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          trailing: SizedBox(
            width: 100,
            // height: 50,
            child: (restaurantReserveFacade.status == "accepted" &&
                    restaurantReserveFacade.date.isBefore(DateTime(
                      dateNow.year,
                      dateNow.month,
                      dateNow.day + 1,
                    )))
                ? IconButton(
                    onPressed: () {}, icon: const Icon(Icons.add_comment))
                : Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.all(1),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.done,
                          color: Colors.greenAccent,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.close, color: Colors.redAccent),
                      ),
                    ],
                  ),
          ),
          leading: restaurantReserveFacade.status == "waiting"
              ? const CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 255, 255, 254),
                  child: Icon(
                    Icons.pending,
                    size: 45,
                    color: Color.fromARGB(255, 230, 192, 28),
                  ),
                )
              : restaurantReserveFacade.status == "rejected"
                  ? const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      child: Icon(
                        Icons.cancel,
                        size: 45,
                        color: Color.fromARGB(255, 199, 49, 49),
                      ),
                    )
                  : const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      child: Icon(
                        Icons.check_circle,
                        size: 45,
                        color: Color.fromARGB(255, 113, 226, 37),
                      ),
                    ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(restaurantReserveFacade.numOfPeople.toString()),
              Row(
                children: [
                  const Icon(Icons.person),
                  Text(
                    "${restaurantReserveFacade.numOfPeople}",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 32, 33, 34),
                      fontSize: 20,
                    ),
                  ),
                ],
              )
            ],
          ),
          subtitle: Text(restaurantReserveFacade.dateAsString +
              " " +
              restaurantReserveFacade.hour.toString()),
        ),
      ),
    );
  }
}
