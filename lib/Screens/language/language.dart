import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';
import '../Home/home.dart';
import '../Home/home_screen.dart';
import 'language_provider.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({Key? key}) : super(key: key);

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  List<String> languageList = [
    'English',
    'Chinese',
    'Hindi',
    'French',
    'Spanish',
    'Japanese',
    'Arabic',
    'Romanian',
    'Italian',
    'German',
    'Vietnamese',
    'Русский',
    'Indonesian',
    'Korean',
    'Serbian',
    'Polish',
    'Persian',
    'Ukrainian',
    'Bangla',
    'Malay',
    'Lao',
    'Turkish',
    'Portuguese',
    'Hungarian',
    'Hebrew',
    'Thai',
    'Dutch',
    'Finland',
    'Greek',
    'Khmer',
    'Bosnian',
    'Bangla',
    'Swahili',
    'Slovak',
    'Sinhala',
    'Urdu',
    'Kannada',
    'Marathi',
    'Tamil',
    'Afrikans',
    'Czech',
    'Swedish',
    'Albanian',
    'Danish',
    'Azerbaijani',
    'Kazakh',
    'Crotian',
    'Nepali',
    'Burmese'
  ];

  String selectedLanguage = 'English';

  Future<void> saveData(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ButtonGlobalWithoutIcon(
          buttontext: lang.S.of(context).save,
          buttonDecoration: kButtonDecoration.copyWith(
            color: kMainColor,
            borderRadius: BorderRadius.circular(6.0),
          ),
          onPressed: () {
            setState(
              () async {
                await saveData(selectedLanguage).then(
                  (value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home())),
                );
              },
            );
          },
          buttonTextColor: Colors.white),
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: kWhite,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            FeatherIcons.x,
            color: kTitleColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          lang.S.of(context).selectLang,
          style: const TextStyle(color: kTitleColor),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
              itemCount: languageList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return StatefulBuilder(
                  builder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            selectedLanguage = languageList[index];
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
                                                                                                                            ? context
                                                                                                                                .read<LanguageChangeProvider>()
                                                                                                                                .changeLocale("he")
                                                                                                                            : selectedLanguage == 'Thai'
                                                                                                                                ? context
                                                                                                                                    .read<LanguageChangeProvider>()
                                                                                                                                    .changeLocale("th")
                                                                                                                                : selectedLanguage == 'Dutch'
                                                                                                                                    ? context
                                                                                                                                        .read<LanguageChangeProvider>()
                                                                                                                                        .changeLocale("nl")
                                                                                                                                    : selectedLanguage == 'Finland'
                                                                                                                                        ? context
                                                                                                                                            .read<LanguageChangeProvider>()
                                                                                                                                            .changeLocale("fi")
                                                                                                                                        : selectedLanguage == 'Greek'
                                                                                                                                            ? context
                                                                                                                                                .read<LanguageChangeProvider>()
                                                                                                                                                .changeLocale("el")
                                                                                                                                            : selectedLanguage == 'Khmer'
                                                                                                                                                ? context
                                                                                                                                                    .read<LanguageChangeProvider>()
                                                                                                                                                    .changeLocale("km")
                                                                                                                                                : selectedLanguage == 'Bosnian'
                                                                                                                                                    ? context
                                                                                                                                                        .read<
                                                                                                                                                            LanguageChangeProvider>()
                                                                                                                                                        .changeLocale("bs")
                                                                                                                                                    : selectedLanguage == 'Bangla'
                                                                                                                                                        ? context
                                                                                                                                                            .read<
                                                                                                                                                                LanguageChangeProvider>()
                                                                                                                                                            .changeLocale("bn")
                                                                                                                                                        : selectedLanguage ==
                                                                                                                                                                'Swahili'
                                                                                                                                                            ? context
                                                                                                                                                                .read<
                                                                                                                                                                    LanguageChangeProvider>()
                                                                                                                                                                .changeLocale("sw")
                                                                                                                                                            : selectedLanguage ==
                                                                                                                                                                    'Slovak'
                                                                                                                                                                ? context
                                                                                                                                                                    .read<
                                                                                                                                                                        LanguageChangeProvider>()
                                                                                                                                                                    .changeLocale(
                                                                                                                                                                        "sk")
                                                                                                                                                                : selectedLanguage ==
                                                                                                                                                                        'Sinhala'
                                                                                                                                                                    ? context
                                                                                                                                                                        .read<
                                                                                                                                                                            LanguageChangeProvider>()
                                                                                                                                                                        .changeLocale(
                                                                                                                                                                            "si")
                                                                                                                                                                    : selectedLanguage ==
                                                                                                                                                                            'Urdu'
                                                                                                                                                                        ? context.read<LanguageChangeProvider>().changeLocale("ur")
                                                                                                                                                                        : selectedLanguage == 'Kannada'
                                                                                                                                                                            ? context.read<LanguageChangeProvider>().changeLocale("kn")
                                                                                                                                                                            : selectedLanguage == 'Marathi'
                                                                                                                                                                                ? context.read<LanguageChangeProvider>().changeLocale("mr")
                                                                                                                                                                                : selectedLanguage == 'Tamil'
                                                                                                                                                                                    ? context.read<LanguageChangeProvider>().changeLocale("ta")
                                                                                                                                                                                    : selectedLanguage == 'Afrikans'
                                                                                                                                                                                        ? context.read<LanguageChangeProvider>().changeLocale("af")
                                                                                                                                                                                        : selectedLanguage == 'Czech'
                                                                                                                                                                                            ? context.read<LanguageChangeProvider>().changeLocale("cs")
                                                                                                                                                                                            : selectedLanguage == 'Swedish'
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
                          });
                        },
                        contentPadding: const EdgeInsets.only(left: 10, right: 10.0),
                        horizontalTitleGap: 10,
                        title: Text(languageList[index]),
                        trailing: Icon(
                          selectedLanguage == languageList[index] ? Icons.radio_button_checked_outlined : Icons.circle_outlined,
                          color: selectedLanguage == languageList[index] ? kMainColor : Colors.grey,
                        ),
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
