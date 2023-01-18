import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:restaurant_owner_app/widgets/utils/addSpace.dart';

class EventBox extends StatefulWidget {
  final List<String> selectedItem;
  final void Function(List<String>) onSave;
  final List<String> buttonsData;
  EventBox({
    Key? key,
    required this.selectedItem,
    required this.onSave,
    required this.buttonsData,
  }) : super(key: key);

  @override
  State<EventBox> createState() => _EventBoxState();
}

class _EventBoxState extends State<EventBox> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            onSelected: (
              value,
              index,
              isSelected,
            ) {
              if (widget.selectedItem.contains(value.toString())) {
                log('if $value $isSelected $index');

                setState(() {
                  widget.selectedItem.remove(value.toString());
                  isSelected = false;
                });
              } else {
                setState(() {
                  widget.selectedItem.add(value.toString());
                });
              }
              log(widget.selectedItem.toString());
            },
            buttonBuilder: (selected, data, context) {
              if (widget.selectedItem.contains(data.toString())) {
                // log('if $data $selected');
                selected = true;
              }
              // log('else  if $data $selected');

              return CategoryCard(
                data: data.toString(),
                isSelected: selected,
              );
            },
            buttons: widget.buttonsData,
          ),
          AddVerticalSpace(10),
          SizedBox(
            width: 180,
            child: OutlinedButton.icon(
              onPressed: () {
                try {
                  widget.onSave(widget.selectedItem);
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

class CategoryCard extends StatefulWidget {
  final String data;
  bool isSelected;
  // final bool? isPreviousSelected;
  CategoryCard({
    Key? key,
    required this.data,
    required this.isSelected,
    // this.isPreviousSelected,
  }) : super(key: key);

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    log("${widget.isSelected}");

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.isSelected ? Colors.blue[300] : Colors.amber,
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
              widget.data.toString(),
              style: TextStyle(
                fontSize: 15,
                // fontWeight: FontWeight.w40,
                color: widget.isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
