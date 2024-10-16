import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Authentication/Sign%20Up/repo/sign_up_repo.dart';
import 'package:mobile_pos/constant.dart';
import 'package:pinput/pinput.dart' as p;
import '../forgot password/repo/forgot_pass_repo.dart';
import '../forgot password/set_new_password.dart';
import '../profile_setup_screen.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;


class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key, required this.email, required this.isFormForgotPass}) : super(key: key);
  final String email;
  final bool isFormForgotPass;

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  ///__________variables_____________
  bool isClicked = false;

  ///________countdown_Timer___________________
  Timer? _timer;
  int _start = 180; // 3 minutes = 180 seconds
  bool _isButtonEnabled = false;
  void startTimer() {
    _isButtonEnabled = false;
    _start = 180; // Reset to 3 minutes
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          _isButtonEnabled = true;
          _timer?.cancel();
        }
      });
    });
  }

  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final _pinputKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();

    super.dispose();
  }

  static const focusedBorderColor = kMainColor;
  static const fillColor = Color(0xFFF3F3F3);
  final defaultPinTheme = p.PinTheme(
    width: 45,
    height: 52,
    textStyle: const TextStyle(
      fontSize: 20,
      color: kTitleColor,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: kBorderColor),
    ),
  );

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kWhite,
        surfaceTintColor: kWhite,
        centerTitle: true,
        titleSpacing: 16,
        title: Text(
          lang.S.of(context).verityEmail,
         // 'Verity Email',
          style: textTheme.titleMedium?.copyWith(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(lang.S.of(context).verityEmail,
             // 'Verification',
              style: textTheme.titleMedium?.copyWith(fontSize: 24.0),
            ),
            const SizedBox(height: 8.0),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(text: lang.S.of(context).digits, style: textTheme.bodyMedium?.copyWith(color: kGreyTextColor, fontSize: 16), children: [
                TextSpan(
                  text: widget.email,
                  style: textTheme.bodyMedium?.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 16),
                )
              ]),
            ),
            const SizedBox(height: 24.0),
            Form(
              key: _pinputKey,
              child: p.Pinput(
                length: 6,
                controller: pinController,
                focusNode: focusNode,
                // listenForMultipleSmsOnAndroid: true,
                defaultPinTheme: defaultPinTheme,
                separatorBuilder: (index) => const SizedBox(width: 11),
                validator: (value) {
                  if ((value?.length ?? 0) < 6) {
                    //return 'Enter valid OTP';
                    return lang.S.of(context).enterValidOTP;
                  } else {
                    return null;
                  }
                },
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: kMainColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kTitleColor),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyBorderWith(
                  border: Border.all(color: Colors.redAccent),
                ),
              ),
            ),
            // const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 11, bottom: 11),
                  child: Text(
                    _isButtonEnabled ? 'You can now resend the OTP.' : 'Resend OTP in $_start seconds',
                    // style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: _isButtonEnabled,
                  child: TextButton(
                    onPressed: _isButtonEnabled
                        ? () async {
                            EasyLoading.show();
                            SignUpRepo repo = SignUpRepo();
                            if (await repo.resendOTP(email: widget.email, context: context)) {
                              startTimer();
                            }
                          }
                        : null,
                    child:  Text(
                      lang.S.of(context).resendOTP,
                      //'Resend OTP',
                      style: const TextStyle(color: kMainColor),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            UpdateButton(
              onpressed: widget.isFormForgotPass
                  ? () async {
                      if (isClicked) {
                        return;
                      }
                      focusNode.unfocus();
                      if (_pinputKey.currentState?.validate() ?? false) {
                        isClicked = true;
                        EasyLoading.show();
                        ForgotPassRepo repo = ForgotPassRepo();
                        if (await repo.verifyOTPForgotPass(email: widget.email, otp: pinController.text, context: context)) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SetNewPassword(
                                email: widget.email,
                              ),
                            ),
                          );
                        } else {
                          isClicked = false;
                        }
                      }
                    }
                  : () async {
                      if (isClicked) {
                        return;
                      }
                      focusNode.unfocus();
                      if (_pinputKey.currentState?.validate() ?? false) {
                        isClicked = true;
                        EasyLoading.show();
                        SignUpRepo repo = SignUpRepo();
                        if (await repo.verifyOTP(email: widget.email, otp: pinController.text, context: context)) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileSetup(),
                            ),
                          );
                        } else {
                          isClicked = false;
                        }
                      }
                    },
              text:lang.S.of(context).continueE,
             // 'Continue',
            ),
          ],
        ),
      ),
    );
  }
}
