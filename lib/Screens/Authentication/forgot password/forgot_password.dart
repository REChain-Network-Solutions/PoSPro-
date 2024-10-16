import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Authentication/forgot%20password/repo/forgot_pass_repo.dart';
import '../../../constant.dart';
import '../Sign Up/verify_email.dart';
import '../Wedgets/check_email_for_otp_popup.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  bool isClicked = false;
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 16,
        backgroundColor: kWhite,
        surfaceTintColor: kWhite,
        centerTitle: true,
        title: Text(
           // 'Forgot Password',
          lang.S.of(context).forgotPassword,
          style: textTheme.titleMedium?.copyWith(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                // 'Forgot Password',
                lang.S.of(context).forgotPassword,
                style: textTheme.titleMedium?.copyWith(fontSize: 24.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                //'Reset password by using your email or phone number',
                lang.S.of(context).reset,
                style: textTheme.bodyMedium?.copyWith(color: kGreyTextColor,fontSize: 16),textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration:  kInputDecoration.copyWith(
                  // labelText: 'Email',
                  labelText: lang.S.of(context).lableEmail,
                  // hintText: 'Enter email address',
                  hintText: lang.S.of(context).hintEmail,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    //return 'Email can\'t be empty';
                    return lang.S.of(context).emailCannotBeEmpty;
                  } else if (!value.contains('@')) {
                   // return 'Please enter a valid email';
                    return lang.S.of(context).pleaseEnterAValidEmail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              UpdateButton(
                onpressed: () async {
                  if (isClicked) {
                    return;
                  }
                  if (_formKey.currentState?.validate() ?? false) {
                    isClicked = true;
                    EasyLoading.show();
                    ForgotPassRepo repo = ForgotPassRepo();
                    if (await repo.forgotPass(email: _emailController.text, context: context)) {
                      if (await checkEmailForCodePupUp(email: _emailController.text, context: context, textTheme: textTheme)) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyEmail(
                              email: _emailController.text,
                              isFormForgotPass: true,
                            ),
                          ),
                        );
                      }
                    } else {
                      isClicked = false;
                    }
                  }
                },
                text:
               lang.S.of(context).continueE,
                //'Continue',
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       InkWell(
      //         highlightColor: kMainColor.withOpacity(0.1),
      //         borderRadius: BorderRadius.circular(3.0),
      //         onTap: () => Navigator.pushReplacement(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => const SignUpScreen(),
      //           ),
      //         ),
      //         hoverColor: kMainColor.withOpacity(0.1),
      //         child: RichText(
      //           text: TextSpan(
      //             text: 'Don’t have an account? ',
      //             style: textTheme.bodyMedium?.copyWith(color: kGreyTextColor),
      //             children: [
      //               TextSpan(
      //                 text: 'Sign Up',
      //                 style: textTheme.bodyMedium?.copyWith(color: kMainColor, fontWeight: FontWeight.bold),
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:influencer/widgets/theme/theme_constants.dart';
// import '../../../../widgets/buttons widgets/button_widgets.dart';
// import 'set_new_password.dart';
//
// class ForgotPassword extends StatefulWidget {
//   const ForgotPassword({super.key});
//
//   @override
//   State<ForgotPassword> createState() => _ForgotPasswordState();
// }
//
// class _ForgotPasswordState extends State<ForgotPassword> {
//   @override
//   Widget build(BuildContext context) {
//     TextTheme textTheme = Theme.of(context).textTheme;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         titleSpacing: 16,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 16.0),
//           child: Back(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         title: Text(
//           'Forgot Password',
//           style: textTheme.titleMedium,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Forgot Password',
//               style: textTheme.titleMedium?.copyWith(fontSize: 30.0),
//             ),
//             const SizedBox(height: 8.0),
//             Text(
//               'Reset password by using your email or phone number',
//               style: textTheme.bodyMedium?.copyWith(color: lightGreyTextColor),
//             ),
//             const SizedBox(height: 24.0),
//             Text(
//               'Email',
//               style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8.0),
//             TextFormField(
//               keyboardType: TextInputType.emailAddress,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: 'Enter email address',
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Email can\'n be empty';
//                 } else if (!value.contains('@')) {
//                   return 'Please enter a valid email';
//                 }
//                 return null;
//               },
//               onSaved: (value) {},
//             ),
//             const SizedBox(height: 24.0),
//             PrimaryButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
//                       child: Dialog(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16.0),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.fromLTRB(20.0, 38.0, 20.0, 28.0),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Verify Your Email',
//                                 style: textTheme.titleMedium?.copyWith(fontSize: 24.0),
//                               ),
//                               const SizedBox(height: 16.0),
//                               Text(
//                                 'We have sent a confirmation email to',
//                                 textAlign: TextAlign.center,
//                                 style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal, color: lightGreyTextColor),
//                               ),
//                               Text(
//                                 'sahidul11182@gmail.com',
//                                 style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 16.0),
//                               Text(
//                                 'It May be that the mail ended up in your spam folder.',
//                                 textAlign: TextAlign.center,
//                                 style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal, color: lightGreyTextColor),
//                               ),
//                               const SizedBox(height: 17.0),
//                               PrimaryButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => const ChangePassword(),
//                                     ),
//                                   );
//                                 },
//                                 text: 'Got It !',
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//               text: 'Continue',
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             InkWell(
//               highlightColor: primaryColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(3.0),
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const ForgotPassword(),
//                 ),
//               ),
//               hoverColor: primaryColor.withOpacity(0.1),
//               child: RichText(
//                 text: TextSpan(
//                   text: 'Don’t have an account? ',
//                   style: textTheme.bodyMedium?.copyWith(color: lightGreyTextColor),
//                   children: [
//                     TextSpan(
//                       text: 'Sign Up',
//                       style: textTheme.bodyMedium?.copyWith(color: primaryColor, fontWeight: FontWeight.bold),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
