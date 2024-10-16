import 'package:flutter/material.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/currency.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class IncomeReport extends StatefulWidget {
  const IncomeReport({Key? key}) : super(key: key);

  @override
  State<IncomeReport> createState() => _IncomeReportState();
}

class _IncomeReportState extends State<IncomeReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      bottomNavigationBar: Container(
        height: 50,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: Color(0xffFEF0F1)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(lang.S.of(context).totall,
              //'Total:',
              style: gTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor),),
            Text('$currency 380',style: gTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor),),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: kWhite,
        title:  Text(lang.S.of(context).incomeReport,
           // 'Income Report'
        ),
        surfaceTintColor: kWhite,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xffFEF0F1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(lang.S.of(context).name,
                //  'Name',
                  style: gTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor),),
                Text(lang.S.of(context).category,
                 // 'Category',
                  style: gTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor),),
                Text(lang.S.of(context).balance,
                 // 'Balance',
                  style: gTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor),),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: 20,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_,index){
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(lang.S.of(context).itemsSales,
                                   // 'items Sales'
                                ),
                                Text('Jun 29, 2024',style: gTextStyle.copyWith(color: kGreyTextColor),)
                              ],
                            ),
                             Text(lang.S.of(context).sales,
                                // 'Sales'
                             ),
                            Text('$currency 250.00')
                          ],
                        ),
                      );
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
