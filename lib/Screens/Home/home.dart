import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';
import 'package:mobile_pos/Screens/DashBoard/dashboard.dart';

import 'package:mobile_pos/Screens/Report/reports.dart';
import 'package:mobile_pos/Screens/Settings/settings_screen.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../Sales/sales_contact.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool isNoInternet = false;

  static const List<Widget> _widgetOptions = <Widget>[DashboardScreen(), SalesContact(), Reports(), SettingScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // void signOutAutoLogin() async {
  //   CurrentUserData currentUserData = CurrentUserData();
  //   if (await currentUserData.isSubUserEmailNotFound() && isSubUser) {
  //     await FirebaseAuth.instance.signOut();
  //     Future.delayed(const Duration(milliseconds: 5000), () async {
  //       EasyLoading.showError('User is deleted');
  //     });
  //     Future.delayed(const Duration(milliseconds: 1000), () async {
  //       Restart.restartApp();
  //     });
  //   }
  // }
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   isSubUser ? signOutAutoLogin() : null;
  // }

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title:  Text(
              lang.S.of(context).areYouSure,
                //'Are you sure?'
            ),
            content: Text(
              lang.S.of(context).doYouWantToExitTheApp,
                //'Do you want to exit the app?'
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child:  Text(
                  lang.S.of(context).no,
                    //'No'
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child:  Text(
                  lang.S.of(context).yes,
                  //  'Yes'
                ),
              ),
            ],
          ),
        );
        return shouldPop ?? false; // Allow default back button behavior if dialog is dismissed
      },
      child: Scaffold(
        // body: Center(
        //   child: _widgetOptions.elementAt(_selectedIndex),
        // ),
        // bottomNavigationBar: BottomNavigationBar(
        //   type: BottomNavigationBarType.fixed,
        //   elevation: 6.0,
        //   backgroundColor: kWhite,
        //   selectedItemColor: kMainColor,
        //   items: [
        //     BottomNavigationBarItem(
        //       icon: const Icon(FeatherIcons.home),
        //       label: lang.S.of(context).home,
        //     ),
        //     BottomNavigationBarItem(
        //       icon: const Icon(FeatherIcons.shoppingCart),
        //       label: lang.S.of(context).sales,
        //     ),
        //     BottomNavigationBarItem(
        //       icon: const Icon(FeatherIcons.fileText),
        //       label: lang.S.of(context).reports,
        //     ),
        //     BottomNavigationBarItem(icon: const Icon(FeatherIcons.settings), label: lang.S.of(context).setting),
        //   ],
        //   currentIndex: _selectedIndex,
        //   onTap: _onItemTapped,
        // ),
        body: PageView(
          controller: pageController,
          onPageChanged: (v) {
            tabIndex = v;
          },
          children: const [
            DashboardScreen(), DashboardScreen(), Reports(), SettingScreen()
          ],
        ),

        bottomNavigationBar: CircleNavBar(
          activeIcons:   [
            SvgPicture.asset('assets/cHome.svg',fit: BoxFit.scaleDown,height: 28,width: 28,),
            SvgPicture.asset('assets/dashbord1.svg',height: 28,width: 28,fit: BoxFit.scaleDown,),
            SvgPicture.asset('assets/cFile.svg',height: 28,width: 28,fit: BoxFit.scaleDown,),
            SvgPicture.asset('assets/cSetting.svg',height: 28,width: 28,fit: BoxFit.scaleDown,),
          ],
          inactiveIcons:  [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/home.svg',height: 24,width: 24,color: kGreyTextColor,),
                 Text(
                   lang.S.of(context).home,
                 //  "Home",
                   style: TextStyle(color: kGreyTextColor),),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/dashbord.svg',height: 24,width: 24,color: kGreyTextColor,),
                 Text(
                   lang.S.of(context).dashboard,
                   //"Dashboard",
                   style: TextStyle(color: kGreyTextColor),),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/file.svg',height: 24,width: 24,color: kGreyTextColor,),
                Text(
                  lang.S.of(context).reports,
                 // "Reports",
                  style: TextStyle(color: kGreyTextColor),),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/setting.svg',height: 24,width: 24,color: kGreyTextColor,),
                Text(
                  lang.S.of(context).setting,
                  //"Setting",
                  style: TextStyle(color: kGreyTextColor),),
              ],
            ),
          ],
          color: Colors.white,
          height: 65,
          circleWidth: 60,
          activeIndex: tabIndex,
          onTap: (index) {
            tabIndex = index;
            pageController.jumpToPage(tabIndex);
          },
          padding:  EdgeInsets.zero,
          cornerRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),

          ),
          shadowColor: kBorderColorTextField,
          elevation: 2,
        ),

      ),
    );
  }
}

