import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:mobile_pos/Screens/Products/update_product.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/currency.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        surfaceTintColor: kWhite,
        title: Text(
          'Product Details',
          style: GoogleFonts.poppins(
            color: kTitleColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateProduct()));
                },
                icon: Row(
                  children: [
                    const Icon(
                      IconlyBold.edit,
                      color: kMainColor,
                      size: 18,
                    ),
                    Text(
                      'Edit',
                      style: gTextStyle.copyWith(fontSize: 13, color: kMainColor),
                    )
                  ],
                )),
          )
        ],
        centerTitle: true,
        // iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.0,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 20,),
                Container(
                  height: 290,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), color: const Color(0xffFEF0F1), image: const DecorationImage(fit: BoxFit.cover, image: NetworkImage('https://tinyurl.com/3tme92c2'))),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Smart watch',
                          style: gTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor, fontSize: 20),
                        ),
                        Text(
                          'Apple Watch',
                          style: gTextStyle.copyWith(color: kGreyTextColor),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      '$currency 175.0',
                      style: gTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: kTitleColor),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Details',
                  style: gTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adi piscing elit. Accumsan vulputate tellus scele risque odio con sectetur tincidunt semper.',
                  style: gTextStyle.copyWith(color: kGreyTextColor),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffFEF0F1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sale Price',
                              style: gTextStyle.copyWith(
                                color: kTitleColor,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '$currency ${180}',
                              style: gTextStyle.copyWith(color: kGreyTextColor),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Wholesale price',
                              style: gTextStyle.copyWith(color: kTitleColor, fontSize: 16),
                            ),
                            Text(
                              '$currency ${170}',
                              style: gTextStyle.copyWith(color: kGreyTextColor),
                            )
                          ],
                        ),
                        RotatedBox(
                          quarterTurns: 1,
                          child: Container(
                            height: 1,
                            width: 100,
                            color: kBorderColorTextField,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Stock',
                              style: gTextStyle.copyWith(
                                color: kTitleColor,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '250',
                              style: gTextStyle.copyWith(color: kGreyTextColor),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Dealer price',
                              style: gTextStyle.copyWith(color: kTitleColor, fontSize: 16),
                            ),
                            Text(
                              '$currency ${175}',
                              style: gTextStyle.copyWith(color: kGreyTextColor),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
