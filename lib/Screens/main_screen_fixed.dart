import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/app_provider.dart';
import '../Provider/auth_provider.dart';
import '../Provider/ai_provider.dart';
import '../Provider/web3_provider.dart';
import '../Provider/blockchain_provider.dart';
import '../Provider/social_provider.dart';
import '../Provider/product_provider.dart';
import '../Provider/analytics_provider.dart';
import '../Screens/ai_chat_screen.dart';
import '../Screens/pos_screen.dart';
import '../Screens/inventory_screen.dart';
import '../Screens/nft_screen.dart';
import '../Screens/web3_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    
    // Инициализируем приложение
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        // Показываем индикатор загрузки, если приложение инициализируется
        if (appProvider.isAnythingLoading && !appProvider.isInitialized) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Инициализация PoSPro...',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          );
        }

        // Показываем ошибки, если они есть
        if (appProvider.hasErrors) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Произошла ошибка',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Попробуйте перезапустить приложение',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        appProvider.clearAllErrors();
                        appProvider.initialize();
                      },
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: const [
              DashboardScreen(),
              ProductsScreen(),
              AIScreen(),
              Web3Screen(),
              SocialScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Главная',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory),
                label: 'Товары',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.psychology),
                label: 'AI',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet),
                label: 'Web3',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Соцсети',
              ),

            ],
          ),
        );
      },
    );
  }
}

// Дашборд экран
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  String _selectedPeriod = 'week';
  String _selectedMetric = 'sales';
  
  // Анимации
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
    
    // Инициализация анимаций
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
                child: Consumer<AppProvider>(
                  builder: (context, appProvider, child) {
                    final stats = appProvider.getGlobalStats();
                    
                    if (stats == null) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(50),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWelcomeSection(),
                          const SizedBox(height: 24),
                          _buildQuickStats(stats),
                          const SizedBox(height: 24),
                          _buildAnalyticsSection(stats),
                          const SizedBox(height: 24),
                          _buildQuickActions(),
                          const SizedBox(height: 24),
                          _buildRecentActivity(),
                          const SizedBox(height: 30),
                        ],
                      ),
                    );
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
      expandedHeight: 140,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'PoSPro Дашборд',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
                Theme.of(context).primaryColor.withOpacity(0.6),
              ],
            ),
          ),
          child: Center(
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Icon(
                Icons.dashboard,
                size: 60,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            setState(() {
              _selectedPeriod = value;
            });
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'day', child: Text('День')),
            const PopupMenuItem(value: 'week', child: Text('Неделя')),
            const PopupMenuItem(value: 'month', child: Text('Месяц')),
            const PopupMenuItem(value: 'year', child: Text('Год')),
          ],
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getPeriodText(_selectedPeriod),
                  style: const TextStyle(color: Colors.white),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.waving_hand,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Добро пожаловать в PoSPro!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ваша система управления торговлей с AI и блокчейн возможностями',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Последнее обновление: ${DateTime.now().toString().substring(0, 16)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Онлайн',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(Map<String, dynamic> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Общая статистика',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            _buildStatCard(
              context,
              'Товары',
              '${stats['products']?['total_products'] ?? 0}',
              Icons.inventory,
              Colors.blue,
              _getTrendIcon(stats['products']?['trend'] ?? 'stable'),
              _getTrendColor(stats['products']?['trend'] ?? 'stable'),
            ),
            _buildStatCard(
              context,
              'Категории',
              '${stats['products']?['total_categories'] ?? 0}',
              Icons.category,
              Colors.green,
              _getTrendIcon(stats['products']?['categories_trend'] ?? 'stable'),
              _getTrendColor(stats['products']?['categories_trend'] ?? 'stable'),
            ),
            _buildStatCard(
              context,
              'AI функции',
              '${stats['ai']?['personal_recommendations_count'] ?? 0}',
              Icons.psychology,
              Colors.purple,
              _getTrendIcon(stats['ai']?['trend'] ?? 'stable'),
              _getTrendColor(stats['ai']?['trend'] ?? 'stable'),
            ),
            _buildStatCard(
              context,
              'Web3',
              stats['web3']?['is_connected'] == true ? 'Подключено' : 'Отключено',
              Icons.account_balance_wallet,
              Colors.orange,
              stats['web3']?['is_connected'] == true ? Icons.check_circle : Icons.cancel,
              stats['web3']?['is_connected'] == true ? Colors.green : Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalyticsSection(Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Аналитика продаж',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  setState(() {
                    _selectedMetric = value;
                  });
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'sales', child: Text('Продажи')),
                  const PopupMenuItem(value: 'revenue', child: Text('Доход')),
                  const PopupMenuItem(value: 'orders', child: Text('Заказы')),
                  const PopupMenuItem(value: 'customers', child: Text('Клиенты')),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.analytics,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getMetricText(_selectedMetric),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'График $_selectedMetric',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Период: ${_getPeriodText(_selectedPeriod)}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Быстрые действия',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.add,
                label: 'Добавить товар',
                color: Colors.blue,
                onTap: () {
                  _showAddProductDialog(context);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                icon: Icons.psychology,
                label: 'AI анализ',
                color: Colors.purple,
                onTap: () {
                  _showAIAnalysisDialog(context);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                icon: Icons.account_balance_wallet,
                label: 'Web3',
                color: Colors.orange,
                onTap: () {
                  _showWeb3Dialog(context);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.post_add,
                label: 'Создать пост',
                color: Colors.green,
                onTap: () {
                  _showCreatePostDialog(context);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                icon: Icons.analytics,
                label: 'Аналитика',
                color: Colors.teal,
                onTap: () {
                  _showAnalyticsDialog(context);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                icon: Icons.settings,
                label: 'Настройки',
                color: Colors.indigo,
                onTap: () {
                  _showSettingsDialog(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
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
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Последняя активность',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          _buildRecentActivityItem(
            context,
            Icons.add_shopping_cart,
            'Добавлен новый товар',
            'iPhone 15 Pro добавлен в каталог',
            '2 мин назад',
            Colors.green,
          ),
          _buildRecentActivityItem(
            context,
            Icons.payment,
            'Новая продажа',
            'Продажа на сумму \$1,299',
            '15 мин назад',
            Colors.blue,
          ),
          _buildRecentActivityItem(
            context,
            Icons.inventory,
            'Обновлен склад',
            'Пополнение товара на складе',
            '1 час назад',
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color, IconData? trendIcon, Color? trendColor) {
    return GestureDetector(
      onTap: () => _showStatDetailsDialog(context, title, value, icon, color),
      child: Container(
        padding: const EdgeInsets.all(20),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 24, color: color),
                ),
                if (trendIcon != null)
                  Icon(trendIcon, size: 20, color: trendColor),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityItem(BuildContext context, IconData icon, String title, String description, String time, Color color) {
    return GestureDetector(
      onTap: () => _showActivityDetailsDialog(context, icon, title, description, time, color),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                time,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPeriodText(String period) {
    switch (period) {
      case 'day':
        return 'День';
      case 'week':
        return 'Неделя';
      case 'month':
        return 'Месяц';
      case 'year':
        return 'Год';
      default:
        return 'Неделя';
    }
  }

  String _getMetricText(String metric) {
    switch (metric) {
      case 'sales':
        return 'Продажи';
      case 'revenue':
        return 'Доход';
      case 'orders':
        return 'Заказы';
      case 'customers':
        return 'Клиенты';
      default:
        return 'Продажи';
    }
  }

  IconData _getTrendIcon(String trend) {
    switch (trend) {
      case 'up':
        return Icons.trending_up;
      case 'down':
        return Icons.trending_down;
      default:
        return Icons.trending_flat;
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'up':
        return Colors.green;
      case 'down':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  bool _hasWarnings(Map<String, dynamic>? stats) {
    if (stats == null) return false;
    // Проверяем наличие товаров с низким запасом
    final lowStockProducts = stats['products']?['low_stock_products_count'] ?? 0;
    return lowStockProducts > 0;
  }

  // Диалоги для быстрых действий
  void _showAddProductDialog(BuildContext context) {
    // Переход на экран товаров для добавления
    final pageController = context.findAncestorStateOfType<_MainScreenState>()?._pageController;
    if (pageController != null) {
      pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _showAIAnalysisDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AI Анализ'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Выберите тип анализа:'),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.trending_up),
                title: Text('Анализ продаж'),
                subtitle: Text('Прогноз и тренды'),
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Поведение клиентов'),
                subtitle: Text('Сегментация и предпочтения'),
              ),
              ListTile(
                leading: Icon(Icons.inventory),
                title: Text('Управление запасами'),
                subtitle: Text('Оптимизация и прогнозы'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Запустить AI анализ
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('AI анализ запущен!')),
                );
              },
              child: const Text('Запустить'),
            ),
          ],
        );
      },
    );
  }

  void _showWeb3Dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Web3 Функции'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Выберите действие:'),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('Подключить кошелек'),
                subtitle: Text('MetaMask, WalletConnect'),
              ),
              ListTile(
                leading: Icon(Icons.token),
                title: Text('Создать NFT'),
                subtitle: Text('Минтинг токенов'),
              ),
              ListTile(
                leading: Icon(Icons.swap_horiz),
                title: Text('DeFi операции'),
                subtitle: Text('Свопы, стейкинг'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Выполнить Web3 действие
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Web3 действие выполнено!')),
                );
              },
              child: const Text('Выполнить'),
            ),
          ],
        );
      },
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Создать пост'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Заголовок поста',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Текст поста',
                  border: OutlineInputBorder(),
                  hintText: 'Что хотите рассказать?',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Создать пост
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Пост создан!')),
                );
              },
              child: const Text('Опубликовать'),
            ),
          ],
        );
      },
    );
  }

  void _showAnalyticsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Аналитика'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Выберите отчет:'),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.bar_chart),
                title: Text('Продажи'),
                subtitle: Text('Графики и статистика'),
              ),
              ListTile(
                leading: Icon(Icons.pie_chart),
                title: Text('Категории'),
                subtitle: Text('Распределение по типам'),
              ),
              ListTile(
                leading: Icon(Icons.timeline),
                title: Text('Тренды'),
                subtitle: Text('Временные ряды'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Показать аналитику
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Отчет загружается!')),
                );
              },
              child: const Text('Показать'),
            ),
          ],
        );
      },
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Настройки'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Уведомления'),
                subtitle: Text('Настройка оповещений'),
              ),
              ListTile(
                leading: Icon(Icons.security),
                title: Text('Безопасность'),
                subtitle: Text('Пароли и доступ'),
              ),
              ListTile(
                leading: Icon(Icons.language),
                title: Text('Язык'),
                subtitle: Text('Русский, English'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Открыть настройки
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Настройки открыты!')),
                );
              },
              child: const Text('Открыть'),
            ),
          ],
        );
      },
    );
  }

  void _showStatDetailsDialog(BuildContext context, String title, String value, IconData icon, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(title),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Текущее значение:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Дополнительная информация:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildStatDetailItem('Изменение за день', '+5.2%', Icons.trending_up, Colors.green),
              _buildStatDetailItem('Изменение за неделю', '+12.8%', Icons.trending_up, Colors.green),
              _buildStatDetailItem('Изменение за месяц', '+23.4%', Icons.trending_up, Colors.green),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showDetailedAnalytics(context, title);
              },
              child: const Text('Подробнее'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatDetailItem(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailedAnalytics(BuildContext context, String category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Детальная аналитика: $category'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'График аналитики\n(Здесь будет отображаться интерактивный график)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Экспорт в PDF!')),
                          );
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Экспорт PDF'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Экспорт в Excel!')),
                          );
                        },
                        icon: const Icon(Icons.table_chart),
                        label: const Text('Экспорт Excel'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  void _showActivityDetailsDialog(BuildContext context, IconData icon, String title, String description, String time, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(child: Text(title)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Описание:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(description),
              ),
              const SizedBox(height: 16),
              Text(
                'Время:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Действия:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildActionButton(
                icon: Icons.edit,
                label: 'Редактировать',
                onTap: () {
                  Navigator.of(context).pop();
                  _showEditActivityDialog(context, title, description);
                },
              ),
              const SizedBox(height: 8),
              _buildActionButton(
                icon: Icons.delete,
                label: 'Удалить',
                onTap: () {
                  Navigator.of(context).pop();
                  _showDeleteConfirmationDialog(context, title);
                },
                color: Colors.red,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showActivityHistory(context, title);
              },
              child: const Text('История'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: (color ?? Colors.blue).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: (color ?? Colors.blue).withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color ?? Colors.blue, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color ?? Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditActivityDialog(BuildContext context, String title, String description) {
    final TextEditingController titleController = TextEditingController(text: title);
    final TextEditingController descController = TextEditingController(text: description);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Редактировать активность'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Заголовок',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
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
                  const SnackBar(content: Text('Активность обновлена!')),
                );
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение удаления'),
          content: Text('Вы уверены, что хотите удалить активность "$title"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Активность удалена!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }

  void _showActivityHistory(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('История активности: $title'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(
                          index == 0 ? Icons.check_circle : Icons.history,
                          color: index == 0 ? Colors.green : Colors.grey,
                        ),
                        title: Text('Версия ${5 - index}'),
                        subtitle: Text('Изменено ${index + 1} ${index == 0 ? 'час' : 'часа'} назад'),
                        trailing: Text('v${5 - index}.0'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }
}

// Экран товаров
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> with TickerProviderStateMixin {
  // Анимации
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
    
    // Инициализация анимаций
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
                child: Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                    if (productProvider.isLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(50),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchAndFilters(productProvider),
                          const SizedBox(height: 24),
                          _buildQuickStats(productProvider),
                          const SizedBox(height: 24),
                          _buildProductsList(productProvider),
                          const SizedBox(height: 30),
                        ],
                      ),
                    );
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
      expandedHeight: 140,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Товары',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
                Theme.of(context).primaryColor.withOpacity(0.6),
              ],
            ),
          ),
          child: Center(
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Icon(
                Icons.inventory,
                size: 60,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            _showAddProductDialog(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white),
          onPressed: () {
            _showAdvancedFiltersDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters(ProductProvider productProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Поиск и фильтры',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          
          // Поиск
          TextField(
            decoration: InputDecoration(
              hintText: 'Поиск товаров...',
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
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
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (value) {
              productProvider.setSearchQuery(value);
            },
          ),
          const SizedBox(height: 20),
          
          // Фильтры
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Категория',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  value: null,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Все категории')),
                    ...productProvider.categories.map((cat) => DropdownMenuItem(
                      value: cat['id'],
                      child: Text(cat['name'] ?? ''),
                    )),
                  ],
                  onChanged: (value) {
                    // Применить фильтр по категории
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Сортировка',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  value: 'name',
                  items: const [
                    DropdownMenuItem(value: 'name', child: Text('По названию')),
                    DropdownMenuItem(value: 'price', child: Text('По цене')),
                    DropdownMenuItem(value: 'stock', child: Text('По остатку')),
                    DropdownMenuItem(value: 'date', child: Text('По дате')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      productProvider.setSortBy(value);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(ProductProvider productProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Статистика товаров',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Всего товаров',
                value: '${productProvider.totalProducts}',
                icon: Icons.inventory,
                color: Colors.blue,
                subtitle: 'В каталоге',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'Категорий',
                value: '${productProvider.totalCategories}',
                icon: Icons.category,
                color: Colors.green,
                subtitle: 'Доступно',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'Низкий запас',
                value: '${productProvider.products.where((p) => (p['stock_quantity'] ?? 0) <= (p['min_stock_level'] ?? 0)).length}',
                icon: Icons.warning,
                color: Colors.orange,
                subtitle: 'Требует внимания',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return GestureDetector(
      onTap: () => _showProductStatDetailsDialog(context, title, value, icon, color, subtitle),
      child: Container(
        padding: const EdgeInsets.all(20),
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
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsList(ProductProvider productProvider) {
    final productsToShow = productProvider.filteredProducts.isNotEmpty 
        ? productProvider.filteredProducts 
        : productProvider.products;
    
    if (productsToShow.isEmpty) {
      return _buildEmptyProductsState();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Список товаров',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              '${productsToShow.length} товаров',
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
          itemCount: productsToShow.length,
          itemBuilder: (context, index) {
            final product = productsToShow[index];
            return _buildProductCard(product, index);
          },
        ),
      ],
    );
  }

  Widget _buildEmptyProductsState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Icon(
            Icons.inventory_2,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'Товары не найдены',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Попробуйте изменить фильтры или поисковый запрос',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              _showAddProductDialog(context);
            },
            icon: const Icon(Icons.add),
            label: const Text('Добавить товар'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, int index) {
    final isLowStock = (product['stock_quantity'] ?? 0) <= (product['min_stock_level'] ?? 0);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: InkWell(
        onTap: () {
          _showProductDetailsDialog(context, product);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Изображение товара
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                ),
                child: product['image_url'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product['image_url'],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.inventory,
                              size: 40,
                              color: Colors.grey[400],
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.inventory,
                        size: 40,
                        color: Colors.grey[400],
                      ),
              ),
              const SizedBox(width: 16),
              
              // Информация о товаре
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product['category_name'] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isLowStock ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isLowStock ? Colors.red.withOpacity(0.3) : Colors.green.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Остаток: ${product['stock_quantity'] ?? 0}',
                            style: TextStyle(
                              color: isLowStock ? Colors.red : Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(product['price'] ?? 0.0).toStringAsFixed(2)} ₽',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Кнопки действий
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Переход на Ozon: ${product['name']}'),
                          action: SnackBarAction(
                            label: 'Открыть',
                            onPressed: () {
                              // Здесь будет реальный переход на Ozon
                            },
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size(0, 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Ozon', style: TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    onPressed: () {
                      _showProductDetailsDialog(context, product);
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



  // Диалоги для ProductsScreen
  void _showAddProductDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController stockController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить товар'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Название товара *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceController,
                        decoration: const InputDecoration(
                          labelText: 'Цена *',
                          border: OutlineInputBorder(),
                          prefixText: '₽ ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: stockController,
                        decoration: const InputDecoration(
                          labelText: 'Количество *',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Категория',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
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
                if (nameController.text.isNotEmpty && 
                    priceController.text.isNotEmpty && 
                    stockController.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Товар успешно добавлен!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Заполните обязательные поля!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  void _showProductDetailsDialog(BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.inventory, color: Theme.of(context).primaryColor),
              const SizedBox(width: 12),
              Expanded(child: Text(product['name'] ?? 'Товар')),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Изображение товара
                if (product['image_url'] != null)
                  Container(
                    width: double.maxFinite,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[100],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product['image_url'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.inventory,
                            size: 80,
                            color: Colors.grey[400],
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                
                // Информация о товаре
                _buildDetailRow('Название', product['name'] ?? ''),
                _buildDetailRow('Категория', product['category_name'] ?? ''),
                _buildDetailRow('Цена', '${(product['price'] ?? 0.0).toStringAsFixed(2)} ₽'),
                _buildDetailRow('Остаток', '${product['stock_quantity'] ?? 0}'),
                _buildDetailRow('Мин. запас', '${product['min_stock_level'] ?? 0}'),
                if (product['description'] != null)
                  _buildDetailRow('Описание', product['description']),
                
                const SizedBox(height: 16),
                
                // Действия
                Text(
                  'Действия:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showEditProductDialog(context, product);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Редактировать'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showDeleteConfirmationDialog(context, product);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Удалить'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showInventoryDialog(context, product);
                        },
                        icon: const Icon(Icons.inventory_2),
                        label: const Text('Инвентаризация'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showAnalyticsDialog(context, product);
                        },
                        icon: const Icon(Icons.analytics),
                        label: const Text('Аналитика'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(BuildContext context, Map<String, dynamic> product) {
    final TextEditingController nameController = TextEditingController(text: product['name'] ?? '');
    final TextEditingController priceController = TextEditingController(text: (product['price'] ?? 0.0).toString());
    final TextEditingController stockController = TextEditingController(text: (product['stock_quantity'] ?? 0).toString());
    final TextEditingController categoryController = TextEditingController(text: product['category_name'] ?? '');
    final TextEditingController descriptionController = TextEditingController(text: product['description'] ?? '');
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Редактировать товар'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Название товара',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceController,
                        decoration: const InputDecoration(
                          labelText: 'Цена',
                          border: OutlineInputBorder(),
                          prefixText: '₽ ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: stockController,
                        decoration: const InputDecoration(
                          labelText: 'Количество',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Категория',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
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
                  const SnackBar(content: Text('Товар успешно обновлен!')),
                );
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение удаления'),
          content: Text('Вы уверены, что хотите удалить товар "${product['name']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Товар удален!'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }

  void _showInventoryDialog(BuildContext context, Map<String, dynamic> product) {
    final TextEditingController newStockController = TextEditingController(
      text: (product['stock_quantity'] ?? 0).toString()
    );
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Инвентаризация'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Товар: ${product['name']}'),
              const SizedBox(height: 16),
              TextField(
                controller: newStockController,
                decoration: const InputDecoration(
                  labelText: 'Новое количество',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Количество обновлено!')),
                        );
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Подтвердить'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showStockAdjustmentDialog(context, product);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Корректировка'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  void _showStockAdjustmentDialog(BuildContext context, Map<String, dynamic> product) {
    final TextEditingController adjustmentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Корректировка запасов'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Товар: ${product['name']}'),
              const SizedBox(height: 16),
              TextField(
                controller: adjustmentController,
                decoration: const InputDecoration(
                  labelText: 'Количество для добавления/вычитания',
                  border: OutlineInputBorder(),
                  hintText: 'Используйте + для добавления, - для вычитания',
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
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Запасы скорректированы!')),
                );
              },
              child: const Text('Применить'),
            ),
          ],
        );
      },
    );
  }

  void _showAnalyticsDialog(BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Аналитика: ${product['name']}'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                // Статистика продаж
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Статистика продаж',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildAnalyticsCard('Сегодня', '5', Icons.today),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildAnalyticsCard('Неделя', '32', Icons.date_range),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildAnalyticsCard('Месяц', '128', Icons.calendar_month),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // График
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'График продаж\n(Здесь будет интерактивный график)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Экспорт
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Экспорт в PDF!')),
                          );
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('PDF'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Экспорт в Excel!')),
                          );
                        },
                        icon: const Icon(Icons.table_chart),
                        label: const Text('Excel'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showProductStatDetailsDialog(BuildContext context, String title, String value, IconData icon, Color color, String subtitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(title),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Текущее значение:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Дополнительная информация:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildProductStatDetailItem('Изменение за день', '+2.1%', Icons.trending_up, Colors.green),
              _buildProductStatDetailItem('Изменение за неделю', '+8.7%', Icons.trending_up, Colors.green),
              _buildProductStatDetailItem('Изменение за месяц', '+15.3%', Icons.trending_up, Colors.green),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showProductDetailedAnalytics(context, title);
              },
              child: const Text('Подробнее'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductStatDetailItem(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showProductDetailedAnalytics(BuildContext context, String category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Детальная аналитика: $category'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'График аналитики товаров\n(Здесь будет отображаться интерактивный график)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Экспорт в PDF!')),
                          );
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Экспорт PDF'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Экспорт в Excel!')),
                          );
                        },
                        icon: const Icon(Icons.table_chart),
                        label: const Text('Экспорт Excel'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  void _showAdvancedFiltersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Расширенные фильтры'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                // Ценовой диапазон
                Text(
                  'Ценовой диапазон',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'От',
                          border: OutlineInputBorder(),
                          prefixText: '₽ ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'До',
                          border: OutlineInputBorder(),
                          prefixText: '₽ ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Остаток на складе
                Text(
                  'Остаток на складе',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'От',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'До',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Дата добавления
                Text(
                  'Дата добавления',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Выбрать дату "от"
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Выберите дату "от"')),
                          );
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('От'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Выбрать дату "до"
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Выберите дату "до"')),
                          );
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('До'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Дополнительные опции
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Только в наличии'),
                        value: false,
                        onChanged: (value) {
                          // TODO: Применить фильтр
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Со скидкой'),
                        value: false,
                        onChanged: (value) {
                          // TODO: Применить фильтр
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Сбросить'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Фильтры применены!')),
                );
              },
              child: const Text('Применить'),
            ),
          ],
        );
      },
    );
  }
}

// AI экран
class AIScreen extends StatefulWidget {
  const AIScreen({Key? key}) : super(key: key);

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> with TickerProviderStateMixin {
  // Анимации
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  // Контроллеры
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productCategoryController = TextEditingController();
  final TextEditingController _generatedDescriptionController = TextEditingController();
  final TextEditingController _generatedHashtagsController = TextEditingController();
  final TextEditingController _generatedPostController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Инициализация анимаций
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
    _productNameController.dispose();
    _productCategoryController.dispose();
    _generatedDescriptionController.dispose();
    _generatedHashtagsController.dispose();
    _generatedPostController.dispose();
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
                child: Consumer<AIProvider>(
                  builder: (context, aiProvider, child) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWelcomeSection(),
                          const SizedBox(height: 24),
                          _buildAIStats(aiProvider),
                          const SizedBox(height: 24),
                          _buildRecommendationsSection(aiProvider),
                          const SizedBox(height: 24),
                          _buildContentGenerationSection(aiProvider),
                          const SizedBox(height: 24),
                          _buildStyleAnalysisSection(aiProvider),
                          const SizedBox(height: 24),
                          _buildSalesAnalysisSection(aiProvider),
                          const SizedBox(height: 30),
                        ],
                      ),
                    );
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
      expandedHeight: 140,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'AI Помощник',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
                Theme.of(context).primaryColor.withOpacity(0.6),
              ],
            ),
          ),
          child: Center(
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Icon(
                Icons.psychology,
                size: 60,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            _showSettingsDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.waving_hand,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Добро пожаловать в PoSPro!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ваша система управления торговлей с AI и блокчейн возможностями',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Последнее обновление: ${DateTime.now().toString().substring(0, 16)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Онлайн',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIStats(AIProvider aiProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.analytics,
                  color: Colors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Статистика AI',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Рекомендаций',
                  '${aiProvider.personalRecommendations.length}',
                  Icons.recommend,
                  Colors.purple,
                  'AI Рекомендации',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Профиль стиля',
                  aiProvider.userStyleProfile != null ? 'Активен' : 'Неактивен',
                  Icons.person,
                  Colors.blue,
                  'AI Анализ стиля',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(Map<String, dynamic> rec) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple[100],
          child: Icon(Icons.recommend, color: Colors.purple),
        ),
        title: Text(rec['product_name'] ?? ''),
        subtitle: Text(rec['reason'] ?? ''),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.purple[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${(rec['score'] * 100).toInt()}%',
            style: TextStyle(
              color: Colors.purple[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoRecommendationsCard() {
    return Card(
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.psychology, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'Нет рекомендаций',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Нажмите кнопку ниже, чтобы получить персональные рекомендации',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsSection(AIProvider aiProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.psychology,
                  color: Colors.purple,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'AI Рекомендации',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (aiProvider.personalRecommendations.isNotEmpty) ...[
            ...aiProvider.personalRecommendations.map((rec) => _buildRecommendationCard(rec)),
            const SizedBox(height: 16),
          ],
          if (aiProvider.personalRecommendations.isEmpty) ...[
            _buildNoRecommendationsCard(),
            const SizedBox(height: 16),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await aiProvider.getPersonalRecommendations(userId: 'current_user');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Рекомендации обновлены!')),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Получить рекомендации'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleAnalysisSection(AIProvider aiProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.style,
                  color: Colors.indigo,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'AI Анализ стиля',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (aiProvider.userStyleProfile != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Основной стиль: ${aiProvider.userStyleProfile!['primary_style']}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Уверенность: ${(aiProvider.userStyleProfile!['style_confidence'] * 100).toInt()}%',
                    style: TextStyle(
                      color: Colors.indigo[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (aiProvider.styleRecommendations.isNotEmpty) ...[
              Text(
                'Рекомендации по стилю:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              ...aiProvider.styleRecommendations.map((rec) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rec['style_name'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            rec['description'] ?? '',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.indigo[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${(rec['confidence'] * 100).toInt()}%',
                        style: TextStyle(
                          color: Colors.indigo[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ] else ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  Icon(Icons.style, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text(
                    'Профиль стиля не создан',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Нажмите кнопку ниже, чтобы создать профиль стиля',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await aiProvider.analyzeUserStyle(userId: 'current_user');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Анализ стиля завершен!')),
                );
              },
              icon: const Icon(Icons.analytics),
              label: const Text('Анализировать стиль'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesAnalysisSection(AIProvider aiProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: Colors.teal,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'AI Анализ продаж',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final aiProvider = context.read<AIProvider>();
                    final trends = await aiProvider.analyzeSalesTrends(category: 'Общая категория');
                    if (trends != null) {
                      _showSalesTrendsDialog(context, trends);
                    }
                  },
                  icon: const Icon(Icons.trending_up),
                  label: const Text('Анализ трендов'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final aiProvider = context.read<AIProvider>();
                    final behavior = await aiProvider.analyzeCustomerBehavior(customerId: 'current_user');
                    if (behavior != null) {
                      _showCustomerBehaviorDialog(context, behavior);
                    }
                  },
                  icon: const Icon(Icons.people),
                  label: const Text('Поведение клиентов'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentGenerationSection(AIProvider aiProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'AI Генерация контента',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _productNameController,
            decoration: InputDecoration(
              labelText: 'Название товара',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'Введите название товара для генерации контента',
              prefixIcon: Icon(Icons.inventory, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _productCategoryController,
            decoration: InputDecoration(
              labelText: 'Категория',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'Введите категорию товара',
              prefixIcon: Icon(Icons.category, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_productNameController.text.isNotEmpty) {
                      final aiProvider = context.read<AIProvider>();
                      final description = await aiProvider.generateProductDescription(
                        productName: _productNameController.text,
                        category: _productCategoryController.text.isNotEmpty 
                            ? _productCategoryController.text 
                            : 'Общая категория',
                      );
                      if (description != null) {
                        setState(() {
                          _generatedDescriptionController.text = description;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Описание сгенерировано!')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Введите название товара')),
                      );
                    }
                  },
                  icon: const Icon(Icons.description),
                  label: const Text('Сгенерировать описание'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_productNameController.text.isNotEmpty) {
                      final aiProvider = context.read<AIProvider>();
                      final hashtags = await aiProvider.generateHashtags(
                        productName: _productNameController.text,
                        category: _productCategoryController.text.isNotEmpty 
                            ? _productCategoryController.text 
                            : 'Общая категория',
                      );
                      if (hashtags.isNotEmpty) {
                        setState(() {
                          _generatedHashtagsController.text = hashtags.join(' ');
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Хештеги сгенерированы!')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Введите название товара')),
                      );
                    }
                  },
                  icon: const Icon(Icons.tag),
                  label: const Text('Сгенерировать хештеги'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_generatedDescriptionController.text.isNotEmpty) ...[
            _buildGeneratedContentSection(
              'Сгенерированное описание:',
              _generatedDescriptionController,
              4,
              'Описание скопировано!',
              'Использовать для товара',
              () => Navigator.of(context).pushNamed('/products/add', arguments: {
                'description': _generatedDescriptionController.text,
              }),
            ),
            const SizedBox(height: 16),
          ],
          if (_generatedHashtagsController.text.isNotEmpty) ...[
            _buildGeneratedContentSection(
              'Сгенерированные хештеги:',
              _generatedHashtagsController,
              2,
              'Хештеги скопированы!',
              'Использовать для поста',
              () => Navigator.of(context).pushNamed('/social/create', arguments: {
                'hashtags': _generatedHashtagsController.text,
              }),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGeneratedContentSection(
    String title,
    TextEditingController controller,
    int maxLines,
    String copyMessage,
    String actionText,
    VoidCallback onAction,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: 'Сгенерированный контент появится здесь',
            filled: true,
            fillColor: Colors.grey[50],
          ),
          maxLines: maxLines,
          readOnly: false,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(copyMessage)),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('Копировать'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.check),
              label: Text(actionText),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Настройки AI'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Настройки AI помощника'),
            SizedBox(height: 16),
            Text('• Автоматические рекомендации'),
            Text('• Анализ стиля'),
            Text('• Генерация контента'),
            Text('• Анализ продаж'),
          ],
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

  void _showSalesTrendsDialog(BuildContext context, Map<String, dynamic> trends) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Анализ трендов продаж'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Популярные категории: ${trends['popular_categories']?.join(', ') ?? ''}'),
              const SizedBox(height: 8),
              Text('Тренд роста: ${trends['growth_trend'] ?? ''}'),
              const SizedBox(height: 8),
              Text('Рекомендации: ${trends['recommendations'] ?? ''}'),
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

  void _showCustomerBehaviorDialog(BuildContext context, Map<String, dynamic> behavior) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Анализ поведения клиентов'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Средний чек: ${behavior['average_order_value'] ?? ''}'),
              const SizedBox(height: 8),
              Text('Частота покупок: ${behavior['purchase_frequency'] ?? ''}'),
              const SizedBox(height: 8),
              Text('Предпочтения: ${behavior['preferences'] ?? ''}'),
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

  // Дополнительные диалоги для AIScreen
  void _showAIStatDetailsDialog(BuildContext context, String title, String value, IconData icon, Color color, String subtitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(title),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Текущее значение:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'AI Анализ:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildAIStatDetailItem('Точность AI', '95.2%', Icons.verified, Colors.green),
              _buildAIStatDetailItem('Обновление', 'Каждые 2 часа', Icons.update, Colors.blue),
              _buildAIStatDetailItem('Источник данных', 'Анализ поведения', Icons.data_usage, Colors.purple),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showAIDetailedAnalysis(context, title);
              },
              child: const Text('Подробнее'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAIStatDetailItem(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showAIDetailedAnalysis(BuildContext context, String category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Детальный AI анализ: $category'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                // AI Статистика
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'AI Статистика',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildAIAnalyticsCard('Точность', '95.2%', Icons.verified),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildAIAnalyticsCard('Скорость', '0.3с', Icons.speed),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildAIAnalyticsCard('Обучение', '24/7', Icons.school),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // График AI
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'AI График анализа\n(Здесь будет отображаться интерактивный AI график)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Экспорт AI данных
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('AI отчет в PDF!')),
                          );
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('PDF'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('AI отчет в Excel!')),
                          );
                        },
                        icon: const Icon(Icons.table_chart),
                        label: const Text('Excel'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAIAnalyticsCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showAIChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AI Чат'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'AI Чат\n(Здесь будет отображаться чат с AI помощником)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Введите сообщение',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Сообщение отправлено AI!')),
                        );
                      },
                      child: const Text('Отправить'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  void _showAITrainingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AI Обучение'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Текущий статус обучения:'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(Icons.school, color: Colors.green, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'AI активно обучается',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Последнее обновление: ${DateTime.now().toString().substring(0, 16)}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('AI обучение запущено!')),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Запустить'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('AI обучение остановлено!')),
                        );
                      },
                      icon: const Icon(Icons.stop),
                      label: const Text('Остановить'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }
}

// Web3 экран
class Web3Screen extends StatefulWidget {
  const Web3Screen({Key? key}) : super(key: key);

  @override
  State<Web3Screen> createState() => _Web3ScreenState();
}

class _Web3ScreenState extends State<Web3Screen> with TickerProviderStateMixin {
  // Анимации
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  // Состояние
  String _selectedTab = 'wallet';
  
  // Контроллеры
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nftNameController = TextEditingController();
  final TextEditingController _nftDescriptionController = TextEditingController();
  final TextEditingController _swapFromController = TextEditingController();
  final TextEditingController _swapToController = TextEditingController();
  final TextEditingController _swapAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Инициализация анимаций
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
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
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
    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
    _pulseController.repeat(reverse: true);
    _rotateController.repeat();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    _addressController.dispose();
    _amountController.dispose();
    _nftNameController.dispose();
    _nftDescriptionController.dispose();
    _swapFromController.dispose();
    _swapToController.dispose();
    _swapAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Web3Provider>(
      builder: (context, web3Provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(web3Provider),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildWeb3Content(web3Provider),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(Web3Provider web3Provider) {
    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'PoSPro Web3',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
                Theme.of(context).primaryColor.withOpacity(0.6),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Фоновая иконка блокчейна
              Positioned(
                right: 20,
                top: 20,
                child: RotationTransition(
                  turns: _rotateAnimation,
                  child: Icon(
                    Icons.account_balance_wallet,
                    size: 80,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
              // Центральная иконка с пульсацией
              Center(
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: Icon(
                    Icons.account_balance,
                    size: 60,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
              // Статус подключения
              Positioned(
                left: 20,
                bottom: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: web3Provider.isConnected 
                        ? Colors.green.withOpacity(0.9)
                        : Colors.red.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        web3Provider.isConnected ? Icons.check_circle : Icons.cancel,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        web3Provider.isConnected ? 'Подключено' : 'Отключено',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        // Кнопка выбора вкладки
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedTab = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'wallet', child: Text('Кошелек')),
              const PopupMenuItem(value: 'nfts', child: Text('NFTs')),
              const PopupMenuItem(value: 'tokens', child: Text('Токены')),
              const PopupMenuItem(value: 'transactions', child: Text('Транзакции')),
              const PopupMenuItem(value: 'blockchain', child: Text('Блокчейн')),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getTabIcon(_selectedTab),
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getTabTitle(_selectedTab),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getTabIcon(String tab) {
    switch (tab) {
      case 'wallet':
        return Icons.account_balance_wallet;
      case 'nfts':
        return Icons.image;
      case 'tokens':
        return Icons.token;
      case 'transactions':
        return Icons.receipt_long;
      case 'blockchain':
        return Icons.account_balance;
      default:
        return Icons.account_balance_wallet;
    }
  }

  String _getTabTitle(String tab) {
    switch (tab) {
      case 'wallet':
        return 'Кошелек';
      case 'nfts':
        return 'NFTs';
      case 'tokens':
        return 'Токены';
      case 'transactions':
        return 'Транзакции';
      case 'blockchain':
        return 'Блокчейн';
      default:
        return 'Кошелек';
    }
  }

  Widget _buildWeb3Content(Web3Provider web3Provider) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: _buildTabContent(web3Provider),
      ),
    );
  }

  Widget _buildTabContent(Web3Provider web3Provider) {
    switch (_selectedTab) {
      case 'wallet':
        return _buildWalletTab(web3Provider);
      case 'nfts':
        return _buildNFTsTab(web3Provider);
      case 'tokens':
        return _buildTokensTab(web3Provider);
      case 'transactions':
        return _buildTransactionsTab(web3Provider);
      case 'blockchain':
        return _buildBlockchainTab(web3Provider);
      default:
        return _buildWalletTab(web3Provider);
    }
  }

  Widget _buildWalletTab(Web3Provider web3Provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок вкладки
        _buildTabHeader(
          'Кошелек',
          Icons.account_balance_wallet,
          Colors.blue,
          'Управление вашим Web3 кошельком',
        ),
        const SizedBox(height: 24),
        
        // Статус подключения
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: web3Provider.isConnected 
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      web3Provider.isConnected ? Icons.check_circle : Icons.cancel,
                      color: web3Provider.isConnected ? Colors.green : Colors.red,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          web3Provider.isConnected ? 'Кошелек подключен' : 'Кошелек отключен',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          web3Provider.isConnected 
                              ? 'Вы можете отправлять и получать криптовалюту'
                              : 'Подключитесь к кошельку для начала работы',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              if (web3Provider.isConnected) ...[
                const SizedBox(height: 24),
                _buildWalletInfoCard(web3Provider),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showSendTransactionDialog(context, web3Provider);
                        },
                        icon: const Icon(Icons.send),
                        label: const Text('Отправить ETH'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showReceiveDialog(context, web3Provider);
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Получить'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (web3Provider.isConnected) {
                      await web3Provider.disconnectWallet();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Кошелек отключен')),
                      );
                    } else {
                      final success = await web3Provider.connectWallet();
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Кошелек подключен!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ошибка подключения кошелька')),
                        );
                      }
                    }
                  },
                  icon: Icon(
                    web3Provider.isConnected ? Icons.logout : Icons.login,
                  ),
                  label: Text(
                    web3Provider.isConnected ? 'Отключиться' : 'Подключиться',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: web3Provider.isConnected ? Colors.red : Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabHeader(String title, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletInfoCard(Web3Provider web3Provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildInfoRow('Адрес кошелька', web3Provider.currentAddress ?? 'Не подключен', Icons.account_balance_wallet),
          const SizedBox(height: 16),
          _buildInfoRow('Сеть', web3Provider.currentNetwork ?? 'Не подключен', Icons.network_check),
          const SizedBox(height: 16),
          _buildInfoRow('Баланс ETH', '${web3Provider.ethBalance} ETH', Icons.currency_bitcoin),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue[600], size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNFTsTab(Web3Provider web3Provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок вкладки
        _buildTabHeader(
          'NFTs',
          Icons.image,
          Colors.purple,
          'Управление вашими NFT токенами',
        ),
        const SizedBox(height: 24),
        
        // Основной контент
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Мои NFTs',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showMintNFTDialog(context, web3Provider);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Создать NFT'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              if (web3Provider.userNFTs.isNotEmpty) ...[
                ...web3Provider.userNFTs.map((nft) => _buildNFTCard(nft)),
                const SizedBox(height: 16),
              ] else ...[
                _buildEmptyNFTState(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNFTCard(Map<String, dynamic> nft) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Изображение NFT
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: nft['image_url'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      nft['image_url'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.image, color: Colors.grey[600], size: 30);
                      },
                    ),
                  )
                : Icon(Icons.image, color: Colors.grey[600], size: 30),
          ),
          
          const SizedBox(width: 16),
          
          // Информация о NFT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nft['name'] ?? 'Без названия',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  nft['description'] ?? 'Без описания',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Правая часть с ценой и статусом
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${nft['value']} ETH',
                  style: TextStyle(
                    color: Colors.purple[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (nft['status'] == 'Активен' ? Colors.green : Colors.orange).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (nft['status'] == 'Активен' ? Colors.green : Colors.orange).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  nft['status'] ?? 'Неизвестно',
                  style: TextStyle(
                    color: nft['status'] == 'Активен' ? Colors.green[700] : Colors.orange[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyNFTState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.image_not_supported,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'NFT не найдены',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Создайте свой первый NFT или подключите существующий кошелек',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTokensTab(Web3Provider web3Provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Мои токены',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _showSwapTokensDialog(context, web3Provider);
                        },
                        child: const Text('Обмен'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (web3Provider.userTokens.isNotEmpty)
                    ...web3Provider.userTokens.map((token) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: Text(
                          token['symbol']?[0] ?? 'T',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text('${token['name']} (${token['symbol']})'),
                      subtitle: Text('Баланс: ${token['balance']}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('\$${token['total_value_usd']}'),
                          Text(
                            '${token['price_change_24h'] ?? 0}%',
                            style: TextStyle(
                              color: (token['price_change_24h'] ?? 0) >= 0 
                                  ? Colors.green 
                                  : Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        _showTokenDetailsDialog(context, token);
                      },
                    ))
                  else
                    const Text('Токены не найдены'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab(Web3Provider web3Provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'История транзакций',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  if (web3Provider.userTransactions.isNotEmpty)
                    ...web3Provider.userTransactions.take(5).map((tx) => ListTile(
                      leading: Icon(
                        tx['type'] == 'send' ? Icons.arrow_upward : Icons.arrow_downward,
                        color: tx['type'] == 'send' ? Colors.red : Colors.green,
                      ),
                      title: Text('${tx['amount']} ETH'),
                      subtitle: Text('${tx['from']} → ${tx['to']}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            tx['status'] ?? 'В обработке',
                            style: TextStyle(
                              color: tx['status'] == 'Подтверждено' 
                                  ? Colors.green 
                                  : Colors.orange,
                            ),
                          ),
                          Text(
                            tx['date'] ?? '',
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                      onTap: () {
                        _showTransactionDetailsDialog(context, tx);
                      },
                    ))
                  else
                    const Text('Транзакции не найдены'),
                  if (web3Provider.userTransactions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _showAllTransactionsDialog(context, web3Provider);
                          },
                          child: const Text('Показать все транзакции'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSendTransactionDialog(BuildContext context, Web3Provider web3Provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отправить ETH'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Адрес получателя',
                hintText: '0x...',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Количество ETH',
                hintText: '0.0',
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
              final amount = double.tryParse(_amountController.text);
              if (amount != null && amount > 0) {
                final transactionHash = await web3Provider.sendTransaction(
                  toAddress: _addressController.text,
                  value: amount,
                );
                Navigator.of(context).pop();
                if (transactionHash != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Транзакция отправлена: $transactionHash')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ошибка отправки транзакции')),
                  );
                }
              }
            },
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }

  void _showReceiveDialog(BuildContext context, Web3Provider web3Provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Получить ETH'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ваш адрес для получения:'),
            const SizedBox(height: 8),
            SelectableText(
              web3Provider.currentAddress ?? 'Не подключен',
              style: TextStyle(
                fontFamily: 'monospace',
                backgroundColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16),
            Text('Поделитесь этим адресом для получения ETH'),
          ],
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

  void _showMintNFTDialog(BuildContext context, Web3Provider web3Provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать NFT'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nftNameController,
              decoration: const InputDecoration(
                labelText: 'Название NFT',
                hintText: 'Мой уникальный токен',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nftDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание',
                hintText: 'Описание вашего NFT',
              ),
              maxLines: 3,
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
              if (_nftNameController.text.isNotEmpty) {
                final nftId = await web3Provider.mintNFT(
                  name: _nftNameController.text,
                  description: _nftDescriptionController.text,
                  imageUrl: 'https://via.placeholder.com/150',
                );
                Navigator.of(context).pop();
                if (nftId != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('NFT успешно создан!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ошибка создания NFT')),
                  );
                }
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _showSwapTokensDialog(BuildContext context, Web3Provider web3Provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Обмен токенов'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _swapFromController,
              decoration: const InputDecoration(
                labelText: 'От токена',
                hintText: 'ETH',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _swapToController,
              decoration: const InputDecoration(
                labelText: 'К токену',
                hintText: 'USDT',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _swapAmountController,
              decoration: const InputDecoration(
                labelText: 'Количество',
                hintText: '0.0',
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
              final amount = double.tryParse(_swapAmountController.text);
              if (amount != null && amount > 0) {
                final success = await web3Provider.swapTokens(
                  fromToken: _swapFromController.text,
                  toToken: _swapToController.text,
                  amount: amount,
                );
                Navigator.of(context).pop();
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Обмен выполнен успешно!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ошибка обмена токенов')),
                  );
                }
              }
            },
            child: const Text('Обменять'),
          ),
        ],
      ),
    );
  }

  void _showNFTDetailsDialog(BuildContext context, Map<String, dynamic> nft) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Детали NFT: ${nft['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Описание: ${nft['description']}'),
            Text('Значение: ${nft['value']} ETH'),
            Text('Статус: ${nft['status']}'),
            Text('Дата создания: ${nft['created_at']}'),
            if (nft['image_url'] != null) ...[
              const SizedBox(height: 16),
              Image.network(
                nft['image_url'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ],
          ],
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

  void _showTokenDetailsDialog(BuildContext context, Map<String, dynamic> token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Детали токена: ${token['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Символ: ${token['symbol']}'),
            Text('Баланс: ${token['balance']}'),
            Text('Общая стоимость: \$${token['total_value_usd']}'),
            Text('Изменение за 24ч: ${token['price_change_24h']}%'),
            Text('Контракт: ${token['contract_address']?.substring(0, 8)}...'),
          ],
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

  void _showTransactionDetailsDialog(BuildContext context, Map<String, dynamic> tx) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Детали транзакции'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Тип: ${tx['type']}'),
            Text('Количество: ${tx['amount']} ETH'),
            Text('От: ${tx['from']}'),
            Text('К: ${tx['to']}'),
            Text('Статус: ${tx['status']}'),
            Text('Дата: ${tx['date']}'),
            if (tx['hash'] != null) ...[
              const SizedBox(height: 8),
              Text('Хеш: ${tx['hash']}'),
            ],
          ],
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

  void _showAllTransactionsDialog(BuildContext context, Web3Provider web3Provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Все транзакции'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: web3Provider.userTransactions.length,
            itemBuilder: (context, index) {
              final tx = web3Provider.userTransactions[index];
              return ListTile(
                leading: Icon(
                  tx['type'] == 'send' ? Icons.arrow_upward : Icons.arrow_downward,
                  color: tx['type'] == 'send' ? Colors.red : Colors.green,
                ),
                title: Text('${tx['amount']} ETH'),
                subtitle: Text('${tx['from']} → ${tx['to']}'),
                trailing: Text(
                  tx['status'] ?? 'В обработке',
                  style: TextStyle(
                    color: tx['status'] == 'Подтверждено' ? Colors.green : Colors.orange,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _showTransactionDetailsDialog(context, tx);
                },
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

  Widget _buildBlockchainTab(Web3Provider web3Provider) {
    return Consumer<BlockchainProvider>(
      builder: (context, blockchainProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Статус блокчейна
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Статус блокчейна',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildBlockchainMetricCard(
                              'Последний блок',
                              '${blockchainProvider.blockchainData['last_block_number'] ?? 0}',
                              Icons.block,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildBlockchainMetricCard(
                              'Хешрейт',
                              '${(blockchainProvider.blockchainData['hashrate'] ?? 0.0 / 1000000).toStringAsFixed(2)} TH/s',
                              Icons.speed,
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildBlockchainMetricCard(
                              'Сложность',
                              '${(blockchainProvider.blockchainData['difficulty'] ?? 0.0 / 1000000000000).toStringAsFixed(2)} T',
                              Icons.trending_up,
                              Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildBlockchainMetricCard(
                              'Время блока',
                              '${blockchainProvider.blockchainData['block_time'] ?? 0} сек',
                              Icons.timer,
                              Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // DeFi протоколы
              Text(
                'DeFi Протоколы',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ...blockchainProvider.defiProtocols.map((protocol) => _buildProtocolCard(protocol)),
              const SizedBox(height: 24),

              // Ликвидность
              Text(
                'Пуллы ликвидности',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ...blockchainProvider.liquidityPools.map((pool) => _buildLiquidityPoolCard(pool)),
              const SizedBox(height: 24),

              // Yield Farming
              Text(
                'Yield Farming',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ...blockchainProvider.yieldFarming.map((farm) => _buildYieldFarmCard(farm)),
              const SizedBox(height: 24),

              // Смарт контракты
              Text(
                'Смарт контракты',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ...blockchainProvider.smartContracts.map((contract) => _buildSmartContractCard(contract)),
              const SizedBox(height: 24),

              // Рыночные тренды
              Text(
                'Рыночные тренды',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ...blockchainProvider.marketTrends.map((trend) => _buildMarketTrendCard(trend)),
              const SizedBox(height: 24),

              // Рекомендации DeFi
              Text(
                'DeFi Рекомендации',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ...blockchainProvider.getDeFiRecommendations().map((rec) => _buildDeFiRecommendationCard(rec)),
            ],
          ),
        );
      },
    );
  }

  // Вспомогательные виджеты для блокчейн вкладки
  Widget _buildBlockchainMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolCard(Map<String, dynamic> protocol) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            protocol['name']?.substring(0, 1).toUpperCase() ?? 'D',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(protocol['name'] ?? ''),
        subtitle: Text('TVL: \$${(protocol['total_value_locked'] ?? 0.0 / 1000000).toStringAsFixed(1)}M'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${(protocol['apy'] * 100).toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              'APY',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiquidityPoolCard(Map<String, dynamic> pool) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.water_drop, color: Colors.white),
        ),
        title: Text('${pool['token0']} / ${pool['token1']}'),
        subtitle: Text('Ликвидность: \$${(pool['liquidity'] ?? 0.0 / 1000000).toStringAsFixed(1)}M'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${(pool['fee'] * 100).toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              'Комиссия',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYieldFarmCard(Map<String, dynamic> farm) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange,
          child: Icon(Icons.agriculture, color: Colors.white),
        ),
        title: Text(farm['name'] ?? ''),
        subtitle: Text('Стекинг: ${farm['staked_amount']} ${farm['token_symbol']}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${(farm['reward_rate'] * 100).toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            Text(
              'Награда/день',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartContractCard(Map<String, dynamic> contract) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple,
          child: Icon(Icons.code, color: Colors.white),
        ),
        title: Text(contract['name'] ?? ''),
        subtitle: Text('Адрес: ${contract['address']?.substring(0, 8)}...'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              contract['status'] ?? '',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: contract['status'] == 'active' ? Colors.green : Colors.red,
              ),
            ),
            Text(
              '${contract['interactions']} вызовов',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketTrendCard(Map<String, dynamic> trend) {
    Color trendColor = Colors.green;
    if (trend['direction'] == 'down') trendColor = Colors.red;
    if (trend['direction'] == 'sideways') trendColor = Colors.blue;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: trendColor,
          child: Icon(_getTrendIcon(trend['direction']), color: Colors.white),
        ),
        title: Text(trend['asset'] ?? ''),
        subtitle: Text('${trend['timeframe']} тренд'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${trend['change_percentage']?.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: trendColor,
              ),
            ),
            Text(
              'Изменение',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeFiRecommendationCard(Map<String, dynamic> rec) {
    Color scoreColor = Colors.green;
    if (rec['score'] < 0.6) scoreColor = Colors.orange;
    if (rec['score'] < 0.4) scoreColor = Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: scoreColor,
          child: Icon(Icons.lightbulb, color: Colors.white),
        ),
        title: Text(rec['strategy'] ?? ''),
        subtitle: Text('Риск: ${rec['risk_level']}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${(rec['score'] * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: scoreColor,
              ),
            ),
            Text(
              'Счет',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        onTap: () => _showDeFiRecommendationDetails(rec),
      ),
    );
  }

  IconData _getTrendIcon(String? direction) {
    switch (direction) {
      case 'up':
        return Icons.trending_up;
      case 'down':
        return Icons.trending_down;
      case 'sideways':
        return Icons.trending_flat;
      default:
        return Icons.trending_flat;
    }
  }

  void _showDeFiRecommendationDetails(Map<String, dynamic> rec) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Детали рекомендации'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Стратегия: ${rec['strategy']}'),
            const SizedBox(height: 8),
            Text('Описание: ${rec['description']}'),
            Text('Риск: ${rec['risk_level']}'),
            Text('Ожидаемая доходность: ${(rec['expected_return'] * 100).toStringAsFixed(2)}%'),
            const SizedBox(height: 8),
            Text('Требования:'),
            ...(rec['requirements'] as List?)?.map((req) => Text('• $req')) ?? [],
            const SizedBox(height: 8),
            Text('Шаги:'),
            ...(rec['steps'] as List?)?.map((step) => Text('• $step')) ?? [],
          ],
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

  // Дополнительные диалоги для Web3Screen
  void _showWalletConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подключение кошелька'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Выберите способ подключения:'),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.phone_android, color: Colors.blue),
                title: const Text('MetaMask'),
                subtitle: const Text('Популярный Web3 кошелек'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Подключение к MetaMask...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.qr_code, color: Colors.green),
                title: const Text('WalletConnect'),
                subtitle: const Text('QR-код для мобильных кошельков'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Откройте WalletConnect...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet, color: Colors.purple),
                title: const Text('Coinbase Wallet'),
                subtitle: const Text('Кошелек от Coinbase'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Подключение к Coinbase Wallet...')),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
          ],
        );
      },
    );
  }












}

// Социальный экран
class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> with TickerProviderStateMixin {
  // Анимации
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;

  // Состояние
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    
    // Инициализация анимаций
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
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.bounceOut),
    );

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
    _pulseController.repeat(reverse: true);
    _bounceController.forward();
  }



  @override
  void dispose() {
    _postController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Consumer<SocialProvider>(
        builder: (context, socialProvider, child) {
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(socialProvider),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildSocialContent(socialProvider),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(SocialProvider socialProvider) {
    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Социальная сеть',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
                Theme.of(context).primaryColor.withOpacity(0.6),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Фоновая иконка социальной сети
              Positioned(
                right: 20,
                top: 20,
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: Icon(
                    Icons.people,
                    size: 80,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
              // Центральная иконка с пульсацией
              Center(
                child: ScaleTransition(
                  scale: _bounceAnimation,
                  child: Icon(
                    Icons.chat_bubble,
                    size: 60,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
              // Статистика постов
              Positioned(
                left: 20,
                bottom: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.post_add,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${socialProvider.posts.length} постов',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        // Кнопка создания поста
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () {
              _showCreatePostDialog(context);
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
        // Кнопка фильтров
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('Все посты')),
              const PopupMenuItem(value: 'my', child: Text('Мои посты')),
              const PopupMenuItem(value: 'liked', child: Text('Понравившиеся')),
              const PopupMenuItem(value: 'trending', child: Text('Популярные')),
            ],
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: const Icon(
                Icons.filter_list,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialContent(SocialProvider socialProvider) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          children: [
            // Создание поста
            _buildCreatePostSection(socialProvider),
            const SizedBox(height: 24),
            
            // Фильтры
            _buildFiltersSection(),
            const SizedBox(height: 24),
            
            // Лента постов
            _buildPostsSection(socialProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatePostSection(SocialProvider socialProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.edit,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Создать пост',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _postController,
            decoration: InputDecoration(
              hintText: 'Что у вас нового?',
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.image, color: Colors.grey[600], size: 20),
                ),
                onPressed: () {
                  _showImagePickerDialog(context);
                },
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.tag, color: Colors.grey[600], size: 20),
                ),
                onPressed: () {
                  _showHashtagDialog(context);
                },
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.location_on, color: Colors.grey[600], size: 20),
                ),
                onPressed: () {
                  _showLocationDialog(context);
                },
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_postController.text.isNotEmpty) {
                    final success = await socialProvider.createPost(
                      content: _postController.text,
                    );
                    if (success) {
                      _postController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Пост опубликован!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ошибка при публикации поста')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Введите текст поста')),
                    );
                  }
                },
                icon: const Icon(Icons.send),
                label: const Text('Опубликовать'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Фильтры',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildFilterChip('Все', 'all', Icons.all_inclusive),
              _buildFilterChip('Мои', 'my', Icons.person),
              _buildFilterChip('Понравившиеся', 'liked', Icons.favorite),
              _buildFilterChip('Популярные', 'trending', Icons.trending_up),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, IconData icon) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      backgroundColor: Colors.grey[100],
      selectedColor: Colors.blue,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildPostsSection(SocialProvider socialProvider) {
    final posts = _getFilteredPosts(socialProvider);
    
    if (posts.isEmpty) {
      return _buildEmptyPostsState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Лента постов',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        ...posts.map((post) => _buildPostCard(post, socialProvider)),
      ],
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post, SocialProvider socialProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок поста
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: post['avatar'] != null
                      ? NetworkImage(post['avatar'])
                      : null,
                  backgroundColor: Colors.grey[200],
                  child: post['avatar'] == null
                      ? Text(
                          post['username']?[0]?.toUpperCase() ?? 'U',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['username'] ?? 'Пользователь',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        post['created_at'] ?? 'Недавно',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    _handlePostAction(context, value, post, socialProvider);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Редактировать')),
                    const PopupMenuItem(value: 'delete', child: Text('Удалить')),
                    const PopupMenuItem(value: 'report', child: Text('Пожаловаться')),
                  ],
                  child: Icon(Icons.more_vert, color: Colors.grey[600]),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Содержимое поста
            Text(
              post['content'] ?? '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                height: 1.4,
              ),
            ),
            
            // Хештеги
            if (post['hashtags'] != null && post['hashtags'].isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (post['hashtags'] as List).map((tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    '#$tag',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
            ],
            
            // Изображение
            if (post['image_url'] != null) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  post['image_url'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
            ],
            
            // Местоположение
            if (post['location'] != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    post['location'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 20),
            
            // Действия с постом
            Row(
              children: [
                _buildActionButton(
                  icon: post['is_liked'] == true ? Icons.favorite : Icons.favorite_border,
                  label: '${post['likes_count'] ?? 0}',
                  color: post['is_liked'] == true ? Colors.red : Colors.grey[600]!,
                  onPressed: () {
                    socialProvider.likePost(post['id']);
                  },
                ),
                const SizedBox(width: 24),
                                 _buildActionButton(
                   icon: Icons.comment,
                   label: '${post['comments_count'] ?? 0}',
                   color: Colors.grey[600]!,
                   onPressed: () {
                     _showCommentsDialog(context, post, socialProvider);
                   },
                 ),
                const SizedBox(width: 24),
                                 _buildActionButton(
                   icon: Icons.share,
                   label: '${post['shares_count'] ?? 0}',
                   color: Colors.grey[600]!,
                   onPressed: () {
                     socialProvider.sharePost(post['id']);
                   },
                 ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPostsState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Icon(
            Icons.post_add,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Посты не найдены',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Создайте первый пост или измените фильтры',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredPosts(SocialProvider socialProvider) {
    switch (_selectedFilter) {
      case 'my':
        return socialProvider.posts.where((post) => post['is_my_post'] == true).toList();
      case 'liked':
        return socialProvider.posts.where((post) => post['is_liked'] == true).toList();
      case 'trending':
        return List.from(socialProvider.posts)
          ..sort((a, b) => (b['likes_count'] ?? 0).compareTo(a['likes_count'] ?? 0));
      default:
        return socialProvider.posts;
    }
  }

  void _handlePostAction(BuildContext context, String action, Map<String, dynamic> post, SocialProvider socialProvider) {
    switch (action) {
      case 'edit':
        _showEditPostDialog(context, post, socialProvider);
        break;
      case 'delete':
        _showDeletePostDialog(context, post, socialProvider);
        break;
      case 'report':
        _showReportPostDialog(context, post);
        break;
    }
  }

  void _showCreatePostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать пост'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _postController,
              decoration: const InputDecoration(
                labelText: 'Текст поста',
                hintText: 'Что у вас нового?',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
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
              if (_postController.text.isNotEmpty) {
                final socialProvider = context.read<SocialProvider>();
                final success = await socialProvider.createPost(
                  content: _postController.text,
                );
                Navigator.of(context).pop();
                if (success) {
                  _postController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Пост опубликован!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ошибка при публикации поста')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Введите текст поста')),
                );
              }
            },
            child: const Text('Опубликовать'),
          ),
        ],
      ),
    );
  }

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить изображение'),
        content: const Text('Функция добавления изображений будет доступна в следующем обновлении.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showHashtagDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить хештеги'),
        content: const Text('Функция добавления хештегов будет доступна в следующем обновлении.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить местоположение'),
        content: const Text('Функция добавления местоположения будет доступна в следующем обновлении.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showCommentsDialog(BuildContext context, Map<String, dynamic> post, SocialProvider socialProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Комментарии'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: post['comments']?.length ?? 0,
                  itemBuilder: (context, index) {
                    final comment = post['comments'][index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: comment['avatar'] != null
                            ? NetworkImage(comment['avatar'])
                            : null,
                        child: comment['avatar'] == null
                            ? Text(comment['username']?[0] ?? '')
                            : null,
                      ),
                      title: Text(comment['username'] ?? ''),
                      subtitle: Text(comment['content'] ?? ''),
                      trailing: Text(
                        comment['created_at'] ?? '',
                        style: TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Добавить комментарий...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        // Добавление комментария
                        _commentController.clear();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Комментарий добавлен!')),
                        );
                      }
                    },
                    child: const Text('Отправить'),
                  ),
                ],
              ),
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

  void _showEditPostDialog(BuildContext context, Map<String, dynamic> post, SocialProvider socialProvider) {
    final contentController = TextEditingController(text: post['content'] ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Редактировать пост'),
        content: TextField(
          controller: contentController,
          decoration: const InputDecoration(
            labelText: 'Текст поста',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (contentController.text.isNotEmpty) {
                final success = await socialProvider.updatePost(
                  postId: post['id'],
                  content: contentController.text,
                );
                if (success) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Пост обновлен!')),
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

  void _showDeletePostDialog(BuildContext context, Map<String, dynamic> post, SocialProvider socialProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить пост'),
        content: const Text('Вы уверены, что хотите удалить этот пост?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await socialProvider.deletePost(post['id']);
              if (success) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Пост удален!')),
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

  void _showReportPostDialog(BuildContext context, Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Пожаловаться на пост'),
        content: const Text('Функция жалоб будет доступна в следующем обновлении.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  // Дополнительные диалоги для SocialScreen
  void _showUserProfileDialog(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Профиль ${user['username'] ?? 'пользователя'}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: user['avatar'] != null
                    ? NetworkImage(user['avatar'])
                    : null,
                backgroundColor: Colors.grey[200],
                child: user['avatar'] == null
                    ? Text(
                        user['username']?[0]?.toUpperCase() ?? 'U',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                user['username'] ?? 'Пользователь',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              if (user['bio'] != null) ...[
                const SizedBox(height: 8),
                Text(
                  user['bio'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        '${user['posts_count'] ?? 0}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Постов',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '${user['followers_count'] ?? 0}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Подписчиков',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '${user['following_count'] ?? 0}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Подписок',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Сообщение отправлено!')),
                );
              },
              child: const Text('Написать'),
            ),
          ],
        );
      },
    );
  }

  void _showSharePostDialog(BuildContext context, Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Поделиться постом'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.blue),
                title: const Text('Копировать ссылку'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ссылка скопирована!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.green),
                title: const Text('Поделиться в соцсетях'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Открывается приложение...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.message, color: Colors.orange),
                title: const Text('Отправить в сообщении'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Открывается чат...')),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  void _showPostAnalyticsDialog(BuildContext context, Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Аналитика поста'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _buildAnalyticsRow('Просмотры', '${post['views_count'] ?? 0}', Icons.visibility),
                      _buildAnalyticsRow('Лайки', '${post['likes_count'] ?? 0}', Icons.favorite),
                      _buildAnalyticsRow('Комментарии', '${post['comments_count'] ?? 0}', Icons.comment),
                      _buildAnalyticsRow('Репосты', '${post['shares_count'] ?? 0}', Icons.share),
                      _buildAnalyticsRow('Досягаемость', '${post['reach_count'] ?? 0}', Icons.people),
                      _buildAnalyticsRow('Вовлеченность', '${(post['engagement_rate'] ?? 0.0).toStringAsFixed(1)}%', Icons.trending_up),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Экспорт аналитики!')),
                );
              },
              child: const Text('Экспорт'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnalyticsRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showTrendingTopicsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Трендовые темы'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: Text(
                            '#${index + 1}',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text('Трендовая тема ${index + 1}'),
                        subtitle: Text('${1000 - index * 50} постов'),
                        trailing: Icon(
                          index < 3 ? Icons.trending_up : Icons.trending_flat,
                          color: index < 3 ? Colors.green : Colors.grey,
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Поиск по теме ${index + 1}')),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  void _showSocialSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Настройки социальной сети'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Уведомления о лайках'),
                subtitle: const Text('Получать уведомления когда кто-то лайкает ваши посты'),
                value: true,
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Уведомления ${value ? 'включены' : 'отключены'}')),
                  );
                },
              ),
              SwitchListTile(
                title: const Text('Уведомления о комментариях'),
                subtitle: const Text('Получать уведомления о новых комментариях'),
                value: true,
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Уведомления ${value ? 'включены' : 'отключены'}')),
                  );
                },
              ),
              SwitchListTile(
                title: const Text('Приватность профиля'),
                subtitle: const Text('Сделать профиль приватным'),
                value: false,
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Профиль ${value ? 'приватный' : 'публичный'}')),
                  );
                },
              ),
            ],
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
                  const SnackBar(content: Text('Настройки сохранены!')),
                );
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  // Дополнительные диалоги для SocialScreen
  void _showUserProfileDialog(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Профиль ${user['username'] ?? 'пользователя'}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: user['avatar'] != null
                    ? NetworkImage(user['avatar'])
                    : null,
                backgroundColor: Colors.grey[200],
                child: user['avatar'] == null
                    ? Text(
                        user['username']?[0]?.toUpperCase() ?? 'U',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                user['username'] ?? 'Пользователь',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              if (user['bio'] != null) ...[
                const SizedBox(height: 8),
                Text(
                  user['bio'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        '${user['posts_count'] ?? 0}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Постов',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '${user['followers_count'] ?? 0}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Подписчиков',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '${user['following_count'] ?? 0}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Подписок',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Сообщение отправлено!')),
                );
              },
              child: const Text('Написать'),
            ),
          ],
        );
      },
    );
  }

  void _showSharePostDialog(BuildContext context, Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Поделиться постом'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.blue),
                title: const Text('Копировать ссылку'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ссылка скопирована!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.green),
                title: const Text('Поделиться в соцсетях'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Открывается приложение...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.message, color: Colors.orange),
                title: const Text('Отправить в сообщении'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Открывается чат...')),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  void _showPostAnalyticsDialog(BuildContext context, Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Аналитика поста'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _buildAnalyticsRow('Просмотры', '${post['views_count'] ?? 0}', Icons.visibility),
                      _buildAnalyticsRow('Лайки', '${post['likes_count'] ?? 0}', Icons.favorite),
                      _buildAnalyticsRow('Комментарии', '${post['comments_count'] ?? 0}', Icons.comment),
                      _buildAnalyticsRow('Репосты', '${post['shares_count'] ?? 0}', Icons.share),
                      _buildAnalyticsRow('Досягаемость', '${post['reach_count'] ?? 0}', Icons.people),
                      _buildAnalyticsRow('Вовлеченность', '${(post['engagement_rate'] ?? 0.0).toStringAsFixed(1)}%', Icons.trending_up),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Экспорт аналитики!')),
                );
              },
              child: const Text('Экспорт'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnalyticsRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showTrendingTopicsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Трендовые темы'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: Text(
                            '#${index + 1}',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text('Трендовая тема ${index + 1}'),
                        subtitle: Text('${1000 - index * 50} постов'),
                        trailing: Icon(
                          index < 3 ? Icons.trending_up : Icons.trending_flat,
                          color: index < 3 ? Colors.green : Colors.grey,
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Поиск по теме ${index + 1}')),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  }
