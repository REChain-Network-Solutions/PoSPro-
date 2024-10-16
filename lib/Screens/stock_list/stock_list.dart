import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Products/Model/product_model.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:mobile_pos/invoice_constant.dart';
import '../../Provider/product_provider.dart';
import '../../currency.dart';

class StockList extends StatefulWidget {
  const StockList({Key? key, required this.isFromReport}) : super(key: key);
  final bool isFromReport;

  @override
  // ignore: library_private_types_in_public_api
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  String productSearch = '';
  @override
  Widget build(BuildContext context) {
    num totalStock = 0;
    double totalSalePrice = 0;
    double totalParPrice = 0;
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(productProvider);
      return providerData.when(data: (product) {
        List<ProductModel> showableProducts = [];
        for (var element in product) {
          if (element.productName!.toLowerCase().contains(productSearch.toLowerCase().trim())) {
            showableProducts.add(element);
            totalStock += (element.productStock ?? 0);
            totalSalePrice += (element.productSalePrice ?? 0) * (element.productStock ?? 0);
            totalParPrice += (element.productPurchasePrice ?? 0) * (element.productStock ?? 0);
          }
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
             widget.isFromReport?'Stock Report': lang.S.of(context).stockList,
              style: GoogleFonts.poppins(color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.w500),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
            child: product.isNotEmpty
                ? Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        color: const Color(0xffFEF0F1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  lang.S.of(context).product,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      lang.S.of(context).cost,
                                     // 'Cost',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                                    ),
                                    Text(
                                      lang.S.of(context).qty,
                                      //'Qty',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                                    ),
                                    Text(
                                      lang.S.of(context).sale,
                                      textAlign: TextAlign.end,
                                      overflow: TextOverflow.ellipsis,
                                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                            itemCount: showableProducts.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          showableProducts[index].productName.toString(),
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Text(
                                          showableProducts[index].brand?.brandName ?? '',
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.poppins(
                                            color: kGreyTextColor,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${showableProducts[index].productPurchasePrice}',
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.poppins(
                                            color: (showableProducts[index].productStock ?? 0) < 20 ? Colors.red : Colors.black,
                                          ),
                                        ),
                                        Text(
                                          showableProducts[index].productStock.toString(),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            color: (showableProducts[index].productStock ?? 0) < 20 ? Colors.red : Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '${showableProducts[index].productSalePrice}',
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.poppins(
                                            color: (showableProducts[index].productStock ?? 0) < 20 ? Colors.red : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ],
                  )
                :  Center(child: Text(
              lang.S.of(context).noProductFound,
               // 'No Product Found'
            )),
          ),
          bottomNavigationBar: Container(
            color: const Color(0xffFEF0F1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lang.S.of(context).stockValue,
                    //'Stock Value:',
                    style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor, fontSize: 14),
                  ),
                  Text(
                    '$currency${totalParPrice.toInt().toString()}',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      }, error: (e, stack) {
        return Text(e.toString());
      }, loading: () {
        return const Center(child: CircularProgressIndicator());
      });
    });
  }
}
