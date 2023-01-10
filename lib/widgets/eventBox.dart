import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:restaurant_owner_app/widgets/utils/addSpace.dart';

class EventBox extends StatefulWidget {
  final List<String> selectedItem;
  final List<String> saveNewItem;
  final List<String> items;
  final void Function(List<String>) onSave;

  EventBox({
    Key? key,
    required this.selectedItem,
    required this.saveNewItem,
    required this.onSave,
    required this.items,
  }) : super(key: key);

  @override
  State<EventBox> createState() => _EventBoxState();
}

class _EventBoxState extends State<EventBox> {
  List<String> _selectedItem = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedItem = widget.selectedItem.toList();
  }

  // @override
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          AddVerticalSpace(10),
          const Center(
            child: Text(
              "Add Category",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          AddVerticalSpace(15),
          GroupButton(
            options: GroupButtonOptions(
              elevation: 3,
              borderRadius: BorderRadius.circular(10),
              buttonHeight: 55,
              // buttonWidth: 55,
              mainGroupAlignment: MainGroupAlignment.center,
              selectedColor: Colors.blue,
              unselectedColor: Colors.orange,
            ),
            isRadio: false,
            enableDeselect: true,
            onSelected: (value, index, isSelected, {onSelected}) {
              if (_selectedItem.contains(value.toString())) {
                isSelected = false;

                _selectedItem.remove(value.toString());

                setState(() {});
              } else {
                _selectedItem.add(value.toString());
              }
            },
            buttonBuilder: (selected, data, context) {
              if (_selectedItem.contains(data.toString())) {
                selected = true;
              }
              return CategoryCard(
                data: data.toString(),
                isSelected: selected,
              );
            },
            buttons: const [
              "Family",
              "Friends",
              "Couples",
              "Birth Day",
              "19:00",
              "21:40"
            ],
          ),
          AddVerticalSpace(10),
          SizedBox(
            width: 180,
            child: OutlinedButton.icon(
              onPressed: () {
                try {
                  widget.onSave(_selectedItem);
                } catch (e) {}
              },
              icon: const Icon(Icons.save),
              label: const Text(
                "Save",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          AddVerticalSpace(10),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String data;
  final bool isSelected;
  // final bool? isPreviousSelected;
  const CategoryCard({
    Key? key,
    required this.data,
    required this.isSelected,
    // this.isPreviousSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSelected ? Colors.blue[300] : Colors.amber,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: SizedBox(
        height: 70,
        width: 75,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              data.toString(),
              style: TextStyle(
                fontSize: 15,
                // fontWeight: FontWeight.w40,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
