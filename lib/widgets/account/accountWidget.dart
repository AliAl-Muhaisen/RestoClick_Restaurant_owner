import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/addSpace.dart';

SizedBox ProfilePic({bool isEdit = false}) {
  return SizedBox(
    height: 115,
    width: 115,
    child: Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage("assets/images/avatar.png"),
        ),
        if (isEdit)
          Positioned(
            right: -8,
            bottom: 0,
            child: SizedBox(
              child: TextButton(
                // ignore: prefer_const_constructors
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black45,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.camera_alt, color: Colors.white),
              ),
              height: 46,
              width: 46,
            ),
          ),
      ],
    ),
  );
}

class CardSetting extends StatelessWidget {
  Function onPressed;
  final icon;
  IconData? tailIcon;
  String text;

  CardSetting(
      {Key? key,
      required this.onPressed,
      required this.icon,
      required this.text,
      this.tailIcon = Icons.arrow_forward_ios})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Color(0xFFF5F5F9),
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          onPressed();
        },
        child: Row(
          children: [
            Icon(
              // Icons.manage_accounts_outlined,
              icon,
              color: Colors.red[300],
            ),
            AddHorizontalSpace(20),
            Expanded(
              child: Text(text),
            ),
            Icon(tailIcon),
          ],
        ),
      ),
    );
  }
}

class CardMealMenu extends StatefulWidget {
  Function(bool) onPressed;
  // final icon;
  // IconData? tailIcon;
  String text;

  CardMealMenu({
    Key? key,
    required this.onPressed,
    // required this.icon,
    required this.text,
    // this.tailIcon=Icons.arrow_forward_ios
  }) : super(key: key);

  @override
  State<CardMealMenu> createState() => _CardMealMenuState();
}

class _CardMealMenuState extends State<CardMealMenu> {
  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Color(0xFFF5F5F9),
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          setState(() {
            toggle = !toggle;
          });
        },
        child: Row(
          children: [
            // Icon(
            //   // Icons.manage_accounts_outlined,
            //   icon,
            //   color: Colors.red[300],
            // ),
            AddHorizontalSpace(20),
            Expanded(
              child: Text(
                widget.text,
                style: TextStyle(fontSize: 20),
              ),
            ),
            //  Icon(tailIcon),
            CupertinoSwitch(
              value: toggle,
              thumbColor: CupertinoColors.systemBlue,
              trackColor: CupertinoColors.systemRed.withOpacity(0.14),
              activeColor: CupertinoColors.systemRed.withOpacity(0.64),
              onChanged: (bool? value) {
                // This is called when the user toggles the switch.
                widget.onPressed(value!);
                setState(() {
                  toggle = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
