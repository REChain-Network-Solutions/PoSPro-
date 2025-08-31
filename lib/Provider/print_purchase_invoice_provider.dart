// import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/Screens/Purchase/Model/purchase_transaction_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constant.dart';
import '../model/print_transaction_model.dart';

final printerPurchaseProviderNotifier = ChangeNotifierProvider((ref) => PrinterPurchase());

class PrinterPurchase extends ChangeNotifier {
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

  Future<bool> printPurchaseThermalInvoice({required PrintPurchaseTransactionModel printTransactionModel, required List<Details>? productList}) async {
    // Временно отключено для сборки
    bool isPrinted = false;
    toast('Printing temporarily disabled');
    notifyListeners();
    return isPrinted;
  }

  Future<List<int>> getTicket({required PrintPurchaseTransactionModel printTransactionModel, required List<Details>? productList}) async {
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

    // bytes += generator.row([
    //   PosColumn(
    //       text: "Sada Dosa",
    //       width: 5,
    //       styles: PosStyles(
    //         align: PosAlign.left,
    //       )),
    //   PosColumn(
    //       text: "30",
    //       width: 2,
    //       styles: PosStyles(
    //         align: PosAlign.center,
    //       )),
    //   PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: "30", width: 3, styles: PosStyles(align: PosAlign.right)),
    // ]);
    //
    // bytes += generator.row([
    //   PosColumn(
    //       text: "Masala Dosa",
    //       width: 5,
    //       styles: PosStyles(
    //         align: PosAlign.left,
    //       )),
    //   PosColumn(
    //       text: "50",
    //       width: 2,
    //       styles: PosStyles(
    //         align: PosAlign.center,
    //       )),
    //   PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: "50", width: 3, styles: PosStyles(align: PosAlign.right)),
    // ]);
    //
    // bytes += generator.row([
    //   PosColumn(
    //       text: "Rova Dosa",
    //       width: 5,
    //       styles: PosStyles(
    //         align: PosAlign.left,
    //       )),
    //   PosColumn(
    //       text: "70",
    //       width: 2,
    //       styles: PosStyles(
    //         align: PosAlign.center,
    //       )),
    //   PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: "70", width: 3, styles: PosStyles(align: PosAlign.right)),
    // ]);
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
    // bytes += generator.row([
    //   PosColumn(
    //       text: 'Return amount:',
    //       width: 8,
    //       styles: const PosStyles(
    //         align: PosAlign.left,
    //       )),
    //   PosColumn(
    //       text: printTransactionModel.purchaseTransitionModel!.returnAmount.toString(),
    //       width: 4,
    //       styles: const PosStyles(
    //         align: PosAlign.right,
    //       )),
    // ]);
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
}
