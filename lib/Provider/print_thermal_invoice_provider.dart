import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

import '../Screens/Purchase/Model/purchase_transaction_model.dart';
import '../constant.dart';
import '../model/print_transaction_model.dart';
import '../model/sale_transaction_model.dart';

final thermalPrinterProvider = ChangeNotifierProvider((ref) => ThermalPrinter());

class ThermalPrinter extends ChangeNotifier {
  List<BluetoothInfo> availableBluetoothDevices = [];
  Future<void> getBluetooth() async {
    final List<BluetoothInfo> bluetooths = await PrintBluetoothThermal.pairedBluetooths;
    availableBluetoothDevices = bluetooths;
    notifyListeners();
  }

  Future<bool> setConnect(String mac) async {
    bool status = false;
    final bool result = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    if (result == true) {
      connected = true;
      status = true;
    }
    notifyListeners();
    return status;
  }

  Future<dynamic> listOfBluDialog({required BuildContext context}) async {
    return showDialog(
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
                      itemCount: availableBluetoothDevices.isNotEmpty ? availableBluetoothDevices.length : 0,
                      itemBuilder: (context1, index) {
                        return ListTile(
                          onTap: () async {
                            BluetoothInfo select = availableBluetoothDevices[index];
                            bool isConnect = await setConnect(select.macAdress);
                            isConnect
                                ? finish(context1)
                                : toast(
                                    lang.S.of(context1).tryAgain,
                                    //'Try Again'
                                  );
                          },
                          title: Text(availableBluetoothDevices[index].name),
                          subtitle: Text(lang.S.of(context1).clickToConnect),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      lang.S.of(context).connectYourPrinter,
                      //'Connect Your printer'
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
  }

  ///________Sales____________________

  Future<bool> printSalesTicket({required PrintTransactionModel printTransactionModel, required List<SalesDetails>? productList}) async {
    bool isPrinted = false;
    bool? isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected == true) {
      List<int> bytes = await getSalesTicket(printTransactionModel: printTransactionModel, productList: productList);
      if (productList!.isNotEmpty) {
        await PrintBluetoothThermal.writeBytes(bytes);
        EasyLoading.showSuccess('Successfully Printed');
      } else {
        toast('No Product Found');
      }

      isPrinted = true;
    } else {
      isPrinted = false;
    }
    notifyListeners();
    return isPrinted;
  }

  Future<List<int>> getSalesTicket({required PrintTransactionModel printTransactionModel, required List<SalesDetails>? productList}) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.text(printTransactionModel.personalInformationModel.companyName ?? '',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text('Seller :${printTransactionModel.transitionModel!.user?.name}', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(printTransactionModel.personalInformationModel.address ?? '', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Tel: ${printTransactionModel.personalInformationModel.phoneNumber ?? ''}', styles: const PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.text('Name: ${printTransactionModel.transitionModel?.party?.name ?? 'Guest'}', styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('mobile: ${printTransactionModel.transitionModel?.party?.phone ?? 'Not Provided'}', styles: const PosStyles(align: PosAlign.left));
    // bytes += generator.text('Sales By: ${printTransactionModel.transitionModel?.user?.name ?? 'Not Provided'}', styles: const PosStyles(align: PosAlign.left));
    bytes +=
        generator.text('Invoice Number: ${printTransactionModel.transitionModel?.invoiceNumber ?? 'Not Provided'}', styles: const PosStyles(align: PosAlign.left), linesAfter: 1);

    bytes += generator.row([
      PosColumn(text: 'Item', width: 5, styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: 'Price', width: 2, styles: const PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(text: 'Qty', width: 2, styles: const PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(text: 'Total', width: 3, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);
    bytes += generator.hr();
    List.generate(productList?.length ?? 1, (index) {
      return bytes += generator.row([
        PosColumn(
            text: productList?[index].product?.productName ?? 'Not Defined',
            width: 5,
            styles: const PosStyles(
              align: PosAlign.left,
            )),
        PosColumn(
            text: productList?[index].price?.toStringAsFixed(2) ?? 'Not Defined',
            width: 2,
            styles: const PosStyles(
              align: PosAlign.center,
            )),
        PosColumn(text: productList?[index].quantities.toString() ?? 'Not Defined', width: 2, styles: const PosStyles(align: PosAlign.center)),
        PosColumn(text: "${(productList?[index].price ?? 0) * (productList![index].quantities ?? 0)}", width: 3, styles: const PosStyles(align: PosAlign.right)),
      ]);
    });
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: 'Subtotal',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: '${printTransactionModel.transitionModel!.totalAmount!.toDouble() + printTransactionModel.transitionModel!.discountAmount!.toDouble()}',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'VAT',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: '${printTransactionModel.transitionModel?.vatAmount ?? 0}',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Discount',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printTransactionModel.transitionModel?.discountAmount.toString() ?? '',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(text: 'TOTAL', width: 8, styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: printTransactionModel.transitionModel?.totalAmount.toString() ?? '', width: 4, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);

    // bytes += generator.hr(ch: '=', linesAfter: 1);
    // bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
          text: 'Payment Type:',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printTransactionModel.transitionModel?.paymentType ?? 'Cash',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Payment Amount:',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: '${printTransactionModel.transitionModel!.totalAmount!.toDouble() - printTransactionModel.transitionModel!.dueAmount!.toDouble()}',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Return amount:',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: (printTransactionModel.transitionModel?.paidAmount ?? 0) > (printTransactionModel.transitionModel?.totalAmount ?? 0)
              ? ((printTransactionModel.transitionModel?.paidAmount ?? 0) - (printTransactionModel.transitionModel?.totalAmount ?? 0)).toString()
              : '0',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Due Amount:',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printTransactionModel.transitionModel!.dueAmount.toString(),
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.hr(ch: '=', linesAfter: 1);

    // ticket.feed(2);
    bytes += generator.text('Thank you!', styles: const PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.text(printTransactionModel.transitionModel!.saleDate ?? '', styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.text('Note: Goods once sold will not be taken back or exchanged.', styles: const PosStyles(align: PosAlign.center, bold: false), linesAfter: 1);

    bytes += generator.qrcode('https://maantechnology.com', size: QRSize.Size4);
    bytes += generator.text('Developed By: Maan Technology', styles: const PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.cut();
    return bytes;
  }

  ///__________Purchase________________
  Future<bool> printPurchaseThermalInvoice({required PrintPurchaseTransactionModel printTransactionModel, required List<Details>? productList}) async {
    bool isPrinted = false;
    bool isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected == true) {
      List<int> bytes = await getPurchaseTicket(printTransactionModel: printTransactionModel, productList: productList);
      if (productList!.isNotEmpty) {
        await PrintBluetoothThermal.writeBytes(bytes);
      } else {
        toast('No Product Found');
      }

      isPrinted = true;
    } else {
      isPrinted = false;
    }
    notifyListeners();
    return isPrinted;
  }

  Future<List<int>> getPurchaseTicket({required PrintPurchaseTransactionModel printTransactionModel, required List<Details>? productList}) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    // final ByteData data = await rootBundle.load('images/logo.png');
    // final Uint8List imageBytes = data.buffer.asUint8List();
    // final images.Image? imagez = decodeImage(imageBytes);
    // bytes += generator.image(imagez!);
    bytes += generator.text(printTransactionModel.personalInformationModel.companyName ?? '',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text('Seller :${printTransactionModel.purchaseTransitionModel?.user?.name}', styles: const PosStyles(align: PosAlign.center));

    bytes += generator.text(printTransactionModel.personalInformationModel.address ?? '', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Tel: ${printTransactionModel.personalInformationModel.phoneNumber ?? ''}', styles: const PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.text('Name: ${printTransactionModel.purchaseTransitionModel?.party?.name ?? 'Guest'}', styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('mobile: ${printTransactionModel.purchaseTransitionModel?.party?.phone ?? 'Not Provided'}', styles: const PosStyles(align: PosAlign.left));
    // bytes += generator.text('Purchase By: ${printTransactionModel.purchaseTransitionModel?.user?.name ?? 'Not Provided'}', styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Invoice Number: ${printTransactionModel.purchaseTransitionModel?.invoiceNumber ?? 'Not Provided'}',
        styles: const PosStyles(align: PosAlign.left), linesAfter: 1);
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(text: 'Item', width: 5, styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: 'Price', width: 2, styles: const PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(text: 'Qty', width: 2, styles: const PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(text: 'Total', width: 3, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);
    bytes += generator.hr();
    List.generate(productList?.length ?? 1, (index) {
      return bytes += generator.row([
        PosColumn(
            text: productList?[index].product?.productName ?? 'Not Defined',
            width: 5,
            styles: const PosStyles(
              align: PosAlign.left,
            )),
        PosColumn(
            text: productList?[index].productPurchasePrice.toString() ?? 'Not Defined',
            width: 2,
            styles: const PosStyles(
              align: PosAlign.center,
            )),
        PosColumn(text: productList?[index].quantities.toString() ?? 'Not Defined', width: 2, styles: const PosStyles(align: PosAlign.center)),
        PosColumn(text: "${(productList?[index].productPurchasePrice ?? 0) * (productList![index].quantities ?? 0)}", width: 3, styles: const PosStyles(align: PosAlign.right)),
      ]);
    });

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: 'Subtotal',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: '${printTransactionModel.purchaseTransitionModel!.totalAmount!.toDouble() + printTransactionModel.purchaseTransitionModel!.discountAmount!.toDouble()}',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Discount',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printTransactionModel.purchaseTransitionModel?.discountAmount.toString() ?? '',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(text: 'TOTAL', width: 8, styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: printTransactionModel.purchaseTransitionModel?.totalAmount.toString() ?? '', width: 4, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);

    bytes += generator.row([
      PosColumn(
          text: 'Payment Type:',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printTransactionModel.purchaseTransitionModel?.paymentType ?? 'Cash',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Payment Amount:',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: '${printTransactionModel.purchaseTransitionModel!.totalAmount!.toDouble() - printTransactionModel.purchaseTransitionModel!.dueAmount!.toDouble()}',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Due Amount:',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printTransactionModel.purchaseTransitionModel!.dueAmount.toString(),
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.hr(ch: '=', linesAfter: 1);

    // ticket.feed(2);
    bytes += generator.text('Thank you!', styles: const PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.text(printTransactionModel.purchaseTransitionModel!.purchaseDate ?? '', styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.text('Note: Goods once sold will not be taken back or exchanged.', styles: const PosStyles(align: PosAlign.center, bold: false), linesAfter: 1);

    bytes += generator.qrcode('https://maantechnology.com', size: QRSize.Size4);
    bytes += generator.text('Developed By: Maan Technology', styles: const PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.cut();
    return bytes;
  }

  ///_________Due________________________
  Future<bool> printDueTicket({required PrintDueTransactionModel printDueTransactionModel}) async {
    bool isPrinted = false;
    bool? isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected == true) {
      List<int> bytes = await getDueTicket(printDueTransactionModel: printDueTransactionModel);
      await PrintBluetoothThermal.writeBytes(bytes);

      isPrinted = true;
    } else {
      isPrinted = false;
    }
    notifyListeners();
    return isPrinted;
  }

  Future<List<int>> getDueTicket({required PrintDueTransactionModel printDueTransactionModel}) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    // final ByteData data = await rootBundle.load('images/logo.png');
    // final Uint8List imageBytes = data.buffer.asUint8List();
    // final Image? imagez = decodeImage(imageBytes);
    // bytes += generator.image(imagez!);
    bytes += generator.text(printDueTransactionModel.personalInformationModel.companyName ?? '',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text('Seller :${printDueTransactionModel.dueTransactionModel?.user?.name ?? ''}', styles: const PosStyles(align: PosAlign.center));

    bytes += generator.text(printDueTransactionModel.personalInformationModel.address ?? '', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(printDueTransactionModel.personalInformationModel.phoneNumber ?? '', styles: const PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.text('Received From: ${printDueTransactionModel.dueTransactionModel?.party?.name} ', styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Mobile: ${printDueTransactionModel.dueTransactionModel?.party?.phone}', styles: const PosStyles(align: PosAlign.left));
    // bytes += generator.text('Received By: ${printDueTransactionModel.dueTransactionModel?.user?.name}', styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Invoice Number: ${printDueTransactionModel.dueTransactionModel?.invoiceNumber ?? 'Not Provided'}',
        styles: const PosStyles(align: PosAlign.left), linesAfter: 1);

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(text: 'Invoice', width: 8, styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: 'Due', width: 4, styles: const PosStyles(align: PosAlign.center, bold: true)),
    ]);
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: printDueTransactionModel.dueTransactionModel?.invoiceNumber ?? '',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printDueTransactionModel.dueTransactionModel!.totalDue.toString(),
          width: 4,
          styles: const PosStyles(
            align: PosAlign.center,
          )),
    ]);

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
          text: 'Payment Type:',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printDueTransactionModel.dueTransactionModel!.paymentType.toString(),
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Payment Amount:',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printDueTransactionModel.dueTransactionModel!.payDueAmount.toString(),
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Remaining Due:',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printDueTransactionModel.dueTransactionModel!.dueAmountAfterPay.toString(),
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.hr(ch: '=', linesAfter: 1);

    // ticket.feed(2);
    bytes += generator.text('Thank you!', styles: const PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.text(printDueTransactionModel.dueTransactionModel?.paymentDate ?? '', styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.qrcode('https://maantechnology.com', size: QRSize.Size4);
    bytes += generator.text('Developed By: Maan Technology', styles: const PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.cut();
    return bytes;
  }
}
