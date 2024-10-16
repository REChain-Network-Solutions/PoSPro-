import 'package:flutter/material.dart';
import 'package:mobile_pos/Screens/Settings/settings_screen.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.pushNamed(context, '/home');
          break;
        case 1:
          Navigator.pushNamed(context, '/order');
          break;
        case 2:
          Navigator.pushNamed(context, '/featuredProduct');
          break;
        case 3:
          const SettingScreen().launch(context);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 6.0,
      selectedItemColor: kMainColor,
      // ignore: prefer_const_literals_to_create_immutables
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.flare_sharp),
          label: 'Maan',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.backpack),
          label: 'Package',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
