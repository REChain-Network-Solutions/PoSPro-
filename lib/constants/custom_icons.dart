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
  static Widget home = Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.blue.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.dashboard, color: Colors.blue, size: 20),
  );
  
  // Мода - Комбинация style и fashion
  static Widget fashion = Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.pink.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.style, color: Colors.pink, size: 20),
  );
  
  // Маркетплейс - Комбинация store и shopping_cart
  static Widget marketplace = Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.green.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.store, color: Colors.green, size: 20),
  );
  
  // AI - Комбинация psychology и smart_toy
  static Widget ai = Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.purple.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.psychology, color: Colors.purple, size: 20),
  );
  
  // Web3 - Комбинация account_balance_wallet и currency_bitcoin
  static Widget web3 = Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.orange.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.account_balance_wallet, color: Colors.orange, size: 20),
  );
  
  // Соцсети - Комбинация people и share
  static Widget social = Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.teal.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.people, color: Colors.teal, size: 20),
  );
  
  // Профиль - Комбинация person и account_circle
  static Widget profile = Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.indigo.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.person, color: Colors.indigo, size: 20),
  );
  
  // AI-чат - Комбинация chat_bubble и smart_toy
  static Widget aiChat = Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.deepPurple.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.chat_bubble, color: Colors.deepPurple, size: 20),
  );
  
  // POS - Комбинация point_of_sale и receipt
  static Widget pos = Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.red.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.point_of_sale, color: Colors.red, size: 20),
  );
  
  // Склад - Комбинация inventory и warehouse
  static Widget inventory = Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.brown.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.inventory, color: Colors.brown, size: 20),
  );
  
  // NFT - Комбинация token и art_track
  static Widget nft = Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.amber.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.token, color: Colors.amber, size: 20),
  );
  
  // Аналитика - Комбинация analytics и trending_up
  static Widget analytics = Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.lightGreen.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.analytics, color: Colors.lightGreen, size: 20),
  );
  
  // Сайт - Комбинация web и language
  static Widget website = Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.cyan.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.web, color: Colors.cyan, size: 20),
  );
}
