import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  static const routeName='/Menu';
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Hiiiiiiiiiiiiiii")),
    );
  }
}
