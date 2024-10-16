import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../constant.dart';

class PurchaseList extends StatefulWidget {
  const PurchaseList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PurchaseListState createState() => _PurchaseListState();
}

class _PurchaseListState extends State<PurchaseList> {
  final dateController = TextEditingController();

  String dropdownValue = 'Last 30 Days';

  DropdownButton<String> getCategory() {
    List<String> dropDownItems = [
      'Last 7 Days',
      'Last 30 Days',
      'Current year',
      'Last Year',
    ];
    return DropdownButton(
      items: dropDownItems.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      value: dropdownValue,
      onChanged: (value) {
        setState(() {
          dropdownValue = value!;
        });
      },
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang.S.of(context).purchaseList,
          //'Purchase List',
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
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: kGreyTextColor),
                          ),
                          child: Center(child: getCategory()),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          readOnly: true,
                          onTap: () async {
                            var date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));
                            dateController.text =
                                date.toString().substring(0, 10);
                          },
                          controller: dateController,
                          decoration:  InputDecoration(
                              border: OutlineInputBorder(),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              //labelText: 'Start Date',
                              labelText: lang.S.of(context).startDate,
                              //hintText: 'Pick Start Date'
                              hintText: lang.S.of(context).pickStartDate
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.OTHER,
                          readOnly: true,
                          onTap: () async {
                            var date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));
                            dateController.text =
                                date.toString().substring(0, 10);
                          },
                          controller: dateController,
                          decoration:  InputDecoration(
                              border: OutlineInputBorder(),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              //labelText: 'End Date',
                              labelText:
                              lang.S.of(context).endDate,
                              //hintText: 'Pick End Date'
                              hintText: lang.S.of(context).pickEndDate
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: 80,
                    horizontalMargin: 0,
                    headingRowColor:
                        MaterialStateColor.resolveWith((states) => kDarkWhite),
                    columns:  <DataColumn>[
                      DataColumn(
                        label: Text(
                         // 'Name',
                          lang.S.of(context).name
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          lang.S.of(context).quantity
                          //'Quantity',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          lang.S.of(context).amount
                          //'Amount',
                        ),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(right: 3.0),
                                  height: 30.0,
                                  width: 30.0,
                                  child: const CircleAvatar(
                                    backgroundImage:
                                        AssetImage('images/profile.png'),
                                  ),
                                ),
                                Text(
                                  lang.S.of(context).riead,
                                 // 'Riead',
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const DataCell(
                            Text('2'),
                          ),
                          const DataCell(
                            Text('25'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            DataTable(
              columnSpacing: 120,
              headingRowColor:
                  MaterialStateColor.resolveWith((states) => kDarkWhite),
              columns:  <DataColumn>[
                DataColumn(
                  label: Text(
                    lang.S.of(context).totall
                    //'Total:',
                  ),
                ),
                DataColumn(
                  label: Text(
                    '8',
                  ),
                ),
                DataColumn(
                  label: Text(
                    '50',
                  ),
                ),
              ],
              rows: const [],
            ),
          ],
        ),
      ),
    );
  }
}
