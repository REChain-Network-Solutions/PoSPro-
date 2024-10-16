// ignore_for_file: unused_result, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/add_to_cart.dart';
import 'package:mobile_pos/Provider/profile_provider.dart';
import 'package:mobile_pos/Screens/Sales/Repo/sales_repo.dart';
import 'package:mobile_pos/Screens/Sales/sales_products_list_screen.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Repository/API/future_invoice.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/business_info_model.dart' as b;
import '../../model/sale_transaction_model.dart';
import '../Customers/Model/parties_model.dart';
import '../Home/home.dart';
import '../Home/home_screen.dart';
import '../invoice_details/sales_invoice_details_screen.dart';

// ignore: must_be_immutable
class AddSalesScreen extends StatefulWidget {
  AddSalesScreen({Key? key, required this.customerModel}) : super(key: key);

  Party? customerModel;

  @override
  State<AddSalesScreen> createState() => _AddSalesScreenState();
}

class _AddSalesScreenState extends State<AddSalesScreen> {
  TextEditingController paidText = TextEditingController();
  int invoice = 0;
  double paidAmount = 0;
  double discountAmount = 0;
  double returnAmount = 0;
  double dueAmount = 0;
  double subTotal = 0;
  String? paymentType = 'Cash';
  String? selectedPaymentType;
  TextEditingController vatPercentageEditingController = TextEditingController();
  TextEditingController vatAmountEditingController = TextEditingController();

  double vatAmount = 0;

  bool isClicked = false;

  double calculateSubtotal({required double total}) {
    subTotal = total + vatAmount - discountAmount;
    return total + vatAmount - discountAmount;
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

  late b.BusinessInformation personalInformationModel;
  TextEditingController dateController = TextEditingController(text: DateTime.now().toString().substring(0, 10));
  TextEditingController phoneContoller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, consumerRef, __) {
      final providerData = consumerRef.watch(cartNotifier);
      final personalData = consumerRef.watch(businessInfoProvider);
      return personalData.when(data: (data) {
        personalInformationModel = data;
        return Scaffold(
          backgroundColor: kWhite,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              lang.S.of(context).addSales,
              style: GoogleFonts.poppins(
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 2.0,
            surfaceTintColor: kWhite,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      FutureBuilder(
                        future: FutureInvoice().getFutureInvoice(tag: 'sales'),
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
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: dateController,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).date,
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
                          Text(lang.S.of(context).dueAmount),
                          Text(
                            widget.customerModel?.due == null ? '$currency 0' : '$currency${widget.customerModel?.due}',
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
                        initialValue: widget.customerModel?.name ?? 'Guest',
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: lang.S.of(context).customerName,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      Visibility(
                        visible: widget.customerModel == null,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: AppTextField(
                            controller: phoneContoller,
                            textFieldType: TextFieldType.PHONE,
                            decoration: kInputDecoration.copyWith(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              //labelText: 'Customer Phone Number',
                              labelText: lang.S.of(context).customerPhoneNumber,
                              //hintText: 'Enter customer phone number',
                              hintText: lang.S.of(context).enterCustomerPhoneNumber,
                            ),
                          ),
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
                            itemCount: providerData.cartItemList.length,
                            itemBuilder: (context, index) {
                              providerData.controllers[index].text = (providerData.cartItemList[index].quantity.toString());
                              providerData.focus[index].addListener(
                                () {
                                  if (!providerData.focus[index].hasFocus) {
                                    setState(() {
                                      vatAmount = (vatPercentageEditingController.text.toDouble() / 100) * providerData.getTotalAmount().toDouble();
                                      vatAmountEditingController.text = vatAmount.toStringAsFixed(2);
                                    });
                                  }
                                },
                              );
                              return Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: Text(providerData.cartItemList[index].productName.toString()),
                                  subtitle: Text(
                                      '${providerData.cartItemList[index].quantity} X ${providerData.cartItemList[index].subTotal} = ${(double.parse(providerData.cartItemList[index].subTotal) * providerData.cartItemList[index].quantity).toStringAsFixed(2)}'),
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
                                                setState(() {
                                                  vatAmount = (vatPercentageEditingController.text.toDouble() / 100) * providerData.getTotalAmount().toDouble();
                                                  vatAmountEditingController.text = vatAmount.toStringAsFixed(2);
                                                });
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
                                                  num stock = providerData.cartItemList[index].stock ?? 1;
                                                  if (value.isEmpty || value == '0') {
                                                    value = '1';
                                                  } else if (num.tryParse(value) == null) {
                                                    return;
                                                  } else {
                                                    final newQuantity = num.parse(value);
                                                    if (newQuantity <= stock) {
                                                      providerData.cartItemList[index].quantity = newQuantity.round();
                                                    } else {
                                                      providerData.controllers[index].text = '1';
                                                      EasyLoading.showError(
                                                        lang.S.of(context).outOfStock,
                                                         // 'Out Of Stock'
                                                      );
                                                    }
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: providerData.focus[index].hasFocus ? null : providerData.cartItemList[index].quantity.toString()),
                                              ),
                                            ),
                                            // Text(
                                            //   '${providerData.cartItemList[index].quantity}',
                                            //   style: GoogleFonts.poppins(
                                            //     color: kGreyTextColor,
                                            //     fontSize: 15.0,
                                            //   ),
                                            // ),
                                            const SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: () {
                                                providerData.quantityIncrease(index);
                                                setState(() {
                                                  vatAmount = (vatPercentageEditingController.text.toDouble() / 100) * providerData.getTotalAmount().toDouble();
                                                  vatAmountEditingController.text = vatAmount.toStringAsFixed(2);
                                                });
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
                                          setState(() {
                                            vatAmount = (vatPercentageEditingController.text.toDouble() / 100) * providerData.getTotalAmount().toDouble();
                                            vatAmountEditingController.text = vatAmount.toStringAsFixed(2);
                                          });
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
                      SaleProductsList(
                        catName: null,
                        customerModel: widget.customerModel,
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
                                 lang.S.of(context).vat,
                               // 'VAT',
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
                                  const SizedBox(width: 4.0),
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
                                          lang.S.of(context).enterAValidDiscount
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
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () async {
                          const Home().launch(context, isNewTask: true);
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child:  Center(
                            child: Text(
                              lang.S.of(context).cancel,
                              //'Cancel',
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
                                SalesTransaction? saleData;
                                saleData = await repo.createSale(
                                  ref: consumerRef,
                                  context: context,
                                  totalAmount: subTotal,
                                  purchaseDate: selectedDate.toString(),
                                  products: selectedProductList,
                                  paymentType: paymentType ?? 'Cash',
                                  partyId: widget.customerModel?.id,
                                  customerPhone: widget.customerModel == null ? phoneContoller.text : null,
                                  vatAmount: vatAmount,
                                  vatPercent: vatPercentageEditingController.text.toInt(),
                                  isPaid: dueAmount <= 0 ? true : false,
                                  dueAmount: dueAmount <= 0 ? 0 : dueAmount,
                                  discountAmount: discountAmount,
                                  paidAmount: paidAmount,
                                );
                                if (saleData != null) {
                                  SalesInvoiceDetails(
                                    businessInfo: personalData.value!,
                                    saleTransaction: saleData,
                                    fromSale: true,
                                  ).launch(context);
                                }
                              } catch (e) {
                                EasyLoading.dismiss();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              }
                            } else {
                              EasyLoading.showError(
                                lang.S.of(context).addProductFirst,
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
                            child:  Center(
                              child: Text(
                                lang.S.of(context).save,
                                //'Save',
                                style: TextStyle(fontSize: 18, color: Colors.white),
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
