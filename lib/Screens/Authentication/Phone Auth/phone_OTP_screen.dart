// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconly/iconly.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Authentication/Phone%20Auth/Repo/phone_auth_repo.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';
import 'package:pinput/pinput.dart';

class OTPVerify extends StatefulWidget {
  const OTPVerify({Key? key, required this.phoneNumber}) : super(key: key);

  final String phoneNumber;

  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {

  String code = '';
  FocusNode focusNode = FocusNode();
  int _start = 60; // 2 minutes in seconds
  late Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_start == 0) {
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  void _resendOtp() async {
    _start = 60;
    _startTimer();
    PhoneAuthRepo repo = PhoneAuthRepo();
    await repo.sentOTP(phoneNumber: widget.phoneNumber, context: context);
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
    focusNode.dispose();
  }

  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: kWhite,
        body: Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const NameWithLogo(),
                const SizedBox(height: 25),
                Text(
                  lang.S.of(context).phoneVerification,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'We sent an OTP in your phone number',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.phoneNumber,
                        style: const TextStyle(fontSize: 16, color: kMainColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        IconlyLight.edit_square,
                        size: 16,
                        color: kMainColor,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _key,
                  child: Pinput(
                      focusNode: focusNode,
                      keyboardType: TextInputType.number,
                      errorPinTheme:
                          PinTheme(width: 50, height: 50, decoration: BoxDecoration(color: Colors.red.shade200, borderRadius: const BorderRadius.all(Radius.circular(8)))),
                      validator: (value) {
                        if (value.isEmptyOrNull) {
                          return 'Please enter the OTP';
                        }
                        if (value!.length < 4) {
                          return 'Enter a valid OTP';
                        } else {
                          return null;
                        }
                      },
                      length: 4,
                      showCursor: true,
                      onCompleted: (pin) {
                        code = pin;
                      }),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: kMainColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      onPressed: () async {
                        focusNode.unfocus();

                        if (_key.currentState?.validate() ?? false) {
                          EasyLoading.show();

                          PhoneAuthRepo repo = PhoneAuthRepo();

                          await repo.submitOTP(phoneNumber: widget.phoneNumber, otp: code, context: context);
                        }
                      },
                      child:  const Text(
                        'Verify',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _start == 0
                        ? GestureDetector(
                            onTap: _resendOtp,
                            child: const Text(
                              'Resend OTP',
                              style: TextStyle(color: kMainColor),
                            ))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Resend OTP in '),
                              Text(
                                '${_start.toString()} seconds',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          )
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
