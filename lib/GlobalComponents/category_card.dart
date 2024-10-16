import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Products/product_data.dart';

import '../constant.dart';
import 'button_global.dart';

// ignore: must_be_immutable
class CategoryCard extends StatelessWidget {
  CategoryCard({Key? key, required this.product, required this.pressed}) : super(key: key);

  final Product product;
  // ignore: prefer_typing_uninitialized_variables
  var pressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              product.title,
              style: GoogleFonts.poppins(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ButtonGlobalWithoutIcon(
              buttontext: 'Select',
              buttonDecoration: kButtonDecoration.copyWith(color: kDarkWhite),
              onPressed: pressed,
              buttonTextColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
