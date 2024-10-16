import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Authentication/Phone%20Auth/phone_OTP_screen.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import 'Repo/phone_auth_repo.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  String? phoneNumber;

  bool phoneFieldValid = true;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const NameWithLogo(),
              const SizedBox(height: 25),
              Text(
                lang.S.of(context).phoneVerification,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                lang.S.of(context).registerTitle,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              IntlPhoneField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(borderSide: BorderSide(), borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                initialCountryCode: 'BD',
                onChanged: (phone) {
                  phoneNumber = phone.completeNumber;
                },
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
              ),
              const SizedBox(height: 20),
              // Container(
              //   height: 55,
              //   decoration:
              //       BoxDecoration(border: Border.all(width: phoneFieldValid ? 1 : 2, color: phoneFieldValid ? Colors.grey : Colors.red), borderRadius: BorderRadius.circular(10)),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       const SizedBox(width: 10),
              //       SizedBox(
              //         width: 40,
              //         child: TextField(
              //           controller: countryController,
              //           keyboardType: TextInputType.number,
              //           decoration: const InputDecoration(
              //             border: InputBorder.none,
              //           ),
              //         ),
              //       ),
              //       const Text(
              //         "|",
              //         style: TextStyle(fontSize: 33, color: Colors.grey),
              //       ),
              //       const SizedBox(width: 10),
              //       Expanded(
              //           child: Form(
              //         key: _key,
              //         child: TextFormField(
              //           controller: phoneNumberController,
              //           inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d'))],
              //           validator: (value) {
              //             if (value.isEmptyOrNull) {
              //               setState(() {
              //                 phoneFieldValid = false;
              //               });
              //               return null;
              //             }
              //             if (value!.length < 8) {
              //               setState(() {
              //                 phoneFieldValid = false;
              //               });
              //               return null;
              //             } else {
              //               setState(() {
              //                 phoneFieldValid = true;
              //               });
              //
              //               return null;
              //             }
              //           },
              //           keyboardType: TextInputType.phone,
              //           decoration: const InputDecoration(
              //             border: InputBorder.none,
              //             hintText: "Phone Number",
              //           ),
              //         ),
              //       ))
              //     ],
              //   ),
              // ),
              // Visibility(
              //     visible: !phoneFieldValid,
              //     child: const Padding(
              //       padding: EdgeInsets.only(top: 4, left: 2),
              //       child: Text(
              //         'Enter a valid phone number',
              //         style: TextStyle(color: Colors.red),
              //       ),
              //     )),
              // const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: kMainColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    // onPressed: () async {
                    //   // const OTPVerify().launch(context);
                    //   _key.currentState?.validate();
                    //
                    //   if (phoneFieldValid) {
                    //     EasyLoading.show();
                    //     PhoneAuthRepo repo = PhoneAuthRepo();
                    //
                    //     if (await repo.sentOTP(phoneNumber: countryController.text + phoneNumberController.text, context: context)) {
                    //       OTPVerify(phoneNumber: countryController.text + phoneNumberController.text).launch(context);
                    //     }
                    //   }
                    // },
                    onPressed: () async {
                      if ((phoneNumber?.length ?? 0) > 8) {
                        EasyLoading.show();
                        PhoneAuthRepo repo = PhoneAuthRepo();

                        if (await repo.sentOTP(phoneNumber: phoneNumber!, context: context)) {
                          OTPVerify(phoneNumber: phoneNumber!).launch(context);
                        }
                      } else {
                        EasyLoading.showError('Enter a valid Phone Number');
                      }
                    },
                    child: Text(
                      lang.S.of(context).sendCode,
                      style: const TextStyle(color: Colors.white),
                    )),
              ),
              const SizedBox(height: 10),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     TextButton(
              //       onPressed: () {
              //         const LoginForm(isEmailLogin: false).launch(context);
              //       },
              //       child: Text(lang.S.of(context).staffLogin),
              //     ),
              //     Flexible(
              //       child: TextButton(
              //         onPressed: () {
              //           const LoginForm(isEmailLogin: true).launch(context);
              //         },
              //         child: Text(
              //           lang.S.of(context).logInWithMail,
              //           overflow: TextOverflow.ellipsis,
              //           maxLines: 1,
              //         ),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
