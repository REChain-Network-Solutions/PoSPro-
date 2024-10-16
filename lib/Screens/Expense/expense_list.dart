import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Expense/Providers/all_expanse_provider.dart';
import 'package:mobile_pos/Screens/Expense/add_erxpense.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../../currency.dart';

class ExpenseList extends StatefulWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  final dateController = TextEditingController();
  TextEditingController fromDateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime(2021)));
  TextEditingController toDateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime.now()));
  DateTime fromDate = DateTime(2021);
  DateTime toDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
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
                Padding(
                  padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10, bottom: 10),
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
                                  totalExpense = 0;
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
                                  totalExpense = 0;
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
                      if ((fromDate.isBefore(DateTime.parse(element.expenseDate?.substring(0, 10) ?? '')) ||
                              DateTime.parse(element.expenseDate?.substring(0, 10) ?? '').isAtSameMomentAs(fromDate)) &&
                          (toDate.isAfter(DateTime.parse(element.expenseDate?.substring(0, 10) ?? '')) ||
                              DateTime.parse(element.expenseDate?.substring(0, 10) ?? '').isAtSameMomentAs(DateTime.parse(toDate.toString().substring(0, 10))))) {
                        totalExpense += element.amount ?? 0;
                      }
                    }
                    return SizedBox(
                      width: context.width(),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: mainData.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Visibility(
                            visible: (fromDate.isBefore(DateTime.parse(mainData[index].expenseDate ?? '')) ||
                                    DateTime.parse(mainData[index].expenseDate?.substring(0, 10) ?? '').isAtSameMomentAs(fromDate)) &&
                                (toDate.isAfter(DateTime.parse(mainData[index].expenseDate ?? '')) ||
                                    DateTime.parse(mainData[index].expenseDate?.substring(0, 10) ?? '').isAtSameMomentAs(DateTime.parse(toDate.toString().substring(0, 10)))),
                            child: Column(
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
                            ),
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
                  return const Center(child: CircularProgressIndicator());
                }),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ///_________total______________________________________________
              Container(
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

              ///________button________________________________________________
              ButtonGlobalWithoutIcon(
                buttontext: lang.S.of(context).addExpense,
                buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                onPressed: () {
                  const AddExpense().launch(context);
                },
                buttonTextColor: Colors.white,
              ),
            ],
          ),
        ),
      );
    });
  }
}
