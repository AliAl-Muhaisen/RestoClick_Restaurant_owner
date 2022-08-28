import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputFormField extends StatefulWidget {
  // const InputFormField({Key? key}) : super(key: key);
  // var inputController = TextEditingController(text: null);
  TextEditingController? inputController;
  final keyBoardType;
  final inputIcon;
  final label;
  final hintText;
  bool isValid = false;
  bool? isEnable;
  String? initialValue;
  final String? Function(String) validator;
  final Function(String) onSaved;
  // ignore: use_key_in_widget_constructors
  InputFormField({
    this.keyBoardType,
    this.inputIcon,
    this.label,
    this.hintText,
    required this.validator,
    required this.onSaved,
    this.initialValue,
    this.isEnable=true,
  });

  @override
  State<InputFormField> createState() => _InputFormFieldState();
}

class _InputFormFieldState extends State<InputFormField> {
  var changeIconColor = null;
  // final inputController = Numbe();

  // _InputFormFieldState(this.keyBoardType);
  @override
  void initState() {
    super.initState();
    widget.inputController = TextEditingController(text: widget.initialValue);

    widget.inputController!.addListener(
      () => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.keyBoardType);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        enabled: widget.isEnable,
        enableSuggestions: true,
        validator: (value) {
          String? verify = widget.validator(value!);
          print('verify $verify');

          if (verify != null) {
            setState(() {
              changeIconColor = Colors.red;
            });
            return verify;
          } else {
            setState(() {
              changeIconColor = null;
            });
            return null;
          }
        },

        onSaved: (value) {
          print('saved');
          widget.onSaved(value!);
        },

        controller: widget.inputController,
        onChanged: (String? value) {
          // widget.isValid = !widget.isValid;
          // print('\n\n');
          // print('widget.isValid ${widget.inputController.value.text}');
          // print('\n\n');
        },
        decoration: InputDecoration(
          label: Text(widget.label),
          hintText: widget.hintText,
          filled: true,

          fillColor: Colors.white,
          focusedBorder: UnderlineInputBorder(
            borderSide:const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide:const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),

          // errorText:
          //     isEmail ? 'Do not use the @ char.' : 'null',
          border:const UnderlineInputBorder(), //OutlineInputBorder(),
          prefixIcon: Icon(
            widget.inputIcon,
            color: changeIconColor,
          ),
          suffixIcon: widget.inputController!.text.isNotEmpty
              ? IconButton(
                  color: Colors.red,
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    widget.inputController!.clear();
                  },
                )
              : null,
        ),
        // validator: (String? value) =>stateOfIsEmail(value),
        keyboardType: widget.keyBoardType,
      ),
    );
  }
}
