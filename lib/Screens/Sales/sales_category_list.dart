import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/category_card.dart';
import 'package:mobile_pos/Screens/Products/product_data.dart';
import 'package:mobile_pos/Screens/Sales/sales_products_list_screen.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../Products/add_category_screen.dart';

class SalesCategoryList extends StatefulWidget {
  const SalesCategoryList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SalesCategoryListState createState() => _SalesCategoryListState();
}

class _SalesCategoryListState extends State<SalesCategoryList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Image(
              image: AssetImage('images/x.png'),
            )),
        title: Text(
          lang.S.of(context).categories,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: AppTextField(
                    textFieldType: TextFieldType.NAME,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                     // hintText: 'Search',
                      hintText:lang.S.of(context).search,
                      prefixIcon: Icon(
                        Icons.search,
                        color: kGreyTextColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      const AddCategory().launch(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      height: 60.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: kGreyTextColor),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: kGreyTextColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  ...List.generate(
                    demoCategory.length,
                    (index) => CategoryCard(
                      product: demoCategory[index],
                      pressed: () {
                        SaleProductsList(catName: demoCategory[index].title).launch(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
