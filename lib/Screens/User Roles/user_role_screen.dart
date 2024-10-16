import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/User%20Roles/user_role_details.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import 'Provider/user_role_provider.dart';
import 'add_user_role_screen.dart';

class UserRoleScreen extends StatefulWidget {
  const UserRoleScreen({Key? key}) : super(key: key);

  @override
  State<UserRoleScreen> createState() => _UserRoleScreenState();
}

class _UserRoleScreenState extends State<UserRoleScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final userRoleData = ref.watch(userRoleProvider);
      return Scaffold(
        backgroundColor: kWhite,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            lang.S.of(context).userRole,
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
            padding: const EdgeInsets.all(16.0),
            child: userRoleData.when(data: (users) {
              if (users.isNotEmpty) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: kWhite,
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xff0C1A4B).withOpacity(0.24),
                                blurRadius: 1
                            ),
                            BoxShadow(
                                color: const Color(0xff473232).withOpacity(0.05),
                                offset: const Offset(0, 3),
                                spreadRadius: -1,
                                blurRadius: 8
                            )
                          ],
                        ),
                        child: ListTile(
                          visualDensity: const VisualDensity(vertical: -4,horizontal: -4),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          onTap: () {
                            UserRoleDetails(
                              userRoleModel: users[index],
                            ).launch(context);
                          },
                          title: Text(users[index].email ?? ''),
                          subtitle: Text(users[index].name ?? ''),
                          trailing:  const Icon(Icons.arrow_forward_ios,color: kGreyTextColor,size: 20,),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text(lang.S.of(context).noRoleFound));
              }
            }, error: (e, stack) {
              return Text(e.toString());
            }, loading: () {
              return const Center(child: CircularProgressIndicator());
            }),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              const AddUserRole().launch(context);
            },
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                color: kMainColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                child: Text(
                  lang.S.of(context).addUserRole,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
