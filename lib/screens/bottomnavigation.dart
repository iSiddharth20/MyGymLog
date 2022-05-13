import 'package:flutter/material.dart';
import 'package:mygymlog/screens/addworkout.dart';
import 'package:mygymlog/screens/logworkout.dart';
import 'package:mygymlog/screens/seestatistics.dart';

class Bottomnavigation extends StatefulWidget {
  Bottomnavigation({Key? key}) : super(key: key);

  @override
  _BottomnavigationState createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    LogWorkout(),
    SeeStatistics(),
    AddWorkout()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    // This dialog will exit your app on saying yes
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books_outlined),
              label: 'Log Workout',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books_outlined),
              label: 'See Statistics',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Add Workout',
                backgroundColor: Colors.green),
            
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}