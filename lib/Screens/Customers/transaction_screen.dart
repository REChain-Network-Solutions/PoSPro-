import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

import '../../PDF Invoice/generate_pdf.dart';
import '../../currency.dart';

class CustomerAllTransactionScreen extends StatefulWidget {
  const CustomerAllTransactionScreen({Key? key}) : super(key: key);

  @override
  State<CustomerAllTransactionScreen> createState() => _CustomerAllTransactionScreenState();
}

class _CustomerAllTransactionScreenState extends State<CustomerAllTransactionScreen> {
  int currentIndex=0;
  bool isSearch=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        elevation: 2.0,
        surfaceTintColor: kWhite,
        automaticallyImplyLeading: isSearch?false:true,
        backgroundColor: kWhite,
        title: isSearch?TextFormField(
          decoration: kInputDecoration.copyWith(
            contentPadding: EdgeInsets.only(left: 12,right: 5),
            //hintText: 'Search Here.....',
           hintText: lang.S.of(context).searchH,
          ),
        ):  Text(
          lang.S.of(context).transactions,
          //  'Transactions'
        ),
        actions:  [
          GestureDetector(
            onTap: (){
              setState(() {
                isSearch=true;
              });
            },
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Icon(FeatherIcons.search,color: kGreyTextColor,),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // SalesInvoiceDetails(
                      //   businessInfo: personalData.value!,
                      //   saleTransaction: transaction[index],
                      // ).launch(context);
                    },
                    child: Column(
                      children: [
                        Container(
                          // padding: const EdgeInsets.all(20),
                          width: context.width(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    lang.S.of(context).sale,
                                    //"Sale",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const Text('#2145'),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    // padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: const Color(0xff0dbf7d).withOpacity(0.1) ,
                                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                                    child: Text(
                                      lang.S.of(context).paid,
                                      style: TextStyle(color: const Color(0xff0dbf7d)),
                                    ),
                                  ),
                                  const Text(
                                    '30/08/2021',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${lang.S.of(context).total} : $currency 20000',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${lang.S.of(context).due}: $currency 3000',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: (){},
                                          icon: const Icon(
                                            FeatherIcons.printer,
                                            color: Colors.grey,
                                          )),
                                      IconButton(
                                          onPressed: (){},
                                          icon: const Icon(
                                            Icons.picture_as_pdf,
                                            color: Colors.grey,
                                          )),
                                      // IconButton(
                                      //   onPressed: () {},
                                      //   icon: const Icon(
                                      //     FeatherIcons.share,
                                      //     color: Colors.grey,
                                      //   ),
                                      // ),
                                      // IconButton(
                                      //     onPressed: () {},
                                      //     icon: const Icon(
                                      //       FeatherIcons.moreVertical,
                                      //       color: Colors.grey,
                                      //     )),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 0.5,
                          width: context.width(),
                          color: Colors.grey,
                        )
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
