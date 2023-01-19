import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant_owner_app/models/userReserveFacade.dart';
import 'package:restaurant_owner_app/widgets/utils/addSpace.dart';

import '../../widgets/loadingSpin.dart';
import '../../widgets/utils/showDialog.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.chat)),
                Tab(icon: Icon(Icons.report)),
              ],
            ),
            title: const Text('Feedback'),
          ),
          body: const TabBarView(
            children: [
              Comment(),
              Report(),
            ],
          ),
        ),
      ),
    );
  }
}

class Comment extends StatelessWidget {
  const Comment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await UserReserveFacade.feedbackWithUser(isRefresh: true);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AddVerticalSpace(15),
              FutureBuilder(
                future: UserReserveFacade.feedbackWithUser(),
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
                            "You did not have any comment yet",
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
                      child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          scrollDirection: Axis.vertical,
                          itemCount: result.length,
                          itemBuilder: (context, index) {
                            return SingleChildScrollView(
                              child: InkWell(
                                onTap: () {
                                  if (result[index].feedback!.isUserReported) {
                                    showAddSuggestionDialog(
                                      context: context,
                                      id: result[index].feedback!.id!,
                                      userId: result[index].feedback!.userId!,
                                    );
                                  } else {
                                    final snackBar = SnackBar(
                                      content: const Text(
                                        "your report this before",
                                      ),
                                      action: SnackBarAction(
                                        label: "Hide",
                                        onPressed: () {
                                          // Some code to undo the change.
                                        },
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: FeedbackCardItem(
                                  imageUrl: result[index].user.imageProfile,
                                  userName: result[index].user.name,
                                  text: result[index].feedback!.text!,
                                  rateWidget: RatingBarIndicator(
                                    rating: result[index].feedback?.rate ?? 0,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    unratedColor: Colors.amber.withAlpha(100),
                                    direction: Axis.horizontal,
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  }

                  return const Center(
                    child: Text(
                      "Something went wrong please check your internet connection",
                    ),
                  );
                },
              ),
              AddVerticalSpace(100),
            ],
          ),
        ),
      ),
    );
  }
}

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await UserReserveFacade.reportWithUser(isRefresh: true);
            return Future(() {
              setState(() {});
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AddVerticalSpace(15),
              FutureBuilder(
                future: UserReserveFacade.reportWithUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: spinKitLoading());
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<UserReserveFacade> result =
                        snapshot.data as List<UserReserveFacade>;
                    log(result.toString());
                    if (!snapshot.hasData || result.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "You did not have any report yet",
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
                      child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          scrollDirection: Axis.vertical,
                          itemCount: result.length,
                          itemBuilder: (context, index) {
                            return SingleChildScrollView(
                              child: FeedbackCardItem(
                                imageUrl: result[index].user.imageProfile,
                                userName: result[index].user.name,
                                text: result[index].feedback!.text!,
                              ),
                            );
                          }),
                    );
                  }

                  return const Center(
                    child: Text(
                      "Something went wrong please check your internet connection",
                    ),
                  );
                },
              ),
              AddVerticalSpace(100),
            ],
          ),
        ),
      ),
    );
  }
}

class FeedbackCardItem extends StatelessWidget {
  final String? imageUrl;
  final String userName;
  final String text;
  final Widget? rateWidget;
  const FeedbackCardItem({
    Key? key,
    this.imageUrl,
    required this.userName,
    required this.text,
    this.rateWidget,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: (imageUrl?.isNotEmpty ?? false)
          ? CircleAvatar(
              backgroundImage: NetworkImage(imageUrl!),
              backgroundColor: const Color.fromARGB(0, 255, 255, 255),
            )
          : const Image(image: AssetImage('assets/images/avatar.png')),
      title: Text(userName),
      subtitle: Text(text),
      trailing: rateWidget ?? const Text(''),
    );
  }
}
