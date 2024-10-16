
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool showProgress = false;
  late String email;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  lang.S.of(context).forgotPassword,
                  style: GoogleFonts.poppins(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    lang.S.of(context).enterEmail,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: kGreyTextColor,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppTextField(
                    textFieldType: TextFieldType.EMAIL,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: lang.S.of(context).email,
                        border: const OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'example@example.com'),
                  ),
                ),
                ButtonGlobalWithoutIcon(
                    buttontext: lang.S.of(context).sendLink,
                    buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                    onPressed: (){},
                    // onPressed: () async {
                    //   setState(() {
                    //     showProgress = true;
                    //   });
                    //   try {
                    //     await FirebaseAuth.instance.sendPasswordResetEmail(
                    //       email: email,
                    //     );
                    //     // ScaffoldMessenger.of(context).showSnackBar(
                    //     //   const SnackBar(
                    //     //     content: Text('Check your Inbox'),
                    //     //     duration: Duration(seconds: 3),
                    //     //   ),
                    //     // );
                    //     if (!mounted) return;
                    //     const LoginForm(
                    //       isEmailLogin: true,
                    //     ).launch(context);
                    //   } on FirebaseAuthException catch (e) {
                    //     if (e.code == 'user-not-found') {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         const SnackBar(
                    //           content: Text('No user found for that email.'),
                    //           duration: Duration(seconds: 3),
                    //         ),
                    //       );
                    //     } else if (e.code == 'wrong-password') {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         const SnackBar(
                    //           content: Text('Wrong password provided for that user.'),
                    //           duration: Duration(seconds: 3),
                    //         ),
                    //       );
                    //     }
                    //   } catch (e) {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(
                    //         content: Text(e.toString()),
                    //         duration: const Duration(seconds: 3),
                    //       ),
                    //     );
                    //   }
                    //   setState(
                    //     () {
                    //       showProgress = false;
                    //     },
                    //   );
                    // },
                    buttonTextColor: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
