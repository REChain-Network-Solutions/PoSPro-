import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constant.dart';
import '../Sign Up/sign_up_screen.dart';
import '../forgot password/forgot_password.dart';
import 'Repo/sign_in_repo.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool showPassword = true;
  bool _isChecked = false;

  ///__________variables_____________
  bool isClicked = false;

  final key = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserCredentials();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isChecked = prefs.getBool('remember_me') ?? false;
      if (_isChecked) {
        emailController.text = prefs.getString('email') ?? '';
        passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  void _saveUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('remember_me', _isChecked);
    if (_isChecked) {
      prefs.setString('email', emailController.text);
      prefs.setString('password', passwordController.text);
    } else {
      prefs.remove('email');
      prefs.remove('password');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        surfaceTintColor: kWhite,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: kWhite,
        titleSpacing: 16,
        title: Text(
          // 'Sign in',
          lang.S.of(context).signIn,
          style: textTheme.titleSmall?.copyWith(fontSize: 20, color: kTitleColor),
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
                const SizedBox(
                  height: 24,
                ),
                const NameWithLogo(),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  // 'Welcome back!',f
                  lang.S.of(context).welcomeBack,
                  style: textTheme.titleMedium?.copyWith(fontSize: 24.0, fontWeight: FontWeight.w600),
                ),
                Text(
                  lang.S.of(context).pleaseEnterYourDetails,
                  //'Please enter your details.',
                  style: textTheme.bodyMedium?.copyWith(color: kGreyTextColor, fontSize: 16),
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: kInputDecoration.copyWith(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                   // labelText: 'Email',
                    labelText: lang.S.of(context).lableEmail,
                    //hintText: 'Enter email address',
                    hintText: lang.S.of(context).hintEmail,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                     // return 'Email can\'t be empty';
                      return lang.S.of(context).emailCannotBeEmpty;
                    } else if (!value.contains('@')) {
                      //return 'Please enter a valid email';
                      return lang.S.of(context).pleaseEnterAValidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: showPassword,
                  decoration: kInputDecoration.copyWith(
                    //labelText: 'Password',
                    labelText: lang.S.of(context).lablePassword,
                    //hintText: 'Enter password',
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
                      // return 'Password can\'t be empty';
                      return lang.S.of(context).passwordCannotBeEmpty;
                    } else if (value.length < 6) {
                      //return 'Please enter a bigger password';
                      return lang.S.of(context).pleaseEnterABiggerPassword;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      checkColor: Colors.white,
                      activeColor: kMainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      fillColor: MaterialStateProperty.all(_isChecked ? kMainColor : Colors.transparent),
                      visualDensity: const VisualDensity(horizontal: -4),
                      side: const BorderSide(color: kGreyTextColor),
                      value: _isChecked,
                      onChanged: (newValue) {
                        setState(() {
                          _isChecked = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      lang.S.of(context).rememberMe,
                       //'Remember me',
                      style: textTheme.bodyMedium?.copyWith(color: kGreyTextColor),
                    ),
                    const Spacer(),
                    TextButton(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPassword(),
                        ),
                      ),
                      child: Text(
                        lang.S.of(context).forgotPassword,
                        //'Forgot password?',
                        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                UpdateButton(
                  onpressed: () async {
                    if (isClicked) {
                      return;
                    }
                    if (key.currentState?.validate() ?? false) {
                      isClicked = true;
                      EasyLoading.show();
                      LogInRepo repo = LogInRepo();
                      if (await repo.logIn(email: emailController.text, password: passwordController.text, context: context)) {
                        _saveUserCredentials();
                        EasyLoading.showSuccess('Done');
                      } else {
                        isClicked = false;
                      }
                    }
                  },
                  text: lang.S.of(context).logIn,
                  //'Login',
                ),
                const SizedBox(
                  height: 16,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      highlightColor: kMainColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3.0),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const SignUpScreen();
                          },
                        ));
                      },
                      hoverColor: kMainColor.withOpacity(0.1),
                      child: RichText(
                        text: TextSpan(
                          text:
                         lang.S.of(context).donNotHaveAnAccount,
                          //'Don’t have an account? ',
                          style: textTheme.bodyMedium?.copyWith(color: kGreyTextColor),
                          children: [
                            TextSpan(
                              // text:lang.S.of(context).signUp,
                              text:'Sign Up',
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
