import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/add_to_cart.dart';
import 'package:mobile_pos/Provider/print_sales_invoice_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/Screens/Sales%20List/sales_report_edit_screen.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:mobile_pos/model/print_transaction_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Provider/profile_provider.dart';
import '../../../constant.dart';
import '../../PDF Invoice/generate_pdf.dart';
import '../../currency.dart';
import '../Home/home.dart';
import '../Home/home_screen.dart';
import '../invoice_details/sales_invoice_details_screen.dart';

class SalesListScreen extends StatefulWidget {
  const SalesListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SalesListScreenState createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
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
            lang.S.of(context).saleList,
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
          final providerData = ref.watch(salesTransactionProvider);
          final profile = ref.watch(businessInfoProvider);
          final printerData = ref.watch(salesPrinterProvider);
          final personalData = ref.watch(businessInfoProvider);
          final cart = ref.watch(cartNotifier);
          return SingleChildScrollView(
            child: providerData.when(data: (transaction) {
              return transaction.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: transaction.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            SalesInvoiceDetails(
                              saleTransaction: transaction[index],
                              businessInfo: profile.value!,
                            ).launch(context);
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                width: context.width(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          transaction[index].party?.name ?? '',
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
                                          DateFormat.yMMMd().format(DateTime.parse(transaction[index].saleDate ?? '')),
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      ' ${lang.S.of(context).total} : $currency ${transaction[index].totalAmount.toString()}',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${lang.S.of(context).paid} : $currency ${transaction[index].totalAmount!.toDouble() - transaction[index].dueAmount!.toDouble()}',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${lang.S.of(context).due}: $currency ${transaction[index].dueAmount.toString()}',
                                          style: const TextStyle(fontSize: 16),
                                        ).visible(transaction[index].dueAmount!.toInt() != 0),
                                        personalData.when(data: (data) {
                                          return Row(
                                            children: [
                                              IconButton(
                                                  padding: EdgeInsets.zero,
                                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
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
                                                                          shrinkWrap: true,
                                                                          itemCount: printerData.availableBluetoothDevices.isNotEmpty ? printerData.availableBluetoothDevices.length : 0,
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
                                                                                    : toast(
                                                                                  lang.S.of(context).tryAgain,
                                                                                   // 'Try Again'
                                                                                );
                                                                              },
                                                                              title: Text('${printerData.availableBluetoothDevices[index]}'),
                                                                              subtitle:  Text(lang.S.of(context).clickToConnect,
                                                                                  //"Click to connect"
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                        const SizedBox(height: 10),
                                                                         Text(
                                                                           lang.S.of(context).connectYourPrinter
                                                                             //'Connect Your printer'
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
                                                                              style: const TextStyle(color: kMainColor),
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
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              IconButton(
                                                  padding: EdgeInsets.zero,
                                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                  onPressed: () => GeneratePdf().generateSaleDocument(transaction[index], data, context),
                                                  icon: const Icon(
                                                    Icons.picture_as_pdf,
                                                    color: Colors.grey,
                                                  )),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              IconButton(
                                                  padding: EdgeInsets.zero,
                                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                  onPressed: () {
                                                    cart.clearCart();
                                                    SalesReportEditScreen(
                                                      transitionModel: transaction[index],
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
                                         // return const Text('Loading');
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
                        lang.S.of(context).addSale,
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
