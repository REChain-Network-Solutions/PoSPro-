import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Const/api_config.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/print_purchase_invoice_provider.dart';
// ignore: library_prefixes
import '../../constant.dart' as mainConstant;
import '../../currency.dart';
import '../../invoice_constant.dart';
import '../../model/business_info_model.dart';
import '../../model/print_transaction_model.dart';
import '../Purchase/Model/purchase_transaction_model.dart';

class PurchaseInvoiceDetails extends StatefulWidget {
  const PurchaseInvoiceDetails({Key? key, required this.transitionModel, required this.businessInfo, this.isFromPurchase}) : super(key: key);

  final PurchaseTransaction transitionModel;
  final BusinessInformation businessInfo;
  final bool? isFromPurchase;

  @override
  State<PurchaseInvoiceDetails> createState() => _PurchaseInvoiceDetailsState();
}

class _PurchaseInvoiceDetailsState extends State<PurchaseInvoiceDetails> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final printerData = ref.watch(printerPurchaseProviderNotifier);
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
                      decoration: widget.businessInfo.pictureUrl.isEmptyOrNull
                          ? const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/no_shop_image.png'),
                              ),
                            )
                          : BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage('${APIConfig.domain}${widget.businessInfo.pictureUrl ?? ''}'),
                              ),
                            ),
                    ),
                    title: Text(
                      '${widget.businessInfo.companyName}',
                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.businessInfo.address.toString(),
                          style: kTextStyle.copyWith(
                            color: kGreyTextColor,
                          ),
                        ),
                        Text(
                          widget.businessInfo.phoneNumber.toString(),
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
                        '${lang.S.of(context).invoice}# ${widget.transitionModel.invoiceNumber}',
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        'Name: ${widget.transitionModel.party?.name ?? ''}',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat.yMMMd().format(DateTime.parse(widget.transitionModel.purchaseDate ?? '')),
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        'Phone: ${widget.transitionModel.party?.phone ?? ''}',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const Spacer(),
                      Text(
                        widget.transitionModel.purchaseDate?.substring(10, 16) ?? '',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    'Purchase By: ${widget.transitionModel.user?.name ?? ''}',
                    style: kTextStyle.copyWith(color: kGreyTextColor),
                  ),
                  const SizedBox(height: 10.0),

                  ///________________________________________________
                  // Divider(
                  //   thickness: 1.0,
                  //   color: kGreyTextColor.withOpacity(0.1),
                  // ),
                  // SizedBox(
                  //   width: context.width(),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         lang.S.of(context).product,
                  //         maxLines: 2,
                  //         style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                  //       ),
                  //       const Spacer(),
                  //       Text(
                  //         lang.S.of(context).unitPirce,
                  //         maxLines: 2,
                  //         style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                  //       ),
                  //       const Spacer(),
                  //       Text(
                  //         lang.S.of(context).quantity,
                  //         maxLines: 1,
                  //         style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                  //       ),
                  //       const Spacer(),
                  //       Text(
                  //         lang.S.of(context).totalPrice,
                  //         maxLines: 2,
                  //         style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 10.0),
                  // ListView.builder(
                  //     shrinkWrap: true,
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     itemCount: widget.transitionModel.details!.length,
                  //     itemBuilder: (_, i) {
                  //       return Padding(
                  //         padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  //         child: SizedBox(
                  //           width: context.width(),
                  //           child: Row(
                  //             children: [
                  //               Text(
                  //                 widget.transitionModel.details![i].product?.productName.toString() ?? '',
                  //                 maxLines: 2,
                  //                 style: kTextStyle.copyWith(color: kGreyTextColor),
                  //               ),
                  //               SizedBox(width: MediaQuery.of(context).size.width / 12),
                  //               Text(
                  //                 '$currency ${widget.transitionModel.details![i].productPurchasePrice}',
                  //                 maxLines: 2,
                  //                 style: kTextStyle.copyWith(color: kGreyTextColor),
                  //               ),
                  //               const Spacer(),
                  //               Text(
                  //                 widget.transitionModel.details![i].quantities.toString(),
                  //                 maxLines: 1,
                  //                 style: kTextStyle.copyWith(color: kGreyTextColor),
                  //               ),
                  //               const Spacer(),
                  //               Text(
                  //                 '$currency ${(widget.transitionModel.details![i].productPurchasePrice ?? 0) * (widget.transitionModel.details![i].quantities ?? 0)}',
                  //                 maxLines: 2,
                  //                 style: kTextStyle.copyWith(color: kTitleColor),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     }),
                  // Divider(
                  //   thickness: 1.0,
                  //   color: kGreyTextColor.withOpacity(0.1),
                  // ),
                  ///____________________________________________________
                  SizedBox(
                    width: context.width(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: context.width() / 2.4,
                          child: Text(
                            lang.S.of(context).product,
                            maxLines: 1,
                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          ),
                        ),

                        SizedBox(
                          width: (context.width() - (context.width() / 2.4 + 20)) / 3,
                          child: Text(
                            lang.S.of(context).unitPirce,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign:TextAlign.center,
                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: (context.width() - (context.width() / 2.4 + 20)) / 3,
                          child: Text(
                            lang.S.of(context).quantity,
                            maxLines: 1,
                            textAlign:TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: (context.width() - (context.width() / 2.4 + 20)) / 3,
                          child: Text(
                            lang.S.of(context).totalPrice,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign:TextAlign.center,
                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1.0,
                    color: kGreyTextColor.withOpacity(0.1),
                  ),
                  // const SizedBox(height: 10.0),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.transitionModel.details!.length,
                      itemBuilder: (_, i) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                          child: SizedBox(
                            width: context.width(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: context.width() / 2.4,
                                  child: Text(
                                    widget.transitionModel.details![i].product?.productName.toString() ?? '',
                                    maxLines: 2,
                                    style: kTextStyle.copyWith(color: kGreyTextColor),
                                  ),
                                ),
                                SizedBox(
                                  width: (context.width() - (context.width() / 2.4 + 20)) / 3,
                                  child: Text(
                                    '$currency ${widget.transitionModel.details![i].productPurchasePrice}',
                                    maxLines: 1,
                                    textAlign:TextAlign.center,
                                    style: kTextStyle.copyWith(color: kGreyTextColor),
                                  ),
                                ),
                                SizedBox(
                                  width: (context.width() - (context.width() / 2.4 + 20)) / 3,
                                  child: Text(
                                    widget.transitionModel.details![i].quantities.toString(),
                                    maxLines: 1,
                                    textAlign:TextAlign.center,
                                    style: kTextStyle.copyWith(color: kGreyTextColor),
                                  ),
                                ),
                                SizedBox(
                                  width: (context.width() - (context.width() / 2.4 + 20)) / 3,
                                  child: Text(
                                    '$currency ${(widget.transitionModel.details![i].productPurchasePrice ?? 0) * (widget.transitionModel.details![i].quantities ?? 0)}',
                                    maxLines: 1,
                                    textAlign:TextAlign.center,
                                    style: kTextStyle.copyWith(color: kTitleColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  Divider(
                    thickness: 1.0,
                    color: kGreyTextColor.withOpacity(0.1),
                  ),
                  ///___________________________________________________
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        lang.S.of(context).subTotal,
                        maxLines: 1,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: 120,
                        child: Text(
                          '$currency ${widget.transitionModel.totalAmount!.toDouble() + widget.transitionModel.discountAmount!.toDouble()}',
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Text(
                  //       lang.S.of(context).totalVat,
                  //       maxLines: 1,
                  //       style: kTextStyle.copyWith(color: kGreyTextColor),
                  //     ),
                  //     const SizedBox(width: 20.0),
                  //     SizedBox(
                  //       width: 120,
                  //       child: Text(
                  //         '$currency 0.00',
                  //         maxLines: 2,
                  //         style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                  //         textAlign: TextAlign.end,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        lang.S.of(context).discount,
                        maxLines: 1,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: 120,
                        child: Text(
                          '$currency ${widget.transitionModel.discountAmount}',
                          maxLines: 2,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 5.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Text(
                  //       lang.S.of(context).deliveryCharge,
                  //       maxLines: 1,
                  //       style: kTextStyle.copyWith(color: kGreyTextColor),
                  //     ),
                  //     const SizedBox(width: 20.0),
                  //     SizedBox(
                  //       width: 120,
                  //       child: Text(
                  //         '$currency 0.00',
                  //         maxLines: 2,
                  //         style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                  //         textAlign: TextAlign.end,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        lang.S.of(context).totalPayable,
                        maxLines: 1,
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: 120,
                        child: Text(
                          '$currency ${widget.transitionModel.totalAmount}',
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
                        lang.S.of(context).paid,
                        maxLines: 1,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: 120,
                        child: Text(
                          '$currency ${widget.transitionModel.totalAmount! - widget.transitionModel.dueAmount!.toDouble()}',
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
                        lang.S.of(context).due,
                        maxLines: 1,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: 120,
                        child: Text(
                          '$currency ${widget.transitionModel.dueAmount}',
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
                      lang.S.of(context).thakYouForYourPurchase,
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
                  onTap: () {
                    if (widget.isFromPurchase ?? false) {
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
                    PrintPurchaseTransactionModel model =
                        PrintPurchaseTransactionModel(purchaseTransitionModel: widget.transitionModel, personalInformationModel: widget.businessInfo);
                    mainConstant.connected
                        ? printerData.printPurchaseThermalInvoice(
                            printTransactionModel: model,
                            productList: model.purchaseTransitionModel!.details,
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
