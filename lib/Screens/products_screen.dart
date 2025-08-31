import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/product_provider.dart';
import 'dart:math' as math;

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _minStockController = TextEditingController();
  
  String _selectedCategory = 'all';
  String _selectedSortBy = 'name';
  String _selectedSortOrder = 'asc';
  bool _showLowStockOnly = false;
  bool _showOutOfStock = false;
  
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    ));
    
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (productProvider.error != null) {
            return _buildErrorView(productProvider);
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                children: [
                  // Фильтры и поиск
                  _buildFiltersSection(),
                  
                  // Статистика
                  _buildStatsSection(productProvider),
                  
                  // Список товаров
                  Expanded(
                    child: _buildProductsList(productProvider),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProductDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Добавить товар'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  /// Построение AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Управление товарами'),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () => _showAdvancedFiltersDialog(context),
          tooltip: 'Расширенные фильтры',
        ),
        IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () => _showSortDialog(context),
          tooltip: 'Сортировка',
        ),
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: () => _showExportDialog(context),
          tooltip: 'Экспорт',
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => _showSettingsDialog(context),
          tooltip: 'Настройки',
        ),
      ],
    );
  }

  /// Построение секции фильтров
  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        children: [
          // Поиск
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Поиск по названию, описанию, категории...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) => setState(() {}),
          ),
          
          const SizedBox(height: 16),
          
          // Быстрые фильтры
          Row(
            children: [
              // Категория
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Категория',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    const DropdownMenuItem(value: 'all', child: Text('Все категории')),
                    const DropdownMenuItem(value: 'clothing', child: Text('Одежда')),
                    const DropdownMenuItem(value: 'accessories', child: Text('Аксессуары')),
                    const DropdownMenuItem(value: 'shoes', child: Text('Обувь')),
                    const DropdownMenuItem(value: 'jewelry', child: Text('Украшения')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value ?? 'all';
                    });
                  },
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Чекбоксы
              Row(
                children: [
                  FilterChip(
                    label: const Text('Низкий запас'),
                    selected: _showLowStockOnly,
                    onSelected: (selected) {
                      setState(() {
                        _showLowStockOnly = selected;
                      });
                    },
                    selectedColor: Colors.orange[100],
                    checkmarkColor: Colors.orange[800],
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Нет в наличии'),
                    selected: _showOutOfStock,
                    onSelected: (selected) {
                      setState(() {
                        _showOutOfStock = selected;
                      });
                    },
                    selectedColor: Colors.red[100],
                    checkmarkColor: Colors.red[800],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Построение секции статистики
  Widget _buildStatsSection(ProductProvider productProvider) {
    final totalProducts = productProvider.totalProducts;
    final lowStockProducts = productProvider.products.where((p) => 
      (p['stock_quantity'] ?? 0) <= (p['min_stock_level'] ?? 0)
    ).length;
    final outOfStockProducts = productProvider.products.where((p) => 
      (p['stock_quantity'] ?? 0) == 0
    ).length;
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Всего товаров',
              '$totalProducts',
              Icons.inventory,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Низкий запас',
              '$lowStockProducts',
              Icons.warning,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Нет в наличии',
              '$outOfStockProducts',
              Icons.error,
              Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  /// Построение карточки статистики
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Построение списка товаров
  Widget _buildProductsList(ProductProvider productProvider) {
    var filteredProducts = _getFilteredProducts(productProvider.products);
    
    if (filteredProducts.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildProductCard(product, productProvider);
      },
    );
  }

  /// Построение карточки товара
  Widget _buildProductCard(Map<String, dynamic> product, ProductProvider productProvider) {
    final stockQuantity = product['stock_quantity'] ?? 0;
    final minStockLevel = product['min_stock_level'] ?? 0;
    final isLowStock = stockQuantity <= minStockLevel;
    final isOutOfStock = stockQuantity == 0;
    
    Color stockColor;
    IconData stockIcon;
    
    if (isOutOfStock) {
      stockColor = Colors.red;
      stockIcon = Icons.error;
    } else if (isLowStock) {
      stockColor = Colors.orange;
      stockIcon = Icons.warning;
    } else {
      stockColor = Colors.green;
      stockIcon = Icons.check_circle;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Изображение товара
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: product['image_url'] != null
                    ? Image.network(
                        product['image_url'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                            size: 32,
                          );
                        },
                      )
                    : Icon(
                        Icons.inventory,
                        color: Colors.grey[400],
                        size: 32,
                      ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Информация о товаре
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product['name'] ?? 'Без названия',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(product['category'] ?? 'other').withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          product['category'] ?? 'other',
                          style: TextStyle(
                            color: _getCategoryColor(product['category'] ?? 'other'),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    product['description'] ?? 'Без описания',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Text(
                        'Цена: ${product['price']?.toString() ?? '0'} ₽',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(stockIcon, color: stockColor, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Запас: $stockQuantity',
                            style: TextStyle(
                              color: stockColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Действия
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditProductDialog(context, product),
                  tooltip: 'Редактировать',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _showDeleteProductDialog(context, product),
                  tooltip: 'Удалить',
                  color: Colors.red,
                ),
                IconButton(
                  icon: const Icon(Icons.inventory_2),
                  onPressed: () => _showStockDialog(context, product),
                  tooltip: 'Управление запасом',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Построение пустого состояния
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Товары не найдены',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Попробуйте изменить фильтры или добавить новый товар',
            style: TextStyle(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddProductDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Добавить товар'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// Построение экрана ошибки
  Widget _buildErrorView(ProductProvider productProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Ошибка загрузки товаров',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            productProvider.error ?? 'Неизвестная ошибка',
            style: TextStyle(color: Colors.red[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              productProvider.clearError();
              productProvider.initialize();
            },
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  // Диалоги

  /// Диалог добавления товара
  void _showAddProductDialog(BuildContext context) {
    _clearControllers();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить новый товар'),
        content: SizedBox(
          width: 500,
          child: _buildProductForm(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_validateForm()) {
                final success = await context.read<ProductProvider>().addProduct({
                  'name': _nameController.text.trim(),
                  'description': _descriptionController.text.trim(),
                  'price': double.tryParse(_priceController.text) ?? 0.0,
                  'stock_quantity': int.tryParse(_stockController.text) ?? 0,
                  'min_stock_level': int.tryParse(_minStockController.text) ?? 0,
                  'category': _selectedCategory == 'all' ? 'other' : _selectedCategory,
                  'image_url': null,
                });
                
                if (success) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Товар успешно добавлен!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка: ${context.read<ProductProvider>().error}')),
                  );
                }
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  /// Диалог редактирования товара
  void _showEditProductDialog(BuildContext context, Map<String, dynamic> product) {
    _fillControllers(product);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Редактировать: ${product['name']}'),
        content: SizedBox(
          width: 500,
          child: _buildProductForm(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_validateForm()) {
                final success = await context.read<ProductProvider>().updateProduct(
                  product['id'],
                  {
                    'name': _nameController.text.trim(),
                    'description': _descriptionController.text.trim(),
                    'price': double.tryParse(_priceController.text) ?? 0.0,
                    'stock_quantity': int.tryParse(_stockController.text) ?? 0,
                    'min_stock_level': int.tryParse(_minStockController.text) ?? 0,
                    'category': _selectedCategory == 'all' ? 'other' : _selectedCategory,
                  },
                );
                
                if (success) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Товар успешно обновлен!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка: ${context.read<ProductProvider>().error}')),
                  );
                }
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  /// Диалог удаления товара
  void _showDeleteProductDialog(BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтверждение удаления'),
        content: Text(
          'Вы уверены, что хотите удалить товар "${product['name']}"?\n\nЭто действие нельзя отменить.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              final success = await context.read<ProductProvider>().deleteProduct(product['id']);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Товар успешно удален!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ошибка: ${context.read<ProductProvider>().error}')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  /// Диалог управления запасом
  void _showStockDialog(BuildContext context, Map<String, dynamic> product) {
    final stockController = TextEditingController(
      text: (product['stock_quantity'] ?? 0).toString(),
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Управление запасом: ${product['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Текущий запас: ${product['stock_quantity'] ?? 0}'),
            const SizedBox(height: 16),
            TextField(
              controller: stockController,
              decoration: const InputDecoration(
                labelText: 'Новый запас',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newStock = int.tryParse(stockController.text) ?? 0;
              
              final success = await context.read<ProductProvider>().updateProduct(
                product['id'],
                {'stock_quantity': newStock},
              );
              
              if (success) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Запас обновлен!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ошибка: ${context.read<ProductProvider>().error}')),
                );
              }
            },
            child: const Text('Обновить'),
          ),
        ],
      ),
    );
  }

  /// Диалог расширенных фильтров
  void _showAdvancedFiltersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Расширенные фильтры'),
        content: const Text('Здесь будут дополнительные фильтры'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  /// Диалог сортировки
  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сортировка'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedSortBy,
              decoration: const InputDecoration(labelText: 'Сортировать по'),
              items: const [
                DropdownMenuItem(value: 'name', child: Text('Название')),
                DropdownMenuItem(value: 'price', child: Text('Цена')),
                DropdownMenuItem(value: 'stock', child: Text('Запас')),
                DropdownMenuItem(value: 'category', child: Text('Категория')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSortBy = value ?? 'name';
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSortOrder,
              decoration: const InputDecoration(labelText: 'Порядок'),
              items: const [
                DropdownMenuItem(value: 'asc', child: Text('По возрастанию')),
                DropdownMenuItem(value: 'desc', child: Text('По убыванию')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSortOrder = value ?? 'asc';
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Применить'),
          ),
        ],
      ),
    );
  }

  /// Диалог экспорта
  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Экспорт товаров'),
        content: const Text('Выберите формат для экспорта'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Экспорт в Excel начат')),
              );
            },
            child: const Text('Excel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Экспорт в CSV начат')),
              );
            },
            child: const Text('CSV'),
          ),
        ],
      ),
    );
  }

  /// Диалог настроек
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Настройки товаров'),
        content: const Text('Здесь будут настройки управления товарами'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  // Вспомогательные методы

  /// Построение формы товара
  Widget _buildProductForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Название товара',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Описание',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Цена (₽)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _stockController,
                decoration: const InputDecoration(
                  labelText: 'Количество на складе',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _minStockController,
          decoration: const InputDecoration(
            labelText: 'Минимальный запас',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  /// Очистка контроллеров
  void _clearControllers() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _stockController.clear();
    _minStockController.clear();
  }

  /// Заполнение контроллеров данными
  void _fillControllers(Map<String, dynamic> product) {
    _nameController.text = product['name'] ?? '';
    _descriptionController.text = product['description'] ?? '';
    _priceController.text = (product['price'] ?? 0).toString();
    _stockController.text = (product['stock_quantity'] ?? 0).toString();
    _minStockController.text = (product['min_stock_level'] ?? 0).toString();
  }

  /// Валидация формы
  bool _validateForm() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите название товара')),
      );
      return false;
    }
    if (_priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите цену товара')),
      );
      return false;
    }
    return true;
  }

  /// Получение отфильтрованных товаров
  List<Map<String, dynamic>> _getFilteredProducts(List<Map<String, dynamic>> products) {
    var filtered = products;

    // Фильтр по поиску
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((product) {
        final name = (product['name'] ?? '').toString().toLowerCase();
        final description = (product['description'] ?? '').toString().toLowerCase();
        final category = (product['category'] ?? '').toString().toLowerCase();
        return name.contains(query) || description.contains(query) || category.contains(query);
      }).toList();
    }

    // Фильтр по категории
    if (_selectedCategory != 'all') {
      filtered = filtered.where((product) => 
        product['category'] == _selectedCategory
      ).toList();
    }

    // Фильтр по низкому запасу
    if (_showLowStockOnly) {
      filtered = filtered.where((product) {
        final stock = product['stock_quantity'] ?? 0;
        final minStock = product['min_stock_level'] ?? 0;
        return stock <= minStock && stock > 0;
      }).toList();
    }

    // Фильтр по отсутствию на складе
    if (_showOutOfStock) {
      filtered = filtered.where((product) => 
        (product['stock_quantity'] ?? 0) == 0
      ).toList();
    }

    // Сортировка
    filtered.sort((a, b) {
      dynamic aValue = a[_selectedSortBy];
      dynamic bValue = b[_selectedSortBy];
      
      if (aValue == null) aValue = '';
      if (bValue == null) bValue = '';
      
      int comparison = 0;
      if (aValue is String && bValue is String) {
        comparison = aValue.compareTo(bValue);
      } else if (aValue is num && bValue is num) {
        comparison = aValue.compareTo(bValue);
      }
      
      return _selectedSortOrder == 'desc' ? -comparison : comparison;
    });

    return filtered;
  }

  /// Получение цвета категории
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'clothing':
        return Colors.blue;
      case 'accessories':
        return Colors.green;
      case 'shoes':
        return Colors.orange;
      case 'jewelry':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
