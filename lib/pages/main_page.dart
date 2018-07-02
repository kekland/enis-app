import 'package:enis_new/pages/calculator_page.dart';
import 'package:enis_new/pages/grades_page.dart';
import 'package:enis_new/pages/settings_page.dart';
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
  CalculatorPage(),
  SettingsPage(),
];

var gradeTabs = ['1 term', '2 term', '3 term', '4 term'];
var calculatorTabs = ['IMKO Term', 'JKO Term', 'IMKO Year', 'JKO Year'];
var tabBar = [
  TabBar(
      tabs: gradeTabs.map((var term) {
    return Tab(child: Text(term));
  }).toList()),
  TabBar(
    tabs: calculatorTabs.map((var term) {
      return Tab(child: Text(term));
    }).toList(),
  ),
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
          title: Text('eNIS', style: Theme.of(context).textTheme.title.copyWith(fontFamily: 'Futura')),
          bottom: tabBar[selectedPageIndex],
        ),
        body: pages[selectedPageIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedPageIndex,
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
