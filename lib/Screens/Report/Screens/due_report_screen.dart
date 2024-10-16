import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../../PDF Invoice/generate_pdf.dart';
import '../../../Provider/printer_due_provider.dart';
import '../../../Provider/profile_provider.dart';
import '../../../constant.dart';
import '../../../currency.dart';
import '../../../model/print_transaction_model.dart';
import '../../Due Calculation/Providers/due_provider.dart';
import '../../invoice_details/due_invoice_details.dart';

class DueReportScreen extends StatefulWidget {
  const DueReportScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DueReportScreenState createState() => _DueReportScreenState();
}

class _DueReportScreenState extends State<DueReportScreen> {
  TextEditingController fromDateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime(DateTime.now().year, DateTime.now().month, 1)));
  TextEditingController toDateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime.now()));
  DateTime fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime toDate = DateTime.now();
  double totalReceiveDue = 0;
  double totalPaidDue = 0;
  List<String> timeLimit = ['ToDay', 'This Week', 'This Month', 'This Year', 'All Time', 'Custom'];
  String? dropdownValue = 'This Month';

  void changeDate({required DateTime from}) {
    setState(() {
      fromDate = from;
      fromDateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(from));

      toDate = DateTime.now();
      toDateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)));
    });
  }

  @override
  Widget build(BuildContext context) {
    totalReceiveDue = 0;
    totalPaidDue = 0;
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: Text(
          lang.S.of(context).dueReport,
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
        final providerData = ref.watch(dueCollectionListProvider);
        final printerData = ref.watch(printerDueProviderNotifier);
        final personalData = ref.watch(businessInfoProvider);
        final profile = ref.watch(businessInfoProvider);
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
                                totalReceiveDue = 0;
                                totalPaidDue = 0;
                                dropdownValue = 'Custom';
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
                                totalReceiveDue = 0;
                                totalPaidDue = 0;
                                dropdownValue = 'Custom';
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
                  if ((fromDate.isBefore(DateTime.parse(element.paymentDate ?? '')) || DateTime.parse(element.paymentDate ?? '').isAtSameMomentAs(fromDate)) &&
                      (toDate.isAfter(DateTime.parse(element.paymentDate ?? '')) || DateTime.parse(element.paymentDate ?? '').isAtSameMomentAs(toDate))) {
                    element.party?.type != 'Supplier' ? totalReceiveDue += element.payDueAmount ?? 0 : totalPaidDue += element.payDueAmount ?? 0;
                  }
                }
                return transaction.isNotEmpty
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: const BorderRadius.all(Radius.circular(8))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  underline: null,
                                  // underline: const Divider(color: Colors.black),
                                  value: dropdownValue,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: timeLimit.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      dropdownValue = newValue.toString();

                                      switch (newValue) {
                                        case 'ToDay':
                                          changeDate(from: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
                                          break;
                                        case 'This Week':
                                          changeDate(from: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().weekday));
                                          break;
                                        case 'This Month':
                                          changeDate(from: DateTime(DateTime.now().year, DateTime.now().month, 1));
                                          break;
                                        case 'This Year':
                                          changeDate(from: DateTime(DateTime.now().year, 1, 1));
                                          break;
                                        case 'All Time':
                                          changeDate(from: DateTime(2020, 1, 1));
                                          break;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                            child: Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: kMainColor.withOpacity(0.1), border: Border.all(width: 1, color: kMainColor), borderRadius: const BorderRadius.all(Radius.circular(15))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        totalReceiveDue.toString(),
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                       SizedBox(
                                        width: 120,
                                        child: Text(
                                          lang.S.of(context).customerPay,
                                          //'Customer Pay',
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
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
                                        totalPaidDue.toString(),
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                       SizedBox(
                                        width: 100,
                                        child: Text(
                                          lang.S.of(context).supplerPay,
                                         // 'Suppler Pay',
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Container(
                                  //   width: 1,
                                  //   height: 60,
                                  //   color: kMainColor,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: transaction.length,
                            itemBuilder: (context, index) {
                              return Visibility(
                                visible: (fromDate.isBefore(DateTime.parse(transaction[index].paymentDate ?? '')) ||
                                        DateTime.parse(transaction[index].paymentDate ?? '').isAtSameMomentAs(fromDate)) &&
                                    (toDate.isAfter(DateTime.parse(transaction[index].paymentDate ?? '')) ||
                                        DateTime.parse(transaction[index].paymentDate ?? '').isAtSameMomentAs(toDate)),
                                child: GestureDetector(
                                  onTap: () {
                                    DueInvoiceDetails(
                                      dueCollection: transaction[index],
                                      personalInformationModel: profile.value!,
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
                                                Row(
                                                  children: [
                                                    Text(
                                                      transaction[index].party?.name ?? '',
                                                      style: const TextStyle(fontSize: 16),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Visibility(
                                                      visible: transaction[index].party?.type == 'Supplier',
                                                      child: const Text(
                                                        '[S]',
                                                        style: TextStyle(
                                                            //fontSize: 16,
                                                            color: kMainColor),
                                                      ),
                                                    )
                                                  ],
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
                                                      color: transaction[index].dueAmountAfterPay! <= 0
                                                          ? const Color(0xff0dbf7d).withOpacity(0.1)
                                                          : const Color(0xFFED1A3B).withOpacity(0.1),
                                                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                  child: Text(
                                                    transaction[index].dueAmountAfterPay! <= 0 ? lang.S.of(context).fullyPaid : lang.S.of(context).stillUnpaid,
                                                    style: TextStyle(color: transaction[index].dueAmountAfterPay! <= 0 ? const Color(0xff0dbf7d) : const Color(0xFFED1A3B)),
                                                  ),
                                                ),
                                                Text(
                                                  DateFormat.yMMMd().format(DateTime.parse(transaction[index].paymentDate ?? '')),
                                                  style: const TextStyle(color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              '${lang.S.of(context).total} : $currency ${transaction[index].totalDue.toString()}',
                                              style: const TextStyle(color: Colors.grey),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              '${lang.S.of(context).paid} : $currency ${transaction[index].totalDue!.toDouble() - transaction[index].dueAmountAfterPay!.toDouble()}',
                                              style: const TextStyle(color: Colors.grey),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  '${lang.S.of(context).due}: $currency ${transaction[index].dueAmountAfterPay.toString()}',
                                                  style: const TextStyle(fontSize: 16),
                                                ).visible(transaction[index].dueAmountAfterPay!.toInt() != 0),
                                                personalData.when(data: (data) {
                                                  return Row(
                                                    children: [
                                                      IconButton(
                                                          padding: EdgeInsets.zero,
                                                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                          onPressed: () async {
                                                            if ((Theme.of(context).platform == TargetPlatform.android)) {
                                                              ///________Print_______________________________________________________
                                                              await printerData.getBluetooth();
                                                              PrintDueTransactionModel model =
                                                                  PrintDueTransactionModel(dueTransactionModel: transaction[index], personalInformationModel: data);
                                                              if (connected) {
                                                                await printerData.printTicket(printDueTransactionModel: model);
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
                                                                                        isConnect
                                                                                            // ignore: use_build_context_synchronously
                                                                                            ? finish(context)
                                                                                            : toast(
                                                                                          lang.S.of(context).tryAgain,
                                                                                            //'Try Again'
                                                                                        );
                                                                                      },
                                                                                      title: Text('${printerData.availableBluetoothDevices[index]}'),
                                                                                      subtitle: Text(lang.S.of(context).clickToConnect),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                                const SizedBox(height: 10),
                                                                                Text(lang.S.of(context).connectPrinter),
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
                                                              }
                                                            }
                                                          },
                                                          icon: const Icon(
                                                            FeatherIcons.printer,
                                                            color: Colors.grey,
                                                          )),
                                                      const SizedBox(width: 10),
                                                      IconButton(
                                                          padding: EdgeInsets.zero,
                                                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                          onPressed: () => GeneratePdf().generateDueDocument(transaction[index], data, context),
                                                          icon: const Icon(
                                                            Icons.picture_as_pdf,
                                                            color: Colors.grey,
                                                          )),
                                                    ],
                                                  );
                                                }, error: (e, stack) {
                                                  return Text(e.toString());
                                                }, loading: () {
                                                  //return const Text('Loading');
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
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : Center(
                        child: Text(
                          lang.S.of(context).collectDues,
                          maxLines: 2,
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
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
    );
  }
}
