
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Const/api_config.dart';
import 'package:mobile_pos/Screens/DashBoard/dashboard.dart';
import 'package:mobile_pos/Screens/Profile%20Screen/profile_details.dart';
import 'package:mobile_pos/Screens/User%20Roles/user_role_screen.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/profile_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/business_info_model.dart';
import '../Authentication/Repo/logout_repo.dart';
import '../Currency/currency_screen.dart';
import '../Shimmers/home_screen_appbar_shimmer.dart';
import '../language/language.dart';
import '../subscription/package_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? dropdownValue = '\$ (US Dollar)';
  bool expanded = false;
  bool expandedHelp = false;
  bool expandedAbout = false;
  bool selected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    printerIsEnable();
    getCurrency();
  }

  getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('currency');

    if (!data.isEmptyOrNull) {
      for (var element in items) {
        if (element.substring(0, 2).contains(data!)) {
          setState(() {
            dropdownValue = element;
          });
          break;
        }
      }
    } else {
      setState(() {
        dropdownValue = items[0];
      });
    }
  }

  void printerIsEnable() async {
    final prefs = await SharedPreferences.getInstance();

    isPrintEnable = prefs.getBool('isPrintEnable') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(builder: (context, ref, _) {
        AsyncValue<BusinessInformation> businessInfo = ref.watch(businessInfoProvider);
        return Scaffold(
          backgroundColor: kWhite,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 0.0,
                  color: kWhite,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: businessInfo.when(data: (details) {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              const ProfileDetails().launch(context);
                            },
                            child: Container(
                              height: 42,
                              width: 42,
                              decoration: BoxDecoration(
                                image: details.pictureUrl == null
                                    ? const DecorationImage(image: AssetImage('images/no_shop_image.png'), fit: BoxFit.cover)
                                    : DecorationImage(image: NetworkImage(APIConfig.domain + details.pictureUrl.toString()), fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                details.user?.role == 'staff' ? '${details.companyName ?? ''} [${details.user?.name ?? ''}]' : details.companyName ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                details.category?.name ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  color: kGreyTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }, error: (e, stack) {
                      return Text(e.toString());
                    }, loading: () {
                      return const HomeScreenAppBarShimmer();
                    }),
                  ),
                ),
                ListTile(
                  title: Text(
                    lang.S.of(context).profile,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () {
                    const ProfileDetails().launch(context);
                  },
                  leading: SvgPicture.asset('assets/profile.svg',height: 36,width: 36,),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: kGreyTextColor,
                    size: 20,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    thickness: 1.0,
                    height: 1,
                    color: kBorderColorTextField,
                  ),
                ),
                ListTile(
                  title: Text(
                    lang.S.of(context).printing,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  leading: SvgPicture.asset('assets/print.svg',height: 36,width: 36,),
                  trailing: Transform.scale(
                    scale: 0.7,
                    child: SizedBox(
                      height: 22,
                      width: 40,
                      child: Switch.adaptive(
                        value: isPrintEnable,
                        onChanged: (bool value) async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('isPrintEnable', value);
                          setState(() {
                            isPrintEnable = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    thickness: 1.0,
                    height: 1,
                    color: kBorderColorTextField,
                  ),
                ),

                ///_________subscription_____________________________________________________
                ListTile(
                  title: Text(
                    lang.S.of(context).subscription,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () {
                    const PackageScreen().launch(context);
                  },
                  leading: SvgPicture.asset('assets/subscription.svg',height: 36,width: 36,),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: kGreyTextColor,
                    size: 18,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    thickness: 1.0,
                    height: 1,
                    color: kBorderColorTextField,
                  ),
                ),

                ///_________DashBoard_____________________________________________________
                ListTile(
                  title: Text(
                    lang.S.of(context).dashboard,
                   // 'Dashboard',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () {
                    const DashboardScreen().launch(context);
                  },
                  leading: SvgPicture.asset('assets/dashboard.svg',height: 36,width: 36,),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: kGreyTextColor,
                    size: 18,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    thickness: 1.0,
                    height: 1,
                    color: kBorderColorTextField,
                  ),
                ),

                ///___________user_role___________________________________________________________
                ListTile(
                  title: Text(
                    lang.S.of(context).userRole,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () {
                    const UserRoleScreen().launch(context);
                  },
                  leading: SvgPicture.asset('assets/userRole.svg',height: 36,width: 36,),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: kGreyTextColor,
                    size: 18,
                  ),
                ).visible(businessInfo.value?.user?.role != 'staff'),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    thickness: 1.0,
                    height: 1,
                    color: kBorderColorTextField,
                  ),
                ),

                ///____________Currency________________________________________________
                ListTile(
                  onTap: () async {
                    await const CurrencyScreen().launch(context);
                    setState(() {});
                  },
                  title: Text(
                    lang.S.of(context).currency,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  leading: SvgPicture.asset('assets/currency.svg',height: 36,width: 36,),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '($currency)',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      const Icon(Icons.arrow_forward_ios,color: kGreyTextColor,size: 18,),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    thickness: 1.0,
                    height: 1,
                    color: kBorderColorTextField,
                  ),
                ),

                ///_____________________________________________________________________________language
                ListTile(
                  title: Text(
                    lang.S.of(context).selectLang,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectLanguage(),
                    ),
                  ),
                  leading: SvgPicture.asset('assets/language.svg',height: 36,width: 36,),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: kGreyTextColor,
                    size: 18,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    thickness: 1.0,
                    height: 1,
                    color: kBorderColorTextField,
                  ),
                ),

                ///__________log_Out_______________________________________________________________
                ListTile(
                  title: Text(
                    lang.S.of(context).logOut,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () async {
                    ref.invalidate(businessInfoProvider);
                    EasyLoading.show(status:
                        lang.S.of(context).logOut,
                    //'Log out'
                    );
                    LogOutRepo repo = LogOutRepo();
                    await repo.signOutApi(context: context, ref: ref);
                  },
                  leading: SvgPicture.asset('assets/logout.svg',height: 36,width: 36,),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: kGreyTextColor,
                    size: 18,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    thickness: 1.0,
                    height: 1,
                    color: kBorderColorTextField,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'POSPro V-$appVersion',
                        style: GoogleFonts.poppins(
                          color: kGreyTextColor,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class NoticationSettings extends StatefulWidget {
  const NoticationSettings({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NoticationSettingsState createState() => _NoticationSettingsState();
}

class _NoticationSettingsState extends State<NoticationSettings> {
  bool notify = false;
  String notificationText = 'Off';

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 350.0,
      width: MediaQuery.of(context).size.width - 80,
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              IconButton(
                color: kGreyTextColor,
                icon: const Icon(Icons.cancel_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              color: kDarkWhite,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Center(
              child: Icon(
                Icons.notifications_none_outlined,
                size: 50.0,
                color: kMainColor,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Center(
            child: Text(
              lang.S.of(context).doNotDisturb,
              //'Do Not Disturb',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                lang.S.of(context).loremIpsumDolorSitAmetConsecteturElitInterdumCons,
                //'Lorem ipsum dolor sit amet, consectetur elit. Interdum cons.',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: kGreyTextColor,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                notificationText,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
              Switch(
                value: notify,
                onChanged: (val) {
                  setState(() {
                    notify = val;
                    val ? notificationText = '${lang.S.of(context).on}' : notificationText = '${lang.S.of(context).off}';
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
