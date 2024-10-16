import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

import '../../constant.dart';
import '../../currency.dart';
import '../../model/sale_transaction_model.dart';

class SingleLossProfitScreen extends StatefulWidget {
  const SingleLossProfitScreen({
    Key? key,
    required this.transactionModel,
  }) : super(key: key);

  final SalesTransaction transactionModel;

  @override
  State<SingleLossProfitScreen> createState() => _SingleLossProfitScreenState();
}

class _SingleLossProfitScreenState extends State<SingleLossProfitScreen> {
  double getTotalProfit() {
    double totalProfit = 0;
    for (var element in widget.transactionModel.details!) {
      if (!element.lossProfit!.isNegative) {
        totalProfit = totalProfit + element.lossProfit!;
      }
    }

    return totalProfit;
  }

  double getTotalLoss() {
    double totalLoss = 0;
    for (var element in widget.transactionModel.details!) {
      if (element.lossProfit!.isNegative) {
        totalLoss = totalLoss + element.lossProfit!.abs();
      }
    }

    return totalLoss;
  }

  num getTotalQuantity() {
    num total = 0;
    for (var element in widget.transactionModel.details!) {
      total += element.quantities ?? 0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          lang.S.of(context).lpDetails,
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${lang.S.of(context).invoice} #${widget.transactionModel.invoiceNumber}'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.transactionModel.party?.name ?? ''),
                  Text(
                    "${lang.S.of(context).dates} ${DateFormat.yMMMd().format(
                      DateTime.parse(widget.transactionModel.saleDate ?? ''),
                    )}",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${lang.S.of(context).mobile}${widget.transactionModel.party?.phone ?? ''}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    DateFormat.jm().format(DateTime.parse(widget.transactionModel.saleDate ?? '')),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                color: kMainColor.withOpacity(0.2),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        lang.S.of(context).product,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        lang.S.of(context).quantity,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        lang.S.of(context).profit,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      lang.S.of(context).loss,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  itemCount: widget.transactionModel.details!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    // double purchasePrice = double.parse(widget.transactionModel.details![index].productPurchasePrice.toString()) *
                    //     double.parse(widget.transactionModel.details![index].quantities.toString());
                    // double salePrice = double.parse(widget.transactionModel.details![index].price.toString()) *
                    //     double.parse(widget.transactionModel.details![index].quantities.toString());
                    //
                    // double profit = salePrice - purchasePrice;

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              widget.transactionModel.details?[index].product?.productName.toString() ?? '',
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                widget.transactionModel.details?[index].quantities.toString() ?? '',
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  !(widget.transactionModel.details?[index].lossProfit?.isNegative ?? false)
                                      ? "$currency${widget.transactionModel.details?[index].lossProfit!.abs().toString()}"
                                      : '0',
                                  style: GoogleFonts.poppins(),
                                ),
                              )),
                          Expanded(
                            child: Center(
                              child: Text(
                                (widget.transactionModel.details?[index].lossProfit?.isNegative ?? false)
                                    ? "$currency${widget.transactionModel.details?[index].lossProfit!.abs().toString()}"
                                    : '0',
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(color: kMainColor.withOpacity(0.2), border: const Border(bottom: BorderSide(width: 1, color: Colors.grey))),
              padding: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            lang.S.of(context).total,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "${getTotalQuantity()}",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Text(
                              "$currency${getTotalProfit()}",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                              ),
                            )),
                        Text(
                          "$currency${getTotalLoss()}",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: kMainColor.withOpacity(0.2), border: const Border(bottom: BorderSide(width: 1, color: Colors.grey))),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            lang.S.of(context).discount,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          "$currency${widget.transactionModel.discountAmount ?? 0}",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kMainColor.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            widget.transactionModel.detailsSumLossProfit!.isNegative ? lang.S.of(context).totalLoss : lang.S.of(context).totalProfit,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          widget.transactionModel.detailsSumLossProfit!.isNegative
                              ? "$currency${widget.transactionModel.detailsSumLossProfit!.toInt().abs()}"
                              : "$currency${widget.transactionModel.detailsSumLossProfit!.toInt()}",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
