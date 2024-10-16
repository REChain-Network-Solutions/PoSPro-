// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Screens/Products/Model/product_model.dart';
import 'package:mobile_pos/Screens/Purchase%20List/purchase_edit_invoice_add_productes.dart';
import 'package:mobile_pos/Screens/Purchase%20List/purchase_list_screen.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/add_to_cart_purchase.dart';
import '../../Provider/product_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../constant.dart';
import '../Customers/Model/parties_model.dart' as party;
import '../Purchase/Model/purchase_transaction_model.dart';
import '../Purchase/Repo/purchase_repo.dart';

class PurchaseListEditScreen extends StatefulWidget {
  const PurchaseListEditScreen({Key? key, required this.transitionModel}) : super(key: key);

  final PurchaseTransaction transitionModel;

  @override
  State<PurchaseListEditScreen> createState() => _PurchaseListEditScreenState();
}

class _PurchaseListEditScreenState extends State<PurchaseListEditScreen> {
  @override
  void initState() {
    // pastProducts = widget.transitionModel.details!;
    transitionModel = widget.transitionModel;
    paidAmount = double.parse(widget.transitionModel.paidAmount.toString());
    paymentType = widget.transitionModel.paymentType;
    discountAmount = widget.transitionModel.discountAmount!;
    discountText.text = discountAmount.toString();
    paidText.text = paidAmount.toString();
    pastDue = widget.transitionModel.dueAmount!.toInt();
    // returnAmount = widget.transitionModel.returnAmount!;
    invoice = widget.transitionModel.invoiceNumber.toInt();
    // TODO: implement initState
    super.initState();
  }

  int pastDue = 0;

  late PurchaseTransaction transitionModel = PurchaseTransaction(
    // customerName: widget.transitionModel.customerName,
    // customerPhone: widget.transitionModel.customerPhone,
    // customerType: widget.transitionModel.customerType,
    invoiceNumber: invoice.toString(),
    purchaseDate: DateTime.now().toString(),
  );

  List<ProductModel> pastProducts = [];
  List<ProductModel> presentProducts = [];
  List<ProductModel> decreaseStockList2 = [];
  List<ProductModel> increaseStockList = [];

  TextEditingController discountText = TextEditingController();
  TextEditingController paidText = TextEditingController();

  int invoice = 0;
  double paidAmount = 0;
  num discountAmount = 0;
  double returnAmount = 0;
  double dueAmount = 0;
  double subTotal = 0;
  String? paymentType = 'Cash';

  double calculateSubtotal({required double total}) {
    subTotal = total - discountAmount;
    return total - discountAmount;
  }

  double calculateReturnAmount({required double total}) {
    returnAmount = total - paidAmount;
    return paidAmount <= 0 || paidAmount <= subTotal ? 0 : total - paidAmount;
  }

  double calculateDueAmount({required double total}) {
    if (total < 0) {
      dueAmount = 0;
    } else {
      dueAmount = subTotal - paidAmount;
    }
    return returnAmount <= 0 ? 0 : subTotal - paidAmount;
  }

  bool doNotCheckProducts = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, consumerRef, __) {
      final providerData = consumerRef.watch(cartNotifierPurchase);
      final personalData = consumerRef.watch(businessInfoProvider);
      final productList = consumerRef.watch(productProvider);

      ///__________Add_previous_products_in_the_List___________________________________________

      if (!doNotCheckProducts) {
        List<ProductModel> cartList = [];
        for (var element in widget.transitionModel.details!) {
          productList.value?.forEach((products) {
            if (element.productId == products.id) {
              ProductModel tempProduct = ProductModel(
                type: products.type,
                weight: products.weight,
                size: products.size,
                color: products.color,
                capacity: products.capacity,
                category: products.category,
                unitId: products.unitId,
                id: products.id,
                brand: products.brand,
                brandId: products.unitId,
                businessId: products.businessId,
                categoryId: products.categoryId,
                createdAt: products.createdAt,
                unit: products.unit,
                updatedAt: products.updatedAt,
                productCode: products.productCode,
                productDealerPrice: products.productDealerPrice,
                productDiscount: products.productDiscount,
                productManufacturer: products.productManufacturer,
                productName: products.productName,
                productPicture: products.productPicture,
                productPurchasePrice: products.productPurchasePrice,
                productSalePrice: products.productSalePrice,
                productStock: element.quantities,
                productWholeSalePrice: products.productWholeSalePrice,
              );
              // ProductModel cartItem = products;
              // cartItem.productStock = element.quantities;
              cartList.add(tempProduct);
              providerData.addToCartRiverPod(tempProduct);
              // consumerRef.refresh(productProvider);
            }
          });
          if (widget.transitionModel.details?.length == cartList.length) {
            // providerData.addToCartRiverPodForEdit(cartList);
            doNotCheckProducts = true;
            consumerRef.refresh(productProvider);
          }
        }
      }
      return personalData.when(data: (data) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              lang.S.of(context).editPurchaseInvoice,
              style: GoogleFonts.poppins(
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          readOnly: true,
                          initialValue: widget.transitionModel.invoiceNumber,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).inv,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          readOnly: true,
                          initialValue: DateFormat.yMMMd().format(DateTime.parse(
                            widget.transitionModel.purchaseDate ?? '',
                          )),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).date,
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () async {},
                              icon: const Icon(FeatherIcons.calendar),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    readOnly: true,
                    initialValue: widget.transitionModel.party?.name ?? '',
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: lang.S.of(context).customerName,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ///_______Added_ItemS__________________________________________________
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      border: Border.all(width: 1, color: const Color(0xffEAEFFA)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xffEAEFFA),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              lang.S.of(context).itemAdded,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: providerData.cartItemPurchaseList.length,
                            itemBuilder: (context, index) {
                              int i = 0;
                              for (var element in pastProducts) {
                                if (element.productCode != providerData.cartItemPurchaseList[index].productCode) {
                                  i++;
                                }
                                if (i == pastProducts.length) {
                                  bool isInTheList = false;
                                  for (var element in increaseStockList) {
                                    if (element.productCode == providerData.cartItemPurchaseList[index].productCode) {
                                      element.productStock = providerData.cartItemPurchaseList[index].productStock;
                                      isInTheList = true;
                                      break;
                                    }
                                  }

                                  isInTheList ? null : increaseStockList.add(providerData.cartItemPurchaseList[index]);
                                }
                              }
                              return Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: Text(providerData.cartItemPurchaseList[index].productName.toString()),
                                  subtitle: Text(
                                      '${providerData.cartItemPurchaseList[index].productStock} X ${providerData.cartItemPurchaseList[index].productPurchasePrice} = ${(providerData.cartItemPurchaseList[index].productStock ?? 0) * (providerData.cartItemPurchaseList[index].productPurchasePrice ?? 0)}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(' ${lang.S.of(context).quantity}: ${providerData.cartItemPurchaseList[index].productStock}'),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          providerData.deleteToCart(index);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          color: Colors.red.withOpacity(0.1),
                                          child: const Icon(
                                            Icons.delete,
                                            size: 20,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ],
                    ).visible(providerData.cartItemPurchaseList.isNotEmpty),
                  ),
                  const SizedBox(height: 20),

                  ///_______Add_Button__________________________________________________
                  GestureDetector(
                    onTap: () {
                      EditPurchaseInvoiceSaleProducts(
                        catName: null,
                        customerModel: party.Party(type:
                            lang.S.of(context).retailer,
                        //'Retailer'
                        ),
                        purchaseTransaction: widget.transitionModel,
                      ).launch(context);
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(color: kMainColor.withOpacity(0.1), borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Text(
                          lang.S.of(context).addItems,
                          style: const TextStyle(color: kMainColor, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ///_____Total______________________________
                  Container(
                    decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.grey.shade300, width: 1)),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(color: Color(0xffEAEFFA), borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lang.S.of(context).subTotal,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                providerData.getTotalAmount().toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lang.S.of(context).discount,
                                style: const TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                width: context.width() / 4,
                                child: TextField(
                                  controller: discountText,
                                  onChanged: (value) {
                                    if (value == '') {
                                      setState(() {
                                        discountAmount = 0;
                                      });
                                    } else {
                                      if (value.toInt() <= providerData.getTotalAmount()) {
                                        setState(() {
                                          discountAmount = double.parse(value);
                                        });
                                      } else {
                                        discountText.clear();
                                        setState(() {
                                          discountAmount = 0;
                                        });
                                        EasyLoading.showError(
                                          lang.S.of(context).enterAValidDiscount,
                                            //'Enter a valid Discount'
                                        );
                                      }
                                    }
                                  },
                                  textAlign: TextAlign.right,
                                  decoration: const InputDecoration(
                                    hintText: '0',
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lang.S.of(context).total,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                calculateSubtotal(total: providerData.getTotalAmount()).toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lang.S.of(context).paidAmount,
                                style: const TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                width: context.width() / 4,
                                child: TextField(
                                  controller: paidText,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (value == '') {
                                      setState(() {
                                        paidAmount = 0;
                                      });
                                    } else {
                                      setState(() {
                                        paidAmount = double.parse(value);
                                      });
                                    }
                                  },
                                  textAlign: TextAlign.right,
                                  decoration: const InputDecoration(hintText: '0'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lang.S.of(context).returnAmount,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                calculateReturnAmount(total: subTotal).abs().toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lang.S.of(context).dueAmount,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                calculateDueAmount(total: subTotal).toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).paymentTypes,
                            style: const TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.wallet,
                            color: Colors.green,
                          )
                        ],
                      ),
                      DropdownButton(
                        value: paymentType,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: paymentsTypeList.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            paymentType = newValue.toString();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration:  InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            //labelText: 'Description',
                            labelText: lang.S.of(context).description,
                            //hintText: 'Add Note',
                            hintText: lang.S.of(context).addNote,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                          height: 60,
                          width: 100,
                          decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), color: Colors.grey.shade200),
                          child:  Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  FeatherIcons.camera,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  lang.S.of(context).image,
                                  //'Image',
                                  style: TextStyle(color: Colors.grey, fontSize: 16),
                                )
                              ],
                            ),
                          )),
                    ],
                  ).visible(false),
                  Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                            child: Text(
                              lang.S.of(context).cancel,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      )),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            if (providerData.cartItemPurchaseList.isNotEmpty) {
                              try {
                                EasyLoading.show(status:
                                    lang.S.of(context).loading,
                                //'Loading...',
                                    dismissOnTap: false);
                                List<CartProducts> selectedProductList = [];

                                for (var element in providerData.cartItemPurchaseList) {
                                  selectedProductList.add(
                                    CartProducts(
                                      productId: element.id ?? 0,
                                      quantities: element.productStock,
                                      productWholeSalePrice: element.productWholeSalePrice,
                                      productSalePrice: element.productSalePrice,
                                      productPurchasePrice: element.productPurchasePrice,
                                      productDealerPrice: element.productDealerPrice,
                                    ),
                                  );
                                }

                                PurchaseRepo repo = PurchaseRepo();
                                PurchaseTransaction? purchaseData;
                                purchaseData = await repo.updatePurchase(
                                  id: widget.transitionModel.id!,
                                  ref: consumerRef,
                                  context: context,
                                  totalAmount: subTotal,
                                  purchaseDate: widget.transitionModel.purchaseDate ?? '',
                                  products: selectedProductList,
                                  paymentType: paymentType ?? 'Cash',
                                  partyId: widget.transitionModel.party?.id ?? 0,
                                  isPaid: dueAmount <= 0 ? true : false,
                                  dueAmount: dueAmount <= 0 ? 0 : dueAmount,
                                  discountAmount: discountAmount,
                                  paidAmount: paidAmount,
                                );

                                if (purchaseData != null) {
                                  providerData.clearCart();
                                  const PurchaseListScreen().launch(context);
                                }
                              } catch (e) {
                                EasyLoading.dismiss();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              }
                            } else {
                              EasyLoading.showError(lang.S.of(context).addProductFirst,
                                  //'Add product first'
                              );
                            }
                          },
                          child: Container(
                            height: 60,
                            decoration: const BoxDecoration(
                              color: kMainColor,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(
                              child: Text(
                                lang.S.of(context).save,
                                style: const TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }, error: (e, stack) {
        return Center(
          child: Text(e.toString()),
        );
      }, loading: () {
        return const Center(child: CircularProgressIndicator());
      });
    });
  }
}
