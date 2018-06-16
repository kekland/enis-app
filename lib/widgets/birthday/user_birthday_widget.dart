import 'package:enis_new/api/user_birthday_data.dart';
import 'package:flutter/material.dart';

class UserBirthdayWidget extends StatelessWidget {
  final UserBirthdayData data;
  UserBirthdayWidget({this.data});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(data.name + ' ' + data.surname),
            Text(data.birthday.toString()),
          ],
        ),
      ),
    );
  }
}
