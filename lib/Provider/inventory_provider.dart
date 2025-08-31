import 'package:flutter/foundation.dart';
import 'dart:math';

/// Провайдер для управления складом
class InventoryProvider extends ChangeNotifier {
  // Состояние склада
  bool _isLoading = false;
  String? _error;
  
  // Геттеры
  bool get isLoading => _isLoading;
  String? get error => _error;

  // История операций
  List<InventoryOperation> _operations = [];
  List<InventoryOperation> _todayOperations = [];
  
  // Геттеры операций
  List<InventoryOperation> get operations => _operations;
  List<InventoryOperation> get todayOperations => _todayOperations;

  /// Инициализация провайдера
  Future<void> initialize() async {
    try {
      _setLoading(true);
      _clearError();
      
      // Загружаем историю операций
      await _loadOperationsHistory();
      
      // Загружаем операции за сегодня
      await _loadTodayOperations();
      
    } catch (e) {
      _setError('Error initializing inventory: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Приход товаров
  Future<bool> addInventory(Map<String, dynamic> product, int quantity, String supplier, double cost) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Проверяем данные
      if (quantity <= 0) {
        _setError('Количество должно быть больше 0');
        return false;
      }
      
      if (cost <= 0) {
        _setError('Стоимость должна быть больше 0');
        return false;
      }
      
      // Имитируем задержку
      await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(1000)));
      
      // Создаем операцию прихода
      final operation = InventoryOperation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: OperationType.incoming,
        productId: product['id'],
        productName: product['name'],
        quantity: quantity,
        cost: cost,
        totalCost: cost * quantity,
        supplier: supplier,
        operator: 'Складской работник',
        timestamp: DateTime.now(),
        notes: 'Приход товара',
      );
      
      // Добавляем в историю
      _operations.add(operation);
      _todayOperations.add(operation);
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Error adding inventory: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Списание товаров
  Future<bool> removeInventory(Map<String, dynamic> product, int quantity, String reason, String operator) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Проверяем данные
      if (quantity <= 0) {
        _setError('Количество должно быть больше 0');
        return false;
      }
      
      // Проверяем остаток (в реальном приложении)
      final currentStock = product['stock_quantity'] ?? 0;
      if (quantity > currentStock) {
        _setError('Недостаточно товара на складе');
        return false;
      }
      
      // Имитируем задержку
      await Future.delayed(Duration(milliseconds: 300 + Random().nextInt(500)));
      
      // Создаем операцию списания
      final operation = InventoryOperation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: OperationType.outgoing,
        productId: product['id'],
        productName: product['name'],
        quantity: quantity,
        cost: product['cost'] ?? 0.0,
        totalCost: (product['cost'] ?? 0.0) * quantity,
        supplier: '',
        operator: operator,
        timestamp: DateTime.now(),
        notes: reason,
      );
      
      // Добавляем в историю
      _operations.add(operation);
      _todayOperations.add(operation);
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Error removing inventory: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Инвентаризация
  Future<bool> performInventory(Map<String, dynamic> product, int actualQuantity, int expectedQuantity, String operator) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Вычисляем разницу
      final difference = actualQuantity - expectedQuantity;
      
      if (difference == 0) {
        _setError('Количество совпадает, инвентаризация не требуется');
        return false;
      }
      
      // Имитируем задержку
      await Future.delayed(Duration(milliseconds: 400 + Random().nextInt(600)));
      
      // Создаем операцию инвентаризации
      final operation = InventoryOperation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: OperationType.inventory,
        productId: product['id'],
        productName: product['name'],
        quantity: difference.abs(),
        cost: product['cost'] ?? 0.0,
        totalCost: (product['cost'] ?? 0.0) * difference.abs(),
        supplier: '',
        operator: operator,
        timestamp: DateTime.now(),
        notes: 'Инвентаризация: ожидалось $expectedQuantity, фактически $actualQuantity',
      );
      
      // Добавляем в историю
      _operations.add(operation);
      _todayOperations.add(operation);
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Error performing inventory: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Перемещение товаров
  Future<bool> moveInventory(Map<String, dynamic> product, int quantity, String fromLocation, String toLocation, String operator) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Проверяем данные
      if (quantity <= 0) {
        _setError('Количество должно быть больше 0');
        return false;
      }
      
      if (fromLocation == toLocation) {
        _setError('Места отправления и назначения должны отличаться');
        return false;
      }
      
      // Имитируем задержку
      await Future.delayed(Duration(milliseconds: 350 + Random().nextInt(500)));
      
      // Создаем операцию перемещения
      final operation = InventoryOperation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: OperationType.movement,
        productId: product['id'],
        productName: product['name'],
        quantity: quantity,
        cost: product['cost'] ?? 0.0,
        totalCost: (product['cost'] ?? 0.0) * quantity,
        supplier: '',
        operator: operator,
        timestamp: DateTime.now(),
        notes: 'Перемещение: $fromLocation → $toLocation',
      );
      
      // Добавляем в историю
      _operations.add(operation);
      _todayOperations.add(operation);
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Error moving inventory: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Получение статистики склада
  Map<String, dynamic> getInventoryStats() {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      // Операции за сегодня
      final todayOps = _operations.where((op) => 
        op.timestamp.isAfter(today)
      ).toList();
      
      // Операции за неделю
      final weekAgo = today.subtract(const Duration(days: 7));
      final weekOps = _operations.where((op) => 
        op.timestamp.isAfter(weekAgo)
      ).toList();
      
      // Операции за месяц
      final monthAgo = DateTime(now.year, now.month - 1, now.day);
      final monthOps = _operations.where((op) => 
        op.timestamp.isAfter(monthAgo)
      ).toList();
      
      // Статистика по типам операций
      final typeStats = <String, int>{};
      for (final op in _operations) {
        final typeName = _getOperationTypeName(op.type);
        typeStats[typeName] = (typeStats[typeName] ?? 0) + 1;
      }
      
      // Топ товаров по операциям
      final productStats = <String, int>{};
      for (final op in _operations) {
        productStats[op.productName] = (productStats[op.productName] ?? 0) + op.quantity;
      }
      
      final topProducts = productStats.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      
      // Общая стоимость операций
      final totalValue = _operations.fold(0.0, (sum, op) => sum + op.totalCost);
      
      return {
        'today': {
          'count': todayOps.length,
          'value': todayOps.fold(0.0, (sum, op) => sum + op.totalCost),
        },
        'week': {
          'count': weekOps.length,
          'value': weekOps.fold(0.0, (sum, op) => sum + op.totalCost),
        },
        'month': {
          'count': monthOps.length,
          'value': monthOps.fold(0.0, (sum, op) => sum + op.totalCost),
        },
        'total_value': totalValue,
        'type_stats': typeStats,
        'top_products': topProducts.take(5).map((e) => {
          'name': e.key,
          'quantity': e.value,
        }).toList(),
      };
      
    } catch (e) {
      _setError('Error getting inventory stats: $e');
      return {};
    }
  }

  /// Получение операций по товару
  List<InventoryOperation> getProductOperations(String productId) {
    return _operations.where((op) => op.productId == productId).toList();
  }

  /// Получение операций по типу
  List<InventoryOperation> getOperationsByType(OperationType type) {
    return _operations.where((op) => op.type == type).toList();
  }

  /// Получение операций по периоду
  List<InventoryOperation> getOperationsByPeriod(DateTime start, DateTime end) {
    return _operations.where((op) => 
      op.timestamp.isAfter(start) && op.timestamp.isBefore(end)
    ).toList();
  }

  /// Поиск операций
  List<InventoryOperation> searchOperations(String query) {
    if (query.isEmpty) return _operations;
    
    final lowerQuery = query.toLowerCase();
    return _operations.where((op) => 
      op.productName.toLowerCase().contains(lowerQuery) ||
      op.operator.toLowerCase().contains(lowerQuery) ||
      op.supplier.toLowerCase().contains(lowerQuery) ||
      op.notes.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  // Приватные методы

  /// Загрузка истории операций
  Future<void> _loadOperationsHistory() async {
    // Имитируем загрузку данных
    await Future.delayed(Duration(milliseconds: 300));
    
    // Создаем тестовые данные
    _operations = [
      InventoryOperation(
        id: '1',
        type: OperationType.incoming,
        productId: '1',
        productName: 'Платье "Элегантность"',
        quantity: 50,
        cost: 4500.0,
        totalCost: 225000.0,
        supplier: 'ООО "Мода-Стиль"',
        operator: 'Анна Петрова',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        notes: 'Поставка новой коллекции',
      ),
      InventoryOperation(
        id: '2',
        type: OperationType.outgoing,
        productId: '1',
        productName: 'Платье "Элегантность"',
        quantity: 5,
        cost: 4500.0,
        totalCost: 22500.0,
        supplier: '',
        operator: 'Мария Иванова',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        notes: 'Списание брака',
      ),
      InventoryOperation(
        id: '3',
        type: OperationType.inventory,
        productId: '2',
        productName: 'Блузка "Деловой стиль"',
        quantity: 3,
        cost: 3200.0,
        totalCost: 9600.0,
        supplier: '',
        operator: 'Петр Сидоров',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        notes: 'Инвентаризация: ожидалось 25, фактически 22',
      ),
      InventoryOperation(
        id: '4',
        type: OperationType.movement,
        productId: '3',
        productName: 'Брюки "Строгий крой"',
        quantity: 10,
        cost: 3800.0,
        totalCost: 38000.0,
        supplier: '',
        operator: 'Елена Козлова',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        notes: 'Перемещение: Склад А → Магазин Центральный',
      ),
    ];
  }

  /// Загрузка операций за сегодня
  Future<void> _loadTodayOperations() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    _todayOperations = _operations.where((op) => 
      op.timestamp.isAfter(today)
    ).toList();
  }

  /// Получение названия типа операции
  String _getOperationTypeName(OperationType type) {
    switch (type) {
      case OperationType.incoming:
        return 'Приход';
      case OperationType.outgoing:
        return 'Списание';
      case OperationType.inventory:
        return 'Инвентаризация';
      case OperationType.movement:
        return 'Перемещение';
      default:
        return 'Неизвестно';
    }
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

/// Тип операции со складом
enum OperationType {
  incoming,    // Приход
  outgoing,    // Списание
  inventory,   // Инвентаризация
  movement,    // Перемещение
}

/// Модель операции со складом
class InventoryOperation {
  final String id;
  final OperationType type;
  final String productId;
  final String productName;
  final int quantity;
  final double cost;
  final double totalCost;
  final String supplier;
  final String operator;
  final DateTime timestamp;
  final String notes;

  InventoryOperation({
    required this.id,
    required this.type,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.cost,
    required this.totalCost,
    required this.supplier,
    required this.operator,
    required this.timestamp,
    required this.notes,
  });
}
