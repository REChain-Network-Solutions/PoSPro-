import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Expense/add_expense_category.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../GlobalComponents/button_global.dart';
import '../../constant.dart';
import 'Providers/expense_category_proivder.dart';

class ExpenseCategoryList extends StatefulWidget {
  const ExpenseCategoryList({Key? key, this.mainContext}) : super(key: key);

  final BuildContext? mainContext;

  @override
  // ignore: library_private_types_in_public_api
  _ExpenseCategoryListState createState() => _ExpenseCategoryListState();
}

class _ExpenseCategoryListState extends State<ExpenseCategoryList> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final data = ref.watch(expanseCategoryProvider);
      return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Image(
                image: AssetImage('images/x.png'),
              )),
          title: Text(
            lang.S.of(context).expenseCat,
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: AppTextField(
                      textFieldType: TextFieldType.NAME,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: lang.S.of(context).search,
                        prefixIcon: Icon(
                          Icons.search,
                          color: kGreyTextColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        const AddExpenseCategory().launch(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: kGreyTextColor),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: kGreyTextColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                ],
              ),
              data.when(data: (data) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              data[index].categoryName ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ButtonGlobalWithoutIcon(
                              buttontext:lang.S.of(context).select,
                              //'Select',
                              buttonDecoration: kButtonDecoration.copyWith(color: kDarkWhite),
                              onPressed: () {
                                // const AddExpense().launch(context);
                                Navigator.pop(
                                  context,
                                  data[index],
                                );
                              },
                              buttonTextColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }, error: (error, stackTrace) {
                return Text(error.toString());
              }, loading: () {
                return const CircularProgressIndicator();
              })
            ],
          ),
        ),
      );
    });
  }
}
