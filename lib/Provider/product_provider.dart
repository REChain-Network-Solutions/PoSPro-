import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

/// Provider для управления продуктами в PoSPro
class ProductProvider extends ChangeNotifier {
  // Состояние загрузки
  bool _isLoading = false;
  String? _error;
  
  // Продукты
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  List<Map<String, dynamic>> _featuredProducts = [];
  List<Map<String, dynamic>> _recentProducts = [];
  
  // Категории
  List<Map<String, dynamic>> _categories = [];
  String? _selectedCategory;
  
  // Поиск и фильтры
  String _searchQuery = '';
  Map<String, dynamic> _filters = {};
  String _sortBy = 'name';
  bool _sortAscending = true;
  
  // Статистика
  int _totalProducts = 0;
  int _totalCategories = 0;
  double _totalValue = 0.0;
  
  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<Map<String, dynamic>> get products => _products;
  List<Map<String, dynamic>> get filteredProducts => _filteredProducts;
  List<Map<String, dynamic>> get featuredProducts => _featuredProducts;
  List<Map<String, dynamic>> get recentProducts => _recentProducts;
  List<Map<String, dynamic>> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  
  String get searchQuery => _searchQuery;
  Map<String, dynamic> get filters => _filters;
  String get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;
  
  int get totalProducts => _totalProducts;
  int get totalCategories => _totalCategories;
  double get totalValue => _totalValue;
  
  /// Инициализация провайдера продуктов
  Future<void> initialize() async {
    try {
      _setLoading(true);
      _clearError();
      
      // Загружаем сохраненные данные
      await _loadSavedData();
      
      // Загружаем базовые данные
      await Future.wait([
        _loadCategories(),
        _loadProducts(),
      ]);
      
      // Применяем фильтры и сортировку
      _applyFiltersAndSort();
      
      // Обновляем статистику
      _updateStats();
      
    } catch (e) {
      _setError('Error initializing product provider: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Установка поискового запроса
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  /// Установка категории
  void setSelectedCategory(String? categoryId) {
    _selectedCategory = categoryId;
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  /// Установка сортировки
  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  /// Установка фильтров
  void setFilters(Map<String, dynamic> filters) {
    _filters = filters;
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  /// Установка сортировки
  void setSorting(String sortBy, bool ascending) {
    _sortBy = sortBy;
    _sortAscending = ascending;
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  /// Очистка ошибок
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  /// Сброс состояния
  void reset() {
    _products = [];
    _filteredProducts = [];
    _featuredProducts = [];
    _recentProducts = [];
    _categories = [];
    _selectedCategory = null;
 _searchQuery = '';
    _filters = {};
    _sortBy = 'name';
    _sortAscending = true;
    _totalProducts = 0;
    _totalCategories = 0;
    _totalValue = 0.0;
    _error = null;
    notifyListeners();
  }
  
  // ===== ЗАГРУЗКА ДАННЫХ =====
  
  /// Загрузка сохраненных данных
  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Загружаем сохраненные фильтры и настройки
      _searchQuery = prefs.getString('product_search_query') ?? '';
      _selectedCategory = prefs.getString('product_selected_category');
      _sortBy = prefs.getString('product_sort_by') ?? 'name';
      _sortAscending = prefs.getBool('product_sort_ascending') ?? true;
      
    } catch (e) {
      print('Error loading saved product data: $e');
    }
  }
  
  /// Загрузка категорий
  Future<void> _loadCategories() async {
    try {
      _categories = [
        {
          'id': 'cat_001',
          'name': 'Все товары',
          'description': 'Полный каталог модной одежды',
          'icon': 'all_inclusive',
          'color': '#2196F3',
          'product_count': 10,
        },
        {
          'id': 'cat_002',
          'name': 'Платья',
          'description': 'Элегантные платья для любого случая',
          'icon': 'checkroom',
          'color': '#FF6B9D',
          'product_count': 2,
        },
        {
          'id': 'cat_003',
          'name': 'Верхняя одежда',
          'description': 'Куртки, пальто и верхняя одежда',
          'icon': 'style',
          'color': '#4ECDC4',
          'product_count': 2,
        },
        {
          'id': 'cat_004',
          'name': 'Блузки',
          'description': 'Стильные блузки для делового и повседневного образа',
          'icon': 'dry_cleaning',
          'color': '#45B7D1',
          'product_count': 2,
        },
        {
          'id': 'cat_005',
          'name': 'Брюки',
          'description': 'Классические и современные брюки',
          'icon': 'accessibility',
          'color': '#DDA0DD',
          'product_count': 2,
        },
        {
          'id': 'cat_006',
          'name': 'Юбки',
          'description': 'Элегантные юбки различных фасонов',
          'icon': 'favorite',
          'color': '#FF6B6B',
          'product_count': 2,
        },
        {
          'id': 'cat_007',
          'name': 'Куртки',
          'description': 'Стильные куртки для любого сезона',
          'icon': 'style',
          'color': '#96CEB4',
          'product_count': 2,
        },
      ];
      
      _totalCategories = _categories.length;
      
    } catch (e) {
      _setError('Error loading categories: $e');
    }
  }
  
  /// Загрузка продуктов
  Future<void> _loadProducts() async {
    try {
      _products = [
        // МОДНАЯ ОДЕЖДА - ПЛАТЬЯ
        {
          'id': 'modus_001',
          'name': 'Платье Modus Fashion "Элегантность"',
          'description': 'Элегантное платье из качественного трикотажа с V-образным вырезом. Идеально для офиса и вечерних мероприятий.',
          'price': 12990.0,
          'stock_quantity': 45,
          'category_id': 'cat_002',
          'category_name': 'Платья',
          'image_url': 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=300&h=400&fit=crop&crop=center',
          'is_featured': true,
          'is_active': true,
          'created_at': '2024-01-15T10:00:00Z',
          'updated_at': '2024-01-15T10:00:00Z',
          'sku': 'MOD001',
          'weight': 0.3,
          'dimensions': {'length': 85, 'width': 0, 'height': 0},
          'tags': ['платье', 'modus', 'элегантность', 'офис'],
          'rating': 4.8,
          'reviews_count': 89,
          'sold_count': 156,
          'min_stock_level': 10,
        },
        {
          'id': 'modus_002',
          'name': 'Платье Modus Fashion "Летний бриз"',
          'description': 'Легкое летнее платье из натурального хлопка с цветочным принтом. Свободный крой для максимального комфорта.',
          'price': 8990.0,
          'stock_quantity': 67,
          'category_id': 'cat_002',
          'category_name': 'Платья',
          'image_url': 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=300&h=400&fit=crop&crop=center',
          'is_featured': true,
          'is_active': true,
          'created_at': '2024-01-14T14:30:00Z',
          'updated_at': '2024-01-14T14:30:00Z',
          'sku': 'MOD002',
          'weight': 0.25,
          'dimensions': {'length': 80, 'width': 0, 'height': 0},
          'tags': ['платье', 'лето', 'хлопок', 'цветы'],
          'rating': 4.7,
          'reviews_count': 134,
          'sold_count': 234,
          'min_stock_level': 15,
        },
        
        // МОДНАЯ ОДЕЖДА - БЛУЗКИ
        {
          'id': 'modus_003',
          'name': 'Блузка Modus Fashion "Деловой стиль"',
          'description': 'Классическая блузка из натурального шелка с длинным рукавом. Идеальна для делового образа.',
          'price': 6990.0,
          'stock_quantity': 89,
          'category_id': 'cat_004',
          'category_name': 'Блузки',
          'image_url': 'https://images.unsplash.com/photo-1564257631407-3c5cba6d8477?w=300&h=400&fit=crop&crop=center',
          'is_featured': false,
          'is_active': true,
          'created_at': '2024-01-13T09:15:00Z',
          'updated_at': '2024-01-13T09:15:00Z',
          'sku': 'MOD003',
          'weight': 0.2,
          'dimensions': {'length': 0, 'width': 0, 'height': 0},
          'tags': ['блузка', 'деловой', 'шелк', 'классика'],
          'rating': 4.6,
          'reviews_count': 78,
          'sold_count': 189,
          'min_stock_level': 20,
        },
        {
          'id': 'modus_004',
          'name': 'Блузка Modus Fashion "Романтичность"',
          'description': 'Женственная блузка с кружевными вставками и бантом. Идеальна для свиданий и особых случаев.',
          'price': 5490.0,
          'stock_quantity': 56,
          'category_id': 'cat_004',
          'category_name': 'Блузки',
          'image_url': 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=300&h=400&fit=crop&crop=center',
          'is_featured': true,
          'is_active': true,
          'created_at': '2024-01-12T16:45:00Z',
          'updated_at': '2024-01-12T16:45:00Z',
          'sku': 'MOD004',
          'weight': 0.18,
          'dimensions': {'length': 0, 'width': 0, 'height': 0},
          'tags': ['блузка', 'романтичная', 'кружево', 'бант'],
          'rating': 4.9,
          'reviews_count': 45,
          'sold_count': 123,
          'min_stock_level': 12,
        },
        
        // МОДНАЯ ОДЕЖДА - БРЮКИ
        {
          'id': 'modus_005',
          'name': 'Брюки Modus Fashion "Строгий крой"',
          'description': 'Классические брюки прямого кроя из качественной шерсти. Идеальны для офиса и деловых встреч.',
          'price': 8990.0,
          'stock_quantity': 34,
          'category_id': 'cat_005',
          'category_name': 'Брюки',
          'image_url': 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=300&h=400&fit=crop&crop=center',
          'is_featured': false,
          'is_active': true,
          'created_at': '2024-01-11T11:20:00Z',
          'updated_at': '2024-01-11T11:20:00Z',
          'sku': 'MOD005',
          'weight': 0.4,
          'dimensions': {'length': 0, 'width': 0, 'height': 0},
          'tags': ['брюки', 'классика', 'шерсть', 'офис'],
          'rating': 4.7,
          'reviews_count': 67,
          'sold_count': 145,
          'min_stock_level': 8,
        },
        {
          'id': 'modus_006',
          'name': 'Брюки Modus Fashion "Свободный стиль"',
          'description': 'Современные брюки свободного кроя из эластичного материала. Максимальный комфорт и стиль.',
          'price': 6490.0,
          'stock_quantity': 78,
          'category_id': 'cat_005',
          'category_name': 'Брюки',
          'image_url': 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=300&h=400&fit=crop&crop=center',
          'is_featured': true,
          'is_active': true,
          'created_at': '2024-01-10T13:45:00Z',
          'updated_at': '2024-01-10T13:45:00Z',
          'sku': 'MOD006',
          'weight': 0.35,
          'dimensions': {'length': 0, 'width': 0, 'height': 0},
          'tags': ['брюки', 'свободный', 'эластик', 'комфорт'],
          'rating': 4.8,
          'reviews_count': 92,
          'sold_count': 167,
          'min_stock_level': 18,
        },
        
        // МОДНАЯ ОДЕЖДА - ЮБКИ
        {
          'id': 'modus_007',
          'name': 'Юбка Modus Fashion "Карандаш"',
          'description': 'Элегантная юбка-карандаш из качественной ткани. Идеальна для создания строгого делового образа.',
          'price': 7490.0,
          'stock_quantity': 42,
          'category_id': 'cat_006',
          'category_name': 'Юбки',
          'image_url': 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=300&h=400&fit=crop&crop=center',
          'is_featured': false,
          'is_active': true,
          'created_at': '2024-01-09T15:30:00Z',
          'updated_at': '2024-01-09T15:30:00Z',
          'sku': 'MOD007',
          'weight': 0.25,
          'dimensions': {'length': 0, 'width': 0, 'height': 0},
          'tags': ['юбка', 'карандаш', 'деловой', 'элегантность'],
          'rating': 4.6,
          'reviews_count': 56,
          'sold_count': 134,
          'min_stock_level': 10,
        },
        {
          'id': 'modus_008',
          'name': 'Юбка Modus Fashion "Макси"',
          'description': 'Длинная юбка макси с цветочным принтом. Идеальна для летних прогулок и особых случаев.',
          'price': 5990.0,
          'stock_quantity': 89,
          'category_id': 'cat_006',
          'category_name': 'Юбки',
          'image_url': 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=300&h=400&fit=crop&crop=center',
          'is_featured': true,
          'is_active': true,
          'created_at': '2024-01-08T12:15:00Z',
          'updated_at': '2024-01-08T12:15:00Z',
          'sku': 'MOD008',
          'weight': 0.3,
          'dimensions': {'length': 0, 'width': 0, 'height': 0},
          'tags': ['юбка', 'макси', 'лето', 'цветы'],
          'rating': 4.9,
          'reviews_count': 78,
          'sold_count': 189,
          'min_stock_level': 15,
        },
        
        // МОДНАЯ ОДЕЖДА - КУРТКИ
        {
          'id': 'modus_009',
          'name': 'Куртка Modus Fashion "Демисезонная"',
          'description': 'Стильная демисезонная куртка из качественных материалов. Идеальна для межсезонья.',
          'price': 15990.0,
          'stock_quantity': 23,
          'category_id': 'cat_007',
          'category_name': 'Куртки',
          'image_url': 'https://images.unsplash.com/photo-1544966503-7cc5ac882d5f?w=300&h=400&fit=crop&crop=center',
          'is_featured': true,
          'is_active': true,
          'created_at': '2024-01-07T10:45:00Z',
          'updated_at': '2024-01-07T10:45:00Z',
          'sku': 'MOD009',
          'weight': 0.8,
          'dimensions': {'length': 0, 'width': 0, 'height': 0},
          'tags': ['куртка', 'демисезон', 'стиль', 'качество'],
          'rating': 4.8,
          'reviews_count': 45,
          'sold_count': 89,
          'min_stock_level': 5,
        },
        {
          'id': 'modus_010',
          'name': 'Куртка Modus Fashion "Зимняя"',
          'description': 'Теплая зимняя куртка с меховым воротником. Максимальная защита от холода и стильный вид.',
          'price': 24990.0,
          'stock_quantity': 18,
          'category_id': 'cat_007',
          'category_name': 'Куртки',
          'image_url': 'https://images.unsplash.com/photo-1544966503-7cc5ac882d5f?w=300&h=400&fit=crop&crop=center',
          'is_featured': false,
          'is_active': true,
          'created_at': '2024-01-06T14:20:00Z',
          'updated_at': '2024-01-06T14:20:00Z',
          'sku': 'MOD010',
          'weight': 1.2,
          'dimensions': {'length': 0, 'width': 0, 'height': 0},
          'tags': ['куртка', 'зима', 'тепло', 'мех'],
          'rating': 4.9,
          'reviews_count': 34,
          'sold_count': 67,
          'min_stock_level': 3,
        },
      ];
      
      _totalProducts = _products.length;
      
    } catch (e) {
      _setError('Error loading products: $e');
    }
  }
  
  // ===== ФИЛЬТРАЦИЯ И СОРТИРОВКА =====
  
  /// Применение фильтров и сортировки
  void _applyFiltersAndSort() {
    List<Map<String, dynamic>> filtered = List.from(_products);
    
    // Применяем поиск
    if (_searchQuery.isNotEmpty) {
      filtered = searchProducts(_searchQuery);
    }
    
    // Применяем фильтр по категории
    if (_selectedCategory != null) {
      filtered = filtered.where((product) => 
        product['category_id'] == _selectedCategory
      ).toList();
    }
    
    // Применяем фильтр по цене
    if (_filters.containsKey('price_range')) {
      var priceRange = _filters['price_range'] as Map<String, dynamic>?;
      if (priceRange != null) {
        double minPrice = priceRange['min'] ?? 0.0;
        double maxPrice = priceRange['max'] ?? double.infinity;
        filtered = filtered.where((product) {
          double price = product['price'] ?? 0.0;
          return price >= minPrice && price <= maxPrice;
        }).toList();
      }
    }
    
    // Применяем фильтр по наличию
    if (_filters.containsKey('in_stock_only') && _filters['in_stock_only'] == true) {
      filtered = filtered.where((product) => 
        (product['stock_quantity'] ?? 0) > 0
      ).toList();
    }
    
    // Применяем фильтр по избранным
    if (_filters.containsKey('featured_only') && _filters['featured_only'] == true) {
      filtered = filtered.where((product) => 
        product['is_featured'] == true
      ).toList();
    }
    
    // Применяем сортировку
    _sortProducts(filtered);
    
    _filteredProducts = filtered;
  }
  
  /// Сортировка продуктов
  void _sortProducts(List<Map<String, dynamic>> products) {
    products.sort((a, b) {
      dynamic aValue = a[_sortBy];
      dynamic bValue = b[_sortBy];
      
      // Обработка null значений
      if (aValue == null && bValue == null) return 0;
      if (aValue == null) return _sortAscending ? 1 : -1;
      if (bValue == null) return _sortAscending ? -1 : 1;
      
      int comparison = 0;
      
      if (aValue is String && bValue is String) {
        comparison = aValue.compareTo(bValue);
      } else if (aValue is num && bValue is num) {
        comparison = aValue.compareTo(bValue);
      } else if (aValue is DateTime && bValue is DateTime) {
        comparison = aValue.compareTo(bValue);
      }
      
      return _sortAscending ? comparison : -comparison;
    });
  }
  
  // ===== ОБНОВЛЕНИЕ ДАННЫХ =====
  
  /// Обновление избранных и недавних продуктов
  void _updateFeaturedAndRecent() {
    // Избранные товары
    _featuredProducts = _products
        .where((product) => product['is_featured'] == true)
        .take(6)
        .toList();
    
    // Недавние товары
    _recentProducts = _products
        .take(8)
        .toList();
  }
  
  /// Обновление статистики
  void _updateStats() {
    _totalProducts = _products.length;
    _totalCategories = _categories.length;
    _totalValue = _products.fold(0.0, (sum, product) => 
      sum + ((product['price'] ?? 0.0) * (product['stock_quantity'] ?? 0))
    );
  }
  
  // ===== УПРАВЛЕНИЕ ПРОДУКТАМИ =====
  
  /// Добавление нового товара
  Future<bool> addProduct(Map<String, dynamic> productData) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Имитация добавления товара
      await Future.delayed(Duration(milliseconds: 1000));
      
      // Создаем новый товар
      Map<String, dynamic> newProduct = {
        'id': _generateProductId(),
        'name': productData['name'],
        'description': productData['description'],
        'price': productData['price'] ?? 0.0,
        'stock_quantity': productData['stock_quantity'] ?? 0,
        'category_id': productData['category_id'],
        'category_name': _getCategoryName(productData['category_id']),
        'image_url': productData['image_url'] ?? 'https://via.placeholder.com/300x300/CCCCCC/FFFFFF?text=No+Image',
        'is_featured': productData['is_featured'] ?? false,
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'sku': _generateSKU(productData['name']),
        'weight': productData['weight'] ?? 0.0,
        'dimensions': productData['dimensions'] ?? {'length': 0, 'width': 0, 'height': 0},
        'tags': productData['tags'] ?? [],
        'rating': 0.0,
        'reviews_count': 0,
        'sold_count': 0,
      };
      
      // Добавляем товар в список
      _products.insert(0, newProduct);
      
      // Обновляем фильтрованные товары
      _applyFiltersAndSort();
      
      // Обновляем статистику
      _updateStats();
      
      // Обновляем избранные и недавние товары
      _updateFeaturedAndRecent();
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error adding product: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Обновление товара
  Future<bool> updateProduct(String productId, Map<String, dynamic> updates) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Имитация обновления товара
      await Future.delayed(Duration(milliseconds: 800));
      
      // Находим товар
      int productIndex = _products.indexWhere((product) => product['id'] == productId);
      if (productIndex == -1) {
        throw Exception('Product not found');
      }
      
      // Обновляем поля
      var product = _products[productIndex];
      updates.forEach((key, value) {
        if (product.containsKey(key)) {
          product[key] = value;
        }
      });
      
      // Обновляем связанные поля
      if (updates.containsKey('category_id')) {
        product['category_name'] = _getCategoryName(updates['category_id']);
      }
      
      product['updated_at'] = DateTime.now().toIso8601String();
      
      // Обновляем фильтрованные товары
      _applyFiltersAndSort();
      
      // Обновляем статистику
      _updateStats();
      
      // Обновляем избранные и недавние товары
      _updateFeaturedAndRecent();
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error updating product: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Удаление товара
  Future<bool> deleteProduct(String productId) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Имитация удаления товара
      await Future.delayed(Duration(milliseconds: 600));
      
      // Удаляем товар
      _products.removeWhere((product) => product['id'] == productId);
      
      // Обновляем фильтрованные товары
      _applyFiltersAndSort();
      
      // Обновляем статистику
      _updateStats();
      
      // Обновляем избранные и недавние товары
      _updateFeaturedAndRecent();
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error deleting product: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Получение товара по ID
  Map<String, dynamic>? getProductById(String productId) {
    try {
      return _products.firstWhere((product) => product['id'] == productId);
    } catch (e) {
      return null;
    }
  }

  /// Получение товаров по категории
  List<Map<String, dynamic>> getProductsByCategory(String categoryId) {
    return _products.where((product) => product['category_id'] == categoryId).toList();
  }

  /// Получение товаров с низким запасом
  List<Map<String, dynamic>> getLowStockProducts({int threshold = 10}) {
    return _products.where((product) => 
      (product['stock_quantity'] ?? 0) <= threshold
    ).toList();
  }

  /// Поиск товаров
  List<Map<String, dynamic>> searchProducts(String query) {
    if (query.isEmpty) return _filteredProducts;
    
    return _products.where((product) {
      String name = (product['name'] ?? '').toLowerCase();
      String description = (product['description'] ?? '').toLowerCase();
      String category = (product['category_name'] ?? '').toLowerCase();
      String searchQuery = query.toLowerCase();
      
      return name.contains(searchQuery) || 
             description.contains(searchQuery) || 
             category.contains(searchQuery);
    }).toList();
  }
  
  // ===== СОХРАНЕНИЕ ДАННЫХ =====
  
  /// Сохранение данных
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString('product_search_query', _searchQuery);
      if (_selectedCategory != null) {
        await prefs.setString('product_selected_category', _selectedCategory!);
      }
      await prefs.setString('product_sort_by', _sortBy);
      await prefs.setBool('product_sort_ascending', _sortAscending);
      
    } catch (e) {
      print('Error saving product data: $e');
    }
  }
  
  // ===== ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ =====
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
  }
  
  /// Получение статистики продуктов
  Map<String, dynamic> getProductStats() {
    return {
      'total_products': _totalProducts,
      'total_categories': _totalCategories,
      'total_value': _totalValue,
      'featured_products_count': _featuredProducts.length,
      'recent_products_count': _recentProducts.length,
      'low_stock_products_count': getLowStockProducts().length,
      'last_updated': DateTime.now().toIso8601String(),
    };
  }

  // ===== ПРИВАТНЫЕ МЕТОДЫ ДЛЯ ГЕНЕРАЦИИ МОК ДАННЫХ =====

  String _generateProductId() {
    return 'prod_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
  }

  String _generateSKU(String productName) {
    String prefix = productName.substring(0, min(3, productName.length)).toUpperCase();
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(0, 6);
    return '$prefix$timestamp';
  }

  String _getCategoryName(String? categoryId) {
    if (categoryId == null) return 'Без категории';
    
    var category = _categories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {'name': 'Неизвестная категория'},
    );
    
    return category['name'] ?? 'Неизвестная категория';
  }
}
