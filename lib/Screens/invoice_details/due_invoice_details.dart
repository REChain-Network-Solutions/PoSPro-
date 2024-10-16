import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Const/api_config.dart';
import '../../Provider/printer_due_provider.dart';
import '../../constant.dart' as mainConstant;
import '../../currency.dart';
import '../../invoice_constant.dart';
import '../../model/business_info_model.dart';
import '../../model/print_transaction_model.dart';
import '../Due Calculation/Model/due_collection_model.dart';

class DueInvoiceDetails extends StatefulWidget {
  const DueInvoiceDetails({Key? key, required this.dueCollection, required this.personalInformationModel, this.isFromDue}) : super(key: key);

  final DueCollection dueCollection;
  final BusinessInformation personalInformationModel;
  final bool? isFromDue;

  @override
  State<DueInvoiceDetails> createState() => _DueInvoiceDetailsState();
}

class _DueInvoiceDetailsState extends State<DueInvoiceDetails> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final printerData = ref.watch(printerDueProviderNotifier);
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: widget.personalInformationModel.pictureUrl.isEmptyOrNull
                          ? const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/no_shop_image.png'),
                              ),
                            )
                          : BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage('${APIConfig.domain}${widget.personalInformationModel.pictureUrl ?? ''}'),
                              ),
                            ),
                    ),
                    title: Text(
                      '${widget.personalInformationModel.companyName}',
                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.personalInformationModel.address.toString(),
                          style: kTextStyle.copyWith(
                            color: kGreyTextColor,
                          ),
                        ),
                        Text(
                          widget.personalInformationModel.phoneNumber.toString(),
                          style: kTextStyle.copyWith(
                            color: kGreyTextColor,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                  Divider(
                    thickness: 1.0,
                    color: kGreyTextColor.withOpacity(0.1),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Text(
                        lang.S.of(context).billTO,
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${lang.S.of(context).invoice}# ${widget.dueCollection.invoiceNumber}',
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        'Name: ${widget.dueCollection.party?.name ?? ''}',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat.yMMMd().format(DateTime.parse(widget.dueCollection.paymentDate ?? '')),
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        'Phone: ${widget.dueCollection.party?.phone ?? ''}',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const Spacer(),
                      Text(
                        widget.dueCollection.paymentDate!.substring(10, 16),
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    'Collected By: ${widget.dueCollection.user?.name ?? ''}',
                    style: kTextStyle.copyWith(color: kGreyTextColor),
                  ),
                  const SizedBox(height: 10.0),
                  Divider(
                    thickness: 1.0,
                    color: kGreyTextColor.withOpacity(0.1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        lang.S.of(context).totalDue,
                        maxLines: 1,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: 120,
                        child: Text(
                          '$currency ${widget.dueCollection.totalDue}',
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        lang.S.of(context).paymentsAmount,
                        maxLines: 1,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: 120,
                        child: Text(
                          '$currency ${widget.dueCollection.payDueAmount}',
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        lang.S.of(context).remainingDue,
                        maxLines: 1,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: 120,
                        child: Text(
                          '$currency ${widget.dueCollection.dueAmountAfterPay}',
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1.0,
                    color: kGreyTextColor.withOpacity(0.1),
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      lang.S.of(context).thankYouForYourDuePayment,
                      maxLines: 1,
                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () async {
                    if (widget.isFromDue ?? false) {
                      int count = 0;
                      Navigator.popUntil(context, (route) {
                        return count++ == 2;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    height: 60,
                    width: context.width() / 3,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () async {
                    await printerData.getBluetooth();
                    PrintDueTransactionModel model = PrintDueTransactionModel(dueTransactionModel: widget.dueCollection, personalInformationModel: widget.personalInformationModel);
                    mainConstant.connected
                        ? printerData.printTicket(
                            printDueTransactionModel: model,
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
                                                isConnect ? finish(context) : toast('Try Again');
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
                                              style: const TextStyle(color: mainConstant.kMainColor),
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
                  child: Container(
                    height: 60,
                    width: context.width() / 3,
                    decoration: const BoxDecoration(
                      color: mainConstant.kMainColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        lang.S.of(context).print,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      );
    });
  }
}
