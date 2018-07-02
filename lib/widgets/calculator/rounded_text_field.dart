import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function onDecrementPressed;
  final Function onIncrementPressed;
  RoundedTextField({
    this.label,
    this.controller,
    this.onDecrementPressed,
    this.onIncrementPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(100.0),
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: onDecrementPressed != null
              ? IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: onDecrementPressed,
                )
              : null,
          suffixIcon: onIncrementPressed != null
              ? IconButton(
                  icon: Icon(Icons.add),
                  onPressed: onIncrementPressed,
                )
              : null,
          contentPadding: EdgeInsets.only(
            left: (onDecrementPressed != null) ? 4.0 : 18.0,
            right: (onIncrementPressed != null) ? 4.0 : 18.0,
            top: 12.0,
            bottom: 12.0,
          ),
          isDense: true,
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
