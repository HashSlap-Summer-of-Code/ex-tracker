import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:trackerop/Homepage.dart';



class NewhomePage extends StatefulWidget {
  const NewhomePage({super.key});

  @override
  State<NewhomePage> createState() => _NewhomePageState();
}

class _NewhomePageState extends State<NewhomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          // XYX(),
          Homepage(), // Attach Homepage to Money
          // taskk(), // Attach taskk to Tasks
      

        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 10,
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            padding: EdgeInsets.all(16),
            tabs: const [
                GButton(
                icon: Icons.attach_money_sharp,
                text: "money",
              ),
             
              GButton(
                icon: Icons.settings,
                text: "settings",
              )
            ],
          ),
        ),
      ),
    );
  }
}
