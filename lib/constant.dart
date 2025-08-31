import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kMainColor = Color(0xffC52127);
const kGreyTextColor = Color(0xFF828282);
const kBackgroundColor = Color(0xffF5F3F3);
const kBorderColorTextField = Color(0xFFC2C2C2);
const kDarkWhite = Color(0xFFF1F7F7);
const kWhite = Color(0xFFffffff);
const kBorderColor=Color(0xffD8D8D8);
const kPremiumPlanColor = Color(0xFF8752EE);
const kPremiumPlanColor2 = Color(0xFFFF5F00);
const kTitleColor = Color(0xFF000000);
bool connected = false;
bool isPrintEnable = false;
List<String> paymentsTypeList = ['Cash', 'Card', 'Check', 'Mobile Pay', 'Due'];
bool isExpiringInFiveDays = false;
bool isExpiringInOneDays = false;
const String appVersion = '1.1';
String paypalClientId = '';
String paypalClientSecret = '';
const bool sandbox = true;
String noProductImageUrl = 'images/no_product_image.png';
String purchaseCode = '528cdb9a-5d37-4292-a2b5-b792d5eca03a';

///---------------update information---------------

const String splashLogo = 'images/splashLogo.png';
const String onboard1 = 'images/onbord1.png';
const String onboard2 = 'images/onbord2.png';
const String onboard3 = 'images/onbord3.png';
const String logo = 'images/logo.png';
const String appsName = 'PosPro';

const kButtonDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(
    Radius.circular(5),
  ),
);

const kInputDecoration = InputDecoration(
  hintStyle: TextStyle(color: kGreyTextColor),
  // filled: true,
  // fillColor: Colors.white,
  floatingLabelBehavior: FloatingLabelBehavior.always,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: kBorderColor, width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
    borderSide: BorderSide(color: kBorderColor, width: 1),
  ),
);

final gTextStyle = GoogleFonts.poppins(
  color: Colors.white,
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(1.0),
    borderSide: const BorderSide(color: kBorderColorTextField),
  );
}

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

// List<String> language = ['English'];

List<String> productCategory = ['Fashion', 'Electronics', 'Computer', 'Gadgets', 'Watches', 'Cloths'];

///______________________________________________________________________________________________
String constUserId = '';
String subUserTitle = '';
String subUserEmail = '';
bool isSubUserDeleted = true;
bool newSelect = false;

///--------------------subscription dilog-----------------------

//______________________________________________Back_Button__________________
class Back extends StatelessWidget {
  final VoidCallback onPressed;

  const Back({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(
        color: Color(0xFFF3F3F3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        alignment: Alignment.center,
        padding: EdgeInsets.zero,
        tooltip: 'Back',
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: onPressed,
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
          size: 24,
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 48.0,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(kMainColor)),
        child: Text(
          text,
          style: textTheme.labelLarge,
        ),
      ),
    );
  }
}
