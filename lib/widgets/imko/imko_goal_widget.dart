import 'package:flutter/material.dart';

class IMKOGoalWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Row(
        children: [
          new Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text('1.0.1'),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Using Fast Fourier Transform algorithm, invented in 1974, to use when processing sounds.'),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    border: Border.all(color: Colors.amber, width: 8.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child:
                      Text('a loooooooooooooong loooooooooooooooooooooooooooooong veryyyyyyyyyyyyyyyyyyyy looooooooooooooong desssssscrrrrripppppptive text'),
                ),
              ],
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}
