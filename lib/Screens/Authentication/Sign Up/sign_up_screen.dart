import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:mobile_pos/Screens/Authentication/Sign%20Up/repo/sign_up_repo.dart';
import 'package:mobile_pos/Screens/Authentication/Sign%20Up/verify_email.dart';
import '../../../GlobalComponents/button_global.dart';
import '../../../constant.dart';
import '../Sign In/sign_in_screen.dart';
import '../Wedgets/check_email_for_otp_popup.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  ///__________Variables________________________________
  bool showPassword = true;
  bool isClicked = false;

  ///________Key_______________________________________
  GlobalKey<FormState> key = GlobalKey<FormState>();

  ///___________Controllers______________________________
  TextEditingController nameTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();

  ///________Dispose____________________________________
  @override
  void dispose() {
    super.dispose();
    nameTextController.dispose();
    passwordTextController.dispose();
    emailTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kWhite,
        titleSpacing: 16,
        centerTitle: true,
        surfaceTintColor: kWhite,
        title: Text(
          lang.S.of(context).signIn,
          //'Sign Up',
          style: textTheme.titleMedium?.copyWith(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24,),
                const NameWithLogo(),
                const SizedBox(height: 24,),
                Text(
                  lang.S.of(context).createAFreeAccount,
                  //'Create A Free Account',
                  style: textTheme.titleMedium?.copyWith(fontSize: 24.0,fontWeight: FontWeight.w600),
                ),
                Text(
                  lang.S.of(context).pleaseEnterYourDetails,
                  //'Please enter your details',
                  style: textTheme.bodyMedium?.copyWith(color: kGreyTextColor,fontSize: 16),
                ),
                const SizedBox(height: 24.0),

                ///____________Name______________________________________________
                TextFormField(
                  controller: nameTextController,
                  keyboardType: TextInputType.name,
                  decoration: kInputDecoration.copyWith(
                    //labelText: 'Full Name',
                    labelText: lang.S.of(context).fullName,
                    //hintText: 'Enter your full name',
                    hintText: lang.S.of(context).enterYourFullName,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      //return 'name can\'n be empty';
                      return lang.S.of(context).nameCanNotBeEmpty;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),

                ///__________Email______________________________________________
                TextFormField(
                  controller: emailTextController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: kInputDecoration.copyWith(
                    // border: OutlineInputBorder(),
                    // labelText: 'email',
                    labelText: lang.S.of(context).lableEmail,
                    //hintText: 'Enter email address',
                    hintText: lang.S.of(context).hintEmail,
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
                ),
                const SizedBox(height: 20.0),

                ///___________Password_____________________________________________
                TextFormField(
                  controller: passwordTextController,
                  keyboardType: TextInputType.text,
                  obscureText: showPassword,
                  decoration: kInputDecoration.copyWith(
                    //labelText: 'Password',
                    labelText: lang.S.of(context).lablePassword,
                   // hintText: 'Enter password',
                    hintText: lang.S.of(context).hintPassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      icon: Icon(
                        showPassword ? FeatherIcons.eyeOff : FeatherIcons.eye,
                        color: kGreyTextColor,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      //return 'Password can\'t be empty';
                      return lang.S.of(context).passwordCannotBeEmpty;
                    } else if (value.length < 6) {
                      //return 'Please enter a bigger password';
                      return lang.S.of(context).pleaseEnterABiggerPassword;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),

                ///________Button___________________________________________________
                UpdateButton(
                  onpressed: () async {
                    if (isClicked) {
                      return;
                    }
                    if (key.currentState?.validate() ?? false) {
                      isClicked = true;
                      EasyLoading.show();
                      SignUpRepo repo = SignUpRepo();
                      if (await repo.signUp(name: nameTextController.text, email: emailTextController.text, password: passwordTextController.text, context: context)) {
                        if (await checkEmailForCodePupUp(email: emailTextController.text, context: context, textTheme: textTheme)) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerifyEmail(
                                email: emailTextController.text,
                                isFormForgotPass: false,
                              ),
                            ),
                          );
                        }
                      } else {
                        isClicked = false;
                      }
                    }
                  },
                  text: lang.S.of(context).signIn,
                  //'Sign Up',
                ),
                const SizedBox(height: 20,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      highlightColor: kMainColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3.0),
                      onTap: () => Navigator.pop(context),
                      hoverColor: kMainColor.withOpacity(0.1),
                      child: RichText(
                        text: TextSpan(
                          text:
                          lang.S.of(context).alreadyHaveAnAccount,
                          //'Already have an account? ',
                          style: textTheme.bodyMedium?.copyWith(color: kGreyTextColor),
                          children: [
                            TextSpan(
                              text:lang.S.of(context).signIn,
                              //'Sign In',
                              style: textTheme.bodyMedium?.copyWith(color: kMainColor, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
