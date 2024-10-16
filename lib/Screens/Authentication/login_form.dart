import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Authentication/register_screen.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import 'forgot_password.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key, required this.isEmailLogin}) : super(key: key);

  final bool isEmailLogin;

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool showPassword = true;
  late String email, password;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer(builder: (context, ref, child) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/logoandname.png'),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: globalKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: lang.S.of(context).emailText,
                              hintText: lang.S.of(context).enterYourEmailAddress,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                //return 'Email can\'n be empty';
                                return lang.S.of(context).emailCannotBeEmpty;
                              } else if (!value.contains('@')) {
                                //return 'Please enter a valid email';
                                return lang.S.of(context).pleaseEnterAValidEmail;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              // loginProvider.email = value!;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            obscureText: showPassword,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: lang.S.of(context).password,
                              hintText: lang.S.of(context).pleaseEnterAPassword,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                                icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                //return 'Password can\'t be empty';
                                return lang.S.of(context).passwordCannotBeEmpty;
                              } else if (value.length < 4) {
                                //return 'Please enter a bigger password';
                                return lang.S.of(context).pleaseEnterABiggerPassword;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              // loginProvider.password = value!;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          const ForgotPassword().launch(context);
                          // Navigator.pushNamed(context, '/forgotPassword');
                        },
                        child: Text(
                          lang.S.of(context).forgotPassword,
                          style: GoogleFonts.poppins(
                            color: kGreyTextColor,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ).visible(widget.isEmailLogin),
                  ButtonGlobalWithoutIcon(
                      buttontext: lang.S.of(context).logIn,
                      buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                      onPressed: () {
                        if (validateAndSave()) {
                          // loginProvider.signIn(context);
                        }
                      },
                      buttonTextColor: Colors.white),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lang.S.of(context).noAcc,
                        style: GoogleFonts.poppins(color: kGreyTextColor, fontSize: 15.0),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, '/signup');
                          const RegisterScreen().launch(context);
                        },
                        child: Text(
                          lang.S.of(context).register,
                          style: GoogleFonts.poppins(
                            color: kMainColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ).visible(widget.isEmailLogin),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
