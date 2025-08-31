import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'Provider/app_provider.dart';
import 'Provider/auth_provider.dart';
import 'Provider/ai_provider.dart';
import 'Provider/web3_provider.dart';
import 'Provider/blockchain_provider.dart';
import 'Provider/analytics_provider.dart';
import 'Provider/social_provider.dart';
import 'Provider/product_provider.dart';
import 'Provider/inventory_provider.dart';
import 'Provider/nft_provider.dart';
import 'Screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Создаем и инициализируем AppProvider
  final appProvider = AppProvider();
  await appProvider.initialize();
  
  runApp(PoSProApp(appProvider: appProvider));
}

class PoSProApp extends StatelessWidget {
  final AppProvider appProvider;
  
  const PoSProApp({super.key, required this.appProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Основной провайдер приложения (уже инициализированный)
        ChangeNotifierProvider.value(value: appProvider),
        
        // Провайдеры для различных функций (используем те же экземпляры)
        ChangeNotifierProvider.value(value: appProvider.authProvider),
        ChangeNotifierProvider.value(value: appProvider.aiProvider),
        ChangeNotifierProvider.value(value: appProvider.web3Provider),
        ChangeNotifierProvider.value(value: appProvider.blockchainProvider),
        ChangeNotifierProvider.value(value: appProvider.analyticsProvider),
        ChangeNotifierProvider.value(value: appProvider.socialProvider),
        ChangeNotifierProvider.value(value: appProvider.productProvider),
        ChangeNotifierProvider.value(value: appProvider.aiChatProvider),
        ChangeNotifierProvider.value(value: appProvider.posProvider),
        ChangeNotifierProvider.value(value: appProvider.inventoryProvider),
        ChangeNotifierProvider.value(value: appProvider.nftProvider),
      ],
      child: MaterialApp(
        title: 'PoSPro - AI & Web3 PoS System',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
          
          // Настройки AppBar
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Color(0xFF2196F3),
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          
          // Настройки кнопок
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          
          // Настройки карточек
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          
          // Настройки полей ввода
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        
        // Темная тема
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
          
          // Настройки AppBar для темной темы
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Color(0xFF1976D2),
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          
          // Настройки кнопок для темной темы
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          
          // Настройки карточек для темной темы
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          
          // Настройки полей ввода для темной темы
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        
        home: const MainScreen(),
        
        // Настройки локализации
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ru', 'RU'),
          Locale('en', 'US'),
        ],
        locale: const Locale('en', 'US'), // Временно используем английский для избежания ошибок
        
        // Настройки отладки
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
