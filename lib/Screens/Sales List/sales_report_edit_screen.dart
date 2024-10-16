// ignore_for_file: unused_result
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/add_to_cart.dart';
import 'package:mobile_pos/Provider/profile_provider.dart';
import 'package:mobile_pos/Screens/Sales%20List/sales_Edit_invoice_add_products.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:mobile_pos/model/sale_transaction_model.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../Provider/product_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/add_to_cart_model.dart';
import '../Sales/Repo/sales_repo.dart';

// ignore: must_be_immutable
class SalesReportEditScreen extends StatefulWidget {
  SalesReportEditScreen({Key? key, required this.transitionModel}) : super(key: key);
  SalesTransaction transitionModel;

  @override
  State<SalesReportEditScreen> createState() => _SalesReportEditScreenState();
}

class _SalesReportEditScreenState extends State<SalesReportEditScreen> {
  @override
  void initState() {
    // pastProducts = widget.transitionModel.productList!;
    // TODO: implement initState
    super.initState();
    transitionModel = widget.transitionModel;
    paidAmount = (widget.transitionModel.paidAmount ?? 0);
    discountAmount = widget.transitionModel.discountAmount!;
    paymentType = widget.transitionModel.paymentType;
    discountText.text = discountAmount.toString();
    paidText.text = paidAmount.toString();
    pastDue = widget.transitionModel.dueAmount!.toInt();
    vatAmount = widget.transitionModel.vatAmount ?? 0;
    vatAmountEditingController.text = vatAmount.toString();
    vatPercentageEditingController.text = widget.transitionModel.vatPercent.toString();
    // returnAmount = widget.transitionModel.returnAmount!;
    invoice = widget.transitionModel.invoiceNumber.toInt();
  }

  int pastDue = 0;

  TextEditingController discountText = TextEditingController();
  TextEditingController paidText = TextEditingController();

  int invoice = 0;
  num paidAmount = 0;
  num discountAmount = 0;
  num returnAmount = 0;
  num dueAmount = 0;
  num subTotal = 0;

  bool isGuestCustomer = false;

  List<AddToCartModel> pastProducts = [];
  List<AddToCartModel> presentProducts = [];
  List<AddToCartModel> increaseStockList = [];
  List<AddToCartModel> decreaseStockList = [];

  String? paymentType = 'Cash';
  String? selectedPaymentType;

  num calculateSubtotal({required num total}) {
    subTotal = total + vatAmount - discountAmount;
    return total + vatAmount - discountAmount;
  }

  num calculateReturnAmount({required num total}) {
    returnAmount = total - paidAmount;
    return paidAmount <= 0 || paidAmount <= subTotal ? 0 : total - paidAmount;
  }

  num calculateDueAmount({required num total}) {
    if (total < 0) {
      dueAmount = 0;
    } else {
      dueAmount = subTotal - paidAmount;
    }
    return returnAmount <= 0 ? 0 : subTotal - paidAmount;
  }

  TextEditingController vatPercentageEditingController = TextEditingController();
  TextEditingController vatAmountEditingController = TextEditingController();

  num vatAmount = 0;

  late SalesTransaction transitionModel = SalesTransaction(
      // customerName: widget.transitionModel.customerName,
      // customerPhone: '',
      // customerType: '',
      // invoiceNumber: invoice.toString(),
      // purchaseDate: DateTime.now().toString(),
      );
  DateTime selectedDate = DateTime.now();
  bool doNotCheckProducts = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, consumerRef, __) {
      final providerData = consumerRef.watch(cartNotifier);
      final personalData = consumerRef.watch(businessInfoProvider);
      final productList = consumerRef.watch(productProvider);

      if (!doNotCheckProducts) {
        List<AddToCartModel> list = [];
        productList.value?.forEach((products) {
          String sentProductPrice = '';

          widget.transitionModel.details?.forEach((element) {
            if (element.product!.id == products.id) {
              if (widget.transitionModel.party!.type!.contains('Retailer')) {
                sentProductPrice = products.productSalePrice.toString();
              } else if (widget.transitionModel.party!.type!.contains('Dealer')) {
                sentProductPrice = products.productDealerPrice.toString();
              } else if (widget.transitionModel.party!.type!.contains('Wholesaler')) {
                sentProductPrice = products.productWholeSalePrice.toString();
              } else if (widget.transitionModel.party!.type!.contains('Supplier')) {
                sentProductPrice = products.productPurchasePrice.toString();
              } else if (widget.transitionModel.party!.type!.contains('Guest')) {
                sentProductPrice = products.productSalePrice.toString();
                isGuestCustomer = true;
              }

              AddToCartModel cartItem = AddToCartModel(
                productName: products.productName,
                subTotal: sentProductPrice,
                uuid: element.productId ?? 0,
                quantity: element.quantities?.round() ?? 0,
                productId: products.productCode,
                productBrandName: products.brand?.brandName ?? '',
                stock: (products.productStock ?? 0).round(),
              );
              list.add(cartItem);

              // providerData.addProductsInSales(products);
            }
          });

          if (widget.transitionModel.details?.length == list.length) {
            providerData.addToCartRiverPodForEdit(list);
            doNotCheckProducts = true;
          }
        });
      }
      return personalData.when(data: (data) {
        // invoice = data.invoiceCounter!.toInt();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              lang.S.of(context).editSalesInvoice,
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
                            widget.transitionModel.saleDate ?? '',
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
                            itemCount: providerData.cartItemList.length,
                            itemBuilder: (context, index) {
                              int i = 0;
                              for (var element in pastProducts) {
                                if (element.productId != providerData.cartItemList[index].productId) {
                                  i++;
                                }
                                if (i == pastProducts.length) {
                                  bool isInTheList = false;
                                  for (var element in decreaseStockList) {
                                    if (element.productId == providerData.cartItemList[index].productId) {
                                      element.quantity = providerData.cartItemList[index].quantity;
                                      isInTheList = true;
                                      break;
                                    }
                                  }

                                  isInTheList ? null : decreaseStockList.add(providerData.cartItemList[index]);
                                }
                              }

                              return Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: Text(providerData.cartItemList[index].productName.toString()),
                                  subtitle: Text(
                                      '${providerData.cartItemList[index].quantity} X ${providerData.cartItemList[index].subTotal} = ${double.parse(providerData.cartItemList[index].subTotal) * providerData.cartItemList[index].quantity}'),
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
                                            Text(
                                              '${providerData.cartItemList[index].quantity}',
                                              style: GoogleFonts.poppins(
                                                color: kGreyTextColor,
                                                fontSize: 15.0,
                                              ),
                                            ),
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
                                          int i = 0;
                                          for (var element in pastProducts) {
                                            if (element.productId != providerData.cartItemList[index].productId) {
                                              i++;
                                            }
                                            if (i == pastProducts.length) {
                                              decreaseStockList.removeWhere((element) => element.productId == providerData.cartItemList[index].productId);
                                            }
                                          }

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
                    ).visible(providerData.cartItemList.isNotEmpty),
                  ),
                  const SizedBox(height: 20),

                  ///_______Add_Button__________________________________________________
                  GestureDetector(
                    onTap: () {
                      EditSaleInvoiceSaleProducts(
                        catName: null,
                        salesInfo: widget.transitionModel,
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
                                providerData.getTotalAmount().toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),

                        ///_________Vat__________________________________________
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Text(
                                 lang.S.of(context).vat,
                                //'VAT',
                                style: TextStyle(fontSize: 16),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: context.width() / 4,
                                    height: 40.0,
                                    child: Center(
                                      child: AppTextField(
                                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                                        controller: vatPercentageEditingController,
                                        onChanged: (value) {
                                          if (value == '') {
                                            setState(() {
                                              vatAmountEditingController.text = 0.toString();
                                              vatAmount = 0;
                                            });
                                          } else {
                                            setState(() {
                                              vatAmount = (value.toDouble() / 100) * providerData.getTotalAmount().toDouble();
                                              vatAmountEditingController.text = vatAmount.toStringAsFixed(2);
                                            });
                                          }
                                        },
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.only(right: 6.0),
                                          hintText: '0',
                                          border: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: Color(0xFFff5f00))),
                                          enabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: Color(0xFFff5f00))),
                                          disabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: Color(0xFFff5f00))),
                                          focusedBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: Color(0xFFff5f00))),
                                          prefixIconConstraints: const BoxConstraints(maxWidth: 30.0, minWidth: 30.0),
                                          prefixIcon: Container(
                                            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                            height: 40,
                                            decoration: const BoxDecoration(
                                                color: Color(0xFFff5f00), borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), bottomLeft: Radius.circular(4.0))),
                                            child: const Text(
                                              '%',
                                              style: TextStyle(fontSize: 18.0, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        textFieldType: TextFieldType.PHONE,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4.0,
                                  ),
                                  SizedBox(
                                    width: context.width() / 4,
                                    height: 40.0,
                                    child: Center(
                                      child: AppTextField(
                                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                                        controller: vatAmountEditingController,
                                        onChanged: (value) {
                                          if (value == '') {
                                            setState(() {
                                              vatAmount = 0;
                                              vatPercentageEditingController.clear();
                                            });
                                          } else {
                                            setState(() {
                                              vatAmount = double.parse(value);
                                              vatPercentageEditingController.text = ((vatAmount * 100) / providerData.getTotalAmount()).toStringAsFixed(2);
                                            });
                                          }
                                        },
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.only(right: 6.0),
                                          hintText: '0',
                                          border: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                          enabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                          disabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                          focusedBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                          prefixIconConstraints: const BoxConstraints(maxWidth: 30.0, minWidth: 30.0),
                                          prefixIcon: Container(
                                            alignment: Alignment.center,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                                color: kMainColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), bottomLeft: Radius.circular(4.0))),
                                            child: Text(
                                              currency,
                                              style: const TextStyle(fontSize: 14.0, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        textFieldType: TextFieldType.PHONE,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        ///___Discount____________________________________________
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
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
                                lang.S.of(context).previousPayAmount,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${widget.transitionModel.paidAmount}',
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
                  const SizedBox(height: 30),
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
                        ),
                      ),
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
                            if (providerData.cartItemList.isNotEmpty) {
                              try {
                                EasyLoading.show(status:
                                    lang.S.of(context).loading,
                                //'Loading...',
                                    dismissOnTap: false);
                                List<CartSaleProducts> selectedProductList = [];

                                for (var element in providerData.cartItemList) {
                                  selectedProductList.add(
                                    CartSaleProducts(
                                      productId: element.uuid.toInt(),
                                      quantities: element.quantity.toInt(),
                                      price: (num.tryParse(element.subTotal.toString()) ?? 0),
                                      lossProfit: (element.quantity * (num.tryParse(element.subTotal.toString()) ?? 0)) -
                                          (element.quantity * (num.tryParse(element.productPurchasePrice.toString()) ?? 0)),
                                    ),
                                  );
                                }

                                SaleRepo repo = SaleRepo();
                                await repo.updateSale(
                                  id: widget.transitionModel.id ?? 0,
                                  ref: consumerRef,
                                  context: context,
                                  totalAmount: subTotal,
                                  purchaseDate: selectedDate.toString(),
                                  products: selectedProductList,
                                  paymentType: paymentType ?? 'Cash',
                                  partyId: widget.transitionModel.party?.id,
                                  vatAmount: vatAmount,
                                  vatPercent: num.tryParse(vatPercentageEditingController.text) ?? 0,
                                  isPaid: dueAmount <= 0 ? true : false,
                                  dueAmount: dueAmount <= 0 ? 0 : dueAmount,
                                  discountAmount: discountAmount,
                                  paidAmount: paidAmount,
                                );
                              } catch (e) {
                                EasyLoading.dismiss();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              }
                            } else {
                              EasyLoading.showError(
                                lang.S.of(context).addProductFirst
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
