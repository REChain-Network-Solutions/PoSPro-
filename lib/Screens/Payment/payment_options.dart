import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Payment/payment_complete.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

class PaymentOptions extends StatefulWidget {
  const PaymentOptions({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PaymentOptionsState createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  bool isCvvFocused = false;
  String radioItem = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang.S.of(context).payment,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext bc) => [
              const PopupMenuItem(value: "/addPromoCode", child: Text('Add Promo Code')),
              const PopupMenuItem(value: "/addDiscount", child: Text('Add Discount')),
              const PopupMenuItem(value: "/settings", child: Text('Cancel All Product')),
              const PopupMenuItem(value: "/settings", child: Text('Vat Doesn\'t Apply')),
            ],
            onSelected: (value) {
              Navigator.pushNamed(context, '$value');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // GestureDetector(
            //   onTap: () {
            //     setState(() {
            //       isCvvFocused == false
            //           ? isCvvFocused = true
            //           : isCvvFocused = false;
            //     });
            //   },
            //   child: CreditCardWidget(
            //     cardNumber: '4591 4836 2325 0236',
            //     expiryDate: '11/23',
            //     cardHolderName: 'John Doe',
            //     cvvCode: '089',
            //     showBackView: isCvvFocused,
            //     cardBgColor: kMainColor,
            //     obscureCardNumber: true,
            //     obscureCardCvv: false,
            //     height: 175,
            //     textStyle: const TextStyle(color: Colors.white),
            //     width: MediaQuery.of(context).size.width,
            //     animationDuration: const Duration(milliseconds: 1000),
            //   ),
            // ),
            SizedBox(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                onTap: () {
                  const PaymentCompleted().launch(context);
                },
                title: Row(
                  children: [
                    const Image(
                      image: AssetImage('images/mastercard.png'),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      lang.S.of(context).masterCard,
                      style: GoogleFonts.poppins(
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
                leading: const Icon(Icons.check_circle_outline),
              ),
            ),
            SizedBox(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                onTap: () {
                  const PaymentCompleted().launch(context);
                },
                title: Row(
                  children: [
                    const Image(
                      image: AssetImage('images/instrument.png'),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      lang.S.of(context).instrucation,
                      style: GoogleFonts.poppins(
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
                leading: const Icon(Icons.check_circle_outline),
              ),
            ),
            SizedBox(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                onTap: () {
                  const PaymentCompleted().launch(context);
                },
                title: Row(
                  children: [
                    const Image(
                      image: AssetImage('images/cash.png'),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      lang.S.of(context).cash,
                      style: GoogleFonts.poppins(
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
                leading: const Icon(Icons.check_circle_outline),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
