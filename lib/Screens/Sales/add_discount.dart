import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/GlobalComponents/tab_buttons.dart';
import 'package:mobile_pos/Provider/add_to_cart.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class AddDiscount extends StatefulWidget {
  const AddDiscount({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddDiscountState createState() => _AddDiscountState();
}

class _AddDiscountState extends State<AddDiscount> {
  String discountType = 'USD';
  List<String> allDataList = [];
  String amount = '0';
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(cartNotifier);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            lang.S.of(context).discount,
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TabButton(
                        title: 'USD',
                        text: discountType == 'USD' ? Colors.white : kMainColor,
                        background: discountType == 'USD' ? kMainColor : kDarkWhite,
                        press: () {
                          setState(() {
                            discountType = 'USD';
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TabButton(
                        title: '%',
                        text: discountType == '%' ? Colors.white : kMainColor,
                        background: discountType == '%' ? kMainColor : kDarkWhite,
                        press: () {
                          setState(() {
                            discountType = '%';
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppTextField(
                  textFieldType: TextFieldType.NAME,
                  decoration: const InputDecoration(border: OutlineInputBorder(), floatingLabelBehavior: FloatingLabelBehavior.always, labelText: 'Discount (USD)'),
                  onChanged: (value) {
                    amount = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppTextField(
                  textFieldType: TextFieldType.NAME,
                  maxLines: 3,
                  decoration: const InputDecoration(border: OutlineInputBorder(), floatingLabelBehavior: FloatingLabelBehavior.always, labelText: 'Note'),
                ),
              ),
              ButtonGlobalWithoutIcon(
                buttontext: lang.S.of(context).save,
                buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                onPressed: () {
                  providerData.addDiscount(discountType, amount.toDouble());
                  Navigator.pop(context);
                },
                buttonTextColor: Colors.white,
              ),
            ],
          ),
        ),
      );
    });
  }
}
