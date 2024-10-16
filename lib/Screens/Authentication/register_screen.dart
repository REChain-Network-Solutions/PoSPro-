// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Authentication/Phone%20Auth/phone_auth_screen.dart';
import 'package:mobile_pos/Screens/Authentication/profile_setup_screen.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Repository/API/register_repo.dart';
import '../../constant.dart';
import 'login_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool showPass1 = true;
  bool showPass2 = true;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool passwordShow = false;
  String? givenPassword;
  String? givenPassword2;

  late String email;
  late String password;
  late String passwordConfirmation;

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate() && givenPassword == givenPassword2) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                               // return 'Email can\'n be empty';
                                return lang.S.of(context).emailCannotBeEmpty;
                              } else if (!value.contains('@')) {
                                //return 'Please enter a valid email';
                                return lang.S.of(context).pleaseEnterAValidEmail;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              email = value!;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            obscureText: showPass1,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: lang.S.of(context).password,
                              hintText: lang.S.of(context).pleaseEnterAPassword,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showPass1 = !showPass1;
                                  });
                                },
                                icon: Icon(showPass1 ? Icons.visibility_off : Icons.visibility),
                              ),
                            ),
                            onChanged: (value) {
                              givenPassword = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                //return 'Password can\'t be empty';
                                return lang.S.of(context).passwordCannotBeEmpty;
                              } else if (value.length < 4) {
                                //return 'Please enter a bigger password';
                                return lang.S.of(context).pleaseEnterABiggerPassword;
                              } else if (value.length < 4) {
                                //return 'Please enter a bigger password';
                                return lang.S.of(context).pleaseEnterABiggerPassword;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              password = value!;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            obscureText: showPass2,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: lang.S.of(context).confirmPass,
                              hintText: lang.S.of(context).pleaseEnterAConfirmPassword,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showPass2 = !showPass2;
                                  });
                                },
                                icon: Icon(showPass2 ? Icons.visibility_off : Icons.visibility),
                              ),
                            ),
                            onChanged: (value) {
                              givenPassword2 = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                //return 'Password can\'t be empty';
                                return lang.S.of(context).passwordCannotBeEmpty;
                              } else if (value.length < 4) {
                               // return 'Please enter a bigger password';
                                return lang.S.of(context).pleaseEnterABiggerPassword;
                              } else if (givenPassword != givenPassword2) {
                                //return 'Password Not mach';
                                return lang.S.of(context).passwordsDoNotMatch;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  ButtonGlobalWithoutIcon(
                    buttontext: lang.S.of(context).register,
                    buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                    onPressed: () async {
                      if (validateAndSave()) {
                        RegisterRepo reg = RegisterRepo();
                        if (await reg.registerRepo(email: email, context: context, password: password, confirmPassword: password))
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileSetup(),
                              ));
                        // auth.signUp(context);
                      }
                    },
                    buttonTextColor: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lang.S.of(context).haveAcc,
                        style: GoogleFonts.poppins(color: kGreyTextColor, fontSize: 15.0),
                      ),
                      TextButton(
                        onPressed: () {
                          const LoginForm(
                            isEmailLogin: true,
                          ).launch(context);
                          // Navigator.pushNamed(context, '/loginForm');
                        },
                        child: Text(
                          lang.S.of(context).logIn,
                          style: GoogleFonts.poppins(
                            color: kMainColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      const PhoneAuth().launch(context);
                    },
                    child: Text(lang.S.of(context).loginWithPhone),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
