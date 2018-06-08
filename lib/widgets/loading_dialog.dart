import 'package:flutter/material.dart';

class LoadingDialogWidget extends StatelessWidget {
  final String description;
  LoadingDialogWidget(this.description);
  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: Text(description),
      content: Row(
        children: [
          CircularProgressIndicator(),
          new Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text('Please, wait'),
          ),
        ],
      ),
    );
  }
}
