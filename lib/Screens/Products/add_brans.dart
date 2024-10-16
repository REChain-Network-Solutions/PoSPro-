// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Products/Model/brands_model.dart';
import 'package:mobile_pos/Screens/Products/Repo/brand_repo.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class AddBrands extends StatefulWidget {
  const AddBrands({Key? key, this.brand}) : super(key: key);

  final Brand? brand;

  @override
  // ignore: library_private_types_in_public_api
  _AddBrandsState createState() => _AddBrandsState();
}

class _AddBrandsState extends State<AddBrands> {
  bool showProgress = false;
  TextEditingController brandController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.brand != null ? brandController.text = widget.brand?.brandName ?? '' : null;
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
            lang.S.of(context).addBrand,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                       // return 'Please enter a valid brand name';
                        return lang.S.of(context).pleaseEnterAValidBrandName;
                      }
                      return null;
                    },
                    controller: brandController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                     // hintText: 'Enter a brand name',
                      hintText: lang.S.of(context).enterABrandName,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: lang.S.of(context).brandName,
                    ),
                  ),
                ),
                ButtonGlobalWithoutIcon(
                  buttontext: lang.S.of(context).save,
                  buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      BrandsRepo brandRepo = BrandsRepo();
                      widget.brand == null
                          ? await brandRepo.addBrand(ref: ref, context: context, name: brandController.text)
                          : await brandRepo.editBrand(ref: ref,id: widget.brand?.id??0, context: context, name: brandController.text);
                    }
                  },
                  buttonTextColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
