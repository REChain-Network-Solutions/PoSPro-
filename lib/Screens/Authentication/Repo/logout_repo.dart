import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:restart_app/restart_app.dart';

import '../../../Const/api_config.dart';
import '../../../Repository/constant_functions.dart';

class LogOutRepo {
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    EasyLoading.showSuccess('Successfully Logged Out');
    // final container = ProviderContainer();
    // container.dispose();
    Restart.restartApp();
    // const SplashScreen().launch(context, isNewTask: true);
  }

  Future<void> signOutApi({required BuildContext context, required WidgetRef ref}) async {
    final uri = Uri.parse('${APIConfig.url}/sign-out');

    await http.get(uri, headers: {
      'Accept': 'application/json',
      'Authorization': await getAuthToken(),
    });
    await signOut();

    // if (response.statusCode == 200) {
    //
    //
    //   // Parse into Party objects
    // } else {
    //   EasyLoading.showError('Logout Failed');
    // }
  }
}
