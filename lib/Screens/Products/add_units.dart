// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Products/Model/unit_model.dart';
import 'package:mobile_pos/Screens/Products/Repo/unit_repo.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class AddUnits extends StatefulWidget {
  const AddUnits({Key? key, this.unit}) : super(key: key);
  final Unit? unit;
  @override
  // ignore: library_private_types_in_public_api
  _AddUnitsState createState() => _AddUnitsState();
}

class _AddUnitsState extends State<AddUnits> {
  bool showProgress = false;
  TextEditingController unitController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.unit != null) {
      unitController.text = widget.unit?.unitName ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
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
            lang.S.of(context).addUnit,
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Visibility(
                visible: showProgress,
                child: const CircularProgressIndicator(
                  color: kMainColor,
                  strokeWidth: 5.0,
                ),
              ),
              Form(
                key: _key,
                child: TextFormField(
                  controller: unitController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid unit name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Please enter unit name',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: lang.S.of(context).unitName,
                  ),
                ),
              ),
              ButtonGlobalWithoutIcon(
                buttontext: lang.S.of(context).save,
                buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                onPressed: () async {
                  if (_key.currentState!.validate()) {
                    UnitsRepo unit = UnitsRepo();

                    if ((widget.unit == null)) {
                      await unit.addUnit(ref: ref, context: context, name: unitController.text);
                    } else {
                      await unit.editUnit(ref: ref, id: widget.unit?.id ?? 0, context: context, name: unitController.text);
                    }
                  }
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
