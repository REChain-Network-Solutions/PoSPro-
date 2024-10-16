import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Report/Screens/due_report_screen.dart';
import 'package:mobile_pos/Screens/Report/Screens/expense_report.dart';
import 'package:mobile_pos/Screens/Report/Screens/income_report.dart';
import 'package:mobile_pos/Screens/Report/Screens/purchase_report.dart';
import 'package:mobile_pos/Screens/Report/Screens/sales_report_screen.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../Loss_Profit/loss_profit_screen.dart';
import '../stock_list/stock_list.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: Text(
          lang.S.of(context).reports,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ReportCard(
                pressed: () {
                  const SalesReportScreen().launch(context);
                },
                iconPath: 'assets/salesReport.svg',
                title: lang.S.of(context).salesReport),
            const SizedBox(
              height: 16,
            ),
            ReportCard(
                pressed: () {
                  const PurchaseReportScreen().launch(context);
                },
                iconPath: 'assets/purchaseReport.svg',
                title: lang.S.of(context).purchaseReport),
            const SizedBox(
              height: 16,
            ),
            ReportCard(
                pressed: () {
                  const DueReportScreen().launch(context);
                },
                iconPath: 'assets/duereport.svg',
                title: lang.S.of(context).dueReport),
            const SizedBox(
              height: 16,
            ),

            ///_______________Stock_report________________________________________________________________
            ReportCard(
                pressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StockList(
                                isFromReport: true,
                              )));
                },
                iconPath: 'assets/stock.svg',
                //title: 'Stock Report'
                title: lang.S.of(context).stockReport
            ),
            const SizedBox(height: 16),

            ///_______________Loss/Profit________________________________________________________________
            ReportCard(
                pressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LossProfitScreen()));
                },
                iconPath: 'assets/lossprofit.svg',
                //title: 'Loss/Profit Report'
                title: lang.S.of(context).lossProfitReport
            ),
            const SizedBox(
              height: 16,
            ),

            ///_______________Income_report________________________________________________________________
            // ReportCard(
            //     pressed: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (context) => const IncomeReport()));
            //     },
            //     iconPath: 'assets/incomeReport.svg',
            //     title: 'Income Report'),
            // const SizedBox(
            //   height: 16,
            // ),

            ///__________________Expense Report____________________________________________________________
            ReportCard(
                pressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpenseReport()));
                },
                iconPath: 'assets/expenseReport.svg',
                //title: 'Expense Report'
                title: lang.S.of(context).expenseReport
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReportCard extends StatelessWidget {
  ReportCard({
    Key? key,
    required this.pressed,
    required this.iconPath,
    required this.title,
  }) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  var pressed;
  String iconPath, title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pressed,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: kWhite, boxShadow: [
          BoxShadow(color: const Color(0xff473232).withOpacity(0.05), blurRadius: 8, spreadRadius: -1, offset: const Offset(0, 3)),
          BoxShadow(color: const Color(0xff0C1A4B).withOpacity(0.24), blurRadius: 1)
        ]),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                iconPath,
                height: 38,
                width: 38,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                ),
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.arrow_forward_ios,
                color: kMainColor,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
