// import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constant.dart';
import '../model/print_transaction_model.dart';
import '../model/sale_transaction_model.dart';

final salesPrinterProvider = ChangeNotifierProvider((ref) => SalesPrinter());

class SalesPrinter extends ChangeNotifier {
  List availableBluetoothDevices = [];
  bool connected = false;
  Future<void> getBluetooth() async {
    // Временно отключено для сборки
    availableBluetoothDevices = [];
    notifyListeners();
  }

  Future<bool> setConnect(String mac) async {
    // Временно отключено для сборки
    bool status = false;
    notifyListeners();
    return status;
  }

  Future<bool> printSalesTicket({required PrintTransactionModel printTransactionModel, required List<SalesDetails>? productList}) async {
    // Временно отключено для сборки
    bool isPrinted = false;
    EasyLoading.showSuccess('Printing temporarily disabled');
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
}
