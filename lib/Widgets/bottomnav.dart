import 'package:orlogo/Screens/Addexpense.dart';
import 'package:orlogo/Screens/CardDetails.dart';
import 'package:orlogo/Screens/Dashboard.dart';
import 'package:orlogo/Screens/Detail.dart';
import 'package:orlogo/Screens/MainPage.dart';
import 'package:flutter/material.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int index_color = 0;
  List Screen = [
    Mainpage(),
    CardDetailsPage(),
    CardDetailsPage(),
    DashboardPage(),
    AddExpensePage(),
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Screen[index_color],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            index_color = 4;
          });
        },
        backgroundColor: const Color(0xff368983),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top: 7.5, bottom: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  size: 30,
                  color:
                      index_color == 0 ? const Color(0xff368983) : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 1;
                  });
                },
                child: Icon(Icons.bar_chart_outlined,
                    size: 30,
                    color: index_color == 1
                        ? const Color(0xff368983)
                        : Colors.grey),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 2;
                  });
                },
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 30,
                  color:
                      index_color == 2 ? const Color(0xff368983) : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 3;
                  });
                },
                child: Icon(
                  Icons.person_outlined,
                  size: 30,
                  color:
                      index_color == 3 ? const Color(0xff368983) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
