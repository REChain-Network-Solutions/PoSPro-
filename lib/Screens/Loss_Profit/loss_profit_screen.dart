import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/print_sales_invoice_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/Screens/Loss_Profit/single_loss_profit_screen.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:mobile_pos/model/print_transaction_model.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../Provider/profile_provider.dart';
import '../../../constant.dart';
import '../../currency.dart';
import '../Home/home.dart';
class LossProfitScreen extends StatefulWidget {
  const LossProfitScreen({Key? key, this.fromReport}) : super(key: key);
  final bool? fromReport;

  @override
  // ignore: library_private_types_in_public_api
  _LossProfitScreenState createState() => _LossProfitScreenState();
}

class _LossProfitScreenState extends State<LossProfitScreen> {
  TextEditingController fromDateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime(2021)));
  TextEditingController toDateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime.now()));
  DateTime fromDate = DateTime(2021);
  DateTime toDate = DateTime.now();
  double totalProfit = 0;
  double totalLoss = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await const Home().launch(context, isNewTask: true);
      },
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            (widget.fromReport ?? false) ? 'Loss/Profit Report' : lang.S.of(context).lp,
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Consumer(builder: (context, ref, __) {
                final providerData = ref.watch(salesTransactionProvider);
                final printerData = ref.watch(salesPrinterProvider);
                final personalData = ref.watch(businessInfoProvider);

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 20, bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                textFieldType: TextFieldType.NAME,
                                readOnly: true,
                                controller: fromDateTextEditingController,
                                decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: lang.S.of(context).fromDate,
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      final DateTime? picked = await showDatePicker(
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2015, 8),
                                        lastDate: DateTime(2101),
                                        context: context,
                                      );
                                      setState(() {
                                        fromDateTextEditingController.text = DateFormat.yMMMd().format(picked ?? DateTime.now());
                                        fromDate = picked!;
                                        totalLoss = 0;
                                        totalProfit = 0;
                                      });
                                    },
                                    icon: const Icon(FeatherIcons.calendar),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AppTextField(
                                textFieldType: TextFieldType.NAME,
                                readOnly: true,
                                controller: toDateTextEditingController,
                                decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: lang.S.of(context).toDate,
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      final DateTime? picked = await showDatePicker(
                                        initialDate: toDate,
                                        firstDate: DateTime(2015, 8),
                                        lastDate: DateTime(2101),
                                        context: context,
                                      );

                                      setState(() {
                                        toDateTextEditingController.text = DateFormat.yMMMd().format(picked ?? DateTime.now());
                                        picked!.isToday ? toDate = DateTime.now() : toDate = picked;
                                        totalLoss = 0;
                                        totalProfit = 0;
                                      });
                                    },
                                    icon: const Icon(FeatherIcons.calendar),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      providerData.when(data: (transaction) {
                        for (var element in transaction) {
                          if ((fromDate.isBefore(DateTime.parse(element.saleDate ?? '')) || DateTime.parse(element.saleDate ?? '').isAtSameMomentAs(fromDate)) &&
                              (toDate.isAfter(DateTime.parse(element.saleDate ?? '')) || DateTime.parse(element.saleDate ?? '').isAtSameMomentAs(toDate))) {
                            (element.detailsSumLossProfit ?? 0).isNegative
                                ? totalLoss = totalLoss + (element.detailsSumLossProfit ?? 0).abs()
                                : totalProfit = totalProfit + (element.detailsSumLossProfit ?? 0);
                          }
                        }

                        return transaction.isNotEmpty
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      height: 100,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: kMainColor.withOpacity(0.1),
                                          border: Border.all(width: 1, color: kMainColor),
                                          borderRadius: const BorderRadius.all(Radius.circular(15))),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                totalProfit.toString(),
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                lang.S.of(context).profit,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: 1,
                                            height: 60,
                                            color: kMainColor,
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                totalLoss.toString(),
                                                style: const TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                lang.S.of(context).loss,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: transaction.length,
                                    itemBuilder: (context, index) {
                                      return (fromDate.isBefore(DateTime.parse(transaction[index].saleDate ?? '')) ||
                                                  DateTime.parse(transaction[index].saleDate ?? '').isAtSameMomentAs(fromDate)) &&
                                              (toDate.isAfter(DateTime.parse(transaction[index].saleDate ?? '')) ||
                                                  DateTime.parse(transaction[index].saleDate ?? '').isAtSameMomentAs(toDate))
                                          ? GestureDetector(
                                              onTap: () {
                                                SingleLossProfitScreen(
                                                  transactionModel: transaction[index],
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
                                                              (transaction[index].party?.name != null)
                                                                  ? transaction[index].party?.name ?? ''
                                                                  : transaction[index].party?.phone ?? '',
                                                              style: const TextStyle(fontSize: 16),
                                                            ),
                                                            Text(
                                                              '#${transaction[index].invoiceNumber}',
                                                              style: const TextStyle(color: Colors.black),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 10),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              padding: const EdgeInsets.all(8),
                                                              decoration: BoxDecoration(
                                                                  color: transaction[index].dueAmount! <= 0
                                                                      ? const Color(0xff0dbf7d).withOpacity(0.1)
                                                                      : const Color(0xFFED1A3B).withOpacity(0.1),
                                                                  borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                              child: Text(
                                                                transaction[index].dueAmount! <= 0 ? lang.S.of(context).paid : lang.S.of(context).unPaid,
                                                                style: TextStyle(color: transaction[index].dueAmount! <= 0 ? const Color(0xff0dbf7d) : const Color(0xFFED1A3B)),
                                                              ),
                                                            ),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                Text(
                                                                  DateFormat.yMMMd().format(DateTime.parse(transaction[index].saleDate ?? '')),
                                                                  style: const TextStyle(color: Colors.grey),
                                                                ),
                                                                const SizedBox(height: 5),
                                                                Text(
                                                                  DateFormat.jm().format(DateTime.parse(transaction[index].saleDate ?? '')),
                                                                  style: const TextStyle(color: Colors.grey),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 5),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                              Text(
                                                                '${lang.S.of(context).total} : $currency ${transaction[index].totalAmount.toString()}',
                                                                style: const TextStyle(color: Colors.grey),
                                                              ),
                                                              const SizedBox(height: 5),
                                                              Text(
                                                                '${lang.S.of(context).profit} : $currency ${transaction[index].detailsSumLossProfit}',
                                                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                                              ).visible(!transaction[index].detailsSumLossProfit!.isNegative),
                                                              Text(
                                                                '${lang.S.of(context).loss}: $currency ${transaction[index].detailsSumLossProfit!.abs()}',
                                                                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                                                              ).visible(transaction[index].detailsSumLossProfit!.isNegative),
                                                            ]),
                                                            personalData.when(data: (data) {
                                                              return Row(
                                                                children: [
                                                                  IconButton(
                                                                      onPressed: () async {
                                                                        totalProfit = 0;
                                                                        totalLoss = 0;
                                                                        await printerData.getBluetooth();
                                                                        PrintTransactionModel model =
                                                                            PrintTransactionModel(transitionModel: transaction[index], personalInformationModel: data);
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
                                                                                                        : toast(lang.S.of(context).tryAgain);
                                                                                                  },
                                                                                                  title: Text('${printerData.availableBluetoothDevices[index]}'),
                                                                                                  subtitle: Text(lang.S.of(context).clickToConnect),
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(top: 20, bottom: 10),
                                                                                              child: Text(
                                                                                                lang.S.of(context).pleaseConnectYourBlutohPrinter,
                                                                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                            ),
                                                                                            const SizedBox(height: 10),
                                                                                            Container(height: 1, width: double.infinity, color: Colors.grey),
                                                                                            const SizedBox(height: 15),
                                                                                            GestureDetector(
                                                                                              onTap: () {
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                              child: Center(
                                                                                                child: Text(
                                                                                                  lang.S.of(context).cancel,
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
                                                                      onPressed: () => toast(
                                                                        lang.S.of(context).comingSoon,
                                                                          //'Coming Soon'
                                                                      ),
                                                                      icon: const Icon(
                                                                        FeatherIcons.share,
                                                                        color: Colors.grey,
                                                                      )).visible(false),
                                                                ],
                                                              );
                                                            }, error: (e, stack) {
                                                              return Text(e.toString());
                                                            }, loading: () {
                                                              //return const Text('Loading');
                                                              return  Text(
                                                                lang.S.of(context).loading,
                                                                  //'Loading'
                                                              );
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
                                            )
                                          : Container();
                                    },
                                  ),
                                ],
                              )
                            :  Padding(
                                padding: const EdgeInsets.only(top: 60),
                                child: Text(lang.S.of(context).pleaseMakeASaleFirst,
                                    //"Please make a sale first"
                                ),
                              );
                      }, error: (e, stack) {
                        return Text(e.toString());
                      }, loading: () {
                        return const Center(child: CircularProgressIndicator());
                      }),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
