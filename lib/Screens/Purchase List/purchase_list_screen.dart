import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/PDF%20Invoice/generate_pdf.dart';
import 'package:mobile_pos/Provider/print_purchase_invoice_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/Screens/Purchase%20List/purchase_list_edit_screen.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../../Provider/profile_provider.dart';
import '../../../constant.dart';
import '../../../model/print_transaction_model.dart';
import '../../Provider/add_to_cart_purchase.dart';
import '../../currency.dart';
import '../Home/home.dart';
import '../invoice_details/purchase_invoice_details.dart';

class PurchaseListScreen extends StatefulWidget {
  const PurchaseListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PurchaseReportState createState() => _PurchaseReportState();
}

class _PurchaseReportState extends State<PurchaseListScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await const Home().launch(context, isNewTask: true);
      },
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          title: Text(
            lang.S.of(context).purchaseList,
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
        body: Consumer(builder: (context, ref, __) {
          final providerData = ref.watch(purchaseTransactionProvider);
          final printerData = ref.watch(printerPurchaseProviderNotifier);
          final personalData = ref.watch(businessInfoProvider);
          final profile = ref.watch(businessInfoProvider);
          final cart = ref.watch(cartNotifierPurchase);

          return SingleChildScrollView(
            child: providerData.when(data: (reTransaction) {
              // final reTransaction = transaction.reversed.toList();
              return reTransaction.isNotEmpty
                  ? ListView.builder(
                    padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: reTransaction.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            PurchaseInvoiceDetails(
                              businessInfo: profile.value!,
                              transitionModel: reTransaction[index],
                            ).launch(context);
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                width: context.width(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          reTransaction[index].party?.name ?? '',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text('#${reTransaction[index].invoiceNumber}'),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: reTransaction[index].dueAmount! <= 0 ? const Color(0xff0dbf7d).withOpacity(0.1) : const Color(0xFFED1A3B).withOpacity(0.1),
                                              borderRadius: const BorderRadius.all(Radius.circular(10))),
                                          child: Text(
                                            reTransaction[index].dueAmount! <= 0 ? 'Paid' : 'Unpaid',
                                            style: TextStyle(color: reTransaction[index].dueAmount! <= 0 ? const Color(0xff0dbf7d) : const Color(0xFFED1A3B)),
                                          ),
                                        ),
                                        Text(
                                          DateFormat.yMMMd().format(DateTime.parse(reTransaction[index].purchaseDate ?? '')),
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${lang.S.of(context).total} : $currency ${reTransaction[index].totalAmount.toString()}',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${lang.S.of(context).paid} : $currency ${reTransaction[index].totalAmount!.toDouble() - reTransaction[index].dueAmount!.toDouble()}',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${lang.S.of(context).due}: $currency ${reTransaction[index].dueAmount.toString()}',
                                          style: const TextStyle(fontSize: 16),
                                        ).visible(reTransaction[index].dueAmount!.toInt() != 0),
                                        personalData.when(data: (data) {
                                          return Row(
                                            children: [
                                              IconButton(
                                                  padding: EdgeInsets.zero,
                                                  visualDensity: const VisualDensity(horizontal: -4,vertical: -4),
                                                  onPressed: () async {
                                                    ///________Print_______________________________________________________
                                                    await printerData.getBluetooth();
                                                    PrintPurchaseTransactionModel model =
                                                        PrintPurchaseTransactionModel(purchaseTransitionModel: reTransaction[index], personalInformationModel: data);
                                                    if (connected) {
                                                      await printerData.printPurchaseThermalInvoice(
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
                                                                                  : toast(lang.S.of(context).tryAgain,
                                                                                  //'Try Again'
                                                                              );
                                                                            },
                                                                            title: Text('${printerData.availableBluetoothDevices[index]}'),
                                                                            subtitle:  Text(
                                                                              lang.S.of(context).clickToConnect,
                                                                               // "Click to connect"
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                      const SizedBox(height: 10),
                                                                       Text(lang.S.of(context).connectYourPrinter,
                                                                          // 'Connect Your printer'
                                                                       ),
                                                                      const SizedBox(height: 10),
                                                                      Container(height: 1, width: double.infinity, color: Colors.grey),
                                                                      const SizedBox(height: 15),
                                                                      GestureDetector(
                                                                        onTap: () {
                                                                          Navigator.pop(context);
                                                                        },
                                                                        child:  Center(
                                                                          child: Text(
                                                                            lang.S.of(context).cancel,
                                                                           // 'Cancel',
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
                                              const SizedBox(width: 10,),
                                              IconButton(
                                                  padding: EdgeInsets.zero,
                                                  visualDensity: const VisualDensity(horizontal: -4,vertical: -4),
                                                  onPressed: () => GeneratePdf().generatePurchaseDocument(reTransaction[index], data, context),
                                                  icon: const Icon(
                                                    Icons.picture_as_pdf,
                                                    color: Colors.grey,
                                                  )),
                                              const SizedBox(width: 10,),
                                              IconButton(
                                                  padding: EdgeInsets.zero,
                                                  visualDensity: const VisualDensity(horizontal: -4,vertical: -4),
                                                  onPressed: () {
                                                    cart.clearCart();
                                                    PurchaseListEditScreen(
                                                      transitionModel: reTransaction[index],
                                                    ).launch(context);
                                                  },
                                                  icon: const Icon(
                                                    FeatherIcons.edit,
                                                    color: Colors.grey,
                                                  )),
                                            ],
                                          );
                                        }, error: (e, stack) {
                                          return Text(e.toString());
                                        }, loading: () {
                                          //return  Text('Loading');
                                          return  Text(lang.S.of(context).loading);
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
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        lang.S.of(context).addAPurchase,
                        maxLines: 2,
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    );
            }, error: (e, stack) {
              return Text(e.toString());
            }, loading: () {
              return const Center(child: CircularProgressIndicator());
            }),
          );
        }),
      ),
    );
  }
}
