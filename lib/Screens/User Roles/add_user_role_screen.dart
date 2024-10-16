import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/User%20Roles/Model/user_role_model.dart' as user;
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'Repo/user_role_repo.dart';

class AddUserRole extends StatefulWidget {
  const AddUserRole({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddUserRoleState createState() => _AddUserRoleState();
}

class _AddUserRoleState extends State<AddUserRole> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool allPermissions = false;
  bool salePermission = false;
  bool partiesPermission = false;
  bool purchasePermission = false;
  bool productPermission = false;
  bool profileEditPermission = false;
  bool addExpensePermission = false;
  bool lossProfitPermission = false;
  bool dueListPermission = false;
  bool stockPermission = false;
  bool reportsPermission = false;
  bool salesListPermission = false;
  bool purchaseListPermission = false;
  TextEditingController emailController = TextEditingController();
  // TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  String? phoneNumber;
  String? phoneCode;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: kWhite,
          backgroundColor: Colors.white,
          title: Text(
            lang.S.of(context).addUserRole,
          //  'Add User Role',
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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: kGreyTextColor),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          ///_______all_&_sale____________________________________________
                          Row(
                            children: [
                              ///_______all__________________________
                              Expanded(
                                child: CheckboxListTile(
                                  contentPadding: const EdgeInsets.all(5),
                                  value: allPermissions,
                                  onChanged: (value) {
                                    if (value == true) {
                                      setState(() {
                                        allPermissions = value!;
                                        salePermission = true;
                                        partiesPermission = true;
                                        purchasePermission = true;
                                        productPermission = true;
                                        profileEditPermission = true;
                                        addExpensePermission = true;
                                        lossProfitPermission = true;
                                        dueListPermission = true;
                                        stockPermission = true;
                                        reportsPermission = true;
                                        salesListPermission = true;
                                        purchaseListPermission = true;
                                      });
                                    } else {
                                      setState(() {
                                        allPermissions = value!;
                                        salePermission = false;
                                        partiesPermission = false;
                                        purchasePermission = false;
                                        productPermission = false;
                                        profileEditPermission = false;
                                        addExpensePermission = false;
                                        lossProfitPermission = false;
                                        dueListPermission = false;
                                        stockPermission = false;
                                        reportsPermission = false;
                                        salesListPermission = false;
                                        purchaseListPermission = false;
                                      });
                                    }
                                  },
                                  title:  Text(
                                    lang.S.of(context).all,
                                    //'All',
                                    style: const TextStyle(fontSize: 14),),

                                ),
                              ),
                              Expanded(
                                child: Container()
                              ),
                            ],
                          ),

                          ///_______Edit Profile_&_sale____________________________________________
                          Row(
                            children: [
                              ///_______Edit_Profile_________________________
                              Expanded(
                                child: CheckboxListTile(
                                  contentPadding: const EdgeInsets.all(5),
                                  value: profileEditPermission,
                                  onChanged: (value) {
                                    setState(() {
                                      profileEditPermission = value!;
                                    });
                                  },
                                  title:  Text(
                                    lang.S.of(context).profileEdit,
                                    //'Profile Edit',
                                    style: const TextStyle(fontSize: 14),),
                                ),
                              ),

                              ///______sales____________________________
                              Expanded(
                                child: CheckboxListTile(
                                  contentPadding: const EdgeInsets.all(5),
                                  value: salePermission,
                                  onChanged: (value) {
                                    setState(() {
                                      salePermission = value!;
                                    });
                                  },
                                  title:  Text(
                                    lang.S.of(context).sales,
                                    //'Sales',
                                    style: const TextStyle(fontSize: 14),),
                                ),
                              ),
                            ],
                          ),

                          ///_____parties_&_Purchase_________________________________________
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  contentPadding: const EdgeInsets.all(5),
                                  value: partiesPermission,
                                  onChanged: (value) {
                                    setState(() {
                                      partiesPermission = value!;
                                    });
                                  },
                                  title:  Text(
                                    lang.S.of(context).parties,
                                   // 'Parties',
                                    style: const TextStyle(fontSize: 14),),
                                ),
                              ),
                              Expanded(
                                child: CheckboxListTile(
                                  contentPadding: const EdgeInsets.all(5),
                                  value: purchasePermission,
                                  onChanged: (value) {
                                    setState(() {
                                      purchasePermission = value!;
                                    });
                                  },
                                  title:  Text(
                                    lang.S.of(context).purchase,
                                    //'Purchase',
                                    style: const TextStyle(fontSize: 14),),
                                ),
                              ),
                            ],
                          ),

                          ///_____Product_&_DueList_________________________________________
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  contentPadding: const EdgeInsets.all(5),
                                  value: productPermission,
                                  onChanged: (value) {
                                    setState(() {
                                      productPermission = value!;
                                    });
                                  },
                                  title:  Text(
                                    lang.S.of(context).products,
                                    //'Products',
                                    style: const TextStyle(fontSize: 14),),
                                ),
                              ),
                              Expanded(
                                child: CheckboxListTile(
                                  contentPadding: const EdgeInsets.all(5),
                                  value: dueListPermission,
                                  onChanged: (value) {
                                    setState(() {
                                      dueListPermission = value!;
                                    });
                                  },
                                  title:  Text(
                                    lang.S.of(context).dueList,
                                    //'Due List',
                                    style: const TextStyle(fontSize: 14),),
                                ),
                              ),
                            ],
                          ),

                          ///_____Stock_&_Reports_________________________________________
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  contentPadding: const EdgeInsets.all(5),
                                  value: stockPermission,
                                  onChanged: (value) {
                                    setState(() {
                                      stockPermission = value!;
                                    });
                                  },
                                  title:  Text(
                                    lang.S.of(context).stock,
                                    //'Stock',
                                    style: const TextStyle(fontSize: 14),),
                                ),
                              ),
                              Expanded(
                                child: CheckboxListTile(
                                  contentPadding: const EdgeInsets.all(5),
                                  value: reportsPermission,
                                  onChanged: (value) {
                                    setState(() {
                                      reportsPermission = value!;
                                    });
                                  },
                                  title:   Text(
                                    lang.S.of(context).reports,
                                    //'Reports',
                                    style: const TextStyle(fontSize: 14),),
                                ),
                              ),
                            ],
                          ),

                          ///_____SalesList_&_Purchase List_________________________________________
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  contentPadding: const EdgeInsets.all(5),
                                  value: salesListPermission,
                                  onChanged: (value) {
                                    setState(() {
                                      salesListPermission = value!;
                                    });
                                  },
                                  title:  Text(
                                    lang.S.of(context).salesList,
                                   // 'Sales List',
                                    style: const TextStyle(fontSize: 14),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                ),
                              ),
                              Expanded(
                                child: CheckboxListTile(
                                  contentPadding: const EdgeInsets.all(5),
                                  value: purchaseListPermission,
                                  onChanged: (value) {
                                    setState(() {
                                      purchaseListPermission = value!;
                                    });
                                  },
                                  title:  Text(
                                    lang.S.of(context).purchaseList,
                                    //'Purchase List',
                                    style: const TextStyle(fontSize: 14), maxLines: 1,overflow: TextOverflow.ellipsis,),
                                ),
                              ),
                            ],
                          ),

                          ///_____LossProfit_&_Expense_________________________________________
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  contentPadding: const EdgeInsets.all(5),
                                  value: lossProfitPermission,
                                  onChanged: (value) {
                                    setState(() {
                                      lossProfitPermission = value!;
                                    });
                                  },
                                  title:  Text(
                                    lang.S.of(context).lossProfit,
                                    //'Loss Profit',
                                    style: TextStyle(fontSize: 14),),
                                ),
                              ),
                              Expanded(
                                child: CheckboxListTile(
                                  contentPadding: const EdgeInsets.all(5),
                                  value: addExpensePermission,
                                  onChanged: (value) {
                                    setState(() {
                                      addExpensePermission = value!;
                                    });
                                  },
                                  title:  Text(
                                    lang.S.of(context).expense,
                                    //'Expense',
                                    style: const TextStyle(fontSize: 14),),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                ///___________Text_fields_____________________________________________
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: globalKey,
                    child: Column(
                      children: [
                        ///________Phone_Number___________________________________________________________
                        // AppTextField(
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Phone can\'n be empty';
                        //     }
                        //     return null;
                        //   },
                        //   keyboardType: TextInputType.phone,
                        //   showCursor: true,
                        //   controller: phoneController,
                        //   // cursorColor: kTitleColor,
                        //   decoration: kInputDecoration.copyWith(
                        //     labelText: 'Phone',
                        //     // labelStyle: kTextStyle.copyWith(color: kTitleColor),
                        //     hintText: 'Enter your phone number',
                        //     // hintStyle: kTextStyle.copyWith(color: kLitGreyColor),
                        //     contentPadding: const EdgeInsets.all(10.0),
                        //     enabledBorder: const OutlineInputBorder(
                        //       borderRadius: BorderRadius.all(
                        //         Radius.circular(4.0),
                        //       ),
                        //       borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                        //     ),
                        //     errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                        //     focusedBorder: const OutlineInputBorder(
                        //       borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        //       borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                        //     ),
                        //   ),
                        //   textFieldType: TextFieldType.EMAIL,
                        // ),
                        // const SizedBox(height: 20.0),
                        // IntlPhoneField(
                        //   decoration: kInputDecoration.copyWith(
                        //     labelText: 'Phone Number',
                        //     hintText: 'Enter Phone Number'
                        //     // border: OutlineInputBorder(borderSide: BorderSide(), borderRadius: BorderRadius.all(Radius.circular(5))),
                        //   ),
                        //   initialCountryCode: 'BD',
                        //   // validator: (p0) {
                        //   //   if(phoneNumber!=null){
                        //   //     print(phoneNumber);
                        //   //     return '';
                        //   //   }
                        //   //   return null;
                        //   //   // if(!p0!.isValidNumber()){
                        //   //   //   return 'Enter';
                        //   //   // }
                        //   // },
                        //   onChanged: (phone) {
                        //     phoneNumber = phone.number;
                        //     phoneCode = phone.countryCode;
                        //   },
                        //   inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                        // ),

                        const SizedBox(height: 10),

                        ///__________email_________________________________________________________
                        AppTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                             // return 'Email can\'n be empty';
                              return lang.S.of(context).emailCannotBeEmpty;
                            } else if (!value.contains('@')) {
                              //return 'Please enter a valid email';
                              return lang.S.of(context).pleaseEnterAValidEmail;
                            }
                            return null;
                          },
                          showCursor: true,
                          controller: emailController,
                          // cursorColor: kTitleColor,
                          decoration: kInputDecoration.copyWith(
                            //labelText: 'Email',
                            labelText: lang.S.of(context).email,
                            // labelStyle: kTextStyle.copyWith(color: kTitleColor),
                            //hintText: 'Enter your email address',
                            hintText: lang.S.of(context).enterYourEmailAddress,
                            // hintStyle: kTextStyle.copyWith(color: kLitGreyColor),
                            contentPadding: const EdgeInsets.all(10.0),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                            ),
                            errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                            ),
                          ),
                          textFieldType: TextFieldType.EMAIL,
                        ),
                        const SizedBox(height: 20.0),

                        ///______password___________________________________________________________
                        // AppTextField(
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Password can\'t be empty';
                        //     } else if (value.length < 4) {
                        //       return 'Please enter a bigger password';
                        //     }
                        //     return null;
                        //   },
                        //   controller: passwordController,
                        //   showCursor: true,
                        //   // cursorColor: kTitleColor,
                        //   decoration: kInputDecoration.copyWith(
                        //     labelText: 'Password',
                        //     floatingLabelAlignment: FloatingLabelAlignment.start,
                        //     // labelStyle: kTextStyle.copyWith(color: kTitleColor),
                        //     hintText: 'Enter your password',
                        //     // hintStyle: kTextStyle.copyWith(color: kLitGreyColor),
                        //     contentPadding: const EdgeInsets.all(10.0),
                        //     enabledBorder: const OutlineInputBorder(
                        //       borderRadius: BorderRadius.all(
                        //         Radius.circular(4.0),
                        //       ),
                        //       borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                        //     ),
                        //     errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                        //     focusedBorder: const OutlineInputBorder(
                        //       borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        //       borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                        //     ),
                        //   ),
                        //   textFieldType: TextFieldType.PASSWORD,
                        // ),

                        ///________retype_email____________________________________________________
                        // const SizedBox(height: 20.0),
                        // AppTextField(
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Password can\'t be empty';
                        //     } else if (value != passwordController.text) {
                        //       return 'Password and confirm password does not match';
                        //     } else if (value.length < 4) {
                        //       return 'Please enter a bigger password';
                        //     }
                        //     return null;
                        //   },
                        //   controller: confirmPasswordController,
                        //   showCursor: true,
                        //   // cursorColor: kTitleColor,
                        //   decoration: kInputDecoration.copyWith(
                        //     labelText: 'Password',
                        //     floatingLabelAlignment: FloatingLabelAlignment.start,
                        //     // labelStyle: kTextStyle.copyWith(color: kTitleColor),
                        //     hintText: 'Enter your password',
                        //     // hintStyle: kTextStyle.copyWith(color: kLitGreyColor),
                        //     contentPadding: const EdgeInsets.all(10.0),
                        //     errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                        //     enabledBorder: const OutlineInputBorder(
                        //       borderRadius: BorderRadius.all(
                        //         Radius.circular(4.0),
                        //       ),
                        //       borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                        //     ),
                        //     focusedBorder: const OutlineInputBorder(
                        //       borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        //       borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                        //     ),
                        //   ),
                        //   textFieldType: TextFieldType.PASSWORD,
                        // ),

                        ///__________Title_________________________________________________________

                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              //return 'User title can\'n be empty';
                              return lang.S.of(context).useTitleCanNotBeEmpty;
                            }
                            return null;
                          },
                          showCursor: true,
                          controller: titleController,
                          decoration: kInputDecoration.copyWith(
                            //labelText: 'User Title',
                            labelText: lang.S.of(context).userTitle,
                           // hintText: 'Enter User Title',
                            hintText:lang.S.of(context).enterUserTitle,
                            // contentPadding: const EdgeInsets.all(10.0),
                            errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ButtonGlobalWithoutIcon(
             // buttontext: 'Create',
              buttontext: lang.S.of(context).create,
              buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
              onPressed: (() async {
                if (salePermission ||
                    partiesPermission ||
                    purchasePermission ||
                    productPermission ||
                    profileEditPermission ||
                    addExpensePermission ||
                    lossProfitPermission ||
                    dueListPermission ||
                    stockPermission ||
                    reportsPermission ||
                    salesListPermission ||
                    purchaseListPermission) {
                  if (validateAndSave()) {
                    EasyLoading.show();
                    user.Permission permission = user.Permission(
                      salePermission: salePermission,
                      partiesPermission: partiesPermission,
                      purchasePermission: purchasePermission,
                      productPermission: productPermission,
                      profileEditPermission: profileEditPermission,
                      addExpensePermission: addExpensePermission,
                      lossProfitPermission: lossProfitPermission,
                      dueListPermission: dueListPermission,
                      stockPermission: stockPermission,
                      reportsPermission: reportsPermission,
                      salesListPermission: salesListPermission,
                      purchaseListPermission: purchaseListPermission,
                    );

                    UserRoleRepo userRepo = UserRoleRepo();

                    await userRepo.addUser(
                      ref: ref,
                      context: context,
                      name: titleController.text,
                      email: emailController.text,
                      permission: permission,
                    );
                  }
                } else {
                  EasyLoading.showError(
                    lang.S.of(context).youHaveToGivePermission,
                      //'You Have To Give Permission'
                  );
                }
              }),
              buttonTextColor: Colors.white),
        ),
      );
    });
  }
}
