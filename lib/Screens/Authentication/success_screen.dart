// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Provider/profile_provider.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../Home/home.dart';
import '../Home/home_screen.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key, required this.email}) : super(key: key);

  final String? email;

  @override
  Widget build(BuildContext context) {
    print('Came on Susees screen');
    return Consumer(builder: (context, ref, _) {
      final userRoleData = ref.watch(businessInfoProvider);
      return userRoleData.when(data: (data) {
        return Scaffold(
          backgroundColor: kWhite,
          resizeToAvoidBottomInset: true,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage('images/success.png')),
              const SizedBox(height: 40.0),
              Text(
                lang.S.of(context).congratulation,
                style: GoogleFonts.poppins(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris cras",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: kGreyTextColor,
                    fontSize: 16.0,
                  ),
                ),
              ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonGlobalWithoutIcon(
                  buttontext: lang.S.of(context).continueButton,
                          buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                          onPressed: () {
                          const Home().launch(context);
                          // Navigator.pushNamed(context, '/home');
                          },
                          buttonTextColor: Colors.white,
                          ),
                )
            ],
          // ),
          // bottomNavigationBar: ButtonGlobalWithoutIcon(
          //   buttontext: lang.S.of(context).continueButton,
          //   buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
          //   onPressed: () {
          //     const Home().launch(context);
          //     // Navigator.pushNamed(context, '/home');
          //   },
          //   buttonTextColor: Colors.white,
          // ),
        ));
      }, error: (e, stack) {
        return Text(e.toString());
      }, loading: () {
        return const Center(child: CircularProgressIndicator());
      });
    });
  }
}
