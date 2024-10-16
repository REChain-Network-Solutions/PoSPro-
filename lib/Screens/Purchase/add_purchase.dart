// ignore_for_file: unused_result, unused_local_variable

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Purchase/purchase_products.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/add_to_cart_purchase.dart';
import '../../Provider/print_purchase_invoice_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../Repository/API/future_invoice.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../Customers/Model/parties_model.dart';
import '../invoice_details/purchase_invoice_details.dart';
import 'Model/purchase_transaction_model.dart' as purchase;
import 'Repo/purchase_repo.dart';

class AddPurchaseScreen extends StatefulWidget {
  const AddPurchaseScreen({Key? key, required this.party}) : super(key: key);

  final Party party;

  @override
  State<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends State<AddPurchaseScreen> {
  TextEditingController paidText = TextEditingController();
  int invoice = 0;
  double paidAmount = 0;
  double discountAmount = 0;
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

  DateTime selectedDate = DateTime.now();

  TextEditingController dateController = TextEditingController(text: DateTime.now().toString().substring(0, 10));

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, consumerRef, __) {
      final providerData = consumerRef.watch(cartNotifierPurchase);
      final printerData = consumerRef.watch(printerPurchaseProviderNotifier);
      final personalData = consumerRef.watch(businessInfoProvider);
      return personalData.when(data: (businessInfo) {
        return Scaffold(
          backgroundColor: kWhite,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              lang.S.of(context).addPurchase,
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
                      FutureBuilder(
                        future: FutureInvoice().getFutureInvoice(tag: 'purchases'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Expanded(
                              child: AppTextField(
                                textFieldType: TextFieldType.NAME,
                                initialValue: snapshot.data.toString(),
                                readOnly: true,
                                decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: lang.S.of(context).inv,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            );
                          } else {
                            // return const CircularProgressIndicator();
                            return Expanded(
                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: lang.S.of(context).inv,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      // Expanded(
                      //   child: AppTextField(
                      //     textFieldType: TextFieldType.NAME,
                      //     readOnly: true,
                      //     initialValue: '',
                      //     decoration: InputDecoration(
                      //       floatingLabelBehavior: FloatingLabelBehavior.always,
                      //       labelText: lang.S.of(context).inv,
                      //       border: const OutlineInputBorder(),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: dateController,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).date,
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101),
                                  context: context,
                                );
                                if (picked != null && picked != selectedDate) {
                                  setState(() {
                                    selectedDate = picked;
                                    dateController.text = picked.toString();
                                  });
                                }
                              },
                              icon: const Icon(FeatherIcons.calendar),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                           Text(
                             lang.S.of(context).dueAmount
                               //'Due Amount: '
                           ),
                          Text(
                            widget.party.due == null ? '$currency 0' : '$currency${widget.party.due}',
                            style: const TextStyle(color: Color(0xFFFF8C34)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppTextField(
                        textFieldType: TextFieldType.NAME,
                        readOnly: true,
                        initialValue: widget.party.name,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: lang.S.of(context).supplierName,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ],
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
                              child: SizedBox(
                                width: context.width() / 1.35,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      lang.S.of(context).itemAdded,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      lang.S.of(context).quantity,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: providerData.cartItemPurchaseList.length,
                            itemBuilder: (context, index) {
                              providerData.controllers[index].text = providerData.cartItemPurchaseList[index].productStock.toString();
                              providerData.focus[index].addListener(() {
                                if(!providerData.focus[index].hasFocus){
                                  setState(() {

                                  });
                                }
                              },);
                              return Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: Text(providerData.cartItemPurchaseList[index].productName.toString()),
                                  subtitle: Text(
                                      '${providerData.cartItemPurchaseList[index].productStock} X ${providerData.cartItemPurchaseList[index].productPurchasePrice} = ${((providerData.cartItemPurchaseList[index].productStock ?? 0) * (providerData.cartItemPurchaseList[index].productPurchasePrice ?? 0)).toStringAsFixed(2)}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                providerData.quantityDecrease(index);
                                              },
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                decoration: const BoxDecoration(
                                                  color: kMainColor,
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    '-',
                                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            SizedBox(
                                              width: 30,
                                              child: TextFormField(
                                                onTap: () {
                                                  providerData.controllers[index].clear();
                                                },
                                                focusNode: providerData.focus[index],
                                                controller: providerData.controllers[index],
                                                textAlign: TextAlign.center,
                                                keyboardType: TextInputType.number,
                                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                                                onChanged: (value) {
                                                  // num stock = providerData.cartItemList[index].stock ?? 1;
                                                  if (value.isEmpty || value == '0') {
                                                    value = '1';
                                                  } else if (num.tryParse(value) == null) {
                                                    return;
                                                  } else {
                                                    final newQuantity = num.parse(value);
                                                    providerData.cartItemPurchaseList[index].productStock = newQuantity.round();
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: providerData.focus[index].hasFocus ? null : providerData.cartItemPurchaseList[index].productStock.toString()),
                                              ),
                                            ),
                                            // Text(
                                            //   providerData.cartItemPurchaseList[index].productStock.toString(),
                                            //   style: GoogleFonts.poppins(
                                            //     color: kGreyTextColor,
                                            //     fontSize: 15.0,
                                            //   ),
                                            // ),
                                            const SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: () {
                                                providerData.quantityIncrease(index);
                                              },
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                decoration: const BoxDecoration(
                                                  color: kMainColor,
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                ),
                                                child: const Center(
                                                    child: Text(
                                                  '+',
                                                  style: TextStyle(fontSize: 14, color: Colors.white),
                                                )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
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
                      PurchaseProducts(
                        catName: null,
                        customerModel: widget.party,
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
                      )),
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
                                providerData.getTotalAmount().toStringAsFixed(2),
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
                                  controller: paidText,
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
                                        paidText.clear();
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
                                calculateSubtotal(total: providerData.getTotalAmount()).toStringAsFixed(2),
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
                                calculateReturnAmount(total: subTotal).abs().toStringAsFixed(2),
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
                                calculateDueAmount(total: subTotal).toStringAsFixed(2),
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
                           // hintText: 'Add Note',
                            hintText: lang.S.of(context).addNote,
                            border: const OutlineInputBorder(),
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
                                const Icon(
                                  FeatherIcons.camera,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  lang.S.of(context).image,
                                  //'Image',
                                  style: const TextStyle(color: Colors.grey, fontSize: 16),
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
                        onTap: () async {
                          int count = 0;
                          Navigator.popUntil(context, (route) {
                            return count++ == 2;
                          });
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
                                purchase.PurchaseTransaction? purchaseData;
                                purchaseData = await repo.createPurchase(
                                  ref: consumerRef,
                                  context: context,
                                  totalAmount: subTotal,
                                  purchaseDate: selectedDate.toString(),
                                  products: selectedProductList,
                                  paymentType: paymentType ?? 'Cash',
                                  partyId: widget.party.id ?? 0,
                                  isPaid: dueAmount <= 0 ? true : false,
                                  dueAmount: dueAmount <= 0 ? 0 : dueAmount,
                                  discountAmount: discountAmount,
                                  paidAmount: paidAmount,
                                );

                                if (purchaseData != null) {
                                  providerData.clearCart();

                                  PurchaseInvoiceDetails(
                                    businessInfo: personalData.value!,
                                    transitionModel: purchaseData,
                                    isFromPurchase: true,
                                  ).launch(context);

                                  // const PurchaseListScreen().launch(context);
                                }
                              } catch (e) {
                                EasyLoading.dismiss();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              }
                            } else {
                              EasyLoading.showError(
                                lang.S.of(context).addProductFirst,
                                 // 'Add product first'
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
