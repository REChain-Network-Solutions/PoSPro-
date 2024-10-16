// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/add_to_cart.dart';
import '../../Screens/Sales/sales_products_list_screen.dart';
import '../../model/add_to_cart_model.dart';
import '../../model/sale_transaction_model.dart';

// ignore: must_be_immutable
class EditSaleInvoiceSaleProducts extends StatefulWidget {
  EditSaleInvoiceSaleProducts({Key? key, @required this.catName, required this.salesInfo}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  var catName;
  SalesTransaction salesInfo;

  @override
  // ignore: library_private_types_in_public_api
  _EditSaleInvoiceSaleProductsState createState() => _EditSaleInvoiceSaleProductsState();
}

class _EditSaleInvoiceSaleProductsState extends State<EditSaleInvoiceSaleProducts> {
  String dropdownValue = '';
  String productCode = '0000';

  var salesCart = FlutterCart();
  String productPrice = '0';
  String sentProductPrice = '';

  @override
  void initState() {
    widget.catName == null ? dropdownValue = 'Fashion' : dropdownValue = widget.catName;
    super.initState();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = lang.S.of(context).failedToGetPlatformVersion;
      //'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      productCode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(cartNotifier);
      final productList = ref.watch(productProvider);

      return Scaffold(
        appBar: AppBar(
          title: Text(
            lang.S.of(context).addItems,
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
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          onChanged: (value) {
                            setState(() {
                              productCode = value;
                            });
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            //labelText: 'Product Code',
                            labelText: lang.S.of(context).productCode,
                            hintText: productCode == '0000' || productCode == '-1' ? 'Scan product QR code' : productCode,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () => scanBarcodeNormal(),
                          child: Container(
                            height: 60.0,
                            width: 100.0,
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: kGreyTextColor),
                            ),
                            child: const Image(
                              image: AssetImage('images/barcode.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                productList.when(data: (products) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        if (widget.salesInfo.party!.type!.contains('Retailer')) {
                          productPrice = products[i].productSalePrice.toString();
                        } else if (widget.salesInfo.party!.type!.contains('Dealer')) {
                          productPrice = products[i].productDealerPrice.toString();
                        } else if (widget.salesInfo.party!.type!.contains('Wholesaler')) {
                          productPrice = products[i].productWholeSalePrice.toString();
                        } else if (widget.salesInfo.party!.type!.contains('Supplier')) {
                          productPrice = products[i].productPurchasePrice.toString();
                        } else if (widget.salesInfo.party!.type!.contains('Guest')) {
                          productPrice = products[i].productSalePrice.toString();
                        }
                        return GestureDetector(
                          onTap: () async {
                            if ((products[i].productStock ?? 0) <= 0) {
                              EasyLoading.showError('Out of stock');
                            } else {
                              if (widget.salesInfo.party!.type!.contains('Retailer')) {
                                sentProductPrice = products[i].productSalePrice.toString();
                              } else if (widget.salesInfo.party!.type!.contains('Dealer')) {
                                sentProductPrice = products[i].productDealerPrice.toString();
                              } else if (widget.salesInfo.party!.type!.contains('Wholesaler')) {
                                sentProductPrice = products[i].productWholeSalePrice.toString();
                              } else if (widget.salesInfo.party!.type!.contains('Supplier')) {
                                sentProductPrice = products[i].productPurchasePrice.toString();
                              } else if (widget.salesInfo.party!.type!.contains('Guest')) {
                                sentProductPrice = products[i].productSalePrice.toString();
                              }

                              AddToCartModel cartItem = AddToCartModel(
                                productName: products[i].productName,
                                subTotal: sentProductPrice,
                                productId: products[i].productCode,
                                uuid: products[i].id ?? 0,
                                productBrandName: products[i].brand?.brandName ?? '',
                                stock: (products[i].productStock ?? 0).round(),
                              );
                              providerData.addToCartRiverPod(cartItem);
                              providerData.addProductsInSales(products[i]);
                              EasyLoading.showSuccess(
                                lang.S.of(context).addedToCart,
                                  //'Added To Cart'
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: ProductCard(
                            stock: products[i].productStock ?? 0,
                            productTitle: products[i].productName.toString(),
                            productDescription: products[i].brand?.brandName ?? '',
                            productPrice: num.tryParse(productPrice) ?? 0,
                            productImage: products[i].productPicture,
                          ).visible((products[i].productCode == productCode || productCode == '0000' || productCode == '-1') && productPrice != '0'||
                              products[i].productName!.toLowerCase().contains(productCode.toLowerCase())),
                        );
                      });
                }, error: (e, stack) {
                  return Text(e.toString());
                }, loading: () {
                  return const Center(child: CircularProgressIndicator());
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
