import 'package:flutter/material.dart';

class MyModusIcons {
  // Главная - Дом с модным дизайном
  static const IconData home = IconData(0xe900, fontFamily: 'MyModusIcons');
  
  // Мода - Стильный силуэт
  static const IconData fashion = IconData(0xe901, fontFamily: 'MyModusIcons');
  
  // Маркетплейс - Магазин с короной
  static const IconData marketplace = IconData(0xe902, fontFamily: 'MyModusIcons');
  
  // AI - Мозг с нейросетью
  static const IconData ai = IconData(0xe903, fontFamily: 'MyModusIcons');
  
  // Web3 - Блокчейн куб
  static const IconData web3 = IconData(0xe904, fontFamily: 'MyModusIcons');
  
  // Соцсети - Связанные люди
  static const IconData social = IconData(0xe905, fontFamily: 'MyModusIcons');
  
  // Профиль - Стильный аватар
  static const IconData profile = IconData(0xe906, fontFamily: 'MyModusIcons');
  
  // AI-чат - Чат с искрой
  static const IconData aiChat = IconData(0xe907, fontFamily: 'MyModusIcons');
  
  // POS - Касса с модным дизайном
  static const IconData pos = IconData(0xe908, fontFamily: 'MyModusIcons');
  
  // Склад - Склад с трендом
  static const IconData inventory = IconData(0xe909, fontFamily: 'MyModusIcons');
  
  // NFT - Токен с искусством
  static const IconData nft = IconData(0xe90a, fontFamily: 'MyModusIcons');
  
  // Аналитика - График с трендом
  static const IconData analytics = IconData(0xe90b, fontFamily: 'MyModusIcons');
  
  // Сайт - Глобус My Modus
  static const IconData website = IconData(0xe90c, fontFamily: 'MyModusIcons');
}

// Альтернативные иконки с использованием комбинации стандартных
class MyModusIconWidgets {
  // Главная - Комбинация dashboard и home
  static Widget home(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final iconSize = isSmallScreen ? 16.0 : 20.0;
    final padding = isSmallScreen ? 4.0 : 8.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.dashboard, color: Colors.blue, size: iconSize),
    );
  }
  
  // Мода - Комбинация style и fashion
  static Widget fashion(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final iconSize = isSmallScreen ? 16.0 : 20.0;
    final padding = isSmallScreen ? 4.0 : 8.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.pink.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.style, color: Colors.pink, size: iconSize),
    );
  }

  // Маркетплейс - Комбинация store и shopping_cart
  static Widget marketplace(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final iconSize = isSmallScreen ? 16.0 : 20.0;
    final padding = isSmallScreen ? 4.0 : 8.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.store, color: Colors.green, size: iconSize),
    );
  }

  // AI - Комбинация psychology и smart_toy
  static Widget ai(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final iconSize = isSmallScreen ? 16.0 : 20.0;
    final padding = isSmallScreen ? 4.0 : 8.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.psychology, color: Colors.purple, size: iconSize),
    );
  }

  // Web3 - Комбинация account_balance_wallet и currency_bitcoin
  static Widget web3(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final iconSize = isSmallScreen ? 16.0 : 20.0;
    final padding = isSmallScreen ? 4.0 : 8.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.account_balance_wallet, color: Colors.orange, size: iconSize),
    );
  }

  // Соцсети - Комбинация people и share
  static Widget social(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final iconSize = isSmallScreen ? 16.0 : 20.0;
    final padding = isSmallScreen ? 4.0 : 8.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.people, color: Colors.teal, size: iconSize),
    );
  }

  // Профиль - Комбинация person и account_circle
  static Widget profile(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final iconSize = isSmallScreen ? 16.0 : 20.0;
    final padding = isSmallScreen ? 4.0 : 8.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.person, color: Colors.indigo, size: iconSize),
    );
  }

  // AI-чат - Комбинация chat_bubble и smart_toy
  static Widget aiChat(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final iconSize = isSmallScreen ? 16.0 : 20.0;
    final padding = isSmallScreen ? 4.0 : 8.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.chat_bubble, color: Colors.deepPurple, size: iconSize),
    );
  }

  // POS - Комбинация point_of_sale и receipt
  static Widget pos(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final iconSize = isSmallScreen ? 16.0 : 20.0;
    final padding = isSmallScreen ? 4.0 : 8.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.point_of_sale, color: Colors.red, size: iconSize),
    );
  }

  // Склад - Комбинация inventory и warehouse
  static Widget inventory(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final iconSize = isSmallScreen ? 16.0 : 20.0;
    final padding = isSmallScreen ? 4.0 : 8.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.brown.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.inventory, color: Colors.brown, size: iconSize),
    );
  }

  // NFT - Комбинация token и art_track
  static Widget nft(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final iconSize = isSmallScreen ? 16.0 : 20.0;
    final padding = isSmallScreen ? 4.0 : 8.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.token, color: Colors.amber, size: iconSize),
    );
  }

  // Аналитика - Комбинация analytics и trending_up
  static Widget analytics(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final iconSize = isSmallScreen ? 16.0 : 20.0;
    final padding = isSmallScreen ? 4.0 : 8.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.lightGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.analytics, color: Colors.lightGreen, size: iconSize),
    );
  }

  // Сайт - Комбинация web и language
  static Widget website(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final iconSize = isSmallScreen ? 16.0 : 20.0;
    final padding = isSmallScreen ? 4.0 : 8.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.cyan.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.web, color: Colors.cyan, size: iconSize),
    );
  }
}
