// ignore_for_file: unused_result
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/User%20Roles/Model/user_role_model.dart' as user;
import 'package:mobile_pos/Screens/User%20Roles/Repo/user_role_repo.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'Model/user_role_model.dart';

class UserRoleDetails extends StatefulWidget {
  const UserRoleDetails({Key? key, required this.userRoleModel}) : super(key: key);

  final UserRoleModel userRoleModel;

  @override
  // ignore: library_private_types_in_public_api
  _UserRoleDetailsState createState() => _UserRoleDetailsState();
}

class _UserRoleDetailsState extends State<UserRoleDetails> {
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
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  bool isMailSent = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    salePermission = widget.userRoleModel.visibility?.salePermission ?? false;
    partiesPermission = widget.userRoleModel.visibility?.partiesPermission ?? false;
    purchasePermission = widget.userRoleModel.visibility?.purchasePermission ?? false;
    productPermission = widget.userRoleModel.visibility?.productPermission ?? false;
    profileEditPermission = widget.userRoleModel.visibility?.profileEditPermission ?? false;
    addExpensePermission = widget.userRoleModel.visibility?.addExpensePermission ?? false;
    lossProfitPermission = widget.userRoleModel.visibility?.lossProfitPermission ?? false;
    dueListPermission = widget.userRoleModel.visibility?.dueListPermission ?? false;
    stockPermission = widget.userRoleModel.visibility?.stockPermission ?? false;
    reportsPermission = widget.userRoleModel.visibility?.reportsPermission ?? false;
    salesListPermission = widget.userRoleModel.visibility?.salesListPermission ?? false;
    purchaseListPermission = widget.userRoleModel.visibility?.purchaseListPermission ?? false;
    emailController.text = widget.userRoleModel.email ?? '';
    phoneController.text = widget.userRoleModel.phone ?? '';
    titleController.text = widget.userRoleModel.name ?? '';
  }

  List<UserRoleModel> adminRoleList = [];
  List<UserRoleModel> userRoleList = [];

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            lang.S.of(context).userRoleDetails,
           // 'User Role Details',
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context1) {
                      return Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                   Text(
                                     lang.S.of(context).doYouWantToDeleteTheUser,
                                       //'Do you want to delete the user?',
                                       style: const TextStyle(fontSize: 20)),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ButtonGlobalWithoutIcon(
                                          //buttontext: 'Cancel',
                                          buttontext: lang.S.of(context).cancel,
                                          buttonDecoration: kButtonDecoration.copyWith(color: Colors.green),
                                          onPressed: (() {
                                            Navigator.pop(context1);
                                          }),
                                          buttonTextColor: Colors.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: ButtonGlobalWithoutIcon(
                                            //buttontext: 'Delete',
                                            buttontext: lang.S.of(context).delete,
                                            buttonDecoration: kButtonDecoration.copyWith(color: Colors.red),
                                            onPressed: (() async {
                                              EasyLoading.show(status: lang.S.of(context).loading,
                                              //'loading..'
                                              );
                                              UserRoleRepo repo = UserRoleRepo();
                                              await repo.deleteUser(id: widget.userRoleModel.id.toString(), context: context, ref: ref);
                                            }),
                                            buttonTextColor: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
          ],
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
                    child: Column(
                      children: [
                        ///_______all_&_sale____________________________________________
                        Row(
                          children: [
                            ///_______all__________________________
                            SizedBox(
                              width: context.width() / 2 - 20,
                              child: CheckboxListTile(
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
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),

                        ///_______Edit Profile_&_sale____________________________________________
                        Row(
                          children: [
                            ///_______Edit_Profile_________________________
                            Expanded(
                              child: CheckboxListTile(
                                value: profileEditPermission,
                                onChanged: (value) {
                                  setState(() {
                                    profileEditPermission = value!;
                                  });
                                },
                                title:  Text(
                                  lang.S.of(context).profileEdit,
                                  //'Profile Edit',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),

                            ///______sales____________________________
                            Expanded(
                              child: CheckboxListTile(
                                value: salePermission,
                                onChanged: (value) {
                                  setState(() {
                                    salePermission = value!;
                                  });
                                },
                                title:  Text(
                                  lang.S.of(context).sales,
                                  //'Sales',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),

                        ///_____parties_&_Purchase_________________________________________
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: partiesPermission,
                                onChanged: (value) {
                                  setState(() {
                                    partiesPermission = value!;
                                  });
                                },
                                title:  Text(
                                  lang.S.of(context).parties,
                                  //'Parties',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                value: purchasePermission,
                                onChanged: (value) {
                                  setState(() {
                                    purchasePermission = value!;
                                  });
                                },
                                title:  Text(
                                  lang.S.of(context).purchase,
                                 // 'Purchase',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),

                        ///_____Product_&_DueList_________________________________________
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: productPermission,
                                onChanged: (value) {
                                  setState(() {
                                    productPermission = value!;
                                  });
                                },
                                title:  Text(
                                  lang.S.of(context).products,
                                 // 'Products',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                value: dueListPermission,
                                onChanged: (value) {
                                  setState(() {
                                    dueListPermission = value!;
                                  });
                                },
                                title:  Text(
                                  lang.S.of(context).dueList,
                                  //'Due List',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),

                        ///_____Stock_&_Reports_________________________________________
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: stockPermission,
                                onChanged: (value) {
                                  setState(() {
                                    stockPermission = value!;
                                  });
                                },
                                title:  Text(
                                  lang.S.of(context).stock,
                                  //'Stock',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                value: reportsPermission,
                                onChanged: (value) {
                                  setState(() {
                                    reportsPermission = value!;
                                  });
                                },
                                title:  Text(
                                  lang.S.of(context).reports,
                                  //'Reports',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),

                        ///_____SalesList_&_Purchase List_________________________________________
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: salesListPermission,
                                onChanged: (value) {
                                  setState(() {
                                    salesListPermission = value!;
                                  });
                                },
                                title:  Text(
                                  lang.S.of(context).salesList,
                                  //'Sales List',
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                value: purchaseListPermission,
                                onChanged: (value) {
                                  setState(() {
                                    purchaseListPermission = value!;
                                  });
                                },
                                title:  Text(
                                  lang.S.of(context).purchaseList,
                                 // 'Purchase List',
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),

                        ///_____LossProfit_&_Expense_________________________________________
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: lossProfitPermission,
                                onChanged: (value) {
                                  setState(() {
                                    lossProfitPermission = value!;
                                  });
                                },
                                title:  Text(
                                  lang.S.of(context).lossProfit,
                                  //'Loss Profit',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                value: addExpensePermission,
                                onChanged: (value) {
                                  setState(() {
                                    addExpensePermission = value!;
                                  });
                                },
                                title:  Text(
                                  lang.S.of(context).expense,
                                  //'Expense',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                ///___________Text_fields_____________________________________________
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: globalKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ///__________email_________________________________________________________
                        AppTextField(
                          // readOnly: true,
                          controller: emailController,
                          // initialValue: widget.userRoleModel.email,
                          // cursorColor: kTitleColor,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              //return 'Email can\'n be empty';
                              return lang.S.of(context).emailCannotBeEmpty;
                            } else if (!value.contains('@')) {
                              //return 'Please enter a valid email';
                              return lang.S.of(context).pleaseEnterAValidEmail;
                            }
                            return null;
                          },
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
                        // TextFormField(
                        //   controller: phoneController,
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'User Phone can\'n be empty';
                        //     }
                        //     return null;
                        //   },
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
                        // ),
                        const SizedBox(height: 20.0),

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
                            hintText: lang.S.of(context).enterUserTitle,
                            contentPadding: const EdgeInsets.all(10.0),
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
                        // const SizedBox(height: 20.0),
                        //
                        // TextButton(
                        //   onPressed: () async {
                        //     try {
                        //       EasyLoading.show(status: 'Loading....');
                        //       await FirebaseAuth.instance.sendPasswordResetEmail(
                        //         email: widget.userRoleModel.email ?? '',
                        //       );
                        //
                        //       EasyLoading.showSuccess('An Email has been sent\nCheck your inbox');
                        //       setState(() {
                        //         isMailSent = true;
                        //       });
                        //     } catch (e) {
                        //       EasyLoading.showError(e.toString());
                        //     }
                        //   },
                        //   child: const Text('Forget password? '),
                        // ).visible(!isMailSent),
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
              //buttontext: 'Update',
              buttontext: lang.S.of(context).update,
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
                    EasyLoading.show(status:
                        lang.S.of(context).loading,
                    //'loading..'
                    );
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
                    UserRoleRepo repo = UserRoleRepo();
                    await repo.updateUser(
                      userId: widget.userRoleModel.id.toString(),
                      ref: ref,
                      context: context,
                      userName: titleController.text,
                      email: emailController.text,
                      permission: permission,
                    );
                  }
                } else {
                  EasyLoading.showError(
                    lang.S.of(context).youHaveToGivePermission
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
