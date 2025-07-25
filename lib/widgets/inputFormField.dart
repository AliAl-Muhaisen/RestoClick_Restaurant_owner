import 'package:flutter/material.dart';

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
  final bool obscureText;
  // ignore: use_key_in_widget_constructors

  //?border
  double focusedBorderRadius;
  double enabledBorderRadius;
  InputFormField({
    this.keyBoardType,
    this.inputIcon,
    this.label,
    this.hintText,
    required this.validator,
    required this.onSaved,
    this.initialValue,
    this.isEnable = true,
    this.focusedBorderRadius = 25.7,
    this.enabledBorderRadius = 25.7,
    this.obscureText = false,
  });

  @override
  State<InputFormField> createState() => _InputFormFieldState();
}

class _InputFormFieldState extends State<InputFormField> {
  var changeIconColor = null;

  @override
  void initState() {
    super.initState();
    widget.inputController = TextEditingController(text: widget.initialValue);

    widget.inputController!.addListener(
      () => setState(() {}),
    );
  }

  @override
  void dispose() {
    widget.inputController!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        obscureText: widget.obscureText,
        enabled: widget.isEnable,
        enableSuggestions: true,
        validator: (value) {
          String? verify = widget.validator(value!);

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
          widget.onSaved(value!);
        },
        controller: widget.inputController,
        onChanged: (String? value) {},
        decoration: InputDecoration(
          label: Text(widget.label),
          hintText: widget.hintText,
          filled: true,

          fillColor: Colors.white,
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(widget.focusedBorderRadius),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(widget.enabledBorderRadius),
          ),

          border: const UnderlineInputBorder(), //OutlineInputBorder(),
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
        keyboardType: widget.keyBoardType,
      ),
    );
  }
}
