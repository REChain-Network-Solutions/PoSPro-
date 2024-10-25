// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/SplashScreen/on_board.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:mobile_pos/model/business_info_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Repository/API/business_info_repo.dart';
import '../../currency.dart';
import '../Home/home.dart';
import '../Home/home_screen.dart';
import '../language/language_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String newUpdateVersion = '1.1';

  bool isUpdateAvailable = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  void getPermission() async {
    // ignore: unused_local_variable
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();
  }

  @override
  void initState() {
    super.initState();
    // init();
    getPermission();
    getCurrency();
    nextPage();
    // currentUserData.getUserData();
  }

  getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency') ?? '৳';
    currencyName = prefs.getString('currencyName') ?? 'Bangladeshi Taka';
  }

  // var currentUser = FirebaseAuth.instance.currentUser;

  // bool isis = FirebaseAuth.instance.currentUser

  void setLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String selectedLanguage = prefs.getString('lang') ?? 'English';
    selectedLanguage == 'English'
        ? context.read<LanguageChangeProvider>().changeLocale("en")
        : selectedLanguage == 'Chinese'
            ? context.read<LanguageChangeProvider>().changeLocale("zh")
            : selectedLanguage == 'Hindi'
                ? context.read<LanguageChangeProvider>().changeLocale("hi")
                : selectedLanguage == 'French'
                    ? context.read<LanguageChangeProvider>().changeLocale("fr")
                    : selectedLanguage == 'Spanish'
                        ? context.read<LanguageChangeProvider>().changeLocale("es")
                        : selectedLanguage == 'Japanese'
                            ? context.read<LanguageChangeProvider>().changeLocale("ja")
                            : selectedLanguage == 'Arabic'
                                ? context.read<LanguageChangeProvider>().changeLocale("ar")
                                : selectedLanguage == 'Romanian'
                                    ? context.read<LanguageChangeProvider>().changeLocale("ro")
                                    : selectedLanguage == 'Italian'
                                        ? context.read<LanguageChangeProvider>().changeLocale("it")
                                        : selectedLanguage == 'German'
                                            ? context.read<LanguageChangeProvider>().changeLocale("de")
                                            : selectedLanguage == 'Vietnamese'
                                                ? context.read<LanguageChangeProvider>().changeLocale("vi")
                                                : selectedLanguage == 'Русский'
                                                    ? context.read<LanguageChangeProvider>().changeLocale("ru")
                                                    : selectedLanguage == 'Indonesian'
                                                        ? context.read<LanguageChangeProvider>().changeLocale("id")
                                                        : selectedLanguage == 'Korean'
                                                            ? context.read<LanguageChangeProvider>().changeLocale("ko")
                                                            : selectedLanguage == 'Serbian'
                                                                ? context.read<LanguageChangeProvider>().changeLocale("sr")
                                                                : selectedLanguage == 'Polish'
                                                                    ? context.read<LanguageChangeProvider>().changeLocale("pl")
                                                                    : selectedLanguage == 'Persian'
                                                                        ? context.read<LanguageChangeProvider>().changeLocale("fa")
                                                                        : selectedLanguage == 'Ukrainian'
                                                                            ? context.read<LanguageChangeProvider>().changeLocale("uk")
                                                                            : selectedLanguage == 'Malay'
                                                                                ? context.read<LanguageChangeProvider>().changeLocale("ms")
                                                                                : selectedLanguage == 'Lao'
                                                                                    ? context.read<LanguageChangeProvider>().changeLocale("lo")
                                                                                    : selectedLanguage == 'Turkish'
                                                                                        ? context.read<LanguageChangeProvider>().changeLocale("tr")
                                                                                        : selectedLanguage == 'Portuguese'
                                                                                            ? context.read<LanguageChangeProvider>().changeLocale("pt")
                                                                                            : selectedLanguage == 'Hungarian'
                                                                                                ? context.read<LanguageChangeProvider>().changeLocale("hu")
                                                                                                : selectedLanguage == 'Hebrew'
                                                                                                    ? context.read<LanguageChangeProvider>().changeLocale("he")
                                                                                                    : selectedLanguage == 'Thai'
                                                                                                        ? context.read<LanguageChangeProvider>().changeLocale("th")
                                                                                                        : selectedLanguage == 'Dutch'
                                                                                                            ? context.read<LanguageChangeProvider>().changeLocale("nl")
                                                                                                            : selectedLanguage == 'Finland'
                                                                                                                ? context.read<LanguageChangeProvider>().changeLocale("fi")
                                                                                                                : selectedLanguage == 'Greek'
                                                                                                                    ? context.read<LanguageChangeProvider>().changeLocale("el")
                                                                                                                    : selectedLanguage == 'Khmer'
                                                                                                                        ? context.read<LanguageChangeProvider>().changeLocale("km")
                                                                                                                        : selectedLanguage == 'Bosnian'
                                                                                                                            ? context
                                                                                                                                .read<LanguageChangeProvider>()
                                                                                                                                .changeLocale("bs")
                                                                                                                            : selectedLanguage == 'Bangla'
                                                                                                                                ? context
                                                                                                                                    .read<LanguageChangeProvider>()
                                                                                                                                    .changeLocale("bn")
                                                                                                                                : selectedLanguage == 'Swahili'
                                                                                                                                    ? context
                                                                                                                                        .read<LanguageChangeProvider>()
                                                                                                                                        .changeLocale("sw")
                                                                                                                                    : selectedLanguage == 'Slovak'
                                                                                                                                        ? context
                                                                                                                                            .read<LanguageChangeProvider>()
                                                                                                                                            .changeLocale("sk")
                                                                                                                                        : selectedLanguage == 'Sinhala'
                                                                                                                                            ? context
                                                                                                                                                .read<LanguageChangeProvider>()
                                                                                                                                                .changeLocale("si")
                                                                                                                                            : selectedLanguage == 'Urdu'
                                                                                                                                                ? context
                                                                                                                                                    .read<LanguageChangeProvider>()
                                                                                                                                                    .changeLocale("ur")
                                                                                                                                                : selectedLanguage == 'Kannada'
                                                                                                                                                    ? context
                                                                                                                                                        .read<
                                                                                                                                                            LanguageChangeProvider>()
                                                                                                                                                        .changeLocale("kn")
                                                                                                                                                    : selectedLanguage == 'Marathi'
                                                                                                                                                        ? context
                                                                                                                                                            .read<
                                                                                                                                                                LanguageChangeProvider>()
                                                                                                                                                            .changeLocale("mr")
                                                                                                                                                        : selectedLanguage ==
                                                                                                                                                                'Tamil'
                                                                                                                                                            ? context
                                                                                                                                                                .read<
                                                                                                                                                                    LanguageChangeProvider>()
                                                                                                                                                                .changeLocale("ta")
                                                                                                                                                            : selectedLanguage ==
                                                                                                                                                                    'Afrikans'
                                                                                                                                                                ? context
                                                                                                                                                                    .read<
                                                                                                                                                                        LanguageChangeProvider>()
                                                                                                                                                                    .changeLocale(
                                                                                                                                                                        "af")
                                                                                                                                                                : selectedLanguage ==
                                                                                                                                                                        'Czech'
                                                                                                                                                                    ? context
                                                                                                                                                                        .read<
                                                                                                                                                                            LanguageChangeProvider>()
                                                                                                                                                                        .changeLocale(
                                                                                                                                                                            "cs")
                                                                                                                                                                    : selectedLanguage ==
                                                                                                                                                                            'Swedish'
                                                                                                                                                                        ? context.read<LanguageChangeProvider>().changeLocale("sv")
                                                                                                                                                                        : selectedLanguage == 'Albanian'
                                                                                                                                                                            ? context.read<LanguageChangeProvider>().changeLocale("sq")
                                                                                                                                                                            : selectedLanguage == 'Danish'
                                                                                                                                                                                ? context.read<LanguageChangeProvider>().changeLocale("da")
                                                                                                                                                                                : selectedLanguage == 'Azerbaijani'
                                                                                                                                                                                    ? context.read<LanguageChangeProvider>().changeLocale("az")
                                                                                                                                                                                    : selectedLanguage == 'Kazakh'
                                                                                                                                                                                        ? context.read<LanguageChangeProvider>().changeLocale("kk")
                                                                                                                                                                                        : selectedLanguage == 'Crotian'
                                                                                                                                                                                            ? context.read<LanguageChangeProvider>().changeLocale("hr")
                                                                                                                                                                                            : selectedLanguage == 'Nepali'
                                                                                                                                                                                                ? context.read<LanguageChangeProvider>().changeLocale("ne")
                                                                                                                                                                                                : selectedLanguage == 'Burmese'
                                                                                                                                                                                                    ? context.read<LanguageChangeProvider>().changeLocale("my")
                                                                                                                                                                                                    : context.read<LanguageChangeProvider>().changeLocale("en");
  }

  Future<void> nextPage() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 1));
    if (prefs.getString('token') != null) {
      BusinessInformation? data;
      data = await BusinessRepository().checkBusinessData();
      if (data == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnBoard()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
      }
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnBoard()));
    }
  }

  // void init() async {
  //   setLanguage();
  //   final prefs = await SharedPreferences.getInstance();
  //   isPrintEnable = prefs.getBool('isPrintEnable') ?? true;
  //   final String? skipVersion = prefs.getString('skipVersion');
  //   bool result = await InternetConnectionChecker().hasConnection;
  //   if (result) {
  //     bool isValid = await PurchaseModel().isActiveBuyer();
  //     if (isValid) {
  //       await Future.delayed(const Duration(seconds: 2), () {
  //         if (isUpdateAvailable && (skipVersion == null || skipVersion != newUpdateVersion)) {
  //           showDialog(
  //             context: context,
  //             builder: (BuildContext context) {
  //               return Padding(
  //                 padding: const EdgeInsets.all(30.0),
  //                 child: Center(
  //                   child: Container(
  //                     height: MediaQuery.of(context).size.height / 2,
  //                     width: double.infinity,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.all(Radius.circular(30)),
  //                     ),
  //                     child: Column(
  //                       children: [
  //                         Padding(
  //                           padding: const EdgeInsets.all(20),
  //                           child: Column(
  //                             children: [
  //                               Padding(
  //                                 padding: EdgeInsets.only(top: 20, bottom: 10),
  //                                 child: Text(
  //                                   lang.S.of(context).anewUpdateAvailable,
  //                                   style: TextStyle(
  //                                     fontSize: 20,
  //                                   ),
  //                                 ),
  //                               ),
  //                               const SizedBox(
  //                                 height: 30,
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.all(10.0),
  //                                 child: GestureDetector(
  //                                   onTap: () async {
  //                                     await prefs.remove('skipVersion');
  //                                   },
  //                                   child: Container(
  //                                     height: 50,
  //                                     decoration: const BoxDecoration(
  //                                       color: kMainColor,
  //                                       borderRadius: BorderRadius.all(Radius.circular(20)),
  //                                     ),
  //                                     child: Center(
  //                                         child: Text(
  //                                       lang.S.of(context).updateNow,
  //                                       style: TextStyle(color: Colors.white),
  //                                     )),
  //                                   ),
  //                                 ),
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.all(10.0),
  //                                 child: GestureDetector(
  //                                   onTap: () async {
  //                                     await prefs.setBool('isSkipUpdate', false);
  //                                     await prefs.setString('skipVersion', newUpdateVersion);
  //
  //                                     if (currentUser != null) {
  //                                       const Home().launch(context);
  //                                     } else {
  //                                       const OnBoard().launch(context);
  //                                     }
  //                                   },
  //                                   child: Container(
  //                                     height: 50,
  //                                     decoration: const BoxDecoration(
  //                                       color: kMainColor,
  //                                       borderRadius: BorderRadius.all(Radius.circular(20)),
  //                                     ),
  //                                     child: Center(
  //                                         child: Text(
  //                                       lang.S.of(context).skipTheUpdate,
  //                                       style: TextStyle(color: Colors.white),
  //                                     )),
  //                                   ),
  //                                 ),
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.all(10.0),
  //                                 child: GestureDetector(
  //                                   onTap: () {
  //                                     if (currentUser != null) {
  //                                       const Home().launch(context);
  //                                     } else {
  //                                       const OnBoard().launch(context);
  //                                     }
  //                                   },
  //                                   child: Container(
  //                                     height: 50,
  //                                     decoration: const BoxDecoration(
  //                                       color: kMainColor,
  //                                       borderRadius: BorderRadius.all(Radius.circular(20)),
  //                                     ),
  //                                     child: Center(
  //                                         child: Text(
  //                                       lang.S.of(context).rememberMeLater,
  //                                       style: TextStyle(color: Colors.white),
  //                                     )),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             },
  //           );
  //           // const RedeemConfirmationScreen().launch(context);
  //         } else {
  //           if (currentUser != null) {
  //             const Home().launch(context);
  //           } else {
  //             const OnBoard().launch(context);
  //           }
  //         }
  //       });
  //     } else {
  //       showLicense(context: context);
  //     }
  //   } else {
  //     await Future.delayed(const Duration(seconds: 2), () {
  //       if (isUpdateAvailable && (skipVersion == null || skipVersion != newUpdateVersion)) {
  //         showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return Padding(
  //               padding: const EdgeInsets.all(30.0),
  //               child: Center(
  //                 child: Container(
  //                   height: MediaQuery.of(context).size.height / 2,
  //                   width: double.infinity,
  //                   decoration: const BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.all(Radius.circular(30)),
  //                   ),
  //                   child: Column(
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.all(20),
  //                         child: Column(
  //                           children: [
  //                             Padding(
  //                               padding: EdgeInsets.only(top: 20, bottom: 10),
  //                               child: Text(
  //                                 lang.S.of(context).anewUpdateAvailable,
  //                                 style: TextStyle(
  //                                   fontSize: 20,
  //                                 ),
  //                               ),
  //                             ),
  //                             const SizedBox(
  //                               height: 30,
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.all(10.0),
  //                               child: GestureDetector(
  //                                 onTap: () async {
  //                                   await prefs.remove('skipVersion');
  //                                 },
  //                                 child: Container(
  //                                   height: 50,
  //                                   decoration: const BoxDecoration(
  //                                     color: kMainColor,
  //                                     borderRadius: BorderRadius.all(Radius.circular(20)),
  //                                   ),
  //                                   child: Center(
  //                                       child: Text(
  //                                     lang.S.of(context).updateNow,
  //                                     style: TextStyle(color: Colors.white),
  //                                   )),
  //                                 ),
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.all(10.0),
  //                               child: GestureDetector(
  //                                 onTap: () async {
  //                                   await prefs.setBool('isSkipUpdate', false);
  //                                   await prefs.setString('skipVersion', newUpdateVersion);
  //
  //                                   if (currentUser != null) {
  //                                     const Home().launch(context);
  //                                   } else {
  //                                     const OnBoard().launch(context);
  //                                   }
  //                                 },
  //                                 child: Container(
  //                                   height: 50,
  //                                   decoration: const BoxDecoration(
  //                                     color: kMainColor,
  //                                     borderRadius: BorderRadius.all(Radius.circular(20)),
  //                                   ),
  //                                   child: Center(
  //                                       child: Text(
  //                                     lang.S.of(context).skipTheUpdate,
  //                                     style: TextStyle(color: Colors.white),
  //                                   )),
  //                                 ),
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.all(10.0),
  //                               child: GestureDetector(
  //                                 onTap: () {
  //                                   if (currentUser != null) {
  //                                     const Home().launch(context);
  //                                   } else {
  //                                     const OnBoard().launch(context);
  //                                   }
  //                                 },
  //                                 child: Container(
  //                                   height: 50,
  //                                   decoration: const BoxDecoration(
  //                                     color: kMainColor,
  //                                     borderRadius: BorderRadius.all(Radius.circular(20)),
  //                                   ),
  //                                   child: Center(
  //                                       child: Text(
  //                                     lang.S.of(context).rememberMeLater,
  //                                     style: TextStyle(color: Colors.white),
  //                                   )),
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //         // const RedeemConfirmationScreen().launch(context);
  //       } else {
  //         if (currentUser != null) {
  //           const Home().launch(context);
  //         } else {
  //           const OnBoard().launch(context);
  //         }
  //       }
  //     });
  //   }
  //
  //   defaultBlurRadius = 10.0;
  //   defaultSpreadRadius = 0.5;
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kMainColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              height: 230,
              width: 230,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage(splashLogo))
              ),
            ),
            const Spacer(),
            Column(
              children: [
                Center(
                  child: Text(
                    lang.S.of(context).powerdedByacnoo,
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 20.0),
                  ),
                ),
                Center(
                  child: Text(
                    'V $appVersion',
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 15.0),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
