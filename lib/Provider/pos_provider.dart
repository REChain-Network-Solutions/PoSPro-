import 'package:flutter/foundation.dart';
import 'dart:math';

/// Провайдер для POS-системы
class POSProvider extends ChangeNotifier {
  // Состояние кассы
  bool _isCashRegisterOpen = false;
  double _cashAmount = 0.0;
  String? _currentCashier;
  String? _error;
  bool _isLoading = false;

  // Геттеры
  bool get isCashRegisterOpen => _isCashRegisterOpen;
  double get cashAmount => _cashAmount;
  String? get currentCashier => _currentCashier;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // Текущая продажа
  List<CartItem> _currentCart = [];
  double _cartTotal = 0.0;
  double _cartDiscount = 0.0;
  String _paymentMethod = 'cash';

  // Геттеры корзины
  List<CartItem> get currentCart => _currentCart;
  double get cartTotal => _cartTotal;
  double get cartDiscount => _cartDiscount;
  String get paymentMethod => _paymentMethod;

  // История продаж
  List<Sale> _salesHistory = [];
  List<Sale> _todaySales = [];

  // Геттеры истории
  List<Sale> get salesHistory => _salesHistory;
  List<Sale> get todaySales => _todaySales;

  /// Инициализация провайдера
  Future<void> initialize() async {
    try {
      _setLoading(true);
      _clearError();
      
      // Загружаем историю продаж
      await _loadSalesHistory();
      
      // Загружаем продажи за сегодня
      await _loadTodaySales();
      
    } catch (e) {
      _setError('Error initializing POS: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Открытие кассы
  Future<bool> openCashRegister(String cashierName, double initialAmount) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Проверяем, не открыта ли уже касса
      if (_isCashRegisterOpen) {
        _setError('Касса уже открыта');
        return false;
      }
      
      // Имитируем задержку
      await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(1000)));
      
      _isCashRegisterOpen = true;
      _currentCashier = cashierName;
      _cashAmount = initialAmount;
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Error opening cash register: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Закрытие кассы
  Future<bool> closeCashRegister() async {
    try {
      _setLoading(true);
      _clearError();
      
      // Проверяем, есть ли активные продажи
      if (_currentCart.isNotEmpty) {
        _setError('Нельзя закрыть кассу с активной корзиной');
        return false;
      }
      
      // Имитируем задержку
      await Future.delayed(Duration(milliseconds: 300 + Random().nextInt(500)));
      
      _isCashRegisterOpen = false;
      _currentCashier = null;
      _cashAmount = 0.0;
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Error closing cash register: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Добавление товара в корзину
  void addToCart(Map<String, dynamic> product, {int quantity = 1}) {
    try {
      // Проверяем, открыта ли касса
      if (!_isCashRegisterOpen) {
        _setError('Касса не открыта');
        return;
      }
      
      // Проверяем, есть ли товар в корзине
      final existingIndex = _currentCart.indexWhere((item) => item.productId == product['id']);
      
      if (existingIndex != -1) {
        // Увеличиваем количество
        _currentCart[existingIndex].quantity += quantity;
      } else {
        // Добавляем новый товар
        _currentCart.add(CartItem(
          productId: product['id'],
          name: product['name'],
          price: product['price']?.toDouble() ?? 0.0,
          quantity: quantity,
          imageUrl: product['image_url'],
        ));
      }
      
      _updateCartTotal();
      notifyListeners();
      
    } catch (e) {
      _setError('Error adding to cart: $e');
    }
  }

  /// Удаление товара из корзины
  void removeFromCart(String productId) {
    try {
      _currentCart.removeWhere((item) => item.productId == productId);
      _updateCartTotal();
      notifyListeners();
      
    } catch (e) {
      _setError('Error removing from cart: $e');
    }
  }

  /// Изменение количества товара
  void updateQuantity(String productId, int quantity) {
    try {
      if (quantity <= 0) {
        removeFromCart(productId);
        return;
      }
      
      final itemIndex = _currentCart.indexWhere((item) => item.productId == productId);
      if (itemIndex != -1) {
        _currentCart[itemIndex].quantity = quantity;
        _updateCartTotal();
        notifyListeners();
      }
      
    } catch (e) {
      _setError('Error updating quantity: $e');
    }
  }

  /// Очистка корзины
  void clearCart() {
    _currentCart.clear();
    _cartTotal = 0.0;
    _cartDiscount = 0.0;
    notifyListeners();
  }

  /// Применение скидки
  void applyDiscount(double discountPercent) {
    try {
      if (discountPercent < 0 || discountPercent > 100) {
        _setError('Неверный процент скидки');
        return;
      }
      
      _cartDiscount = (_cartTotal * discountPercent) / 100;
      notifyListeners();
      
    } catch (e) {
      _setError('Error applying discount: $e');
    }
  }

  /// Установка способа оплаты
  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  /// Завершение продажи
  Future<Sale?> completeSale() async {
    try {
      if (_currentCart.isEmpty) {
        _setError('Корзина пуста');
        return null;
      }
      
      if (!_isCashRegisterOpen) {
        _setError('Касса не открыта');
        return null;
      }
      
      _setLoading(true);
      
      // Создаем продажу
      final sale = Sale(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        items: List.from(_currentCart),
        total: _cartTotal,
        discount: _cartDiscount,
        finalTotal: _cartTotal - _cartDiscount,
        paymentMethod: _paymentMethod,
        cashier: _currentCashier ?? 'Unknown',
        timestamp: DateTime.now(),
        status: 'completed',
      );
      
      // Добавляем в историю
      _salesHistory.add(sale);
      _todaySales.add(sale);
      
      // Обновляем кассу
      if (_paymentMethod == 'cash') {
        _cashAmount += sale.finalTotal;
      }
      
      // Очищаем корзину
      clearCart();
      
      notifyListeners();
      return sale;
      
    } catch (e) {
      _setError('Error completing sale: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Возврат товара
  Future<bool> returnItem(Sale sale, String productId, int quantity) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Находим товар в продаже
      final item = sale.items.firstWhere((item) => item.productId == productId);
      
      if (item.quantity < quantity) {
        _setError('Неверное количество для возврата');
        return false;
      }
      
      // Создаем возврат
      final returnSale = Sale(
        id: 'return_${DateTime.now().millisecondsSinceEpoch}',
        items: [CartItem(
          productId: item.productId,
          name: item.name,
          price: item.price,
          quantity: quantity,
          imageUrl: item.imageUrl,
        )],
        total: item.price * quantity,
        discount: 0.0,
        finalTotal: item.price * quantity,
        paymentMethod: 'return',
        cashier: _currentCashier ?? 'Unknown',
        timestamp: DateTime.now(),
        status: 'returned',
        originalSaleId: sale.id,
      );
      
      // Добавляем в историю
      _salesHistory.add(returnSale);
      
      // Обновляем кассу
      if (sale.paymentMethod == 'cash') {
        _cashAmount -= returnSale.finalTotal;
      }
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Error returning item: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Получение статистики продаж
  Map<String, dynamic> getSalesStats() {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      // Продажи за сегодня
      final todaySales = _salesHistory.where((sale) => 
        sale.timestamp.isAfter(today) && sale.status == 'completed'
      ).toList();
      
      // Продажи за неделю
      final weekAgo = today.subtract(const Duration(days: 7));
      final weekSales = _salesHistory.where((sale) => 
        sale.timestamp.isAfter(weekAgo) && sale.status == 'completed'
      ).toList();
      
      // Продажи за месяц
      final monthAgo = DateTime(now.year, now.month - 1, now.day);
      final monthSales = _salesHistory.where((sale) => 
        sale.timestamp.isAfter(monthAgo) && sale.status == 'completed'
      ).toList();
      
      // Топ товаров
      final productStats = <String, int>{};
      for (final sale in _salesHistory.where((s) => s.status == 'completed')) {
        for (final item in sale.items) {
          productStats[item.name] = (productStats[item.name] ?? 0) + item.quantity;
        }
      }
      
      final topProducts = productStats.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      
      return {
        'today': {
          'count': todaySales.length,
          'total': todaySales.fold(0.0, (sum, sale) => sum + sale.finalTotal),
        },
        'week': {
          'count': weekSales.length,
          'total': weekSales.fold(0.0, (sum, sale) => sum + sale.finalTotal),
        },
        'month': {
          'count': monthSales.length,
          'total': monthSales.fold(0.0, (sum, sale) => sum + sale.finalTotal),
        },
        'top_products': topProducts.take(5).map((e) => {
          'name': e.key,
          'quantity': e.value,
        }).toList(),
      };
      
    } catch (e) {
      _setError('Error getting sales stats: $e');
      return {};
    }
  }

  // Приватные методы

  /// Обновление общей суммы корзины
  void _updateCartTotal() {
    _cartTotal = _currentCart.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  /// Загрузка истории продаж
  Future<void> _loadSalesHistory() async {
    // Имитируем загрузку данных
    await Future.delayed(Duration(milliseconds: 300));
    
    // Создаем тестовые данные
    _salesHistory = [
      Sale(
        id: '1',
        items: [
          CartItem(
            productId: '1',
            name: 'Платье "Элегантность"',
            price: 8990.0,
            quantity: 1,
            imageUrl: 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446',
          ),
        ],
        total: 8990.0,
        discount: 0.0,
        finalTotal: 8990.0,
        paymentMethod: 'card',
        cashier: 'Анна Петрова',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        status: 'completed',
      ),
      Sale(
        id: '2',
        items: [
          CartItem(
            productId: '2',
            name: 'Блузка "Деловой стиль"',
            price: 6990.0,
            quantity: 2,
            imageUrl: 'https://images.unsplash.com/photo-1564257631407-3deb25f9c8e8',
          ),
        ],
        total: 13980.0,
        discount: 1398.0,
        finalTotal: 12582.0,
        paymentMethod: 'cash',
        cashier: 'Мария Иванова',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        status: 'completed',
      ),
    ];
  }

  /// Загрузка продаж за сегодня
  Future<void> _loadTodaySales() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    _todaySales = _salesHistory.where((sale) => 
      sale.timestamp.isAfter(today) && sale.status == 'completed'
    ).toList();
  }

  /// Очистка ошибок
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Приватные методы для управления состоянием
  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _setError(String error) {
    _error = error;
  }

  void _clearError() {
    _error = null;
  }
}

/// Модель товара в корзине
class CartItem {
  final String productId;
  final String name;
  final double price;
  int quantity;
  final String? imageUrl;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  double get total => price * quantity;
}

/// Модель продажи
class Sale {
  final String id;
  final List<CartItem> items;
  final double total;
  final double discount;
  final double finalTotal;
  final String paymentMethod;
  final String cashier;
  final DateTime timestamp;
  final String status;
  final String? originalSaleId;

  Sale({
    required this.id,
    required this.items,
    required this.total,
    required this.discount,
    required this.finalTotal,
    required this.paymentMethod,
    required this.cashier,
    required this.timestamp,
    required this.status,
    this.originalSaleId,
  });
}
