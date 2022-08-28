import 'package:flutter/material.dart';

const double borderRad4LogSignGuest = 60;
 ButtonStyle loginSignButtonStyle({backColor, frontColor, radius}) {
  //  
  if(radius !=null)
  {
    radius=radius.toDouble();
  }
  return ElevatedButton.styleFrom(
    primary: backColor ??Colors.black,
    onPrimary: frontColor ?? Colors.white,
    side:
        const BorderSide(color: Colors.red, width: 2, style: BorderStyle.solid),
    shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(radius ?? borderRad4LogSignGuest)),
    textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    shadowColor: Color.fromARGB(255, 14, 13, 13),
    elevation: 10,
  );
}

final ButtonStyle guestButtonStyle = ElevatedButton.styleFrom(
  primary: Color.fromARGB(255, 255, 0, 0),
  onPrimary: Colors.white,
  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRad4LogSignGuest)),
  textStyle: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
);

// final textInputDecoration = InputDecoration(
//   label: Text(widget.label),
//   hintText: widget.hintText,
//   // errorText:
//   //     isEmail ? 'Do not use the @ char.' : 'null',
//   border: OutlineInputBorder(),
//   prefixIcon: Icon(widget.inputIcon),
//   suffixIcon: inputController.text.isNotEmpty
//       ? IconButton(
//           color: Colors.red,
//           icon: Icon(Icons.close),
//           onPressed: () {
//             inputController.clear();
//           },
//         )
//       : null,
// );
