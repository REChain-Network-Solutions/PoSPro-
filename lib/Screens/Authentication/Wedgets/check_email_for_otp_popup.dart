import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';

import '../../../constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;



Future<dynamic> checkEmailForCodePupUp({required String email, required BuildContext context, required TextTheme textTheme}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext contextPopUp) {
      return WillPopScope(
        onWillPop: () async => false,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Dialog(
            backgroundColor: kWhite,
            surfaceTintColor: kWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    lang.S.of(context).verifyYourEmail,
                   // 'Verify Your Email',
                    style: textTheme.titleMedium?.copyWith(fontSize: 24.0),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    lang.S.of(context).weHaveSentAConfirmationEmailTo,
                    //'We have sent a confirmation email to',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal, color: kGreyTextColor,fontSize: 16),
                  ),
                  Text(
                    email,
                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold,fontSize: 16),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    lang.S.of(context).folder,
                   // 'It May be that the mail ended up in your spam folder.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal, color: kGreyTextColor,fontSize: 16),
                  ),
                  const SizedBox(height: 17.0),
                  UpdateButton(
                    onpressed: () {
                      Navigator.pop(contextPopUp, true);
                    },
                    text:
                    lang.S.of(context).gotIt,
                    //'Got It !',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
