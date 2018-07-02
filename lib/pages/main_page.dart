import 'package:enis_new/pages/grades_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

var navBarIcons = [
  {'icon': Icons.assignment, 'text': 'Grades'},
  {'icon': Icons.assessment, 'text': 'Calculator'},
  {'icon': Icons.settings, 'text': 'Settings'},
];

var pages = [
  GradesPage(),
  Container(color: Colors.red),
  Container(color: Colors.green),
];

var terms = ['1 term', '2 term', '3 term', '4 term'];
var tabBar = [
  TabBar(
      tabs: terms.map((var term) {
    return Tab(child: Text(term, style: TextStyle(color: Colors.black)));
  }).toList()),
  null,
  null,
];

class _MainPageState extends State<MainPage> {
  int selectedPageIndex = 0;
  Function fabPressed;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: (tabBar[selectedPageIndex] != null) ? tabBar[selectedPageIndex].tabs.length : 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('eNIS', style: Theme.of(context).textTheme.title.copyWith(fontFamily: 'Futura', color: Colors.black)),
          bottom: tabBar[selectedPageIndex],
        ),
        body: pages[selectedPageIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedPageIndex,
          fixedColor: Colors.black,
          onTap: (pageIndex) => setState(() {
                selectedPageIndex = pageIndex;
              }),
          items: navBarIcons.map((var item) {
            return BottomNavigationBarItem(icon: Icon(item['icon']), title: Text(item['text']));
          }).toList(),
        ),
      ),
    );
  }
}
