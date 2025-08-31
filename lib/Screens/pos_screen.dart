import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/pos_provider.dart';
import '../Provider/product_provider.dart';

class POSScreen extends StatefulWidget {
  const POSScreen({Key? key}) : super(key: key);

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen>
    with TickerProviderStateMixin {
  final TextEditingController _cashierController = TextEditingController();
  final TextEditingController _initialAmountController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

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
    _cashierController.dispose();
    _initialAmountController.dispose();
    _discountController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Consumer<POSProvider>(
                  builder: (context, posProvider, child) {
                    if (posProvider.isLoading) {
                      return Container(
                        height: 400,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (posProvider.error != null) {
                      return _buildErrorView(posProvider);
                    }

                    if (!posProvider.isCashRegisterOpen) {
                      return _buildCashRegisterClosed();
                    }

                    return _buildCashRegisterOpen();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'POS-касса',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.point_of_sale,
              size: 60,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ),
      ),
      actions: [
        Consumer<POSProvider>(
          builder: (context, posProvider, child) {
            if (posProvider.isCashRegisterOpen) {
              return IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => _showCloseCashRegisterDialog(),
                tooltip: 'Закрыть кассу',
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.open_in_new, color: Colors.white),
                onPressed: () => _showOpenCashRegisterDialog(),
                tooltip: 'Открыть кассу',
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.history, color: Colors.white),
          onPressed: () => _showSalesHistoryDialog(),
          tooltip: 'История продаж',
        ),
        IconButton(
          icon: const Icon(Icons.analytics, color: Colors.white),
          onPressed: () => _showSalesStatsDialog(),
          tooltip: 'Статистика',
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () => _showSettingsDialog(),
          tooltip: 'Настройки',
        ),
      ],
    );
  }

  Widget _buildErrorView(POSProvider posProvider) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            'Ошибка: ${posProvider.error}',
            style: TextStyle(color: Colors.red[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              posProvider.clearError();
              posProvider.initialize();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Повторить'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashRegisterClosed() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!, width: 2),
              ),
              child: Icon(
                Icons.store,
                size: 100,
                color: Colors.grey[400],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Касса закрыта',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Для начала работы необходимо открыть кассу',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () => _showOpenCashRegisterDialog(),
            icon: const Icon(Icons.open_in_new, size: 28),
            label: const Text(
              'Открыть кассу',
              style: TextStyle(fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashRegisterOpen() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildQuickStats(),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildProductsPanel(),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: _buildCartPanel(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Consumer<POSProvider>(
      builder: (context, posProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[50]!, Colors.purple[50]!],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.person,
                  label: 'Кассир',
                  value: posProvider.currentCashier ?? 'Не указан',
                  color: Colors.blue,
                ),
              ),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.attach_money,
                  label: 'В кассе',
                  value: '${posProvider.cashAmount.toStringAsFixed(2)} ₽',
                  color: Colors.green,
                ),
              ),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.shopping_cart,
                  label: 'В корзине',
                  value: '${posProvider.currentCart.length}',
                  color: Colors.orange,
                ),
              ),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.receipt,
                  label: 'Продаж сегодня',
                  value: '${posProvider.getSalesStats()['today']?['count'] ?? 0}',
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProductsPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPanelHeader(
            title: 'Товары',
            icon: Icons.inventory,
            color: Colors.blue,
            trailing: _buildSearchBar(),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                final products = productProvider.products;
                
                if (products.isEmpty) {
                  return _buildEmptyProductsState();
                }
                
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _buildProductCard(product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanelHeader({
    required String title,
    required IconData icon,
    required Color color,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (trailing != null) ...[
            const Spacer(),
            trailing,
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: 200,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Поиск товаров...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        onChanged: (value) {
          // Логика поиска будет добавлена
        },
      ),
    );
  }

  Widget _buildEmptyProductsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Товары не найдены',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Добавьте товары в систему',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Consumer<POSProvider>(
      builder: (context, posProvider, child) {
        return GestureDetector(
          onTap: () {
            posProvider.addToCart(product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product['name']} добавлен в корзину'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: product['image_url'] != null
                          ? Image.network(
                              product['image_url'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: Icon(Icons.image_not_supported, size: 40),
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.image_not_supported, size: 40),
                              ),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] ?? 'Без названия',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(product['price'] ?? 0.0).toStringAsFixed(2)} ₽',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.inventory,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${product['stock_quantity'] ?? 0}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPanelHeader(
            title: 'Корзина',
            icon: Icons.shopping_cart,
            color: Colors.orange,
          ),
          Expanded(
            child: Consumer<POSProvider>(
              builder: (context, posProvider, child) {
                if (posProvider.currentCart.isEmpty) {
                  return _buildEmptyCartState();
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: posProvider.currentCart.length,
                  itemBuilder: (context, index) {
                    final item = posProvider.currentCart[index];
                    return _buildCartItem(item);
                  },
                );
              },
            ),
          ),
          _buildCartSummary(),
        ],
      ),
    );
  }

  Widget _buildEmptyCartState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Корзина пуста',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Добавьте товары для продажи',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Consumer<POSProvider>(
      builder: (context, posProvider, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              if (item.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.imageUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.price.toStringAsFixed(2)} ₽ × ${item.quantity}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              Column(
                children: [
                  Text(
                    '${item.total.toStringAsFixed(2)} ₽',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 16),
                        onPressed: () {
                          posProvider.updateQuantity(item.productId, item.quantity - 1);
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red[100],
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 16),
                        onPressed: () {
                          posProvider.updateQuantity(item.productId, item.quantity + 1);
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.green[100],
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartSummary() {
    return Consumer<POSProvider>(
      builder: (context, posProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              _buildDiscountSection(posProvider),
              const SizedBox(height: 20),
              _buildTotalSection(posProvider),
              const SizedBox(height: 20),
              _buildPaymentSection(posProvider),
              const SizedBox(height: 20),
              _buildActionButtons(posProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDiscountSection(POSProvider posProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Скидка',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _discountController,
                  decoration: InputDecoration(
                    labelText: 'Процент скидки',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixText: '%',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    final discount = double.tryParse(value);
                    if (discount != null) {
                      posProvider.applyDiscount(discount);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  final discount = double.tryParse(_discountController.text);
                  if (discount != null) {
                    posProvider.applyDiscount(discount);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('Применить'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection(POSProvider posProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[50]!, Colors.blue[50]!],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Сумма:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '${posProvider.cartTotal.toStringAsFixed(2)} ₽',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          if (posProvider.cartDiscount > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Скидка:',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 16,
                  ),
                ),
                Text(
                  '-${posProvider.cartDiscount.toStringAsFixed(2)} ₽',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ИТОГО:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey[800],
                ),
              ),
              ScaleTransition(
                scale: _pulseAnimation,
                child: Text(
                  '${(posProvider.cartTotal - posProvider.cartDiscount).toStringAsFixed(2)} ₽',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(POSProvider posProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Способ оплаты:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => posProvider.setPaymentMethod('cash'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: posProvider.paymentMethod == 'cash'
                        ? Colors.green
                        : Colors.grey[300],
                    foregroundColor: posProvider.paymentMethod == 'cash'
                        ? Colors.white
                        : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Наличные'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => posProvider.setPaymentMethod('card'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: posProvider.paymentMethod == 'card'
                        ? Colors.blue
                        : Colors.grey[300],
                    foregroundColor: posProvider.paymentMethod == 'card'
                        ? Colors.white
                        : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Карта'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(POSProvider posProvider) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: posProvider.currentCart.isEmpty ? null : () {
              posProvider.clearCart();
              _discountController.clear();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Очистить'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: posProvider.currentCart.isEmpty ? null : () async {
              final sale = await posProvider.completeSale();
              if (sale != null) {
                _discountController.clear();
                _showSaleCompletedDialog(sale);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Оплатить'),
          ),
        ),
      ],
    );
  }

  // Диалоги
  void _showOpenCashRegisterDialog() {
    _cashierController.clear();
    _initialAmountController.clear();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.open_in_new, color: Colors.blue[700]),
            const SizedBox(width: 12),
            const Text('Открыть кассу'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _cashierController,
              decoration: const InputDecoration(
                labelText: 'Имя кассира',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _initialAmountController,
              decoration: const InputDecoration(
                labelText: 'Начальная сумма в кассе',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
                suffixText: '₽',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              final cashier = _cashierController.text.trim();
              final amount = double.tryParse(_initialAmountController.text);
              
              if (cashier.isEmpty || amount == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Заполните все поля')),
                );
                return;
              }
              
              final success = await context.read<POSProvider>().openCashRegister(cashier, amount);
              if (success) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Касса открыта кассиром $cashier')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Открыть'),
          ),
        ],
      ),
    );
  }

  void _showCloseCashRegisterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.close, color: Colors.red[700]),
            const SizedBox(width: 12),
            const Text('Закрыть кассу'),
          ],
        ),
        content: Consumer<POSProvider>(
          builder: (context, posProvider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Кассир: ${posProvider.currentCashier}'),
                const SizedBox(height: 8),
                Text('Сумма в кассе: ${posProvider.cashAmount.toStringAsFixed(2)} ₽'),
                const SizedBox(height: 16),
                const Text('Вы уверены, что хотите закрыть кассу?'),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await context.read<POSProvider>().closeCashRegister();
              if (success) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Касса закрыта')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showSaleCompletedDialog(Sale sale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[700]),
            const SizedBox(width: 12),
            const Text('Продажа завершена!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Чек №${sale.id}'),
            const SizedBox(height: 8),
            Text('Кассир: ${sale.cashier}'),
            const SizedBox(height: 8),
            Text('Способ оплаты: ${_getPaymentMethodText(sale.paymentMethod)}'),
            const SizedBox(height: 8),
            Text('Сумма: ${sale.finalTotal.toStringAsFixed(2)} ₽'),
            const SizedBox(height: 16),
            const Text('Товары:'),
            ...sale.items.map((item) => Text('• ${item.name} × ${item.quantity}')),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSalesHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.history, color: Colors.blue[700]),
            const SizedBox(width: 12),
            const Text('История продаж'),
          ],
        ),
        content: SizedBox(
          width: 600,
          height: 400,
          child: Consumer<POSProvider>(
            builder: (context, posProvider, child) {
              if (posProvider.salesHistory.isEmpty) {
                return const Center(
                  child: Text('История продаж пуста'),
                );
              }
              
              return ListView.builder(
                itemCount: posProvider.salesHistory.length,
                itemBuilder: (context, index) {
                  final sale = posProvider.salesHistory[index];
                  return ListTile(
                    title: Text('Чек №${sale.id}'),
                    subtitle: Text(
                      '${sale.cashier} • ${_getPaymentMethodText(sale.paymentMethod)} • ${sale.finalTotal.toStringAsFixed(2)} ₽',
                    ),
                    trailing: Text(
                      '${sale.timestamp.hour}:${sale.timestamp.minute.toString().padLeft(2, '0')}',
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showSalesStatsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.analytics, color: Colors.purple[700]),
            const SizedBox(width: 12),
            const Text('Статистика продаж'),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Consumer<POSProvider>(
            builder: (context, posProvider, child) {
              final stats = posProvider.getSalesStats();
              
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatCardForDialog('Сегодня', stats['today']?['count'] ?? 0, stats['today']?['total'] ?? 0.0),
                  const SizedBox(height: 16),
                  _buildStatCardForDialog('За неделю', stats['week']?['count'] ?? 0, stats['week']?['total'] ?? 0.0),
                  const SizedBox(height: 16),
                  _buildStatCardForDialog('За месяц', stats['month']?['count'] ?? 0, stats['month']?['total'] ?? 0.0),
                  const SizedBox(height: 16),
                  const Text('Топ товаров:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...(stats['top_products'] as List<dynamic>? ?? []).map((product) => 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• ${product['name']} (${product['quantity']} шт.)'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardForDialog(String title, int count, double total) {
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
                Text('$count продаж'),
              ],
            ),
          ),
          Text(
            '${total.toStringAsFixed(2)} ₽',
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

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.settings, color: Colors.grey[700]),
            const SizedBox(width: 12),
            const Text('Настройки POS'),
          ],
        ),
        content: const Text('Настройки POS-системы будут добавлены'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Вспомогательные методы
  String _getPaymentMethodText(String method) {
    switch (method) {
      case 'cash':
        return 'Наличные';
      case 'card':
        return 'Карта';
      case 'return':
        return 'Возврат';
      default:
        return method;
    }
  }
}
