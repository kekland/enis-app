import 'package:enis_new/api/user_birthday_data.dart';
import 'package:flutter/material.dart';

class UserBirthdayWidget extends StatelessWidget {
  final UserBirthdayData data;
  UserBirthdayWidget({this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data.surname + ' ' + data.name,
                  style: Theme.of(context).textTheme.body1.copyWith(
                        fontSize: 22.0,
                        fontFamily: 'OpenSans',
                      ),
                ),
                Text(data.role),
              ],
            ),
            Text(birthdayToString()),
          ],
        ),
      ),
    );
  }

  String birthdayToString() {
    return '${data.birthday.day}.${data.birthday.month}.${data.birthday.year}';
  }
}
