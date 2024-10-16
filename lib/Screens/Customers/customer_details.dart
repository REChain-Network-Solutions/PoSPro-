// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Const/api_config.dart';
import 'package:mobile_pos/Provider/print_purchase_invoice_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/Screens/Customers/edit_customer.dart';
import 'package:mobile_pos/Screens/Customers/sms_sent_confirmation.dart';
import 'package:mobile_pos/Screens/Customers/transaction_screen.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../GlobalComponents/button_global.dart';
import '../../PDF Invoice/generate_pdf.dart';
import '../../Provider/print_sales_invoice_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../currency.dart';
import '../../model/print_transaction_model.dart';
import '../invoice_details/purchase_invoice_details.dart';
import '../invoice_details/sales_invoice_details_screen.dart';
import 'Model/parties_model.dart';
import 'Repo/parties_repo.dart';

// ignore: must_be_immutable
class CustomerDetails extends StatefulWidget {
  CustomerDetails({Key? key, required this.party}) : super(key: key);
  Party party;

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> showDeleteConfirmationAlert({
    required BuildContext context,
    required String id,
    required WidgetRef ref,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context1) {
        return AlertDialog(
          title:  Text(
            lang.S.of(context).confirmPassword,
              //'Confirm Delete'
          ),
          content:  Text(
            lang.S.of(context).areYouSureYouWant,
              //'Are you sure you want to delete this party?'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:  Text(
                lang.S.of(context).cancel,
                  //'Cancel'
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final party = PartyRepository();
                await party.deleteParty(id: id, context: context, ref: ref);
              },
              child:  Text(
                lang.S.of(context).delete,
                 // 'Delete',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  int selectedIndex=0;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, cRef, __) {
      final providerData = cRef.watch(salesTransactionProvider);
      final purchaseList = cRef.watch(purchaseTransactionProvider);
      final printerData = cRef.watch(salesPrinterProvider);
      final printerDataPurchase = cRef.watch(printerPurchaseProviderNotifier);
      final personalData = cRef.watch(businessInfoProvider);
      return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          surfaceTintColor: kWhite,
          backgroundColor: Colors.white,
          title: Text(
            widget.party.type != 'Supplier' ? lang.S.of(context).CustomerDetails : " Supplier Details",
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              visualDensity: const VisualDensity(horizontal: -4,vertical: -4),
              padding: EdgeInsets.zero,
              onPressed: () {
                EditCustomer(customerModel: widget.party).launch(context);
              },
              icon: const Icon(
                FeatherIcons.edit2,
                color: Colors.grey,
                size: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                visualDensity: const VisualDensity(horizontal: -4,vertical: -4),
                padding: EdgeInsets.zero,
                onPressed: () async {
                  await showDeleteConfirmationAlert(context: context, id: widget.party.id.toString(), ref: cRef);
                },
                icon: const Icon(
                  FeatherIcons.trash2,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ),
          ],
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    image: widget.party.image == null
                        ? const DecorationImage(
                            image: AssetImage('images/no_shop_image.png'),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: NetworkImage('${APIConfig.domain}${widget.party.image!}'),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.party.name ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.party.phone ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                // const SizedBox(height: 30),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     GestureDetector(
                //       onTap: () async {
                //         final Uri url = Uri.parse('tel:${widget.party.phone}');
                //         if (await canLaunchUrl(url)) {
                //           await launchUrl(url);
                //         }
                //         setState(() {
                //           selectedIndex=0;
                //         });
                //       },
                //       child: Container(
                //         height: 90,
                //         width: 110,
                //         decoration: BoxDecoration(color: selectedIndex==0?kMainColor: kMainColor.withOpacity(0.10), borderRadius: const BorderRadius.all(Radius.circular(10))),
                //         child:  Center(
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Icon(
                //                 FeatherIcons.phone,
                //                 size: 25,
                //                 color: selectedIndex==0?kWhite:  Colors.black,
                //               ),
                //               const SizedBox(height: 5),
                //               Text(
                //                 'Call',
                //                 style: TextStyle(
                //                   fontSize: 20,
                //                   color: selectedIndex==0?kWhite:  Colors.black,
                //                 ),
                //               )
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //     GestureDetector(
                //       onTap: () async {
                //         if (widget.party.type != 'Supplier') {
                //           showDialog(
                //             context: context,
                //             builder: (context1) {
                //               return SmsConfirmationPopup(
                //                 customerName: widget.party.name ?? '',
                //                 phoneNumber: widget.party.phone ?? '',
                //                 onCancel: () {
                //                   Navigator.pop(context1);
                //                 },
                //                 onSendSms: () async {
                //                   EasyLoading.show(status: 'SMS Sending..');
                //                   PartyRepository repo = PartyRepository();
                //                   await repo.sendCustomerUdeSms(id: widget.party.id!, context: context);
                //                 },
                //               );
                //             },
                //           );
                //         } else {
                //           final Uri url = Uri.parse('sms:${widget.party.phone}');
                //
                //           if (await canLaunchUrl(url)) {
                //             await launchUrl(url);
                //           }
                //         }
                //         setState(() {
                //           selectedIndex=1;
                //         });
                //       },
                //       child: Container(
                //         height: 90,
                //         width: 110,
                //         decoration: BoxDecoration(
                //           color: selectedIndex==1?kMainColor:kMainColor.withOpacity(0.10),
                //           borderRadius: const BorderRadius.all(
                //             Radius.circular(10),
                //           ),
                //         ),
                //         child:  Center(
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Icon(
                //                 FeatherIcons.messageSquare,
                //                 size: 25,
                //                 color:selectedIndex==1?kWhite: Colors.black,
                //               ),
                //               Text(
                //                 'Message',
                //                 style: TextStyle(
                //                   fontSize: 20,
                //                   color:selectedIndex==1?kWhite: Colors.black,
                //                 ),
                //               )
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //     GestureDetector(
                //       onTap: () async {
                //         setState(() {
                //           selectedIndex=2;
                //         });
                //       },
                //       child: Container(
                //         height: 90,
                //         width: 100,
                //         decoration: BoxDecoration(color: selectedIndex==2?kMainColor:kMainColor.withOpacity(0.10), borderRadius: const BorderRadius.all(Radius.circular(10))),
                //         child:  Center(
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Icon(
                //                 FeatherIcons.mail,
                //                 size: 25,
                //                 color: selectedIndex==2?kWhite: Colors.black,
                //               ),
                //               Text(
                //                 'Email',
                //                 style: TextStyle(
                //                   fontSize: 20,
                //                   color:selectedIndex==2?kWhite: Colors.black,
                //                 ),
                //               )
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang.S.of(context).recentTransaction,
                      style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20,),
                    widget.party.type != 'Supplier'
                        ? providerData.when(data: (transaction) {
                            return  ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: transaction.length,
                              itemBuilder: (context, index) {
                                return Visibility(
                                  visible: transaction[index].party?.id == widget.party.id,
                                  child: GestureDetector(
                                    onTap: () {
                                      SalesInvoiceDetails(
                                        businessInfo: personalData.value!,
                                        saleTransaction: transaction[index],
                                      ).launch(context);
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          // padding: const EdgeInsets.all(20),
                                          width: context.width(),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "${lang.S.of(context).totalProduct} : ${transaction[index].details!.length.toString()}",
                                                    style: const TextStyle(fontSize: 16),
                                                  ),
                                                  Text('#${transaction[index].invoiceNumber}'),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    // padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        color: transaction[index].dueAmount! <= 0 ? const Color(0xff0dbf7d).withOpacity(0.1) : const Color(0xFFED1A3B).withOpacity(0.1),
                                                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                    child: Text(
                                                      transaction[index].dueAmount! <= 0 ? lang.S.of(context).paid : lang.S.of(context).unPaid,
                                                      style: TextStyle(color: transaction[index].dueAmount! <= 0 ? const Color(0xff0dbf7d) : const Color(0xFFED1A3B)),
                                                    ),
                                                  ),
                                                  Text(
                                                    transaction[index].saleDate!.substring(0, 10),
                                                    style: const TextStyle(color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                '${lang.S.of(context).total} : $currency ${transaction[index].totalAmount.toString()}',
                                                style: const TextStyle(color: Colors.grey),
                                              ),
                                              personalData.when(data: (data) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${lang.S.of(context).due}: $currency ${transaction[index].dueAmount.toString()}',
                                                      style: const TextStyle(fontSize: 16),
                                                    ),
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                            onPressed: () async {
                                                              await printerData.getBluetooth();
                                                              PrintTransactionModel model = PrintTransactionModel(transitionModel: transaction[index], personalInformationModel: data);
                                                              connected
                                                                  ? printerData.printSalesTicket(
                                                                      printTransactionModel: model,
                                                                      productList: model.transitionModel!.details,
                                                                    )
                                                                  // ignore: use_build_context_synchronously
                                                                  : showDialog(
                                                                      context: context,
                                                                      builder: (_) {
                                                                        return WillPopScope(
                                                                          onWillPop: () async => false,
                                                                          child: Dialog(
                                                                            child: SizedBox(
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  ListView.builder(
                                                                                    padding: EdgeInsets.zero,
                                                                                    shrinkWrap: true,
                                                                                    itemCount: printerData.availableBluetoothDevices.isNotEmpty
                                                                                        ? printerData.availableBluetoothDevices.length
                                                                                        : 0,
                                                                                    itemBuilder: (context, index) {
                                                                                      return ListTile(
                                                                                        onTap: () async {
                                                                                          String select = printerData.availableBluetoothDevices[index];
                                                                                          List list = select.split("#");
                                                                                          // String name = list[0];
                                                                                          String mac = list[1];
                                                                                          bool isConnect = await printerData.setConnect(mac);
                                                                                          // ignore: use_build_context_synchronously
                                                                                          isConnect
                                                                                              // ignore: use_build_context_synchronously
                                                                                              ? finish(context)
                                                                                              : toast('Try Again');
                                                                                        },
                                                                                        title: Text('${printerData.availableBluetoothDevices[index]}'),
                                                                                        subtitle: const Text("Click to connect"),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                  const SizedBox(height: 10),
                                                                                  const Text('Connect Your printer'),
                                                                                  const SizedBox(height: 10),
                                                                                  Container(height: 1, width: double.infinity, color: Colors.grey),
                                                                                  const SizedBox(height: 15),
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: const Center(
                                                                                      child: Text(
                                                                                        'Cancel',
                                                                                        style: TextStyle(color: kMainColor),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(height: 15),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      });
                                                            },
                                                            icon: const Icon(
                                                              FeatherIcons.printer,
                                                              color: Colors.grey,
                                                            )),
                                                        IconButton(
                                                            onPressed: () => GeneratePdf().generateSaleDocument(transaction[index], data, context),
                                                            icon: const Icon(
                                                              Icons.picture_as_pdf,
                                                              color: Colors.grey,
                                                            )),
                                                        // IconButton(
                                                        //   onPressed: () {},
                                                        //   icon: const Icon(
                                                        //     FeatherIcons.share,
                                                        //     color: Colors.grey,
                                                        //   ),
                                                        // ),
                                                        // IconButton(
                                                        //     onPressed: () {},
                                                        //     icon: const Icon(
                                                        //       FeatherIcons.moreVertical,
                                                        //       color: Colors.grey,
                                                        //     )),
                                                      ],
                                                    )
                                                  ],
                                                );
                                              }, error: (e, stack) {
                                                return Text(e.toString());
                                              }, loading: () {
                                                return const Text('Loading');
                                              }),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 0.5,
                                          width: context.width(),
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }, error: (e, stack) {
                            return Text(e.toString());
                          }, loading: () {
                            return const Center(child: CircularProgressIndicator());
                          })
                        : purchaseList.when(data: (transaction) {
                            return transaction.isNotEmpty? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: transaction.length,
                              itemBuilder: (context, index) {
                                return Visibility(
                                  visible: transaction[index].party?.id == widget.party.id,
                                  child: GestureDetector(
                                    onTap: () {
                                      PurchaseInvoiceDetails(
                                        transitionModel: transaction[index],
                                        businessInfo: personalData.value!,
                                      ).launch(context);
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          // padding: const EdgeInsets.all(20),
                                          width: context.width(),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "${lang.S.of(context).totalProduct} : ${transaction[index].details!.length.toString()}",
                                                    style: const TextStyle(fontSize: 16),
                                                  ),
                                                  Text('#${transaction[index].invoiceNumber}'),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        color: transaction[index].dueAmount! <= 0 ? const Color(0xff0dbf7d).withOpacity(0.1) : const Color(0xFFED1A3B).withOpacity(0.1),
                                                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                    child: Text(
                                                      transaction[index].dueAmount! <= 0 ? lang.S.of(context).paid : lang.S.of(context).unPaid,
                                                      style: TextStyle(color: transaction[index].dueAmount! <= 0 ? const Color(0xff0dbf7d) : const Color(0xFFED1A3B)),
                                                    ),
                                                  ),
                                                  Text(
                                                    transaction[index].purchaseDate!.substring(0, 10),
                                                    style: const TextStyle(color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                '${lang.S.of(context).total} : $currency ${transaction[index].totalAmount.toString()}',
                                                style: const TextStyle(color: Colors.grey),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '${lang.S.of(context).due}: $currency ${transaction[index].dueAmount.toString()}',
                                                    style: const TextStyle(fontSize: 16),
                                                  ),
                                                  personalData.when(data: (data) {
                                                    return Row(
                                                      children: [
                                                        IconButton(
                                                            onPressed: () async {
                                                              ///________Print_______________________________________________________
                                                              await printerDataPurchase.getBluetooth();
                                                              PrintPurchaseTransactionModel model =
                                                                  PrintPurchaseTransactionModel(purchaseTransitionModel: transaction[index], personalInformationModel: data);
                                                              if (connected) {
                                                                await printerDataPurchase.printPurchaseThermalInvoice(
                                                                  printTransactionModel: model,
                                                                  productList: model.purchaseTransitionModel!.details,
                                                                );
                                                              } else {
                                                                // ignore: use_build_context_synchronously
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (_) {
                                                                      return WillPopScope(
                                                                        onWillPop: () async => false,
                                                                        child: Dialog(
                                                                          child: SizedBox(
                                                                            child: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  itemCount:
                                                                                      printerData.availableBluetoothDevices.isNotEmpty ? printerData.availableBluetoothDevices.length : 0,
                                                                                  itemBuilder: (context, index) {
                                                                                    return ListTile(
                                                                                      onTap: () async {
                                                                                        String select = printerData.availableBluetoothDevices[index];
                                                                                        List list = select.split("#");
                                                                                        // String name = list[0];
                                                                                        String mac = list[1];
                                                                                        bool isConnect = await printerData.setConnect(mac);
                                                                                        isConnect
                                                                                            // ignore: use_build_context_synchronously
                                                                                            ? finish(context)
                                                                                            : toast('Try Again');
                                                                                      },
                                                                                      title: Text('${printerData.availableBluetoothDevices[index]}'),
                                                                                      subtitle: const Text("Click to connect"),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                                const SizedBox(height: 10),
                                                                                const Text('Connect Your printer'),
                                                                                const SizedBox(height: 10),
                                                                                Container(height: 1, width: double.infinity, color: Colors.grey),
                                                                                const SizedBox(height: 15),
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: const Center(
                                                                                    child: Text(
                                                                                      'Cancel',
                                                                                      style: TextStyle(color: kMainColor),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(height: 15),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    });
                                                              }
                                                            },
                                                            icon: const Icon(
                                                              FeatherIcons.printer,
                                                              color: Colors.grey,
                                                            )),
                                                        IconButton(
                                                            onPressed: () => GeneratePdf().generatePurchaseDocument(transaction[index], data, context),
                                                            icon: const Icon(
                                                              Icons.picture_as_pdf,
                                                              color: Colors.grey,
                                                            )),
                                                        // IconButton(
                                                        //     onPressed: () {},
                                                        //     icon: const Icon(
                                                        //       FeatherIcons.share,
                                                        //       color: Colors.grey,
                                                        //     )),
                                                        // IconButton(
                                                        //     onPressed: () {},
                                                        //     icon: const Icon(
                                                        //       FeatherIcons.moreVertical,
                                                        //       color: Colors.grey,
                                                        //     )),
                                                      ],
                                                    );
                                                  }, error: (e, stack) {
                                                    return Text(e.toString());
                                                  }, loading: () {
                                                    return Text(lang.S.of(context).loading);
                                                  }),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 0.5,
                                          width: context.width(),
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ):const Text('No Transaction');
                          }, error: (e, stack) {
                            return Text(e.toString());
                          }, loading: () {
                            return const Center(child: CircularProgressIndicator());
                          }),
                  ],
                ),
              ],
            ),
          ),
        ),
        // bottomNavigationBar: ButtonGlobal(
        //   iconWidget: null,
        //   buttontext: lang.S.of(context).viewAll,
        //   iconColor: Colors.white,
        //   buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
        //   onPressed: () {
        //     Navigator.push(context, MaterialPageRoute(builder: (context)=>const CustomerAllTransactionScreen()));
        //   },
        // ),
      );
    });
  }
}
