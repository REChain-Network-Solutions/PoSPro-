// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Const/api_config.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Screens/Customers/Model/parties_model.dart';
import 'package:mobile_pos/Screens/Products/Model/product_model.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/add_to_cart.dart';
import '../../Provider/add_to_cart_purchase.dart';

// ignore: must_be_immutable
class PurchaseProducts extends StatefulWidget {
  PurchaseProducts({Key? key, @required this.catName, this.customerModel}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  var catName;
  Party? customerModel;

  @override
  State<PurchaseProducts> createState() => _PurchaseProductsState();
}

class _PurchaseProductsState extends State<PurchaseProducts> {
  String dropdownValue = '';
  String productCode = '0000';

  var salesCart = FlutterCart();
  String total = 'Cart Is Empty';
  int items = 0;
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
      // Временно используем простой ввод для демонстрации
      barcodeScanRes = 'DEMO_BARCODE_123';
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
      final providerData = ref.watch(cartNotifierPurchase);
      final productList = ref.watch(productProvider);
      return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          title: Text(
            lang.S.of(context).productList,
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
                const SizedBox(
                  height: 20.0,
                ),
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
                        if (widget.customerModel!.type!.contains('Retailer')) {
                          productPrice = products[i].productSalePrice.toString();
                        } else if (widget.customerModel!.type!.contains('Dealer')) {
                          productPrice = products[i].productDealerPrice.toString();
                        } else if (widget.customerModel!.type!.contains('Wholesaler')) {
                          productPrice = products[i].productWholeSalePrice.toString();
                        } else if (widget.customerModel!.type!.contains('Supplier')) {
                          productPrice = products[i].productPurchasePrice.toString();
                        }
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  ProductModel tempProduct = ProductModel(
                                    type: products[i].type,
                                    weight: products[i].weight,
                                    size: products[i].size,
                                    color: products[i].color,
                                    capacity: products[i].capacity,
                                    category: products[i].category,
                                    unitId: products[i].unitId,
                                    id: products[i].id,
                                    brand: products[i].brand,
                                    brandId: products[i].unitId,
                                    businessId: products[i].businessId,
                                    categoryId: products[i].categoryId,
                                    createdAt: products[i].createdAt,
                                    unit: products[i].unit,
                                    updatedAt: products[i].updatedAt,
                                    productCode: products[i].productCode,
                                    productDealerPrice: products[i].productDealerPrice,
                                    productDiscount: products[i].productDiscount,
                                    productManufacturer: products[i].productManufacturer,
                                    productName: products[i].productName,
                                    productPicture: products[i].productPicture,
                                    productPurchasePrice: products[i].productPurchasePrice,
                                    productSalePrice: products[i].productSalePrice,
                                    productStock: 0,
                                    productWholeSalePrice: products[i].productWholeSalePrice,
                                  );
                                  return AlertDialog(
                                      content: SizedBox(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  lang.S.of(context).addItems,
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Icon(
                                                      Icons.cancel,
                                                      color: kMainColor,
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 1,
                                            width: double.infinity,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    products[i].productName.toString(),
                                                    style: const TextStyle(fontSize: 16),
                                                  ),
                                                  Text(
                                                    products[i].brand?.brandName ?? '',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    lang.S.of(context).stock,
                                                    style: const TextStyle(fontSize: 16),
                                                  ),
                                                  Text(
                                                    products[i].productStock.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: AppTextField(
                                                  textFieldType: TextFieldType.NUMBER,
                                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                                                  onChanged: (value) {
                                                    tempProduct.productStock = num.tryParse(value);
                                                  },
                                                  decoration: InputDecoration(
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    labelText: lang.S.of(context).quantity,
                                                   // hintText: 'Enter quantity',
                                                    hintText: lang.S.of(context).enterQuantity,
                                                    border: const OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  initialValue: products[i].productPurchasePrice.toString(),
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                                                  onChanged: (value) {
                                                    tempProduct.productPurchasePrice = num.tryParse(value);
                                                  },
                                                  decoration: InputDecoration(
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    labelText: lang.S.of(context).purchasePrice,
                                                    border: const OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: TextFormField(
                                                  initialValue: products[i].productSalePrice.toString(),
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                                                  onChanged: (value) {
                                                    tempProduct.productSalePrice = num.tryParse(value);
                                                  },
                                                  decoration: InputDecoration(
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    labelText: lang.S.of(context).salePrice,
                                                    border: const OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  initialValue: products[i].productWholeSalePrice.toString(),
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                                                  onChanged: (value) {
                                                    tempProduct.productWholeSalePrice = num.tryParse(value);
                                                  },
                                                  decoration: InputDecoration(
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    labelText: lang.S.of(context).wholeSalePrice,
                                                    border: const OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: TextFormField(
                                                  initialValue: products[i].productDealerPrice.toString(),
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                                                  onChanged: (value) {
                                                    tempProduct.productDealerPrice = num.tryParse(value);
                                                  },
                                                  decoration: InputDecoration(
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    labelText: lang.S.of(context).dealerPrice,
                                                    border: const OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          GestureDetector(
                                            onTap: () {
                                              if ((tempProduct.productStock ?? 0) > 0) {
                                                providerData.addToCartRiverPod(tempProduct);
                                                providerData.addProductsInSales(products[i]);
                                                ref.refresh(productProvider);
                                                int count = 0;
                                                Navigator.popUntil(context, (route) {
                                                  return count++ == 2;
                                                });
                                              } else {
                                                EasyLoading.showError(
                                                  lang.S.of(context).pleaseAddQuantity,
                                                   // 'Please add quantity'
                                                );
                                              }
                                            },
                                            child: Container(
                                              height: 60,
                                              width: context.width(),
                                              decoration: const BoxDecoration(color: kMainColor, borderRadius: BorderRadius.all(Radius.circular(15))),
                                              child: Center(
                                                child: Text(
                                                  lang.S.of(context).save,
                                                  style: const TextStyle(fontSize: 18, color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                                });
                          },
                          child: ProductCard(
                            productTitle: products[i].productName.toString(),
                            productDescription: products[i].brand?.brandName ?? '',
                            stock: products[i].productStock.toString(),
                            productImage: products[i].productPicture,
                          ).visible(((products[i].productCode == productCode || productCode == '0000' || productCode == '-1') && productPrice != '0') ||
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

// ignore: must_be_immutable
class ProductCard extends StatefulWidget {
  ProductCard({Key? key, required this.productTitle, required this.productDescription, required this.stock, required this.productImage}) : super(key: key);

  // final Product product;
  String productTitle, productDescription, stock;
  String? productImage;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(cartNotifier);
      for (var element in providerData.cartItemList) {
        if (element.productName == widget.productTitle) {
          quantity = element.quantity;
        }
      }
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 50,
                width: 50,
                decoration: widget.productImage == null
                    ? BoxDecoration(
                        image: DecorationImage(image: AssetImage(noProductImageUrl), fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(90.0),
                      )
                    : BoxDecoration(
                        image: DecorationImage(image: NetworkImage("${APIConfig.domain}${widget.productImage}"), fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(90.0),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.productTitle,
                        style: GoogleFonts.jost(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.productDescription,
                    style: GoogleFonts.jost(
                      fontSize: 15.0,
                      color: kGreyTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  lang.S.of(context).stock,
                  style: GoogleFonts.jost(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
                Text(
                  widget.stock,
                  style: GoogleFonts.jost(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
