import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/currency.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';
import '../../Expense/Providers/all_expanse_provider.dart';

class ExpenseReport extends StatefulWidget {
  const ExpenseReport({Key? key}) : super(key: key);

  @override
  State<ExpenseReport> createState() => _ExpenseReportState();
}

class _ExpenseReportState extends State<ExpenseReport> {
  final dateController = TextEditingController();

  num totalExpense = 0;

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    totalExpense = 0;
    return Consumer(builder: (context, ref, __) {
      final expenseData = ref.watch(expenseProvider);

      return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          title: Text(
            lang.S.of(context).expenseReport,
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ///__________expense_data_table____________________________________________
                Container(
                  width: context.width(),
                  height: 50,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: kDarkWhite),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 130,
                        child: Text(
                          lang.S.of(context).expenseFor,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(lang.S.of(context).date),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: 70,
                        child: Text(lang.S.of(context).amount),
                      )
                    ],
                  ),
                ),

                expenseData.when(data: (mainData) {
                  if (mainData.isNotEmpty) {
                    totalExpense = 0;
                    for (var element in mainData) {
                      totalExpense += element.amount ?? 0;
                    }
                    return SizedBox(
                      width: context.width(),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: mainData.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 130,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            mainData[index].expanseFor ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            mainData[index].category?.categoryName ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        DateFormat.yMMMd().format(DateTime.parse(mainData[index].expenseDate ?? '')),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: 70,
                                      child: Text(mainData[index].amount.toString()),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Colors.black12,
                              )
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(lang.S.of(context).noData),
                      ),
                    );
                  }
                }, error: (Object error, StackTrace? stackTrace) {
                  return Text(error.toString());
                }, loading: () {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(),
                  ));
                }),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 50,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: kDarkWhite),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lang.S.of(context).totalExpense,
                ),
                Text('$currency$totalExpense')
              ],
            ),
          ),
        ),
      );
    });
  }
}
