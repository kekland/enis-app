import 'package:enis_new/api/user_birthday_data.dart';
import 'package:enis_new/widgets/birthday/user_birthday_widget.dart';
import 'package:flutter/material.dart';

class BirthdayPage extends StatefulWidget {
  @override
  _BirthdayPageState createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Birthdays'),
      ),
      body: Column(
        children: [
          new UserBirthdayWidget(
            data: new UserBirthdayData(
              name: 'name',
              surname: 'surname',
              birthday: new DateTime.utc(2002, 7, 20),
            ),
          ),
        ],
      ),
    );
  }
}
