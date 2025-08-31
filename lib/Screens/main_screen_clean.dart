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
    
    // РРЅРёС†РёР°Р»РёР·РёСЂСѓРµРј РїСЂРёР»РѕР¶РµРЅРёРµ
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
        // РџРѕРєР°Р·С‹РІР°РµРј РёРЅРґРёРєР°С‚РѕСЂ Р·Р°РіСЂСѓР·РєРё, РµСЃР»Рё РїСЂРёР»РѕР¶РµРЅРёРµ РёРЅРёС†РёР°Р»РёР·РёСЂСѓРµС‚СЃСЏ
        if (appProvider.isAnythingLoading && !appProvider.isInitialized) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'РРЅРёС†РёР°Р»РёР·Р°С†РёСЏ PoSPro...',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          );
        }

        // РџРѕРєР°Р·С‹РІР°РµРј РѕС€РёР±РєРё, РµСЃР»Рё РѕРЅРё РµСЃС‚СЊ
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
                      'РџСЂРѕРёР·РѕС€Р»Р° РѕС€РёР±РєР°',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'РџРѕРїСЂРѕР±СѓР№С‚Рµ РїРµСЂРµР·Р°РїСѓСЃС‚РёС‚СЊ РїСЂРёР»РѕР¶РµРЅРёРµ',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        appProvider.clearAllErrors();
                        appProvider.initialize();
                      },
                      child: const Text('РџРѕРІС‚РѕСЂРёС‚СЊ'),
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
              // ProfileScreen(), // Временно закомментировано
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
                label: 'Р“Р»Р°РІРЅР°СЏ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory),
                label: 'РўРѕРІР°СЂС‹',
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
                label: 'РЎРѕС†СЃРµС‚Рё',
              ),

            ],
          ),
        );
      },
    );
  }
}

// Р”Р°С€Р±РѕСЂРґ СЌРєСЂР°РЅ
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  String _selectedPeriod = 'week';
  String _selectedMetric = 'sales';
  
  // РђРЅРёРјР°С†РёРё
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
    
    // РРЅРёС†РёР°Р»РёР·Р°С†РёСЏ Р°РЅРёРјР°С†РёР№
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
          'PoSPro Р”Р°С€Р±РѕСЂРґ',
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
            const PopupMenuItem(value: 'day', child: Text('Р”РµРЅСЊ')),
            const PopupMenuItem(value: 'week', child: Text('РќРµРґРµР»СЏ')),
            const PopupMenuItem(value: 'month', child: Text('РњРµСЃСЏС†')),
            const PopupMenuItem(value: 'year', child: Text('Р“РѕРґ')),
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
                        'Р”РѕР±СЂРѕ РїРѕР¶Р°Р»РѕРІР°С‚СЊ РІ PoSPro!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Р’Р°С€Р° СЃРёСЃС‚РµРјР° СѓРїСЂР°РІР»РµРЅРёСЏ С‚РѕСЂРіРѕРІР»РµР№ СЃ AI Рё Р±Р»РѕРєС‡РµР№РЅ РІРѕР·РјРѕР¶РЅРѕСЃС‚СЏРјРё',
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
                  'РџРѕСЃР»РµРґРЅРµРµ РѕР±РЅРѕРІР»РµРЅРёРµ: ${DateTime.now().toString().substring(0, 16)}',
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
                    'РћРЅР»Р°Р№РЅ',
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
          'РћР±С‰Р°СЏ СЃС‚Р°С‚РёСЃС‚РёРєР°',
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
              'РўРѕРІР°СЂС‹',
              '${stats['products']?['total_products'] ?? 0}',
              Icons.inventory,
              Colors.blue,
              _getTrendIcon(stats['products']?['trend'] ?? 'stable'),
              _getTrendColor(stats['products']?['trend'] ?? 'stable'),
            ),
            _buildStatCard(
              context,
              'РљР°С‚РµРіРѕСЂРёРё',
              '${stats['products']?['total_categories'] ?? 0}',
              Icons.category,
              Colors.green,
              _getTrendIcon(stats['products']?['categories_trend'] ?? 'stable'),
              _getTrendColor(stats['products']?['categories_trend'] ?? 'stable'),
            ),
            _buildStatCard(
              context,
              'AI С„СѓРЅРєС†РёРё',
              '${stats['ai']?['personal_recommendations_count'] ?? 0}',
              Icons.psychology,
              Colors.purple,
              _getTrendIcon(stats['ai']?['trend'] ?? 'stable'),
              _getTrendColor(stats['ai']?['trend'] ?? 'stable'),
            ),
            _buildStatCard(
              context,
              'Web3',
              stats['web3']?['is_connected'] == true ? 'РџРѕРґРєР»СЋС‡РµРЅРѕ' : 'РћС‚РєР»СЋС‡РµРЅРѕ',
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
                'РђРЅР°Р»РёС‚РёРєР° РїСЂРѕРґР°Р¶',
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
                  const PopupMenuItem(value: 'sales', child: Text('РџСЂРѕРґР°Р¶Рё')),
                  const PopupMenuItem(value: 'revenue', child: Text('Р”РѕС…РѕРґ')),
                  const PopupMenuItem(value: 'orders', child: Text('Р—Р°РєР°Р·С‹')),
                  const PopupMenuItem(value: 'customers', child: Text('РљР»РёРµРЅС‚С‹')),
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
                    'Р“СЂР°С„РёРє $_selectedMetric',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'РџРµСЂРёРѕРґ: ${_getPeriodText(_selectedPeriod)}',
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
          'Р‘С‹СЃС‚СЂС‹Рµ РґРµР№СЃС‚РІРёСЏ',
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
                label: 'Р”РѕР±Р°РІРёС‚СЊ С‚РѕРІР°СЂ',
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
                label: 'AI Р°РЅР°Р»РёР·',
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
                label: 'РЎРѕР·РґР°С‚СЊ РїРѕСЃС‚',
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
                label: 'РђРЅР°Р»РёС‚РёРєР°',
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
                label: 'РќР°СЃС‚СЂРѕР№РєРё',
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
            'РџРѕСЃР»РµРґРЅСЏСЏ Р°РєС‚РёРІРЅРѕСЃС‚СЊ',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          _buildRecentActivityItem(
            context,
            Icons.add_shopping_cart,
            'Р”РѕР±Р°РІР»РµРЅ РЅРѕРІС‹Р№ С‚РѕРІР°СЂ',
            'iPhone 15 Pro РґРѕР±Р°РІР»РµРЅ РІ РєР°С‚Р°Р»РѕРі',
            '2 РјРёРЅ РЅР°Р·Р°Рґ',
            Colors.green,
          ),
          _buildRecentActivityItem(
            context,
            Icons.payment,
            'РќРѕРІР°СЏ РїСЂРѕРґР°Р¶Р°',
            'РџСЂРѕРґР°Р¶Р° РЅР° СЃСѓРјРјСѓ \$1,299',
            '15 РјРёРЅ РЅР°Р·Р°Рґ',
            Colors.blue,
          ),
          _buildRecentActivityItem(
            context,
            Icons.inventory,
            'РћР±РЅРѕРІР»РµРЅ СЃРєР»Р°Рґ',
            'РџРѕРїРѕР»РЅРµРЅРёРµ С‚РѕРІР°СЂР° РЅР° СЃРєР»Р°РґРµ',
            '1 С‡Р°СЃ РЅР°Р·Р°Рґ',
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
        return 'Р”РµРЅСЊ';
      case 'week':
        return 'РќРµРґРµР»СЏ';
      case 'month':
        return 'РњРµСЃСЏС†';
      case 'year':
        return 'Р“РѕРґ';
      default:
        return 'РќРµРґРµР»СЏ';
    }
  }

  String _getMetricText(String metric) {
    switch (metric) {
      case 'sales':
        return 'РџСЂРѕРґР°Р¶Рё';
      case 'revenue':
        return 'Р”РѕС…РѕРґ';
      case 'orders':
        return 'Р—Р°РєР°Р·С‹';
      case 'customers':
        return 'РљР»РёРµРЅС‚С‹';
      default:
        return 'РџСЂРѕРґР°Р¶Рё';
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
    // РџСЂРѕРІРµСЂСЏРµРј РЅР°Р»РёС‡РёРµ С‚РѕРІР°СЂРѕРІ СЃ РЅРёР·РєРёРј Р·Р°РїР°СЃРѕРј
    final lowStockProducts = stats['products']?['low_stock_products_count'] ?? 0;
    return lowStockProducts > 0;
  }

  // Р”РёР°Р»РѕРіРё РґР»СЏ Р±С‹СЃС‚СЂС‹С… РґРµР№СЃС‚РІРёР№
  void _showAddProductDialog(BuildContext context) {
    // РџРµСЂРµС…РѕРґ РЅР° СЌРєСЂР°РЅ С‚РѕРІР°СЂРѕРІ РґР»СЏ РґРѕР±Р°РІР»РµРЅРёСЏ
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
          title: const Text('AI РђРЅР°Р»РёР·'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Р’С‹Р±РµСЂРёС‚Рµ С‚РёРї Р°РЅР°Р»РёР·Р°:'),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.trending_up),
                title: Text('РђРЅР°Р»РёР· РїСЂРѕРґР°Р¶'),
                subtitle: Text('РџСЂРѕРіРЅРѕР· Рё С‚СЂРµРЅРґС‹'),
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('РџРѕРІРµРґРµРЅРёРµ РєР»РёРµРЅС‚РѕРІ'),
                subtitle: Text('РЎРµРіРјРµРЅС‚Р°С†РёСЏ Рё РїСЂРµРґРїРѕС‡С‚РµРЅРёСЏ'),
              ),
              ListTile(
                leading: Icon(Icons.inventory),
                title: Text('РЈРїСЂР°РІР»РµРЅРёРµ Р·Р°РїР°СЃР°РјРё'),
                subtitle: Text('РћРїС‚РёРјРёР·Р°С†РёСЏ Рё РїСЂРѕРіРЅРѕР·С‹'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Р—Р°РїСѓСЃС‚РёС‚СЊ AI Р°РЅР°Р»РёР·
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('AI Р°РЅР°Р»РёР· Р·Р°РїСѓС‰РµРЅ!')),
                );
              },
              child: const Text('Р—Р°РїСѓСЃС‚РёС‚СЊ'),
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
          title: const Text('Web3 Р¤СѓРЅРєС†РёРё'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Р’С‹Р±РµСЂРёС‚Рµ РґРµР№СЃС‚РІРёРµ:'),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('РџРѕРґРєР»СЋС‡РёС‚СЊ РєРѕС€РµР»РµРє'),
                subtitle: Text('MetaMask, WalletConnect'),
              ),
              ListTile(
                leading: Icon(Icons.token),
                title: Text('РЎРѕР·РґР°С‚СЊ NFT'),
                subtitle: Text('РњРёРЅС‚РёРЅРі С‚РѕРєРµРЅРѕРІ'),
              ),
              ListTile(
                leading: Icon(Icons.swap_horiz),
                title: Text('DeFi РѕРїРµСЂР°С†РёРё'),
                subtitle: Text('РЎРІРѕРїС‹, СЃС‚РµР№РєРёРЅРі'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Р’С‹РїРѕР»РЅРёС‚СЊ Web3 РґРµР№СЃС‚РІРёРµ
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Web3 РґРµР№СЃС‚РІРёРµ РІС‹РїРѕР»РЅРµРЅРѕ!')),
                );
              },
              child: const Text('Р’С‹РїРѕР»РЅРёС‚СЊ'),
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
          title: const Text('РЎРѕР·РґР°С‚СЊ РїРѕСЃС‚'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Р—Р°РіРѕР»РѕРІРѕРє РїРѕСЃС‚Р°',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'РўРµРєСЃС‚ РїРѕСЃС‚Р°',
                  border: OutlineInputBorder(),
                  hintText: 'Р§С‚Рѕ С…РѕС‚РёС‚Рµ СЂР°СЃСЃРєР°Р·Р°С‚СЊ?',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('РћС‚РјРµРЅР°'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: РЎРѕР·РґР°С‚СЊ РїРѕСЃС‚
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('РџРѕСЃС‚ СЃРѕР·РґР°РЅ!')),
                );
              },
              child: const Text('РћРїСѓР±Р»РёРєРѕРІР°С‚СЊ'),
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
          title: const Text('РђРЅР°Р»РёС‚РёРєР°'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Р’С‹Р±РµСЂРёС‚Рµ РѕС‚С‡РµС‚:'),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.bar_chart),
                title: Text('РџСЂРѕРґР°Р¶Рё'),
                subtitle: Text('Р“СЂР°С„РёРєРё Рё СЃС‚Р°С‚РёСЃС‚РёРєР°'),
              ),
              ListTile(
                leading: Icon(Icons.pie_chart),
                title: Text('РљР°С‚РµРіРѕСЂРёРё'),
                subtitle: Text('Р Р°СЃРїСЂРµРґРµР»РµРЅРёРµ РїРѕ С‚РёРїР°Рј'),
              ),
              ListTile(
                leading: Icon(Icons.timeline),
                title: Text('РўСЂРµРЅРґС‹'),
                subtitle: Text('Р’СЂРµРјРµРЅРЅС‹Рµ СЂСЏРґС‹'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: РџРѕРєР°Р·Р°С‚СЊ Р°РЅР°Р»РёС‚РёРєСѓ
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('РћС‚С‡РµС‚ Р·Р°РіСЂСѓР¶Р°РµС‚СЃСЏ!')),
                );
              },
              child: const Text('РџРѕРєР°Р·Р°С‚СЊ'),
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
          title: const Text('РќР°СЃС‚СЂРѕР№РєРё'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('РЈРІРµРґРѕРјР»РµРЅРёСЏ'),
                subtitle: Text('РќР°СЃС‚СЂРѕР№РєР° РѕРїРѕРІРµС‰РµРЅРёР№'),
              ),
              ListTile(
                leading: Icon(Icons.security),
                title: Text('Р‘РµР·РѕРїР°СЃРЅРѕСЃС‚СЊ'),
                subtitle: Text('РџР°СЂРѕР»Рё Рё РґРѕСЃС‚СѓРї'),
              ),
              ListTile(
                leading: Icon(Icons.language),
                title: Text('РЇР·С‹Рє'),
                subtitle: Text('Р СѓСЃСЃРєРёР№, English'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: РћС‚РєСЂС‹С‚СЊ РЅР°СЃС‚СЂРѕР№РєРё
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('РќР°СЃС‚СЂРѕР№РєРё РѕС‚РєСЂС‹С‚С‹!')),
                );
              },
              child: const Text('РћС‚РєСЂС‹С‚СЊ'),
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
                'РўРµРєСѓС‰РµРµ Р·РЅР°С‡РµРЅРёРµ:',
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
                'Р”РѕРїРѕР»РЅРёС‚РµР»СЊРЅР°СЏ РёРЅС„РѕСЂРјР°С†РёСЏ:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildStatDetailItem('РР·РјРµРЅРµРЅРёРµ Р·Р° РґРµРЅСЊ', '+5.2%', Icons.trending_up, Colors.green),
              _buildStatDetailItem('РР·РјРµРЅРµРЅРёРµ Р·Р° РЅРµРґРµР»СЋ', '+12.8%', Icons.trending_up, Colors.green),
              _buildStatDetailItem('РР·РјРµРЅРµРЅРёРµ Р·Р° РјРµСЃСЏС†', '+23.4%', Icons.trending_up, Colors.green),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showDetailedAnalytics(context, title);
              },
              child: const Text('РџРѕРґСЂРѕР±РЅРµРµ'),
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
          title: Text('Р”РµС‚Р°Р»СЊРЅР°СЏ Р°РЅР°Р»РёС‚РёРєР°: $category'),
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
                        'Р“СЂР°С„РёРє Р°РЅР°Р»РёС‚РёРєРё\n(Р—РґРµСЃСЊ Р±СѓРґРµС‚ РѕС‚РѕР±СЂР°Р¶Р°С‚СЊСЃСЏ РёРЅС‚РµСЂР°РєС‚РёРІРЅС‹Р№ РіСЂР°С„РёРє)',
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
                            const SnackBar(content: Text('Р­РєСЃРїРѕСЂС‚ РІ PDF!')),
                          );
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Р­РєСЃРїРѕСЂС‚ PDF'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Р­РєСЃРїРѕСЂС‚ РІ Excel!')),
                          );
                        },
                        icon: const Icon(Icons.table_chart),
                        label: const Text('Р­РєСЃРїРѕСЂС‚ Excel'),
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
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
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
                'РћРїРёСЃР°РЅРёРµ:',
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
                'Р’СЂРµРјСЏ:',
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
                'Р”РµР№СЃС‚РІРёСЏ:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildActionButton(
                icon: Icons.edit,
                label: 'Р РµРґР°РєС‚РёСЂРѕРІР°С‚СЊ',
                onTap: () {
                  Navigator.of(context).pop();
                  _showEditActivityDialog(context, title, description);
                },
              ),
              const SizedBox(height: 8),
              _buildActionButton(
                icon: Icons.delete,
                label: 'РЈРґР°Р»РёС‚СЊ',
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
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showActivityHistory(context, title);
              },
              child: const Text('РСЃС‚РѕСЂРёСЏ'),
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
          title: const Text('Р РµРґР°РєС‚РёСЂРѕРІР°С‚СЊ Р°РєС‚РёРІРЅРѕСЃС‚СЊ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Р—Р°РіРѕР»РѕРІРѕРє',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'РћРїРёСЃР°РЅРёРµ',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('РћС‚РјРµРЅР°'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('РђРєС‚РёРІРЅРѕСЃС‚СЊ РѕР±РЅРѕРІР»РµРЅР°!')),
                );
              },
              child: const Text('РЎРѕС…СЂР°РЅРёС‚СЊ'),
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
          title: const Text('РџРѕРґС‚РІРµСЂР¶РґРµРЅРёРµ СѓРґР°Р»РµРЅРёСЏ'),
          content: Text('Р’С‹ СѓРІРµСЂРµРЅС‹, С‡С‚Рѕ С…РѕС‚РёС‚Рµ СѓРґР°Р»РёС‚СЊ Р°РєС‚РёРІРЅРѕСЃС‚СЊ "$title"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('РћС‚РјРµРЅР°'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('РђРєС‚РёРІРЅРѕСЃС‚СЊ СѓРґР°Р»РµРЅР°!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('РЈРґР°Р»РёС‚СЊ'),
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
          title: Text('РСЃС‚РѕСЂРёСЏ Р°РєС‚РёРІРЅРѕСЃС‚Рё: $title'),
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
                        title: Text('Р’РµСЂСЃРёСЏ ${5 - index}'),
                        subtitle: Text('РР·РјРµРЅРµРЅРѕ ${index + 1} ${index == 0 ? 'С‡Р°СЃ' : 'С‡Р°СЃР°'} РЅР°Р·Р°Рґ'),
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
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
            ),
          ],
        );
      },
    );
  }
}

// Р­РєСЂР°РЅ С‚РѕРІР°СЂРѕРІ
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> with TickerProviderStateMixin {
  // РђРЅРёРјР°С†РёРё
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
    
    // РРЅРёС†РёР°Р»РёР·Р°С†РёСЏ Р°РЅРёРјР°С†РёР№
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
          'РўРѕРІР°СЂС‹',
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
            'РџРѕРёСЃРє Рё С„РёР»СЊС‚СЂС‹',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          
          // РџРѕРёСЃРє
          TextField(
            decoration: InputDecoration(
              hintText: 'РџРѕРёСЃРє С‚РѕРІР°СЂРѕРІ...',
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
          
          // Р¤РёР»СЊС‚СЂС‹
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'РљР°С‚РµРіРѕСЂРёСЏ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  value: null,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Р’СЃРµ РєР°С‚РµРіРѕСЂРёРё')),
                    ...productProvider.categories.map((cat) => DropdownMenuItem(
                      value: cat['id'],
                      child: Text(cat['name'] ?? ''),
                    )),
                  ],
                  onChanged: (value) {
                    // РџСЂРёРјРµРЅРёС‚СЊ С„РёР»СЊС‚СЂ РїРѕ РєР°С‚РµРіРѕСЂРёРё
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'РЎРѕСЂС‚РёСЂРѕРІРєР°',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  value: 'name',
                  items: const [
                    DropdownMenuItem(value: 'name', child: Text('РџРѕ РЅР°Р·РІР°РЅРёСЋ')),
                    DropdownMenuItem(value: 'price', child: Text('РџРѕ С†РµРЅРµ')),
                    DropdownMenuItem(value: 'stock', child: Text('РџРѕ РѕСЃС‚Р°С‚РєСѓ')),
                    DropdownMenuItem(value: 'date', child: Text('РџРѕ РґР°С‚Рµ')),
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
          'РЎС‚Р°С‚РёСЃС‚РёРєР° С‚РѕРІР°СЂРѕРІ',
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
                title: 'Р’СЃРµРіРѕ С‚РѕРІР°СЂРѕРІ',
                value: '${productProvider.totalProducts}',
                icon: Icons.inventory,
                color: Colors.blue,
                subtitle: 'Р’ РєР°С‚Р°Р»РѕРіРµ',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'РљР°С‚РµРіРѕСЂРёР№',
                value: '${productProvider.totalCategories}',
                icon: Icons.category,
                color: Colors.green,
                subtitle: 'Р”РѕСЃС‚СѓРїРЅРѕ',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'РќРёР·РєРёР№ Р·Р°РїР°СЃ',
                value: '${productProvider.products.where((p) => (p['stock_quantity'] ?? 0) <= (p['min_stock_level'] ?? 0)).length}',
                icon: Icons.warning,
                color: Colors.orange,
                subtitle: 'РўСЂРµР±СѓРµС‚ РІРЅРёРјР°РЅРёСЏ',
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
              'РЎРїРёСЃРѕРє С‚РѕРІР°СЂРѕРІ',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              '${productsToShow.length} С‚РѕРІР°СЂРѕРІ',
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
            'РўРѕРІР°СЂС‹ РЅРµ РЅР°Р№РґРµРЅС‹',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'РџРѕРїСЂРѕР±СѓР№С‚Рµ РёР·РјРµРЅРёС‚СЊ С„РёР»СЊС‚СЂС‹ РёР»Рё РїРѕРёСЃРєРѕРІС‹Р№ Р·Р°РїСЂРѕСЃ',
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
            label: const Text('Р”РѕР±Р°РІРёС‚СЊ С‚РѕРІР°СЂ'),
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
              // РР·РѕР±СЂР°Р¶РµРЅРёРµ С‚РѕРІР°СЂР°
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
              
              // РРЅС„РѕСЂРјР°С†РёСЏ Рѕ С‚РѕРІР°СЂРµ
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
                            'РћСЃС‚Р°С‚РѕРє: ${product['stock_quantity'] ?? 0}',
                            style: TextStyle(
                              color: isLowStock ? Colors.red : Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(product['price'] ?? 0.0).toStringAsFixed(2)} в‚Ѕ',
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
              
              // РљРЅРѕРїРєРё РґРµР№СЃС‚РІРёР№
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('РџРµСЂРµС…РѕРґ РЅР° Ozon: ${product['name']}'),
                          action: SnackBarAction(
                            label: 'РћС‚РєСЂС‹С‚СЊ',
                            onPressed: () {
                              // Р—РґРµСЃСЊ Р±СѓРґРµС‚ СЂРµР°Р»СЊРЅС‹Р№ РїРµСЂРµС…РѕРґ РЅР° Ozon
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



  // Р”РёР°Р»РѕРіРё РґР»СЏ ProductsScreen
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
          title: const Text('Р”РѕР±Р°РІРёС‚СЊ С‚РѕРІР°СЂ'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'РќР°Р·РІР°РЅРёРµ С‚РѕРІР°СЂР° *',
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
                          labelText: 'Р¦РµРЅР° *',
                          border: OutlineInputBorder(),
                          prefixText: 'в‚Ѕ ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: stockController,
                        decoration: const InputDecoration(
                          labelText: 'РљРѕР»РёС‡РµСЃС‚РІРѕ *',
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
                    labelText: 'РљР°С‚РµРіРѕСЂРёСЏ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'РћРїРёСЃР°РЅРёРµ',
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
              child: const Text('РћС‚РјРµРЅР°'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && 
                    priceController.text.isNotEmpty && 
                    stockController.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('РўРѕРІР°СЂ СѓСЃРїРµС€РЅРѕ РґРѕР±Р°РІР»РµРЅ!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Р—Р°РїРѕР»РЅРёС‚Рµ РѕР±СЏР·Р°С‚РµР»СЊРЅС‹Рµ РїРѕР»СЏ!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Р”РѕР±Р°РІРёС‚СЊ'),
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
              Expanded(child: Text(product['name'] ?? 'РўРѕРІР°СЂ')),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // РР·РѕР±СЂР°Р¶РµРЅРёРµ С‚РѕРІР°СЂР°
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
                
                // РРЅС„РѕСЂРјР°С†РёСЏ Рѕ С‚РѕРІР°СЂРµ
                _buildDetailRow('РќР°Р·РІР°РЅРёРµ', product['name'] ?? ''),
                _buildDetailRow('РљР°С‚РµРіРѕСЂРёСЏ', product['category_name'] ?? ''),
                _buildDetailRow('Р¦РµРЅР°', '${(product['price'] ?? 0.0).toStringAsFixed(2)} в‚Ѕ'),
                _buildDetailRow('РћСЃС‚Р°С‚РѕРє', '${product['stock_quantity'] ?? 0}'),
                _buildDetailRow('РњРёРЅ. Р·Р°РїР°СЃ', '${product['min_stock_level'] ?? 0}'),
                if (product['description'] != null)
                  _buildDetailRow('РћРїРёСЃР°РЅРёРµ', product['description']),
                
                const SizedBox(height: 16),
                
                // Р”РµР№СЃС‚РІРёСЏ
                Text(
                  'Р”РµР№СЃС‚РІРёСЏ:',
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
                        label: const Text('Р РµРґР°РєС‚РёСЂРѕРІР°С‚СЊ'),
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
                        label: const Text('РЈРґР°Р»РёС‚СЊ'),
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
                        label: const Text('РРЅРІРµРЅС‚Р°СЂРёР·Р°С†РёСЏ'),
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
                        label: const Text('РђРЅР°Р»РёС‚РёРєР°'),
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
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
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
          title: const Text('Р РµРґР°РєС‚РёСЂРѕРІР°С‚СЊ С‚РѕРІР°СЂ'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'РќР°Р·РІР°РЅРёРµ С‚РѕРІР°СЂР°',
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
                          labelText: 'Р¦РµРЅР°',
                          border: OutlineInputBorder(),
                          prefixText: 'в‚Ѕ ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: stockController,
                        decoration: const InputDecoration(
                          labelText: 'РљРѕР»РёС‡РµСЃС‚РІРѕ',
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
                    labelText: 'РљР°С‚РµРіРѕСЂРёСЏ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'РћРїРёСЃР°РЅРёРµ',
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
              child: const Text('РћС‚РјРµРЅР°'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('РўРѕРІР°СЂ СѓСЃРїРµС€РЅРѕ РѕР±РЅРѕРІР»РµРЅ!')),
                );
              },
              child: const Text('РЎРѕС…СЂР°РЅРёС‚СЊ'),
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
          title: const Text('РџРѕРґС‚РІРµСЂР¶РґРµРЅРёРµ СѓРґР°Р»РµРЅРёСЏ'),
          content: Text('Р’С‹ СѓРІРµСЂРµРЅС‹, С‡С‚Рѕ С…РѕС‚РёС‚Рµ СѓРґР°Р»РёС‚СЊ С‚РѕРІР°СЂ "${product['name']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('РћС‚РјРµРЅР°'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('РўРѕРІР°СЂ СѓРґР°Р»РµРЅ!'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('РЈРґР°Р»РёС‚СЊ'),
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
          title: const Text('РРЅРІРµРЅС‚Р°СЂРёР·Р°С†РёСЏ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('РўРѕРІР°СЂ: ${product['name']}'),
              const SizedBox(height: 16),
              TextField(
                controller: newStockController,
                decoration: const InputDecoration(
                  labelText: 'РќРѕРІРѕРµ РєРѕР»РёС‡РµСЃС‚РІРѕ',
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
                          const SnackBar(content: Text('РљРѕР»РёС‡РµСЃС‚РІРѕ РѕР±РЅРѕРІР»РµРЅРѕ!')),
                        );
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('РџРѕРґС‚РІРµСЂРґРёС‚СЊ'),
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
                      label: const Text('РљРѕСЂСЂРµРєС‚РёСЂРѕРІРєР°'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
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
          title: const Text('РљРѕСЂСЂРµРєС‚РёСЂРѕРІРєР° Р·Р°РїР°СЃРѕРІ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('РўРѕРІР°СЂ: ${product['name']}'),
              const SizedBox(height: 16),
              TextField(
                controller: adjustmentController,
                decoration: const InputDecoration(
                  labelText: 'РљРѕР»РёС‡РµСЃС‚РІРѕ РґР»СЏ РґРѕР±Р°РІР»РµРЅРёСЏ/РІС‹С‡РёС‚Р°РЅРёСЏ',
                  border: OutlineInputBorder(),
                  hintText: 'РСЃРїРѕР»СЊР·СѓР№С‚Рµ + РґР»СЏ РґРѕР±Р°РІР»РµРЅРёСЏ, - РґР»СЏ РІС‹С‡РёС‚Р°РЅРёСЏ',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('РћС‚РјРµРЅР°'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Р—Р°РїР°СЃС‹ СЃРєРѕСЂСЂРµРєС‚РёСЂРѕРІР°РЅС‹!')),
                );
              },
              child: const Text('РџСЂРёРјРµРЅРёС‚СЊ'),
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
          title: Text('РђРЅР°Р»РёС‚РёРєР°: ${product['name']}'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                // РЎС‚Р°С‚РёСЃС‚РёРєР° РїСЂРѕРґР°Р¶
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'РЎС‚Р°С‚РёСЃС‚РёРєР° РїСЂРѕРґР°Р¶',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildAnalyticsCard('РЎРµРіРѕРґРЅСЏ', '5', Icons.today),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildAnalyticsCard('РќРµРґРµР»СЏ', '32', Icons.date_range),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildAnalyticsCard('РњРµСЃСЏС†', '128', Icons.calendar_month),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Р“СЂР°С„РёРє
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Р“СЂР°С„РёРє РїСЂРѕРґР°Р¶\n(Р—РґРµСЃСЊ Р±СѓРґРµС‚ РёРЅС‚РµСЂР°РєС‚РёРІРЅС‹Р№ РіСЂР°С„РёРє)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Р­РєСЃРїРѕСЂС‚
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Р­РєСЃРїРѕСЂС‚ РІ PDF!')),
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
                            const SnackBar(content: Text('Р­РєСЃРїРѕСЂС‚ РІ Excel!')),
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
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
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
                'РўРµРєСѓС‰РµРµ Р·РЅР°С‡РµРЅРёРµ:',
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
                'Р”РѕРїРѕР»РЅРёС‚РµР»СЊРЅР°СЏ РёРЅС„РѕСЂРјР°С†РёСЏ:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildProductStatDetailItem('РР·РјРµРЅРµРЅРёРµ Р·Р° РґРµРЅСЊ', '+2.1%', Icons.trending_up, Colors.green),
              _buildProductStatDetailItem('РР·РјРµРЅРµРЅРёРµ Р·Р° РЅРµРґРµР»СЋ', '+8.7%', Icons.trending_up, Colors.green),
              _buildProductStatDetailItem('РР·РјРµРЅРµРЅРёРµ Р·Р° РјРµСЃСЏС†', '+15.3%', Icons.trending_up, Colors.green),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showProductDetailedAnalytics(context, title);
              },
              child: const Text('РџРѕРґСЂРѕР±РЅРµРµ'),
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
          title: Text('Р”РµС‚Р°Р»СЊРЅР°СЏ Р°РЅР°Р»РёС‚РёРєР°: $category'),
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
                        'Р“СЂР°С„РёРє Р°РЅР°Р»РёС‚РёРєРё С‚РѕРІР°СЂРѕРІ\n(Р—РґРµСЃСЊ Р±СѓРґРµС‚ РѕС‚РѕР±СЂР°Р¶Р°С‚СЊСЃСЏ РёРЅС‚РµСЂР°РєС‚РёРІРЅС‹Р№ РіСЂР°С„РёРє)',
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
                            const SnackBar(content: Text('Р­РєСЃРїРѕСЂС‚ РІ PDF!')),
                          );
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Р­РєСЃРїРѕСЂС‚ PDF'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Р­РєСЃРїРѕСЂС‚ РІ Excel!')),
                          );
                        },
                        icon: const Icon(Icons.table_chart),
                        label: const Text('Р­РєСЃРїРѕСЂС‚ Excel'),
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
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
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
          title: const Text('Р Р°СЃС€РёСЂРµРЅРЅС‹Рµ С„РёР»СЊС‚СЂС‹'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                // Р¦РµРЅРѕРІРѕР№ РґРёР°РїР°Р·РѕРЅ
                Text(
                  'Р¦РµРЅРѕРІРѕР№ РґРёР°РїР°Р·РѕРЅ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'РћС‚',
                          border: OutlineInputBorder(),
                          prefixText: 'в‚Ѕ ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Р”Рѕ',
                          border: OutlineInputBorder(),
                          prefixText: 'в‚Ѕ ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // РћСЃС‚Р°С‚РѕРє РЅР° СЃРєР»Р°РґРµ
                Text(
                  'РћСЃС‚Р°С‚РѕРє РЅР° СЃРєР»Р°РґРµ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'РћС‚',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Р”Рѕ',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Р”Р°С‚Р° РґРѕР±Р°РІР»РµРЅРёСЏ
                Text(
                  'Р”Р°С‚Р° РґРѕР±Р°РІР»РµРЅРёСЏ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Р’С‹Р±СЂР°С‚СЊ РґР°С‚Сѓ "РѕС‚"
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Р’С‹Р±РµСЂРёС‚Рµ РґР°С‚Сѓ "РѕС‚"')),
                          );
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('РћС‚'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Р’С‹Р±СЂР°С‚СЊ РґР°С‚Сѓ "РґРѕ"
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Р’С‹Р±РµСЂРёС‚Рµ РґР°С‚Сѓ "РґРѕ"')),
                          );
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Р”Рѕ'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Р”РѕРїРѕР»РЅРёС‚РµР»СЊРЅС‹Рµ РѕРїС†РёРё
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('РўРѕР»СЊРєРѕ РІ РЅР°Р»РёС‡РёРё'),
                        value: false,
                        onChanged: (value) {
                          // TODO: РџСЂРёРјРµРЅРёС‚СЊ С„РёР»СЊС‚СЂ
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('РЎРѕ СЃРєРёРґРєРѕР№'),
                        value: false,
                        onChanged: (value) {
                          // TODO: РџСЂРёРјРµРЅРёС‚СЊ С„РёР»СЊС‚СЂ
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
              child: const Text('РЎР±СЂРѕСЃРёС‚СЊ'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Р¤РёР»СЊС‚СЂС‹ РїСЂРёРјРµРЅРµРЅС‹!')),
                );
              },
              child: const Text('РџСЂРёРјРµРЅРёС‚СЊ'),
            ),
          ],
        );
      },
    );
  }
}

// AI СЌРєСЂР°РЅ
class AIScreen extends StatefulWidget {
  const AIScreen({Key? key}) : super(key: key);

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> with TickerProviderStateMixin {
  // РђРЅРёРјР°С†РёРё
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  // РљРѕРЅС‚СЂРѕР»Р»РµСЂС‹
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productCategoryController = TextEditingController();
  final TextEditingController _generatedDescriptionController = TextEditingController();
  final TextEditingController _generatedHashtagsController = TextEditingController();
  final TextEditingController _generatedPostController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // РРЅРёС†РёР°Р»РёР·Р°С†РёСЏ Р°РЅРёРјР°С†РёР№
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
          'AI РџРѕРјРѕС‰РЅРёРє',
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
                        'Р”РѕР±СЂРѕ РїРѕР¶Р°Р»РѕРІР°С‚СЊ РІ PoSPro!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Р’Р°С€Р° СЃРёСЃС‚РµРјР° СѓРїСЂР°РІР»РµРЅРёСЏ С‚РѕСЂРіРѕРІР»РµР№ СЃ AI Рё Р±Р»РѕРєС‡РµР№РЅ РІРѕР·РјРѕР¶РЅРѕСЃС‚СЏРјРё',
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
                  'РџРѕСЃР»РµРґРЅРµРµ РѕР±РЅРѕРІР»РµРЅРёРµ: ${DateTime.now().toString().substring(0, 16)}',
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
                    'РћРЅР»Р°Р№РЅ',
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
                'РЎС‚Р°С‚РёСЃС‚РёРєР° AI',
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
                  'Р РµРєРѕРјРµРЅРґР°С†РёР№',
                  '${aiProvider.personalRecommendations.length}',
                  Icons.recommend,
                  Colors.purple,
                  'AI Р РµРєРѕРјРµРЅРґР°С†РёРё',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'РџСЂРѕС„РёР»СЊ СЃС‚РёР»СЏ',
                  aiProvider.userStyleProfile != null ? 'РђРєС‚РёРІРµРЅ' : 'РќРµР°РєС‚РёРІРµРЅ',
                  Icons.person,
                  Colors.blue,
                  'AI РђРЅР°Р»РёР· СЃС‚РёР»СЏ',
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
              'РќРµС‚ СЂРµРєРѕРјРµРЅРґР°С†РёР№',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'РќР°Р¶РјРёС‚Рµ РєРЅРѕРїРєСѓ РЅРёР¶Рµ, С‡С‚РѕР±С‹ РїРѕР»СѓС‡РёС‚СЊ РїРµСЂСЃРѕРЅР°Р»СЊРЅС‹Рµ СЂРµРєРѕРјРµРЅРґР°С†РёРё',
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
                'AI Р РµРєРѕРјРµРЅРґР°С†РёРё',
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
                  const SnackBar(content: Text('Р РµРєРѕРјРµРЅРґР°С†РёРё РѕР±РЅРѕРІР»РµРЅС‹!')),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('РџРѕР»СѓС‡РёС‚СЊ СЂРµРєРѕРјРµРЅРґР°С†РёРё'),
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
                'AI РђРЅР°Р»РёР· СЃС‚РёР»СЏ',
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
                    'РћСЃРЅРѕРІРЅРѕР№ СЃС‚РёР»СЊ: ${aiProvider.userStyleProfile!['primary_style']}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'РЈРІРµСЂРµРЅРЅРѕСЃС‚СЊ: ${(aiProvider.userStyleProfile!['style_confidence'] * 100).toInt()}%',
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
                'Р РµРєРѕРјРµРЅРґР°С†РёРё РїРѕ СЃС‚РёР»СЋ:',
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
                    'РџСЂРѕС„РёР»СЊ СЃС‚РёР»СЏ РЅРµ СЃРѕР·РґР°РЅ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'РќР°Р¶РјРёС‚Рµ РєРЅРѕРїРєСѓ РЅРёР¶Рµ, С‡С‚РѕР±С‹ СЃРѕР·РґР°С‚СЊ РїСЂРѕС„РёР»СЊ СЃС‚РёР»СЏ',
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
                  const SnackBar(content: Text('РђРЅР°Р»РёР· СЃС‚РёР»СЏ Р·Р°РІРµСЂС€РµРЅ!')),
                );
              },
              icon: const Icon(Icons.analytics),
              label: const Text('РђРЅР°Р»РёР·РёСЂРѕРІР°С‚СЊ СЃС‚РёР»СЊ'),
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
                'AI РђРЅР°Р»РёР· РїСЂРѕРґР°Р¶',
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
                    final trends = await aiProvider.analyzeSalesTrends(category: 'РћР±С‰Р°СЏ РєР°С‚РµРіРѕСЂРёСЏ');
                    if (trends != null) {
                      _showSalesTrendsDialog(context, trends);
                    }
                  },
                  icon: const Icon(Icons.trending_up),
                  label: const Text('РђРЅР°Р»РёР· С‚СЂРµРЅРґРѕРІ'),
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
                  label: const Text('РџРѕРІРµРґРµРЅРёРµ РєР»РёРµРЅС‚РѕРІ'),
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
                'AI Р“РµРЅРµСЂР°С†РёСЏ РєРѕРЅС‚РµРЅС‚Р°',
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
              labelText: 'РќР°Р·РІР°РЅРёРµ С‚РѕРІР°СЂР°',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'Р’РІРµРґРёС‚Рµ РЅР°Р·РІР°РЅРёРµ С‚РѕРІР°СЂР° РґР»СЏ РіРµРЅРµСЂР°С†РёРё РєРѕРЅС‚РµРЅС‚Р°',
              prefixIcon: Icon(Icons.inventory, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _productCategoryController,
            decoration: InputDecoration(
              labelText: 'РљР°С‚РµРіРѕСЂРёСЏ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'Р’РІРµРґРёС‚Рµ РєР°С‚РµРіРѕСЂРёСЋ С‚РѕРІР°СЂР°',
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
                            : 'РћР±С‰Р°СЏ РєР°С‚РµРіРѕСЂРёСЏ',
                      );
                      if (description != null) {
                        setState(() {
                          _generatedDescriptionController.text = description;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('РћРїРёСЃР°РЅРёРµ СЃРіРµРЅРµСЂРёСЂРѕРІР°РЅРѕ!')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Р’РІРµРґРёС‚Рµ РЅР°Р·РІР°РЅРёРµ С‚РѕРІР°СЂР°')),
                      );
                    }
                  },
                  icon: const Icon(Icons.description),
                  label: const Text('РЎРіРµРЅРµСЂРёСЂРѕРІР°С‚СЊ РѕРїРёСЃР°РЅРёРµ'),
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
                            : 'РћР±С‰Р°СЏ РєР°С‚РµРіРѕСЂРёСЏ',
                      );
                      if (hashtags.isNotEmpty) {
                        setState(() {
                          _generatedHashtagsController.text = hashtags.join(' ');
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('РҐРµС€С‚РµРіРё СЃРіРµРЅРµСЂРёСЂРѕРІР°РЅС‹!')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Р’РІРµРґРёС‚Рµ РЅР°Р·РІР°РЅРёРµ С‚РѕРІР°СЂР°')),
                      );
                    }
                  },
                  icon: const Icon(Icons.tag),
                  label: const Text('РЎРіРµРЅРµСЂРёСЂРѕРІР°С‚СЊ С…РµС€С‚РµРіРё'),
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
              'РЎРіРµРЅРµСЂРёСЂРѕРІР°РЅРЅРѕРµ РѕРїРёСЃР°РЅРёРµ:',
              _generatedDescriptionController,
              4,
              'РћРїРёСЃР°РЅРёРµ СЃРєРѕРїРёСЂРѕРІР°РЅРѕ!',
              'РСЃРїРѕР»СЊР·РѕРІР°С‚СЊ РґР»СЏ С‚РѕРІР°СЂР°',
              () => Navigator.of(context).pushNamed('/products/add', arguments: {
                'description': _generatedDescriptionController.text,
              }),
            ),
            const SizedBox(height: 16),
          ],
          if (_generatedHashtagsController.text.isNotEmpty) ...[
            _buildGeneratedContentSection(
              'РЎРіРµРЅРµСЂРёСЂРѕРІР°РЅРЅС‹Рµ С…РµС€С‚РµРіРё:',
              _generatedHashtagsController,
              2,
              'РҐРµС€С‚РµРіРё СЃРєРѕРїРёСЂРѕРІР°РЅС‹!',
              'РСЃРїРѕР»СЊР·РѕРІР°С‚СЊ РґР»СЏ РїРѕСЃС‚Р°',
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
            hintText: 'РЎРіРµРЅРµСЂРёСЂРѕРІР°РЅРЅС‹Р№ РєРѕРЅС‚РµРЅС‚ РїРѕСЏРІРёС‚СЃСЏ Р·РґРµСЃСЊ',
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
              label: const Text('РљРѕРїРёСЂРѕРІР°С‚СЊ'),
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
        title: const Text('РќР°СЃС‚СЂРѕР№РєРё AI'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('РќР°СЃС‚СЂРѕР№РєРё AI РїРѕРјРѕС‰РЅРёРєР°'),
            SizedBox(height: 16),
            Text('вЂў РђРІС‚РѕРјР°С‚РёС‡РµСЃРєРёРµ СЂРµРєРѕРјРµРЅРґР°С†РёРё'),
            Text('вЂў РђРЅР°Р»РёР· СЃС‚РёР»СЏ'),
            Text('вЂў Р“РµРЅРµСЂР°С†РёСЏ РєРѕРЅС‚РµРЅС‚Р°'),
            Text('вЂў РђРЅР°Р»РёР· РїСЂРѕРґР°Р¶'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
          ),
        ],
      ),
    );
  }

  void _showSalesTrendsDialog(BuildContext context, Map<String, dynamic> trends) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI РђРЅР°Р»РёР· С‚СЂРµРЅРґРѕРІ РїСЂРѕРґР°Р¶'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('РџРѕРїСѓР»СЏСЂРЅС‹Рµ РєР°С‚РµРіРѕСЂРёРё: ${trends['popular_categories']?.join(', ') ?? ''}'),
              const SizedBox(height: 8),
              Text('РўСЂРµРЅРґ СЂРѕСЃС‚Р°: ${trends['growth_trend'] ?? ''}'),
              const SizedBox(height: 8),
              Text('Р РµРєРѕРјРµРЅРґР°С†РёРё: ${trends['recommendations'] ?? ''}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
          ),
        ],
      ),
    );
  }

  void _showCustomerBehaviorDialog(BuildContext context, Map<String, dynamic> behavior) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI РђРЅР°Р»РёР· РїРѕРІРµРґРµРЅРёСЏ РєР»РёРµРЅС‚РѕРІ'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('РЎСЂРµРґРЅРёР№ С‡РµРє: ${behavior['average_order_value'] ?? ''}'),
              const SizedBox(height: 8),
              Text('Р§Р°СЃС‚РѕС‚Р° РїРѕРєСѓРїРѕРє: ${behavior['purchase_frequency'] ?? ''}'),
              const SizedBox(height: 8),
              Text('РџСЂРµРґРїРѕС‡С‚РµРЅРёСЏ: ${behavior['preferences'] ?? ''}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
          ),
        ],
      ),
    );
  }

  // Р”РѕРїРѕР»РЅРёС‚РµР»СЊРЅС‹Рµ РґРёР°Р»РѕРіРё РґР»СЏ AIScreen
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
                'РўРµРєСѓС‰РµРµ Р·РЅР°С‡РµРЅРёРµ:',
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
                'AI РђРЅР°Р»РёР·:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildAIStatDetailItem('РўРѕС‡РЅРѕСЃС‚СЊ AI', '95.2%', Icons.verified, Colors.green),
              _buildAIStatDetailItem('РћР±РЅРѕРІР»РµРЅРёРµ', 'РљР°Р¶РґС‹Рµ 2 С‡Р°СЃР°', Icons.update, Colors.blue),
              _buildAIStatDetailItem('РСЃС‚РѕС‡РЅРёРє РґР°РЅРЅС‹С…', 'РђРЅР°Р»РёР· РїРѕРІРµРґРµРЅРёСЏ', Icons.data_usage, Colors.purple),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showAIDetailedAnalysis(context, title);
              },
              child: const Text('РџРѕРґСЂРѕР±РЅРµРµ'),
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
          title: Text('Р”РµС‚Р°Р»СЊРЅС‹Р№ AI Р°РЅР°Р»РёР·: $category'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                // AI РЎС‚Р°С‚РёСЃС‚РёРєР°
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'AI РЎС‚Р°С‚РёСЃС‚РёРєР°',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildAIAnalyticsCard('РўРѕС‡РЅРѕСЃС‚СЊ', '95.2%', Icons.verified),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildAIAnalyticsCard('РЎРєРѕСЂРѕСЃС‚СЊ', '0.3СЃ', Icons.speed),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildAIAnalyticsCard('РћР±СѓС‡РµРЅРёРµ', '24/7', Icons.school),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Р“СЂР°С„РёРє AI
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'AI Р“СЂР°С„РёРє Р°РЅР°Р»РёР·Р°\n(Р—РґРµСЃСЊ Р±СѓРґРµС‚ РѕС‚РѕР±СЂР°Р¶Р°С‚СЊСЃСЏ РёРЅС‚РµСЂР°РєС‚РёРІРЅС‹Р№ AI РіСЂР°С„РёРє)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Р­РєСЃРїРѕСЂС‚ AI РґР°РЅРЅС‹С…
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('AI РѕС‚С‡РµС‚ РІ PDF!')),
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
                            const SnackBar(content: Text('AI РѕС‚С‡РµС‚ РІ Excel!')),
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
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
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
          title: const Text('AI Р§Р°С‚'),
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
                        'AI Р§Р°С‚\n(Р—РґРµСЃСЊ Р±СѓРґРµС‚ РѕС‚РѕР±СЂР°Р¶Р°С‚СЊСЃСЏ С‡Р°С‚ СЃ AI РїРѕРјРѕС‰РЅРёРєРѕРј)',
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
                          labelText: 'Р’РІРµРґРёС‚Рµ СЃРѕРѕР±С‰РµРЅРёРµ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('РЎРѕРѕР±С‰РµРЅРёРµ РѕС‚РїСЂР°РІР»РµРЅРѕ AI!')),
                        );
                      },
                      child: const Text('РћС‚РїСЂР°РІРёС‚СЊ'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
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
          title: const Text('AI РћР±СѓС‡РµРЅРёРµ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('РўРµРєСѓС‰РёР№ СЃС‚Р°С‚СѓСЃ РѕР±СѓС‡РµРЅРёСЏ:'),
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
                      'AI Р°РєС‚РёРІРЅРѕ РѕР±СѓС‡Р°РµС‚СЃСЏ',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'РџРѕСЃР»РµРґРЅРµРµ РѕР±РЅРѕРІР»РµРЅРёРµ: ${DateTime.now().toString().substring(0, 16)}',
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
                          const SnackBar(content: Text('AI РѕР±СѓС‡РµРЅРёРµ Р·Р°РїСѓС‰РµРЅРѕ!')),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Р—Р°РїСѓСЃС‚РёС‚СЊ'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('AI РѕР±СѓС‡РµРЅРёРµ РѕСЃС‚Р°РЅРѕРІР»РµРЅРѕ!')),
                        );
                      },
                      icon: const Icon(Icons.stop),
                      label: const Text('РћСЃС‚Р°РЅРѕРІРёС‚СЊ'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
            ),
          ],
        );
      },
    );
  }
}

// Web3 СЌРєСЂР°РЅ
class Web3Screen extends StatefulWidget {
  const Web3Screen({Key? key}) : super(key: key);

  @override
  State<Web3Screen> createState() => _Web3ScreenState();
}

class _Web3ScreenState extends State<Web3Screen> with TickerProviderStateMixin {
  // РђРЅРёРјР°С†РёРё
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

  // РЎРѕСЃС‚РѕСЏРЅРёРµ
  String _selectedTab = 'wallet';
  
  // РљРѕРЅС‚СЂРѕР»Р»РµСЂС‹
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
    
    // РРЅРёС†РёР°Р»РёР·Р°С†РёСЏ Р°РЅРёРјР°С†РёР№
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
              // Р¤РѕРЅРѕРІР°СЏ РёРєРѕРЅРєР° Р±Р»РѕРєС‡РµР№РЅР°
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
              // Р¦РµРЅС‚СЂР°Р»СЊРЅР°СЏ РёРєРѕРЅРєР° СЃ РїСѓР»СЊСЃР°С†РёРµР№
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
              // РЎС‚Р°С‚СѓСЃ РїРѕРґРєР»СЋС‡РµРЅРёСЏ
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
                        web3Provider.isConnected ? 'РџРѕРґРєР»СЋС‡РµРЅРѕ' : 'РћС‚РєР»СЋС‡РµРЅРѕ',
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
        // РљРЅРѕРїРєР° РІС‹Р±РѕСЂР° РІРєР»Р°РґРєРё
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedTab = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'wallet', child: Text('РљРѕС€РµР»РµРє')),
              const PopupMenuItem(value: 'nfts', child: Text('NFTs')),
              const PopupMenuItem(value: 'tokens', child: Text('РўРѕРєРµРЅС‹')),
              const PopupMenuItem(value: 'transactions', child: Text('РўСЂР°РЅР·Р°РєС†РёРё')),
              const PopupMenuItem(value: 'blockchain', child: Text('Р‘Р»РѕРєС‡РµР№РЅ')),
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
        return 'РљРѕС€РµР»РµРє';
      case 'nfts':
        return 'NFTs';
      case 'tokens':
        return 'РўРѕРєРµРЅС‹';
      case 'transactions':
        return 'РўСЂР°РЅР·Р°РєС†РёРё';
      case 'blockchain':
        return 'Р‘Р»РѕРєС‡РµР№РЅ';
      default:
        return 'РљРѕС€РµР»РµРє';
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
        // Р—Р°РіРѕР»РѕРІРѕРє РІРєР»Р°РґРєРё
        _buildTabHeader(
          'РљРѕС€РµР»РµРє',
          Icons.account_balance_wallet,
          Colors.blue,
          'РЈРїСЂР°РІР»РµРЅРёРµ РІР°С€РёРј Web3 РєРѕС€РµР»СЊРєРѕРј',
        ),
        const SizedBox(height: 24),
        
        // РЎС‚Р°С‚СѓСЃ РїРѕРґРєР»СЋС‡РµРЅРёСЏ
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
                          web3Provider.isConnected ? 'РљРѕС€РµР»РµРє РїРѕРґРєР»СЋС‡РµРЅ' : 'РљРѕС€РµР»РµРє РѕС‚РєР»СЋС‡РµРЅ',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          web3Provider.isConnected 
                              ? 'Р’С‹ РјРѕР¶РµС‚Рµ РѕС‚РїСЂР°РІР»СЏС‚СЊ Рё РїРѕР»СѓС‡Р°С‚СЊ РєСЂРёРїС‚РѕРІР°Р»СЋС‚Сѓ'
                              : 'РџРѕРґРєР»СЋС‡РёС‚РµСЃСЊ Рє РєРѕС€РµР»СЊРєСѓ РґР»СЏ РЅР°С‡Р°Р»Р° СЂР°Р±РѕС‚С‹',
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
                        label: const Text('РћС‚РїСЂР°РІРёС‚СЊ ETH'),
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
                        label: const Text('РџРѕР»СѓС‡РёС‚СЊ'),
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
                        const SnackBar(content: Text('РљРѕС€РµР»РµРє РѕС‚РєР»СЋС‡РµРЅ')),
                      );
                    } else {
                      final success = await web3Provider.connectWallet();
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('РљРѕС€РµР»РµРє РїРѕРґРєР»СЋС‡РµРЅ!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('РћС€РёР±РєР° РїРѕРґРєР»СЋС‡РµРЅРёСЏ РєРѕС€РµР»СЊРєР°')),
                        );
                      }
                    }
                  },
                  icon: Icon(
                    web3Provider.isConnected ? Icons.logout : Icons.login,
                  ),
                  label: Text(
                    web3Provider.isConnected ? 'РћС‚РєР»СЋС‡РёС‚СЊСЃСЏ' : 'РџРѕРґРєР»СЋС‡РёС‚СЊСЃСЏ',
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
          _buildInfoRow('РђРґСЂРµСЃ РєРѕС€РµР»СЊРєР°', web3Provider.currentAddress ?? 'РќРµ РїРѕРґРєР»СЋС‡РµРЅ', Icons.account_balance_wallet),
          const SizedBox(height: 16),
          _buildInfoRow('РЎРµС‚СЊ', web3Provider.currentNetwork ?? 'РќРµ РїРѕРґРєР»СЋС‡РµРЅ', Icons.network_check),
          const SizedBox(height: 16),
          _buildInfoRow('Р‘Р°Р»Р°РЅСЃ ETH', '${web3Provider.ethBalance} ETH', Icons.currency_bitcoin),
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
        // Р—Р°РіРѕР»РѕРІРѕРє РІРєР»Р°РґРєРё
        _buildTabHeader(
          'NFTs',
          Icons.image,
          Colors.purple,
          'РЈРїСЂР°РІР»РµРЅРёРµ РІР°С€РёРјРё NFT С‚РѕРєРµРЅР°РјРё',
        ),
        const SizedBox(height: 24),
        
        // РћСЃРЅРѕРІРЅРѕР№ РєРѕРЅС‚РµРЅС‚
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
                    'РњРѕРё NFTs',
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
                    label: const Text('РЎРѕР·РґР°С‚СЊ NFT'),
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
          // РР·РѕР±СЂР°Р¶РµРЅРёРµ NFT
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
          
          // РРЅС„РѕСЂРјР°С†РёСЏ Рѕ NFT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nft['name'] ?? 'Р‘РµР· РЅР°Р·РІР°РЅРёСЏ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  nft['description'] ?? 'Р‘РµР· РѕРїРёСЃР°РЅРёСЏ',
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
          
          // РџСЂР°РІР°СЏ С‡Р°СЃС‚СЊ СЃ С†РµРЅРѕР№ Рё СЃС‚Р°С‚СѓСЃРѕРј
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
                  color: (nft['status'] == 'РђРєС‚РёРІРµРЅ' ? Colors.green : Colors.orange).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (nft['status'] == 'РђРєС‚РёРІРµРЅ' ? Colors.green : Colors.orange).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  nft['status'] ?? 'РќРµРёР·РІРµСЃС‚РЅРѕ',
                  style: TextStyle(
                    color: nft['status'] == 'РђРєС‚РёРІРµРЅ' ? Colors.green[700] : Colors.orange[700],
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
            'NFT РЅРµ РЅР°Р№РґРµРЅС‹',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'РЎРѕР·РґР°Р№С‚Рµ СЃРІРѕР№ РїРµСЂРІС‹Р№ NFT РёР»Рё РїРѕРґРєР»СЋС‡РёС‚Рµ СЃСѓС‰РµСЃС‚РІСѓСЋС‰РёР№ РєРѕС€РµР»РµРє',
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
                        'РњРѕРё С‚РѕРєРµРЅС‹',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _showSwapTokensDialog(context, web3Provider);
                        },
                        child: const Text('РћР±РјРµРЅ'),
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
                      subtitle: Text('Р‘Р°Р»Р°РЅСЃ: ${token['balance']}'),
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
                    const Text('РўРѕРєРµРЅС‹ РЅРµ РЅР°Р№РґРµРЅС‹'),
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
                    'РСЃС‚РѕСЂРёСЏ С‚СЂР°РЅР·Р°РєС†РёР№',
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
                      subtitle: Text('${tx['from']} в†’ ${tx['to']}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            tx['status'] ?? 'Р’ РѕР±СЂР°Р±РѕС‚РєРµ',
                            style: TextStyle(
                              color: tx['status'] == 'РџРѕРґС‚РІРµСЂР¶РґРµРЅРѕ' 
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
                    const Text('РўСЂР°РЅР·Р°РєС†РёРё РЅРµ РЅР°Р№РґРµРЅС‹'),
                  if (web3Provider.userTransactions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _showAllTransactionsDialog(context, web3Provider);
                          },
                          child: const Text('РџРѕРєР°Р·Р°С‚СЊ РІСЃРµ С‚СЂР°РЅР·Р°РєС†РёРё'),
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
        title: const Text('РћС‚РїСЂР°РІРёС‚СЊ ETH'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'РђРґСЂРµСЃ РїРѕР»СѓС‡Р°С‚РµР»СЏ',
                hintText: '0x...',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'РљРѕР»РёС‡РµСЃС‚РІРѕ ETH',
                hintText: '0.0',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('РћС‚РјРµРЅР°'),
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
                    SnackBar(content: Text('РўСЂР°РЅР·Р°РєС†РёСЏ РѕС‚РїСЂР°РІР»РµРЅР°: $transactionHash')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('РћС€РёР±РєР° РѕС‚РїСЂР°РІРєРё С‚СЂР°РЅР·Р°РєС†РёРё')),
                  );
                }
              }
            },
            child: const Text('РћС‚РїСЂР°РІРёС‚СЊ'),
          ),
        ],
      ),
    );
  }

  void _showReceiveDialog(BuildContext context, Web3Provider web3Provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('РџРѕР»СѓС‡РёС‚СЊ ETH'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Р’Р°С€ Р°РґСЂРµСЃ РґР»СЏ РїРѕР»СѓС‡РµРЅРёСЏ:'),
            const SizedBox(height: 8),
            SelectableText(
              web3Provider.currentAddress ?? 'РќРµ РїРѕРґРєР»СЋС‡РµРЅ',
              style: TextStyle(
                fontFamily: 'monospace',
                backgroundColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16),
            Text('РџРѕРґРµР»РёС‚РµСЃСЊ СЌС‚РёРј Р°РґСЂРµСЃРѕРј РґР»СЏ РїРѕР»СѓС‡РµРЅРёСЏ ETH'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
          ),
        ],
      ),
    );
  }

  void _showMintNFTDialog(BuildContext context, Web3Provider web3Provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('РЎРѕР·РґР°С‚СЊ NFT'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nftNameController,
              decoration: const InputDecoration(
                labelText: 'РќР°Р·РІР°РЅРёРµ NFT',
                hintText: 'РњРѕР№ СѓРЅРёРєР°Р»СЊРЅС‹Р№ С‚РѕРєРµРЅ',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nftDescriptionController,
              decoration: const InputDecoration(
                labelText: 'РћРїРёСЃР°РЅРёРµ',
                hintText: 'РћРїРёСЃР°РЅРёРµ РІР°С€РµРіРѕ NFT',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('РћС‚РјРµРЅР°'),
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
                    const SnackBar(content: Text('NFT СѓСЃРїРµС€РЅРѕ СЃРѕР·РґР°РЅ!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('РћС€РёР±РєР° СЃРѕР·РґР°РЅРёСЏ NFT')),
                  );
                }
              }
            },
            child: const Text('РЎРѕР·РґР°С‚СЊ'),
          ),
        ],
      ),
    );
  }

  void _showSwapTokensDialog(BuildContext context, Web3Provider web3Provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('РћР±РјРµРЅ С‚РѕРєРµРЅРѕРІ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _swapFromController,
              decoration: const InputDecoration(
                labelText: 'РћС‚ С‚РѕРєРµРЅР°',
                hintText: 'ETH',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _swapToController,
              decoration: const InputDecoration(
                labelText: 'Рљ С‚РѕРєРµРЅСѓ',
                hintText: 'USDT',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _swapAmountController,
              decoration: const InputDecoration(
                labelText: 'РљРѕР»РёС‡РµСЃС‚РІРѕ',
                hintText: '0.0',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('РћС‚РјРµРЅР°'),
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
                    const SnackBar(content: Text('РћР±РјРµРЅ РІС‹РїРѕР»РЅРµРЅ СѓСЃРїРµС€РЅРѕ!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('РћС€РёР±РєР° РѕР±РјРµРЅР° С‚РѕРєРµРЅРѕРІ')),
                  );
                }
              }
            },
            child: const Text('РћР±РјРµРЅСЏС‚СЊ'),
          ),
        ],
      ),
    );
  }

  void _showNFTDetailsDialog(BuildContext context, Map<String, dynamic> nft) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Р”РµС‚Р°Р»Рё NFT: ${nft['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('РћРїРёСЃР°РЅРёРµ: ${nft['description']}'),
            Text('Р—РЅР°С‡РµРЅРёРµ: ${nft['value']} ETH'),
            Text('РЎС‚Р°С‚СѓСЃ: ${nft['status']}'),
            Text('Р”Р°С‚Р° СЃРѕР·РґР°РЅРёСЏ: ${nft['created_at']}'),
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
            child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
          ),
        ],
      ),
    );
  }

  void _showTokenDetailsDialog(BuildContext context, Map<String, dynamic> token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Р”РµС‚Р°Р»Рё С‚РѕРєРµРЅР°: ${token['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('РЎРёРјРІРѕР»: ${token['symbol']}'),
            Text('Р‘Р°Р»Р°РЅСЃ: ${token['balance']}'),
            Text('РћР±С‰Р°СЏ СЃС‚РѕРёРјРѕСЃС‚СЊ: \$${token['total_value_usd']}'),
            Text('РР·РјРµРЅРµРЅРёРµ Р·Р° 24С‡: ${token['price_change_24h']}%'),
            Text('РљРѕРЅС‚СЂР°РєС‚: ${token['contract_address']?.substring(0, 8)}...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetailsDialog(BuildContext context, Map<String, dynamic> tx) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Р”РµС‚Р°Р»Рё С‚СЂР°РЅР·Р°РєС†РёРё'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('РўРёРї: ${tx['type']}'),
            Text('РљРѕР»РёС‡РµСЃС‚РІРѕ: ${tx['amount']} ETH'),
            Text('РћС‚: ${tx['from']}'),
            Text('Рљ: ${tx['to']}'),
            Text('РЎС‚Р°С‚СѓСЃ: ${tx['status']}'),
            Text('Р”Р°С‚Р°: ${tx['date']}'),
            if (tx['hash'] != null) ...[
              const SizedBox(height: 8),
              Text('РҐРµС€: ${tx['hash']}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
          ),
        ],
      ),
    );
  }

  void _showAllTransactionsDialog(BuildContext context, Web3Provider web3Provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Р’СЃРµ С‚СЂР°РЅР·Р°РєС†РёРё'),
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
                subtitle: Text('${tx['from']} в†’ ${tx['to']}'),
                trailing: Text(
                  tx['status'] ?? 'Р’ РѕР±СЂР°Р±РѕС‚РєРµ',
                  style: TextStyle(
                    color: tx['status'] == 'РџРѕРґС‚РІРµСЂР¶РґРµРЅРѕ' ? Colors.green : Colors.orange,
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
            child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
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
              // РЎС‚Р°С‚СѓСЃ Р±Р»РѕРєС‡РµР№РЅР°
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'РЎС‚Р°С‚СѓСЃ Р±Р»РѕРєС‡РµР№РЅР°',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildBlockchainMetricCard(
                              'РџРѕСЃР»РµРґРЅРёР№ Р±Р»РѕРє',
                              '${blockchainProvider.blockchainData['last_block_number'] ?? 0}',
                              Icons.block,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildBlockchainMetricCard(
                              'РҐРµС€СЂРµР№С‚',
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
                              'РЎР»РѕР¶РЅРѕСЃС‚СЊ',
                              '${(blockchainProvider.blockchainData['difficulty'] ?? 0.0 / 1000000000000).toStringAsFixed(2)} T',
                              Icons.trending_up,
                              Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildBlockchainMetricCard(
                              'Р’СЂРµРјСЏ Р±Р»РѕРєР°',
                              '${blockchainProvider.blockchainData['block_time'] ?? 0} СЃРµРє',
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

              // DeFi РїСЂРѕС‚РѕРєРѕР»С‹
              Text(
                'DeFi РџСЂРѕС‚РѕРєРѕР»С‹',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ...blockchainProvider.defiProtocols.map((protocol) => _buildProtocolCard(protocol)),
              const SizedBox(height: 24),

              // Р›РёРєРІРёРґРЅРѕСЃС‚СЊ
              Text(
                'РџСѓР»Р»С‹ Р»РёРєРІРёРґРЅРѕСЃС‚Рё',
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

              // РЎРјР°СЂС‚ РєРѕРЅС‚СЂР°РєС‚С‹
              Text(
                'РЎРјР°СЂС‚ РєРѕРЅС‚СЂР°РєС‚С‹',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ...blockchainProvider.smartContracts.map((contract) => _buildSmartContractCard(contract)),
              const SizedBox(height: 24),

              // Р С‹РЅРѕС‡РЅС‹Рµ С‚СЂРµРЅРґС‹
              Text(
                'Р С‹РЅРѕС‡РЅС‹Рµ С‚СЂРµРЅРґС‹',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ...blockchainProvider.marketTrends.map((trend) => _buildMarketTrendCard(trend)),
              const SizedBox(height: 24),

              // Р РµРєРѕРјРµРЅРґР°С†РёРё DeFi
              Text(
                'DeFi Р РµРєРѕРјРµРЅРґР°С†РёРё',
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

  // Р’СЃРїРѕРјРѕРіР°С‚РµР»СЊРЅС‹Рµ РІРёРґР¶РµС‚С‹ РґР»СЏ Р±Р»РѕРєС‡РµР№РЅ РІРєР»Р°РґРєРё
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
        subtitle: Text('Р›РёРєРІРёРґРЅРѕСЃС‚СЊ: \$${(pool['liquidity'] ?? 0.0 / 1000000).toStringAsFixed(1)}M'),
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
              'РљРѕРјРёСЃСЃРёСЏ',
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
        subtitle: Text('РЎС‚РµРєРёРЅРі: ${farm['staked_amount']} ${farm['token_symbol']}'),
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
              'РќР°РіСЂР°РґР°/РґРµРЅСЊ',
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
        subtitle: Text('РђРґСЂРµСЃ: ${contract['address']?.substring(0, 8)}...'),
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
              '${contract['interactions']} РІС‹Р·РѕРІРѕРІ',
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
        subtitle: Text('${trend['timeframe']} С‚СЂРµРЅРґ'),
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
              'РР·РјРµРЅРµРЅРёРµ',
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
        subtitle: Text('Р РёСЃРє: ${rec['risk_level']}'),
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
              'РЎС‡РµС‚',
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
        title: Text('Р”РµС‚Р°Р»Рё СЂРµРєРѕРјРµРЅРґР°С†РёРё'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('РЎС‚СЂР°С‚РµРіРёСЏ: ${rec['strategy']}'),
            const SizedBox(height: 8),
            Text('РћРїРёСЃР°РЅРёРµ: ${rec['description']}'),
            Text('Р РёСЃРє: ${rec['risk_level']}'),
            Text('РћР¶РёРґР°РµРјР°СЏ РґРѕС…РѕРґРЅРѕСЃС‚СЊ: ${(rec['expected_return'] * 100).toStringAsFixed(2)}%'),
            const SizedBox(height: 8),
            Text('РўСЂРµР±РѕРІР°РЅРёСЏ:'),
            ...(rec['requirements'] as List?)?.map((req) => Text('вЂў $req')) ?? [],
            const SizedBox(height: 8),
            Text('РЁР°РіРё:'),
            ...(rec['steps'] as List?)?.map((step) => Text('вЂў $step')) ?? [],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
          ),
        ],
      ),
    );
  }

  // Р”РѕРїРѕР»РЅРёС‚РµР»СЊРЅС‹Рµ РґРёР°Р»РѕРіРё РґР»СЏ Web3Screen
  void _showWalletConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('РџРѕРґРєР»СЋС‡РµРЅРёРµ РєРѕС€РµР»СЊРєР°'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Р’С‹Р±РµСЂРёС‚Рµ СЃРїРѕСЃРѕР± РїРѕРґРєР»СЋС‡РµРЅРёСЏ:'),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.phone_android, color: Colors.blue),
                title: const Text('MetaMask'),
                subtitle: const Text('РџРѕРїСѓР»СЏСЂРЅС‹Р№ Web3 РєРѕС€РµР»РµРє'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('РџРѕРґРєР»СЋС‡РµРЅРёРµ Рє MetaMask...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.qr_code, color: Colors.green),
                title: const Text('WalletConnect'),
                subtitle: const Text('QR-РєРѕРґ РґР»СЏ РјРѕР±РёР»СЊРЅС‹С… РєРѕС€РµР»СЊРєРѕРІ'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('РћС‚РєСЂРѕР№С‚Рµ WalletConnect...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet, color: Colors.purple),
                title: const Text('Coinbase Wallet'),
                subtitle: const Text('РљРѕС€РµР»РµРє РѕС‚ Coinbase'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('РџРѕРґРєР»СЋС‡РµРЅРёРµ Рє Coinbase Wallet...')),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('РћС‚РјРµРЅР°'),
            ),
          ],
        );
      },
    );
  }












}

// РЎРѕС†РёР°Р»СЊРЅС‹Р№ СЌРєСЂР°РЅ
class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> with TickerProviderStateMixin {
  // РђРЅРёРјР°С†РёРё
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

  // РЎРѕСЃС‚РѕСЏРЅРёРµ
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    
    // РРЅРёС†РёР°Р»РёР·Р°С†РёСЏ Р°РЅРёРјР°С†РёР№
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
          'РЎРѕС†РёР°Р»СЊРЅР°СЏ СЃРµС‚СЊ',
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
              // Р¤РѕРЅРѕРІР°СЏ РёРєРѕРЅРєР° СЃРѕС†РёР°Р»СЊРЅРѕР№ СЃРµС‚Рё
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
              // Р¦РµРЅС‚СЂР°Р»СЊРЅР°СЏ РёРєРѕРЅРєР° СЃ РїСѓР»СЊСЃР°С†РёРµР№
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
              // РЎС‚Р°С‚РёСЃС‚РёРєР° РїРѕСЃС‚РѕРІ
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
                        '${socialProvider.posts.length} РїРѕСЃС‚РѕРІ',
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
        // РљРЅРѕРїРєР° СЃРѕР·РґР°РЅРёСЏ РїРѕСЃС‚Р°
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
        // РљРЅРѕРїРєР° С„РёР»СЊС‚СЂРѕРІ
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('Р’СЃРµ РїРѕСЃС‚С‹')),
              const PopupMenuItem(value: 'my', child: Text('РњРѕРё РїРѕСЃС‚С‹')),
              const PopupMenuItem(value: 'liked', child: Text('РџРѕРЅСЂР°РІРёРІС€РёРµСЃСЏ')),
              const PopupMenuItem(value: 'trending', child: Text('РџРѕРїСѓР»СЏСЂРЅС‹Рµ')),
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
            // РЎРѕР·РґР°РЅРёРµ РїРѕСЃС‚Р°
            _buildCreatePostSection(socialProvider),
            const SizedBox(height: 24),
            
            // Р¤РёР»СЊС‚СЂС‹
            _buildFiltersSection(),
            const SizedBox(height: 24),
            
            // Р›РµРЅС‚Р° РїРѕСЃС‚РѕРІ
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
                'РЎРѕР·РґР°С‚СЊ РїРѕСЃС‚',
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
              hintText: 'Р§С‚Рѕ Сѓ РІР°СЃ РЅРѕРІРѕРіРѕ?',
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
                        const SnackBar(content: Text('РџРѕСЃС‚ РѕРїСѓР±Р»РёРєРѕРІР°РЅ!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('РћС€РёР±РєР° РїСЂРё РїСѓР±Р»РёРєР°С†РёРё РїРѕСЃС‚Р°')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Р’РІРµРґРёС‚Рµ С‚РµРєСЃС‚ РїРѕСЃС‚Р°')),
                    );
                  }
                },
                icon: const Icon(Icons.send),
                label: const Text('РћРїСѓР±Р»РёРєРѕРІР°С‚СЊ'),
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
            'Р¤РёР»СЊС‚СЂС‹',
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
              _buildFilterChip('Р’СЃРµ', 'all', Icons.all_inclusive),
              _buildFilterChip('РњРѕРё', 'my', Icons.person),
              _buildFilterChip('РџРѕРЅСЂР°РІРёРІС€РёРµСЃСЏ', 'liked', Icons.favorite),
              _buildFilterChip('РџРѕРїСѓР»СЏСЂРЅС‹Рµ', 'trending', Icons.trending_up),
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
          'Р›РµРЅС‚Р° РїРѕСЃС‚РѕРІ',
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
            // Р—Р°РіРѕР»РѕРІРѕРє РїРѕСЃС‚Р°
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
                        post['username'] ?? 'РџРѕР»СЊР·РѕРІР°С‚РµР»СЊ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        post['created_at'] ?? 'РќРµРґР°РІРЅРѕ',
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
                    const PopupMenuItem(value: 'edit', child: Text('Р РµРґР°РєС‚РёСЂРѕРІР°С‚СЊ')),
                    const PopupMenuItem(value: 'delete', child: Text('РЈРґР°Р»РёС‚СЊ')),
                    const PopupMenuItem(value: 'report', child: Text('РџРѕР¶Р°Р»РѕРІР°С‚СЊСЃСЏ')),
                  ],
                  child: Icon(Icons.more_vert, color: Colors.grey[600]),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // РЎРѕРґРµСЂР¶РёРјРѕРµ РїРѕСЃС‚Р°
            Text(
              post['content'] ?? '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                height: 1.4,
              ),
            ),
            
            // РҐРµС€С‚РµРіРё
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
            
            // РР·РѕР±СЂР°Р¶РµРЅРёРµ
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
            
            // РњРµСЃС‚РѕРїРѕР»РѕР¶РµРЅРёРµ
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
            
            // Р”РµР№СЃС‚РІРёСЏ СЃ РїРѕСЃС‚РѕРј
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
            'РџРѕСЃС‚С‹ РЅРµ РЅР°Р№РґРµРЅС‹',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'РЎРѕР·РґР°Р№С‚Рµ РїРµСЂРІС‹Р№ РїРѕСЃС‚ РёР»Рё РёР·РјРµРЅРёС‚Рµ С„РёР»СЊС‚СЂС‹',
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
        title: const Text('РЎРѕР·РґР°С‚СЊ РїРѕСЃС‚'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _postController,
              decoration: const InputDecoration(
                labelText: 'РўРµРєСЃС‚ РїРѕСЃС‚Р°',
                hintText: 'Р§С‚Рѕ Сѓ РІР°СЃ РЅРѕРІРѕРіРѕ?',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('РћС‚РјРµРЅР°'),
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
                    const SnackBar(content: Text('РџРѕСЃС‚ РѕРїСѓР±Р»РёРєРѕРІР°РЅ!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('РћС€РёР±РєР° РїСЂРё РїСѓР±Р»РёРєР°С†РёРё РїРѕСЃС‚Р°')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Р’РІРµРґРёС‚Рµ С‚РµРєСЃС‚ РїРѕСЃС‚Р°')),
                );
              }
            },
            child: const Text('РћРїСѓР±Р»РёРєРѕРІР°С‚СЊ'),
          ),
        ],
      ),
    );
  }

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Р”РѕР±Р°РІРёС‚СЊ РёР·РѕР±СЂР°Р¶РµРЅРёРµ'),
        content: const Text('Р¤СѓРЅРєС†РёСЏ РґРѕР±Р°РІР»РµРЅРёСЏ РёР·РѕР±СЂР°Р¶РµРЅРёР№ Р±СѓРґРµС‚ РґРѕСЃС‚СѓРїРЅР° РІ СЃР»РµРґСѓСЋС‰РµРј РѕР±РЅРѕРІР»РµРЅРёРё.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
          ),
        ],
      ),
    );
  }

  void _showHashtagDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Р”РѕР±Р°РІРёС‚СЊ С…РµС€С‚РµРіРё'),
        content: const Text('Р¤СѓРЅРєС†РёСЏ РґРѕР±Р°РІР»РµРЅРёСЏ С…РµС€С‚РµРіРѕРІ Р±СѓРґРµС‚ РґРѕСЃС‚СѓРїРЅР° РІ СЃР»РµРґСѓСЋС‰РµРј РѕР±РЅРѕРІР»РµРЅРёРё.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
          ),
        ],
      ),
    );
  }

  void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Р”РѕР±Р°РІРёС‚СЊ РјРµСЃС‚РѕРїРѕР»РѕР¶РµРЅРёРµ'),
        content: const Text('Р¤СѓРЅРєС†РёСЏ РґРѕР±Р°РІР»РµРЅРёСЏ РјРµСЃС‚РѕРїРѕР»РѕР¶РµРЅРёСЏ Р±СѓРґРµС‚ РґРѕСЃС‚СѓРїРЅР° РІ СЃР»РµРґСѓСЋС‰РµРј РѕР±РЅРѕРІР»РµРЅРёРё.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
          ),
        ],
      ),
    );
  }

  void _showCommentsDialog(BuildContext context, Map<String, dynamic> post, SocialProvider socialProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('РљРѕРјРјРµРЅС‚Р°СЂРёРё'),
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
                        hintText: 'Р”РѕР±Р°РІРёС‚СЊ РєРѕРјРјРµРЅС‚Р°СЂРёР№...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        // Р”РѕР±Р°РІР»РµРЅРёРµ РєРѕРјРјРµРЅС‚Р°СЂРёСЏ
                        _commentController.clear();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('РљРѕРјРјРµРЅС‚Р°СЂРёР№ РґРѕР±Р°РІР»РµРЅ!')),
                        );
                      }
                    },
                    child: const Text('РћС‚РїСЂР°РІРёС‚СЊ'),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
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
        title: const Text('Р РµРґР°РєС‚РёСЂРѕРІР°С‚СЊ РїРѕСЃС‚'),
        content: TextField(
          controller: contentController,
          decoration: const InputDecoration(
            labelText: 'РўРµРєСЃС‚ РїРѕСЃС‚Р°',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('РћС‚РјРµРЅР°'),
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
                    const SnackBar(content: Text('РџРѕСЃС‚ РѕР±РЅРѕРІР»РµРЅ!')),
                  );
                }
              }
            },
            child: const Text('РЎРѕС…СЂР°РЅРёС‚СЊ'),
          ),
        ],
      ),
    );
  }

  void _showDeletePostDialog(BuildContext context, Map<String, dynamic> post, SocialProvider socialProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('РЈРґР°Р»РёС‚СЊ РїРѕСЃС‚'),
        content: const Text('Р’С‹ СѓРІРµСЂРµРЅС‹, С‡С‚Рѕ С…РѕС‚РёС‚Рµ СѓРґР°Р»РёС‚СЊ СЌС‚РѕС‚ РїРѕСЃС‚?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('РћС‚РјРµРЅР°'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await socialProvider.deletePost(post['id']);
              if (success) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('РџРѕСЃС‚ СѓРґР°Р»РµРЅ!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('РЈРґР°Р»РёС‚СЊ'),
          ),
        ],
      ),
    );
  }

  void _showReportPostDialog(BuildContext context, Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('РџРѕР¶Р°Р»РѕРІР°С‚СЊСЃСЏ РЅР° РїРѕСЃС‚'),
        content: const Text('Р¤СѓРЅРєС†РёСЏ Р¶Р°Р»РѕР± Р±СѓРґРµС‚ РґРѕСЃС‚СѓРїРЅР° РІ СЃР»РµРґСѓСЋС‰РµРј РѕР±РЅРѕРІР»РµРЅРёРё.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
          ),
        ],
      ),
    );
  }

  // Р”РѕРїРѕР»РЅРёС‚РµР»СЊРЅС‹Рµ РґРёР°Р»РѕРіРё РґР»СЏ SocialScreen
  void _showUserProfileDialog(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('РџСЂРѕС„РёР»СЊ ${user['username'] ?? 'РїРѕР»СЊР·РѕРІР°С‚РµР»СЏ'}'),
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
                user['username'] ?? 'РџРѕР»СЊР·РѕРІР°С‚РµР»СЊ',
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
                        'РџРѕСЃС‚РѕРІ',
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
                        'РџРѕРґРїРёСЃС‡РёРєРѕРІ',
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
                        'РџРѕРґРїРёСЃРѕРє',
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
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('РЎРѕРѕР±С‰РµРЅРёРµ РѕС‚РїСЂР°РІР»РµРЅРѕ!')),
                );
              },
              child: const Text('РќР°РїРёСЃР°С‚СЊ'),
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
          title: const Text('РџРѕРґРµР»РёС‚СЊСЃСЏ РїРѕСЃС‚РѕРј'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.blue),
                title: const Text('РљРѕРїРёСЂРѕРІР°С‚СЊ СЃСЃС‹Р»РєСѓ'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('РЎСЃС‹Р»РєР° СЃРєРѕРїРёСЂРѕРІР°РЅР°!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.green),
                title: const Text('РџРѕРґРµР»РёС‚СЊСЃСЏ РІ СЃРѕС†СЃРµС‚СЏС…'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('РћС‚РєСЂС‹РІР°РµС‚СЃСЏ РїСЂРёР»РѕР¶РµРЅРёРµ...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.message, color: Colors.orange),
                title: const Text('РћС‚РїСЂР°РІРёС‚СЊ РІ СЃРѕРѕР±С‰РµРЅРёРё'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('РћС‚РєСЂС‹РІР°РµС‚СЃСЏ С‡Р°С‚...')),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('РћС‚РјРµРЅР°'),
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
          title: const Text('РђРЅР°Р»РёС‚РёРєР° РїРѕСЃС‚Р°'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _buildAnalyticsRow('РџСЂРѕСЃРјРѕС‚СЂС‹', '${post['views_count'] ?? 0}', Icons.visibility),
                      _buildAnalyticsRow('Р›Р°Р№РєРё', '${post['likes_count'] ?? 0}', Icons.favorite),
                      _buildAnalyticsRow('РљРѕРјРјРµРЅС‚Р°СЂРёРё', '${post['comments_count'] ?? 0}', Icons.comment),
                      _buildAnalyticsRow('Р РµРїРѕСЃС‚С‹', '${post['shares_count'] ?? 0}', Icons.share),
                      _buildAnalyticsRow('Р”РѕСЃСЏРіР°РµРјРѕСЃС‚СЊ', '${post['reach_count'] ?? 0}', Icons.people),
                      _buildAnalyticsRow('Р’РѕРІР»РµС‡РµРЅРЅРѕСЃС‚СЊ', '${(post['engagement_rate'] ?? 0.0).toStringAsFixed(1)}%', Icons.trending_up),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Р­РєСЃРїРѕСЂС‚ Р°РЅР°Р»РёС‚РёРєРё!')),
                );
              },
              child: const Text('Р­РєСЃРїРѕСЂС‚'),
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
          title: const Text('РўСЂРµРЅРґРѕРІС‹Рµ С‚РµРјС‹'),
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
                        title: Text('РўСЂРµРЅРґРѕРІР°СЏ С‚РµРјР° ${index + 1}'),
                        subtitle: Text('${1000 - index * 50} РїРѕСЃС‚РѕРІ'),
                        trailing: Icon(
                          index < 3 ? Icons.trending_up : Icons.trending_flat,
                          color: index < 3 ? Colors.green : Colors.grey,
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('РџРѕРёСЃРє РїРѕ С‚РµРјРµ ${index + 1}')),
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
              child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
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
          title: const Text('РќР°СЃС‚СЂРѕР№РєРё СЃРѕС†РёР°Р»СЊРЅРѕР№ СЃРµС‚Рё'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('РЈРІРµРґРѕРјР»РµРЅРёСЏ Рѕ Р»Р°Р№РєР°С…'),
                subtitle: const Text('РџРѕР»СѓС‡Р°С‚СЊ СѓРІРµРґРѕРјР»РµРЅРёСЏ РєРѕРіРґР° РєС‚Рѕ-С‚Рѕ Р»Р°Р№РєР°РµС‚ РІР°С€Рё РїРѕСЃС‚С‹'),
                value: true,
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('РЈРІРµРґРѕРјР»РµРЅРёСЏ ${value ? 'РІРєР»СЋС‡РµРЅС‹' : 'РѕС‚РєР»СЋС‡РµРЅС‹'}')),
                  );
                },
              ),
              SwitchListTile(
                title: const Text('РЈРІРµРґРѕРјР»РµРЅРёСЏ Рѕ РєРѕРјРјРµРЅС‚Р°СЂРёСЏС…'),
                subtitle: const Text('РџРѕР»СѓС‡Р°С‚СЊ СѓРІРµРґРѕРјР»РµРЅРёСЏ Рѕ РЅРѕРІС‹С… РєРѕРјРјРµРЅС‚Р°СЂРёСЏС…'),
                value: true,
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('РЈРІРµРґРѕРјР»РµРЅРёСЏ ${value ? 'РІРєР»СЋС‡РµРЅС‹' : 'РѕС‚РєР»СЋС‡РµРЅС‹'}')),
                  );
                },
              ),
              SwitchListTile(
                title: const Text('РџСЂРёРІР°С‚РЅРѕСЃС‚СЊ РїСЂРѕС„РёР»СЏ'),
                subtitle: const Text('РЎРґРµР»Р°С‚СЊ РїСЂРѕС„РёР»СЊ РїСЂРёРІР°С‚РЅС‹Рј'),
                value: false,
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('РџСЂРѕС„РёР»СЊ ${value ? 'РїСЂРёРІР°С‚РЅС‹Р№' : 'РїСѓР±Р»РёС‡РЅС‹Р№'}')),
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

  Color _getTrendColor(String? trend) {
    switch (trend) {
      case 'increasing':
        return Colors.green;
      case 'decreasing':
        return Colors.red;
      case 'stable':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getTrendIcon(String? trend) {
    switch (trend) {
      case 'increasing':
        return Icons.trending_up;
      case 'decreasing':
        return Icons.trending_down;
      case 'stable':
        return Icons.trending_flat;
      default:
        return Icons.trending_flat;
    }
  }

  Color _getPercentileColor(int percentile) {
    if (percentile >= 80) return Colors.green;
    if (percentile >= 60) return Colors.blue;
    if (percentile >= 40) return Colors.orange;
    return Colors.red;
  }

  void _showAnomalyDetails(Map<String, dynamic> anomaly) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Р”РµС‚Р°Р»Рё Р°РЅРѕРјР°Р»РёРё'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('РћРїРёСЃР°РЅРёРµ: ${anomaly['description']}'),
            const SizedBox(height: 8),
            Text('РўРёРї: ${anomaly['type']}'),
            Text('РЎРµСЂСЊРµР·РЅРѕСЃС‚СЊ: ${anomaly['severity']}'),
            const SizedBox(height: 8),
            Text('Р’РѕР·РјРѕР¶РЅС‹Рµ РїСЂРёС‡РёРЅС‹:'),
            ...(anomaly['possible_causes'] as List?)?.map((cause) => Text('вЂў $cause')) ?? [],
            const SizedBox(height: 8),
            Text('Р РµРєРѕРјРµРЅРґСѓРµРјС‹Рµ РґРµР№СЃС‚РІРёСЏ:'),
            ...(anomaly['recommended_actions'] as List?)?.map((action) => Text('вЂў $action')) ?? [],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
          ),
        ],
      ),
    );
  }

  void _showPredictionDetails(Map<String, dynamic> prediction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Р”РµС‚Р°Р»Рё РїСЂРµРґСЃРєР°Р·Р°РЅРёСЏ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('РўРёРї: ${prediction['type']}'),
            Text('РЈРІРµСЂРµРЅРЅРѕСЃС‚СЊ: ${(prediction['confidence_level'] * 100).toStringAsFixed(1)}%'),
            const SizedBox(height: 8),
            if (prediction['type'] == 'demand_forecast') ...[
              Text('РљР°С‚РµРіРѕСЂРёСЏ: ${prediction['product_category']}'),
              Text('РџСЂРµРґСЃРєР°Р·Р°РЅРЅС‹Р№ СЃРїСЂРѕСЃ: ${prediction['predicted_demand']}'),
              Text('РЎР»РµРґСѓСЋС‰РёР№ РјРµСЃСЏС†: ${prediction['next_month_prediction']}'),
            ],
            if (prediction['type'] == 'customer_churn') ...[
              Text('Р РёСЃРє: ${prediction['risk_level']}'),
              Text('Р—Р°С‚СЂРѕРЅСѓС‚С‹Рµ РєР»РёРµРЅС‚С‹: ${prediction['affected_customers']}'),
              Text('РџСЂРѕРіРЅРѕР·РёСЂСѓРµРјС‹Рµ РїРѕС‚РµСЂРё: ${prediction['predicted_loss']?.toStringAsFixed(0)} в‚Ѕ'),
            ],
            if (prediction['type'] == 'price_optimization') ...[
              Text('РўРµРєСѓС‰Р°СЏ С†РµРЅР°: ${prediction['current_price']?.toStringAsFixed(0)} в‚Ѕ'),
              Text('РћРїС‚РёРјР°Р»СЊРЅР°СЏ С†РµРЅР°: ${prediction['optimal_price']?.toStringAsFixed(0)} в‚Ѕ'),
              Text('РћР¶РёРґР°РµРјС‹Р№ СЌС„С„РµРєС‚: ${prediction['predicted_impact']}'),
            ],
            const SizedBox(height: 8),
            Text('Р РµРєРѕРјРµРЅРґР°С†РёРё:'),
            ...(prediction['recommendations'] as List?)?.map((rec) => Text('вЂў $rec')) ?? [],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Р—Р°РєСЂС‹С‚СЊ'),
          ),
        ],
      ),
    );
  }
}
