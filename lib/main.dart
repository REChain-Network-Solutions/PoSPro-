import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/Screens/Authentication/forgot_password.dart';
import 'package:mobile_pos/Screens/Authentication/login_form.dart';
import 'package:mobile_pos/Screens/Authentication/register_screen.dart';
import 'package:mobile_pos/Screens/Authentication/sign_in.dart';
import 'package:mobile_pos/Screens/Customers/customer_list.dart';
import 'package:mobile_pos/Screens/Expense/expense_list.dart';
import 'package:mobile_pos/Screens/Home/home.dart';
import 'package:mobile_pos/Screens/Payment/payment_options.dart';
import 'package:mobile_pos/Screens/Products/add_product.dart';
import 'package:mobile_pos/Screens/Products/product_list_screen.dart';
import 'package:mobile_pos/Screens/Profile/profile_screen.dart';
import 'package:mobile_pos/Screens/Report/reports.dart';
import 'package:mobile_pos/Screens/Sales/add_discount.dart';
import 'package:mobile_pos/Screens/Sales/add_promo_code.dart';
import 'package:mobile_pos/Screens/Sales/sales_contact.dart';
import 'package:mobile_pos/Screens/SplashScreen/on_board.dart';
import 'package:mobile_pos/Screens/SplashScreen/splash_screen.dart';
import 'package:mobile_pos/Screens/stock_list/stock_list.dart';
import 'package:provider/provider.dart' as pro;
import 'package:shurjopay/utilities/functions.dart';
import 'Screens/Due Calculation/due_calculation_contact_screen.dart';
import 'Screens/Home/home_screen.dart';
import 'Screens/Loss_Profit/loss_profit_screen.dart';
import 'Screens/Products/update_product.dart';
import 'Screens/Purchase List/purchase_list_screen.dart';
import 'Screens/Purchase/choose_supplier_screen.dart';
import 'Screens/Sales List/sales_list_screen.dart';
import 'Screens/language/language_provider.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeShurjopay(environment: 'live');
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return pro.ChangeNotifierProvider<LanguageChangeProvider>(
      create: (context) => LanguageChangeProvider(),
      child: Builder(
          builder: (context) => MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: pro.Provider.of<LanguageChangeProvider>(context, listen: true).currentLocale,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                title: 'POSpro',
                initialRoute: '/',
                builder: EasyLoading.init(),
                routes: {
                  '/': (context) => const SplashScreen(),
                  '/onBoard': (context) => const OnBoard(),
                  '/signIn': (context) => const SignInScreen(),
                  '/loginForm': (context) => const LoginForm(isEmailLogin: true),
                  '/signup': (context) => const RegisterScreen(),
                  '/forgotPassword': (context) => const ForgotPassword(),
                  '/home': (context) => const Home(),
                  '/profile': (context) => const ProfileScreen(),
                  '/AddProducts': (context) => AddProduct(),
                  '/UpdateProducts': (context) => UpdateProduct(),
                  '/Products': (context) => const ProductList(),
                  '/salesCustomer': (context) => const SalesContact(),
                  '/addPromoCode': (context) => const AddPromoCode(),
                  '/addDiscount': (context) => const AddDiscount(),
                  '/Sales': (context) => const SalesContact(),
                  '/Parties': (context) => const CustomerList(),
                  '/Expense': (context) => const ExpenseList(),
                  '/Stock': (context) => const StockList(isFromReport: false,),
                  '/Purchase': (context) => const PurchaseContacts(),
                  '/Reports': (context) => const Reports(),
                  '/Due List': (context) => const DueCalculationContactScreen(),
                  '/PaymentOptions': (context) => const PaymentOptions(),
                  '/Sales List': (context) => const SalesListScreen(),
                  '/Purchase List': (context) => const PurchaseListScreen(),
                  '/Loss/Profit': (context) => const LossProfitScreen(),
                },
              )),
    );
  }
}
