import 'dart:developer';

import 'package:flutter/material.dart';

import '../../widgets/loadingSpin.dart';
import '../../widgets/utils/addSpace.dart';
import '../../widgets/utils/showDialog.dart';
import '../../models/userReserveFacade.dart';

class MyReservationPage extends StatelessWidget {
  static String routeName = "/myReservationPage";

  const MyReservationPage({Key? key}) : super(key: key);
  Future<List<UserReserveFacade>> get reserveWithRestaurant async {
    List<UserReserveFacade> result = await UserReserveFacade.reserveWithUser;
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
                      List<UserReserveFacade> result =
                          snapshot.data as List<UserReserveFacade>;
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
                                    userReserveFacade: result[index]),
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
  final UserReserveFacade userReserveFacade;
  const ReservationItem({
    Key? key,
    required this.userReserveFacade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(userReserveFacade.id),
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
        userReserveFacade.reserve.delete();
      },
      child: ReservationCardItem(
        userReserveFacade: userReserveFacade,
        borderRadius: 30,
        elevation: 5,
        imageBorderRadius: 100,
        marginHorizontal: 15,
        marginVertical: 4,
        paddingHorizontal: 8,
        paddingVertical: 5,
        key: Key(userReserveFacade.id),
        onTap: () {},
      ),
    );
  }
}

class ReservationCardItem extends StatefulWidget {
  final UserReserveFacade userReserveFacade;
  double borderRadius;
  // padding
  double paddingVertical;
  double paddingHorizontal;

  double marginVertical;
  double marginHorizontal;
  double elevation;
  void Function()? onTap;
  double imageBorderRadius;

  ReservationCardItem({
    Key? key,
    required this.userReserveFacade,
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
  State<ReservationCardItem> createState() => _ReservationCardItemState();
}

class _ReservationCardItemState extends State<ReservationCardItem> {
  final dateNow = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key(widget.userReserveFacade.id),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius), // <-- Radius
      ),
      margin: EdgeInsets.symmetric(
        horizontal: widget.marginHorizontal,
        vertical: widget.marginVertical,
      ),
      elevation: widget.elevation,
      color: Color.fromARGB(251, 255, 255, 255),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: widget.paddingHorizontal,
            vertical: widget.paddingVertical),
        child: ListTile(
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!();
            }
          },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          trailing: SizedBox(
            width: 100,
            // height: 50,
            child: (widget.userReserveFacade.reserve.status == "accepted")
                ? (widget.userReserveFacade.reserve.status == "accepted" &&
                        widget.userReserveFacade.reserve.date.isBefore(
                          DateTime.now().add(const Duration(hours: 1)),
                        ))
                    ? Center(
                        child: IconButton(
                          onPressed: () {
                            log("message");
                          },
                          icon: const Icon(
                            Icons.report,
                            color: Color.fromARGB(255, 228, 228, 37),
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          return showHttpDialog(
                            "Phone Number",
                            widget.userReserveFacade.user.phoneNumber
                                .toString(),
                            "Close",
                            context,
                          );
                        },
                        icon: const Icon(Icons.call),
                      )
                : Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          widget.userReserveFacade.reserve
                              .updateStatus(status: "accepted");
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.done,
                          color: Colors.greenAccent,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget.userReserveFacade.reserve
                              .updateStatus(status: "rejected");
                          setState(() {});
                        },
                        icon: const Icon(Icons.close, color: Colors.redAccent),
                      ),
                    ],
                  ),
          ),
          leading: widget.userReserveFacade.reserve.status == "waiting"
              ? const CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 255, 255, 254),
                  child: Icon(
                    Icons.pending,
                    size: 45,
                    color: Color.fromARGB(255, 230, 192, 28),
                  ),
                )
              : widget.userReserveFacade.reserve.status == "rejected"
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
            children: [
              Text(widget.userReserveFacade.user.name.toString()),
              AddHorizontalSpace(10),
              Row(
                children: [
                  const Icon(Icons.person),
                  Text(
                    "${widget.userReserveFacade.reserve.numOfPeople}",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 32, 33, 34),
                      fontSize: 20,
                    ),
                  ),
                ],
              )
            ],
          ),
          subtitle: Text(widget.userReserveFacade.reserve.dateAsString +
              " " +
              widget.userReserveFacade.reserve.hour.toString()),
        ),
      ),
    );
  }
}
