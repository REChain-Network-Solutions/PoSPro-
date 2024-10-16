import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constant.dart';
import '../model/print_transaction_model.dart';

final printerDueProviderNotifier = ChangeNotifierProvider((ref) => PrinterDue());

class PrinterDue extends ChangeNotifier {
  List availableBluetoothDevices = [];
  Future<void> getBluetooth() async {
    final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
    availableBluetoothDevices = bluetooths!;
    notifyListeners();
  }

  Future<bool> setConnect(String mac) async {
    bool status = false;
    final String? result = await BluetoothThermalPrinter.connect(mac);
    if (result == "true") {
      connected = true;
      status = true;
    }
    notifyListeners();
    return status;
  }

  Future<bool> printTicket({required PrintDueTransactionModel printDueTransactionModel}) async {
    bool isPrinted = false;
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await getTicket(printDueTransactionModel: printDueTransactionModel);
      await BluetoothThermalPrinter.writeBytes(bytes);

      isPrinted = true;
    } else {
      isPrinted = false;
    }
    notifyListeners();
    return isPrinted;
  }

  Future<List<int>> getTicket({required PrintDueTransactionModel printDueTransactionModel}) async {
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

    bytes += generator.text('Seller :${printDueTransactionModel.dueTransactionModel?.user?.name??''}', styles: const PosStyles(align: PosAlign.center));

    bytes += generator.text(printDueTransactionModel.personalInformationModel.address ?? '', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(printDueTransactionModel.personalInformationModel.phoneNumber??'', styles: const PosStyles(align: PosAlign.center), linesAfter: 1);
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
          text: printDueTransactionModel.dueTransactionModel?.invoiceNumber??'',
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

    bytes += generator.text(printDueTransactionModel.dueTransactionModel?.paymentDate??'', styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.qrcode('https://maantechnology.com', size: QRSize.Size4);
    bytes += generator.text('Developed By: Maan Technology', styles: const PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.cut();
    return bytes;
  }
}
