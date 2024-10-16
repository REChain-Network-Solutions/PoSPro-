// ignore: import_of_legacy_library_into_null_safe
// ignore_for_file: unused_result

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import 'Repo/parties_repo.dart';

class AddParty extends StatefulWidget {
  const AddParty({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddPartyState createState() => _AddPartyState();
}

class _AddPartyState extends State<AddParty> {
  String groupValue = 'Retailer';
  bool expanded = false;
  final ImagePicker _picker = ImagePicker();
  bool showProgress = false;
  XFile? pickedImage;
  String? phoneNumber;

  // TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dueController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final GlobalKey<FormState> _formKay = GlobalKey();
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: kWhite,
          backgroundColor: Colors.white,
          title: Text(
            lang.S.of(context).addContact,
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Form(
                  key: _formKay,
                  child: Column(
                    children: [
                      ///_________Phone_______________________
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                        child: IntlPhoneField(
                          // controller: phoneController,
                          decoration:  InputDecoration(
                           // labelText: 'Phone Number',
                            labelText: lang.S.of(context).phoneNumber,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          initialCountryCode: 'BD',
                          onChanged: (phone) {
                            phoneNumber = phone.completeNumber;
                          },
                        ),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.all(10.0),
                      //   child: TextFormField(
                      //     controller: phoneController,
                      //     validator: (value) {
                      //       if (value == null || value.isEmpty) {
                      //         return 'Please enter a valid phone number';
                      //       }
                      //       return null;
                      //     },
                      //     keyboardType: TextInputType.phone,
                      //     decoration: InputDecoration(
                      //       floatingLabelBehavior: FloatingLabelBehavior.always,
                      //       labelText: lang.S.of(context).phone,
                      //       hintText: lang.S.of(context).enterYourPhoneNumber,
                      //       border: const OutlineInputBorder(),
                      //     ),
                      //   ),
                      // ),

                      ///_________Name_______________________
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                             // return 'Please enter a valid Name';
                              return lang.S.of(context).pleaseEnterAValidName;
                            }
                            // You can add more validation logic as needed
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).name,
                            hintText: lang.S.of(context).enterYourName,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ///_______Type___________________________
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        groupValue: groupValue,
                        title: Text(
                          lang.S.of(context).retailer,
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                          ),
                        ),
                        value: 'Retailer',
                        onChanged: (value) {
                          setState(() {
                            groupValue = value.toString();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        groupValue: groupValue,
                        title: Text(
                          lang.S.of(context).dealer,
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                          ),
                        ),
                        value: 'Dealer',
                        onChanged: (value) {
                          setState(() {
                            groupValue = value.toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: kMainColor,
                        groupValue: groupValue,
                        title: Text(
                          lang.S.of(context).wholesaler,
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                          ),
                        ),
                        value: 'Wholesaler',
                        onChanged: (value) {
                          setState(() {
                            groupValue = value.toString();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: kMainColor,
                        groupValue: groupValue,
                        title: Text(
                          lang.S.of(context).supplier,
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                          ),
                        ),
                        value: 'Supplier',
                        onChanged: (value) {
                          setState(() {
                            groupValue = value.toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),

                Visibility(
                  visible: showProgress,
                  child: const CircularProgressIndicator(
                    color: kMainColor,
                    strokeWidth: 5.0,
                  ),
                ),
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      expanded == false ? expanded = true : expanded = false;
                    });
                  },
                  animationDuration: const Duration(milliseconds: 500),
                  elevation: 0,
                  dividerColor: Colors.white,
                  children: [
                    ExpansionPanel(
                      backgroundColor: kWhite,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              child: Text(
                                lang.S.of(context).moreInfo,
                                style: GoogleFonts.poppins(
                                  fontSize: 20.0,
                                  color: kMainColor,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  expanded == false ? expanded = true : expanded = false;
                                });
                              },
                            ),
                          ],
                        );
                      },
                      body: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: kWhite,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      // ignore: sized_box_for_whitespace
                                      child: Container(
                                        height: 200.0,
                                        width: MediaQuery.of(context).size.width - 80,
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                                                  setState(() {});
                                                  Future.delayed(const Duration(milliseconds: 100), () {
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.photo_library_rounded,
                                                      size: 60.0,
                                                      color: kMainColor,
                                                    ),
                                                    Text(
                                                      lang.S.of(context).gallery,
                                                      //'Gallery',
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 20.0,
                                                        color: kMainColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 40.0,
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  pickedImage = await _picker.pickImage(source: ImageSource.camera);
                                                  setState(() {});
                                                  Future.delayed(const Duration(milliseconds: 100), () {
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.camera,
                                                      size: 60.0,
                                                      color: kGreyTextColor,
                                                    ),
                                                    Text(
                                                      lang.S.of(context).camera,
                                                      //'Camera',
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 20.0,
                                                        color: kGreyTextColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black54, width: 1),
                                    borderRadius: const BorderRadius.all(Radius.circular(120)),
                                    image: pickedImage == null
                                        ? const DecorationImage(
                                            image: AssetImage('images/no_shop_image.png'),
                                            fit: BoxFit.cover,
                                          )
                                        : DecorationImage(
                                            image: FileImage(File(pickedImage!.path)),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white, width: 2),
                                      borderRadius: const BorderRadius.all(Radius.circular(120)),
                                      color: kMainColor,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),

                          ///__________email__________________________
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: lang.S.of(context).email,
                                //hintText: 'Enter your email address',
                                hintText: lang.S.of(context).hintEmail
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: addressController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: lang.S.of(context).address,
                                  //hintText: 'Enter your address'
                                hintText: lang.S.of(context).hintEmail
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: dueController,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: lang.S.of(context).previousDue,
                                  hintText: lang.S.of(context).amount),
                            ),
                          ),
                        ],
                      ),
                      isExpanded: expanded,
                    ),
                  ],
                ),
                ButtonGlobalWithoutIcon(
                    buttontext: lang.S.of(context).save,
                    buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                    onPressed: () async {
                      // if (_formKay.currentState!.validate()) {
                      if (!nameController.text.isEmptyOrNull && !phoneNumber.isEmptyOrNull) {
                        final partyRepo = PartyRepository();
                        await partyRepo.addParty(
                          ref: ref,
                          context: context,
                          name: nameController.text,
                          phone: phoneNumber ?? '',
                          type: groupValue,
                          image: pickedImage != null ? File(pickedImage!.path) : null,
                          address: addressController.text.isEmptyOrNull ? null : addressController.text,
                          email: emailController.text.isEmptyOrNull ? null : emailController.text,
                          due: dueController.text.isEmptyOrNull ? null : dueController.text,
                        );
                      } else {
                        EasyLoading.showError(
                          lang.S.of(context).pleaseEnterValidPhoneAndNameFirst
                            //'Please Enter valid phone and name first'
                        );
                      }
                    },
                    buttonTextColor: Colors.white),
              ],
            ),
          ),
        ),
      );
    });
  }
}
