// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../themes/stander/colors.dart';

class DropDownListForm extends StatefulWidget {
  Function(String) onSave;
  List<String> listItem;
  String title;
  String errorMessage;
  Color buttonColor;
  double paddingButtonHorizontal;
  bool useValidation;
  DropDownListForm({
    Key? key,
    required this.onSave,
    required this.listItem,
    required this.title,
    required this.errorMessage,
    this.buttonColor = cardBackground,
    this.paddingButtonHorizontal = 20,
    this.useValidation = true,
  }) : super(key: key);

  @override
  State<DropDownListForm> createState() => _DropDownListFormState();
}

class _DropDownListFormState extends State<DropDownListForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.paddingButtonHorizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButtonFormField2(
            dropdownPadding: const EdgeInsets.all(10),
            decoration: InputDecoration(
              //Add isDense true and zero Padding.
              //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.

              isDense: true,
              contentPadding: EdgeInsets.zero,
              fillColor: Color.fromARGB(255, 0, 0, 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              //Add more decoration as you want here
              //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
            ),
            buttonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Color.fromARGB(22, 29, 27, 27),
              ),
              color: widget.buttonColor,
            ),
            dropdownMaxHeight: 300,
            scrollbarRadius: const Radius.circular(40),
            scrollbarThickness: 6,
            scrollbarAlwaysShow: true,
            isExpanded: true,
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                widget.title,
                style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 32, 32, 32),
                    fontWeight: FontWeight.w400),
              ),
            ),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.black45,
            ),
            iconSize: 30,
            dropdownElevation: 30,
            buttonHeight: 70,
            buttonPadding: const EdgeInsets.symmetric(horizontal: 5),
            dropdownDecoration: BoxDecoration(
              color: const Color.fromARGB(255, 253, 250, 250),
              borderRadius: BorderRadius.circular(15),
            ),
            items: widget.listItem
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            validator: (value) {
              if (!widget.useValidation) {
                return null;
              }

              if (value == null) {
                return widget.errorMessage;
              }
            },
            onChanged: (value) {},
            onSaved: (value) {
              widget.onSave(value.toString());
            },
          ),
        ],
      ),
    );
  }
}
