// ignore_for_file: unused_result
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Due%20Calculation/Model/due_collection_model.dart';
import 'package:mobile_pos/Screens/Due%20Calculation/Repo/due_repo.dart';
import 'package:mobile_pos/Screens/invoice_details/due_invoice_details.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/profile_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../Customers/Model/parties_model.dart';
import 'Model/due_collection_invoice_model.dart';
import 'Providers/due_provider.dart';

class DueCollectionScreen extends StatefulWidget {
  const DueCollectionScreen({Key? key, required this.customerModel}) : super(key: key);

  @override
  State<DueCollectionScreen> createState() => _DueCollectionScreenState();
  final Party customerModel;
}

class _DueCollectionScreenState extends State<DueCollectionScreen> {
  num paidAmount = 0;
  num remainDueAmount = 0;
  num dueAmount = 0;

  num calculateDueAmount({required num total}) {
    if (total < 0) {
      remainDueAmount = 0;
    } else {
      remainDueAmount = dueAmount - total;
    }
    return dueAmount - total;
  }

  TextEditingController paidText = TextEditingController();
  TextEditingController dateController = TextEditingController(text: DateTime.now().toString());

  SalesDuesInvoice? selectedInvoice;
  String paymentType = 'Cash';

  // List of items in our dropdown menu

  int count = 0;

  @override
  Widget build(BuildContext context) {
    count++;
    return Consumer(builder: (context, consumerRef, __) {
      // final printerData = consumerRef.watch(printerDueProviderNotifier);
      final personalData = consumerRef.watch(businessInfoProvider);
      final dueInvoiceData = consumerRef.watch(dueInvoiceListProvider(widget.customerModel.id?.round() ?? 0));
      return personalData.when(data: (data) {
        List<SalesDuesInvoice> items = [];
        num openingDueAmount = 0;
        return Scaffold(
          backgroundColor: kWhite,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              lang.S.of(context).collectDue,
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
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      dueInvoiceData.when(data: (data) {
                        num totalDueInInvoice = 0;
                        if (data.salesDues?.isNotEmpty ?? false) {
                          for (var element in data.salesDues!) {
                            totalDueInInvoice += element.dueAmount ?? 0;
                            items.add(element);
                          }
                        }

                        openingDueAmount = (data.due ?? 0) - totalDueInInvoice;

                        if (selectedInvoice == null) dueAmount = openingDueAmount;

                        return Container(
                          height: 60,
                          width: 180,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(05),
                            ),
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<SalesDuesInvoice>(
                                  isExpanded: true,
                                  value: selectedInvoice,
                                  hint:  Text(
                                    lang.S.of(context).selectAInvoice,
                                      //'Select a invoice'
                                  ),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: items.map((SalesDuesInvoice items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items.invoiceNumber.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      dueAmount = newValue?.dueAmount ?? 0;
                                      paidAmount = 0;
                                      paidText.clear();
                                      selectedInvoice = newValue;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      }, error: (e, stack) {
                        return Text(e.toString());
                      }, loading: () {
                        return const Center(child: CircularProgressIndicator());
                      }),
                      const SizedBox(width: 20),
                      Expanded(
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          readOnly: true,
                          controller: dateController,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).date,
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101),
                                  context: context,
                                );
                                if (picked != null) {
                                  setState(() {
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
                             lang.S.of(context).totalDueAmount,
                            //'Total Due amount ',
                          ),
                          Text(
                            widget.customerModel.due == null ? '$currency 0' : '$currency${widget.customerModel.due}',
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
                        initialValue: widget.customerModel.name,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: lang.S.of(context).customerName,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ],
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
                                lang.S.of(context).totalAmount,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                dueAmount.toString(),
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
                                  onChanged: (value) {
                                    if (value == '') {
                                      setState(() {
                                        paidAmount = 0;
                                      });
                                    } else {
                                      if (value.toDouble() <= dueAmount) {
                                        setState(() {
                                          paidAmount = double.parse(value);
                                        });
                                      } else {
                                        paidText.clear();
                                        setState(() {
                                          paidAmount = 0;
                                        });
                                        EasyLoading.showError(
                                          lang.S.of(context).youCanNotPayMoreThenDue,
                                           // 'You can\'t pay more then due'
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
                                lang.S.of(context).dueAmount,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                calculateDueAmount(total: paidAmount).toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
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
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).description,
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
                          child: Center(
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
                            if (paidAmount > 0 && dueAmount > 0) {
                              EasyLoading.show();
                              DueRepo repo = DueRepo();
                              DueCollection? dueData;
                              dueData = await repo.dueCollect(
                                ref: consumerRef,
                                context: context,
                                partyId: widget.customerModel.id ?? 0,
                                invoiceNumber: selectedInvoice?.invoiceNumber,
                                paymentDate: dateController.text,
                                paymentType: paymentType,
                                payDueAmount: paidAmount,
                              );

                              if (dueData != null) {
                                print(dueData.invoiceNumber);
                                print(dueData.party?.name);
                                print(dueData.party?.phone);
                                print(dueData.party?.phone);
                                print(dueData.paymentDate);
                                DueInvoiceDetails(
                                  dueCollection: dueData,
                                  personalInformationModel: data,
                                  isFromDue: true,
                                ).launch(context);
                              }
                            } else {
                              EasyLoading.showError(
                                lang.S.of(context).noDueSelected,
                                  //'No Due Selected'
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
