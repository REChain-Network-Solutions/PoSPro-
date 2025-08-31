import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/inventory_provider.dart';
import '../Provider/product_provider.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> with TickerProviderStateMixin {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _operatorController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    _quantityController.dispose();
    _costController.dispose();
    _supplierController.dispose();
    _reasonController.dispose();
    _operatorController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Consumer<InventoryProvider>(
              builder: (context, inventoryProvider, child) {
                if (inventoryProvider.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (inventoryProvider.error != null) {
                  return _buildErrorView(inventoryProvider);
                }

                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        // Поиск и фильтры
                        _buildSearchAndFilters(),
                        
                        // Статистика
                        _buildQuickStats(),
                        
                        // Список операций
                        _buildOperationsList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Построение SliverAppBar
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.blue[600],
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Управление складом',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 3,
                color: Colors.black26,
              ),
            ],
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[600]!,
                Colors.blue[800]!,
                Colors.indigo[700]!,
              ],
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.warehouse,
              size: 80,
              color: Colors.white54,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () => _showAddInventoryDialog(context),
          tooltip: 'Приход товара',
        ),
        IconButton(
          icon: const Icon(Icons.remove, color: Colors.white),
          onPressed: () => _showRemoveInventoryDialog(context),
          tooltip: 'Списание товара',
        ),
        IconButton(
          icon: const Icon(Icons.assignment, color: Colors.white),
          onPressed: () => _showInventoryCheckDialog(context),
          tooltip: 'Инвентаризация',
        ),
        IconButton(
          icon: const Icon(Icons.swap_horiz, color: Colors.white),
          onPressed: () => _showMoveInventoryDialog(context),
          tooltip: 'Перемещение',
        ),
        IconButton(
          icon: const Icon(Icons.analytics, color: Colors.white),
          onPressed: () => _showInventoryStatsDialog(context),
          tooltip: 'Статистика',
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () => _showSettingsDialog(context),
          tooltip: 'Настройки',
        ),
      ],
    );
  }

  /// Построение представления ошибки
  Widget _buildErrorView(InventoryProvider inventoryProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red[300],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Ошибка загрузки данных',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red[300],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '${inventoryProvider.error}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red[300],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                inventoryProvider.clearError();
                inventoryProvider.initialize();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Построение поиска и фильтров
  Widget _buildSearchAndFilters() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.search, color: Colors.blue[600]),
              const SizedBox(width: 8),
              Text(
                'Поиск и фильтрация',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Поиск по товарам, операторам, поставщикам...',
                    prefixIcon: Icon(Icons.search, color: Colors.blue[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  onChanged: (value) {
                    // В реальном приложении здесь будет поиск
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.filter_list, color: Colors.blue[600]),
                  tooltip: 'Фильтры',
                  onSelected: (value) {
                    // В реальном приложении здесь будет фильтрация
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'all',
                      child: Text('Все операции'),
                    ),
                    const PopupMenuItem(
                      value: 'incoming',
                      child: Text('Только приход'),
                    ),
                    const PopupMenuItem(
                      value: 'outgoing',
                      child: Text('Только списание'),
                    ),
                    const PopupMenuItem(
                      value: 'inventory',
                      child: Text('Только инвентаризация'),
                    ),
                    const PopupMenuItem(
                      value: 'movement',
                      child: Text('Только перемещение'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('Сегодня'),
                selected: true,
                onSelected: (selected) {},
                selectedColor: Colors.blue[100],
                checkmarkColor: Colors.blue[600],
              ),
              FilterChip(
                label: const Text('Приход'),
                selected: false,
                onSelected: (selected) {},
                selectedColor: Colors.green[100],
                checkmarkColor: Colors.green[600],
              ),
              FilterChip(
                label: const Text('Списание'),
                selected: false,
                onSelected: (selected) {},
                selectedColor: Colors.red[100],
                checkmarkColor: Colors.red[600],
              ),
              FilterChip(
                label: const Text('Инвентаризация'),
                selected: false,
                onSelected: (selected) {},
                selectedColor: Colors.orange[100],
                checkmarkColor: Colors.orange[600],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Построение быстрой статистики
  Widget _buildQuickStats() {
    return Consumer<InventoryProvider>(
      builder: (context, inventoryProvider, child) {
        final stats = inventoryProvider.getInventoryStats();
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.analytics, color: Colors.blue[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Быстрая статистика',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildStatCard(
                        'Сегодня',
                        '${stats['today']?['count'] ?? 0}',
                        'операций',
                        Colors.blue,
                        Icons.today,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildStatCard(
                        'За неделю',
                        '${stats['week']?['count'] ?? 0}',
                        'операций',
                        Colors.green,
                        Icons.calendar_view_week,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildStatCard(
                        'Общая стоимость',
                        '${(stats['total_value'] ?? 0.0).toStringAsFixed(0)}',
                        '₽',
                        Colors.orange,
                        Icons.attach_money,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildStatCard(
                        'Товаров на складе',
                        '${stats['total_products'] ?? 0}',
                        'шт.',
                        Colors.purple,
                        Icons.inventory,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Построение карточки статистики
  Widget _buildStatCard(String title, String value, String unit, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            unit,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// Построение списка операций
  Widget _buildOperationsList() {
    return Consumer<InventoryProvider>(
      builder: (context, inventoryProvider, child) {
        if (inventoryProvider.operations.isEmpty) {
          return _buildEmptyOperationsState();
        }

        return Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.list_alt, color: Colors.blue[600]),
                  const SizedBox(width: 8),
                  Text(
                    'История операций',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Всего: ${inventoryProvider.operations.length}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: inventoryProvider.operations.length,
                itemBuilder: (context, index) {
                  final operation = inventoryProvider.operations[index];
                  return AnimatedBuilder(
                    animation: _fadeController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(CurvedAnimation(
                          parent: _fadeController,
                          curve: Interval(
                            index * 0.1,
                            (index + 1) * 0.1,
                            curve: Curves.easeInOut,
                          ),
                        )),
                        child: _buildOperationCard(operation),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Построение пустого состояния операций
  Widget _buildEmptyOperationsState() {
    return Container(
      margin: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _pulseAnimation,
              child: Icon(
                Icons.inventory_2,
                size: 80,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Операции со складом отсутствуют',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Добавьте первую операцию для начала работы со складом',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showAddInventoryDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Добавить операцию'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Построение карточки операции
  Widget _buildOperationCard(InventoryOperation operation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showOperationDetails(operation),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок с типом операции
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getOperationTypeColor(operation.type),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: _getOperationTypeColor(operation.type).withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getOperationTypeIcon(operation.type),
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _getOperationTypeName(operation.type),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '№${operation.id}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Информация о товаре
                Row(
                  children: [
                    // Иконка товара
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.inventory,
                        color: Colors.blue[600],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            operation.productName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.shopping_cart, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 6),
                              Text(
                                'Количество: ${operation.quantity} шт.',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          if (operation.cost > 0) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 6),
                                Text(
                                  'Стоимость: ${operation.cost.toStringAsFixed(2)} ₽/шт.',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (operation.totalCost > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green[200]!),
                            ),
                            child: Text(
                              '${operation.totalCost.toStringAsFixed(2)} ₽',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _formatTime(operation.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Дополнительная информация
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      if (operation.supplier.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(Icons.business, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Поставщик: ${operation.supplier}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      Row(
                        children: [
                          Icon(Icons.person, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Оператор: ${operation.operator}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (operation.notes.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.note, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Примечания: ${operation.notes}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Диалоги

  /// Диалог прихода товара
  void _showAddInventoryDialog(BuildContext context) {
    _quantityController.clear();
    _costController.clear();
    _supplierController.clear();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Приход товара'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Выбор товара
              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  final products = productProvider.products;
                  
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Товар',
                      border: OutlineInputBorder(),
                    ),
                    items: products.map((product) {
                      return DropdownMenuItem<String>(
                        value: product['id'] as String,
                        child: Text(product['name'] as String),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // В реальном приложении здесь будет обновление UI
                    },
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // Количество
              TextField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Количество',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              
              const SizedBox(height: 16),
              
              // Стоимость
              TextField(
                controller: _costController,
                decoration: const InputDecoration(
                  labelText: 'Стоимость за единицу (₽)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              
              const SizedBox(height: 16),
              
              // Поставщик
              TextField(
                controller: _supplierController,
                decoration: const InputDecoration(
                  labelText: 'Поставщик',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              // В реальном приложении здесь будет валидация и добавление
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Товар добавлен на склад')),
              );
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  /// Диалог списания товара
  void _showRemoveInventoryDialog(BuildContext context) {
    _quantityController.clear();
    _reasonController.clear();
    _operatorController.clear();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Списание товара'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Выбор товара
              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  final products = productProvider.products;
                  
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Товар',
                      border: OutlineInputBorder(),
                    ),
                    items: products.map((product) {
                      return DropdownMenuItem<String>(
                        value: product['id'] as String,
                        child: Text('${product['name'] as String} (остаток: ${product['stock_quantity']})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // В реальном приложении здесь будет обновление UI
                    },
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // Количество
              TextField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Количество для списания',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              
              const SizedBox(height: 16),
              
              // Причина
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Причина списания',
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Оператор
              TextField(
                controller: _operatorController,
                decoration: const InputDecoration(
                  labelText: 'Оператор',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              // В реальном приложении здесь будет валидация и списание
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Товар списан со склада')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Списать'),
          ),
        ],
      ),
    );
  }

  /// Диалог инвентаризации
  void _showInventoryCheckDialog(BuildContext context) {
    _quantityController.clear();
    _operatorController.clear();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Инвентаризация'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Выбор товара
              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  final products = productProvider.products;
                  
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Товар',
                      border: OutlineInputBorder(),
                    ),
                    items: products.map((product) {
                      return DropdownMenuItem<String>(
                        value: product['id'] as String,
                        child: Text('${product['name'] as String} (ожидается: ${product['stock_quantity']})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // В реальном приложении здесь будет обновление UI
                    },
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // Фактическое количество
              TextField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Фактическое количество',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              
              const SizedBox(height: 16),
              
              // Оператор
              TextField(
                controller: _operatorController,
                decoration: const InputDecoration(
                  labelText: 'Оператор',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              // В реальном приложении здесь будет валидация и инвентаризация
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Инвентаризация выполнена')),
              );
            },
            child: const Text('Выполнить'),
          ),
        ],
      ),
    );
  }

  /// Диалог перемещения товара
  void _showMoveInventoryDialog(BuildContext context) {
    _quantityController.clear();
    _operatorController.clear();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Перемещение товара'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Выбор товара
              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  final products = productProvider.products;
                  
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Товар',
                      border: OutlineInputBorder(),
                    ),
                    items: products.map((product) {
                      return DropdownMenuItem<String>(
                        value: product['id'] as String,
                        child: Text('${product['name'] as String} (доступно: ${product['stock_quantity']})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // В реальном приложении здесь будет обновление UI
                    },
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // Количество
              TextField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Количество для перемещения',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              
              const SizedBox(height: 16),
              
              // Откуда
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Откуда',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'warehouse_a', child: Text('Склад А')),
                  DropdownMenuItem(value: 'warehouse_b', child: Text('Склад Б')),
                  DropdownMenuItem(value: 'store_central', child: Text('Магазин Центральный')),
                  DropdownMenuItem(value: 'store_north', child: Text('Магазин Северный')),
                ],
                onChanged: (value) {
                  // В реальном приложении здесь будет обновление UI
                },
              ),
              
              const SizedBox(height: 16),
              
              // Куда
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Куда',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'warehouse_a', child: Text('Склад А')),
                  DropdownMenuItem(value: 'warehouse_b', child: Text('Склад Б')),
                  DropdownMenuItem(value: 'store_central', child: Text('Магазин Центральный')),
                  DropdownMenuItem(value: 'store_north', child: Text('Магазин Северный')),
                ],
                onChanged: (value) {
                  // В реальном приложении здесь будет обновление UI
                },
              ),
              
              const SizedBox(height: 16),
              
              // Оператор
              TextField(
                controller: _operatorController,
                decoration: const InputDecoration(
                  labelText: 'Оператор',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              // В реальном приложении здесь будет валидация и перемещение
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Товар перемещен')),
              );
            },
            child: const Text('Переместить'),
          ),
        ],
      ),
    );
  }

  /// Диалог статистики склада
  void _showInventoryStatsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Статистика склада'),
        content: SizedBox(
          width: 600,
          height: 500,
          child: Consumer<InventoryProvider>(
            builder: (context, inventoryProvider, child) {
              final stats = inventoryProvider.getInventoryStats();
              
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Общая статистика
                    _buildStatCardForDialog('Сегодня', stats['today']?['count'] ?? 0, stats['today']?['value'] ?? 0.0),
                    const SizedBox(height: 16),
                    _buildStatCardForDialog('За неделю', stats['week']?['count'] ?? 0, stats['week']?['value'] ?? 0.0),
                    const SizedBox(height: 16),
                    _buildStatCardForDialog('За месяц', stats['month']?['count'] ?? 0, stats['month']?['value'] ?? 0.0),
                    
                    const SizedBox(height: 24),
                    
                    // Статистика по типам операций
                    const Text('Статистика по типам операций:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    ...(stats['type_stats'] as Map<String, dynamic>? ?? {}).entries.map((entry) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key),
                            Text('${entry.value} операций'),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Топ товаров
                    const Text('Топ товаров по операциям:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    ...(stats['top_products'] as List<dynamic>? ?? []).map((product) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('• ${product['name']} (${product['quantity']} шт.)'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  /// Построение карточки статистики для диалога
  Widget _buildStatCardForDialog(String title, int count, double value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('$count операций'),
              ],
            ),
          ),
          Text(
            '${value.toStringAsFixed(2)} ₽',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }

  // Вспомогательные методы

  /// Получение цвета типа операции
  Color _getOperationTypeColor(OperationType type) {
    switch (type) {
      case OperationType.incoming:
        return Colors.green;
      case OperationType.outgoing:
        return Colors.red;
      case OperationType.inventory:
        return Colors.orange;
      case OperationType.movement:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  /// Получение иконки типа операции
  IconData _getOperationTypeIcon(OperationType type) {
    switch (type) {
      case OperationType.incoming:
        return Icons.add_circle;
      case OperationType.outgoing:
        return Icons.remove_circle;
      case OperationType.inventory:
        return Icons.assignment;
      case OperationType.movement:
        return Icons.swap_horiz;
      default:
        return Icons.help;
    }
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

  /// Форматирование времени
  String _formatTime(DateTime time) {
    return '${time.day.toString().padLeft(2, '0')}.${time.month.toString().padLeft(2, '0')}.${time.year} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Показать детали операции
  void _showOperationDetails(InventoryOperation operation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _getOperationTypeIcon(operation.type),
              color: _getOperationTypeColor(operation.type),
            ),
            const SizedBox(width: 12),
            Text('Детали операции №${operation.id}'),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Тип операции', _getOperationTypeName(operation.type)),
              _buildDetailRow('Товар', operation.productName),
              _buildDetailRow('Количество', '${operation.quantity} шт.'),
              if (operation.cost > 0) _buildDetailRow('Стоимость за единицу', '${operation.cost.toStringAsFixed(2)} ₽'),
              if (operation.totalCost > 0) _buildDetailRow('Общая стоимость', '${operation.totalCost.toStringAsFixed(2)} ₽'),
              if (operation.supplier.isNotEmpty) _buildDetailRow('Поставщик', operation.supplier),
              _buildDetailRow('Оператор', operation.operator),
              _buildDetailRow('Дата и время', _formatTime(operation.timestamp)),
              if (operation.notes.isNotEmpty) _buildDetailRow('Примечания', operation.notes),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  /// Построение строки деталей
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  /// Показать диалог настроек
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.settings, color: Colors.blue[600]),
            const SizedBox(width: 12),
            const Text('Настройки склада'),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.notifications, color: Colors.blue[600]),
                title: const Text('Уведомления'),
                subtitle: const Text('Настройки уведомлений о складских операциях'),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
              ListTile(
                leading: Icon(Icons.backup, color: Colors.blue[600]),
                title: const Text('Автоматическое резервное копирование'),
                subtitle: const Text('Создание резервных копий данных'),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
              ListTile(
                leading: Icon(Icons.security, color: Colors.blue[600]),
                title: const Text('Безопасность'),
                subtitle: const Text('Настройки доступа и безопасности'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Настройки сохранены')),
              );
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}
