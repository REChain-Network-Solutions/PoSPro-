import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/app_provider.dart';
import 'dart:math' as math;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  String _selectedPeriod = 'week';
  String _selectedMetric = 'sales';
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          if (appProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final stats = appProvider.getGlobalStats();
          if (stats == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Не удалось загрузить статистику'),
                ],
              ),
            );
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Приветствие и быстрые действия
                    _buildWelcomeSection(stats),
                    const SizedBox(height: 24),
                    
                    // KPI карточки
                    _buildKPICards(stats),
                    const SizedBox(height: 24),
                    
                    // Графики и аналитика
                    _buildAnalyticsSection(stats),
                    const SizedBox(height: 24),
                    
                    // Последние активности
                    _buildRecentActivitySection(stats),
                    const SizedBox(height: 24),
                    
                    // Статус системы
                    _buildSystemStatusSection(appProvider),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Построение AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('PoSPro Дашборд'),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        // Период
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_getPeriodText(_selectedPeriod)),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        
        // Метрика
        PopupMenuButton<String>(
          onSelected: (value) {
            setState(() {
              _selectedMetric = value;
            });
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'sales', child: Text('Продажи')),
            const PopupMenuItem(value: 'revenue', child: Text('Доходы')),
            const PopupMenuItem(value: 'products', child: Text('Товары')),
            const PopupMenuItem(value: 'customers', child: Text('Клиенты')),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_getMetricText(_selectedMetric)),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Действия
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            // Обновление данных
            setState(() {});
          },
          tooltip: 'Обновить',
        ),
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: () {
            // Экспорт данных
            _showExportDialog(context);
          },
          tooltip: 'Экспорт',
        ),
      ],
    );
  }

  /// Построение секции приветствия
  Widget _buildWelcomeSection(Map<String, dynamic> stats) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Добро пожаловать в PoSPro!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ваша система управления торговлей с AI и блокчейн возможностями',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildQuickActionButton(
                          icon: Icons.trending_up,
                          label: 'Аналитика',
                          onTap: () {},
                        ),
                        const SizedBox(width: 12),
                        _buildQuickActionButton(
                          icon: Icons.shopping_cart,
                          label: 'Продажи',
                          onTap: () {},
                        ),
                        const SizedBox(width: 12),
                        _buildQuickActionButton(
                          icon: Icons.inventory,
                          label: 'Склад',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(
                  Icons.analytics,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Построение кнопки быстрого действия
  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Построение KPI карточек
  Widget _buildKPICards(Map<String, dynamic> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ключевые показатели',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildKPICard(
              title: 'Товары',
              value: '${stats['products']['total_products'] ?? 0}',
              subtitle: 'Всего товаров',
              icon: Icons.inventory,
              color: Colors.blue,
              trend: stats['products']['trend'] ?? 'stable',
            ),
            _buildKPICard(
              title: 'Продажи',
              value: '${stats['products']['total_products'] ?? 0}',
              subtitle: 'За ${_getPeriodText(_selectedPeriod)}',
              icon: Icons.shopping_cart,
              color: Colors.green,
              trend: 'increasing',
            ),
            _buildKPICard(
              title: 'AI рекомендации',
              value: '${stats['ai']['personal_recommendations_count'] ?? 0}',
              subtitle: 'Персональных',
              icon: Icons.psychology,
              color: Colors.purple,
              trend: stats['ai']['trend'] ?? 'stable',
            ),
            _buildKPICard(
              title: 'Web3 активность',
              value: '${stats['web3']['total_nfts'] ?? 0}',
              subtitle: 'NFT токенов',
              icon: Icons.token,
              color: Colors.orange,
              trend: 'increasing',
            ),
          ],
        ),
      ],
    );
  }

  /// Построение KPI карточки
  Widget _buildKPICard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String trend,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
                _buildTrendIndicator(trend),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Построение индикатора тренда
  Widget _buildTrendIndicator(String trend) {
    IconData icon;
    Color color;
    
    switch (trend) {
      case 'increasing':
        icon = Icons.trending_up;
        color = Colors.green;
        break;
      case 'decreasing':
        icon = Icons.trending_down;
        color = Colors.red;
        break;
      default:
        icon = Icons.trending_flat;
        color = Colors.grey;
    }
    
    return Icon(icon, color: color, size: 20);
  }

  /// Построение секции аналитики
  Widget _buildAnalyticsSection(Map<String, dynamic> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Аналитика и тренды',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildAnalyticsCard(
                title: 'Продажи по категориям',
                child: _buildCategoryChart(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAnalyticsCard(
                title: 'Тренд продаж',
                child: _buildSalesTrendChart(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Построение карточки аналитики
  Widget _buildAnalyticsCard({
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(height: 200, child: child),
          ],
        ),
      ),
    );
  }

  /// Построение графика категорий
  Widget _buildCategoryChart() {
    return CustomPaint(
      painter: CategoryChartPainter(),
      size: const Size(double.infinity, double.infinity),
    );
  }

  /// Построение графика тренда продаж
  Widget _buildSalesTrendChart() {
    return CustomPaint(
      painter: SalesTrendPainter(),
      size: const Size(double.infinity, double.infinity),
    );
  }

  /// Построение секции последних активностей
  Widget _buildRecentActivitySection(Map<String, dynamic> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Последние активности',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) => _buildActivityItem(index),
          ),
        ),
      ],
    );
  }

  /// Построение элемента активности
  Widget _buildActivityItem(int index) {
    final activities = [
      {'type': 'sale', 'message': 'Продажа товара "Элегантное платье"', 'time': '2 минуты назад'},
      {'type': 'inventory', 'message': 'Пополнение склада на 50 единиц', 'time': '15 минут назад'},
      {'type': 'ai', 'message': 'AI создал 3 персональных рекомендации', 'time': '1 час назад'},
      {'type': 'nft', 'message': 'Минт нового NFT токена', 'time': '2 часа назад'},
      {'type': 'social', 'message': 'Новый пост в социальной сети', 'time': '3 часа назад'},
    ];
    
    final activity = activities[index];
    final icon = _getActivityIcon(activity['type']!);
    final color = _getActivityColor(activity['type']!);
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        activity['message']!,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        activity['time']!,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {},
      ),
    );
  }

  /// Получение иконки активности
  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'sale':
        return Icons.shopping_cart;
      case 'inventory':
        return Icons.inventory;
      case 'ai':
        return Icons.psychology;
      case 'nft':
        return Icons.token;
      case 'social':
        return Icons.share;
      default:
        return Icons.info;
    }
  }

  /// Получение цвета активности
  Color _getActivityColor(String type) {
    switch (type) {
      case 'sale':
        return Colors.green;
      case 'inventory':
        return Colors.blue;
      case 'ai':
        return Colors.purple;
      case 'nft':
        return Colors.orange;
      case 'social':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  /// Построение секции статуса системы
  Widget _buildSystemStatusSection(AppProvider appProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Статус системы',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSystemStatusItem(
                  title: 'Аутентификация',
                  status: appProvider.authProvider.isAuthenticated ? 'active' : 'inactive',
                  icon: Icons.security,
                ),
                _buildSystemStatusItem(
                  title: 'Товары',
                  status: appProvider.productProvider.isLoading ? 'loading' : 'active',
                  icon: Icons.inventory,
                ),
                _buildSystemStatusItem(
                  title: 'AI сервисы',
                  status: appProvider.aiProvider.isLoading ? 'loading' : 'active',
                  icon: Icons.psychology,
                ),
                _buildSystemStatusItem(
                  title: 'Web3 интеграция',
                  status: appProvider.web3Provider.isLoading ? 'loading' : 'active',
                  icon: Icons.token,
                ),
                _buildSystemStatusItem(
                  title: 'Аналитика',
                  status: appProvider.analyticsProvider.isLoading ? 'loading' : 'active',
                  icon: Icons.analytics,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Построение элемента статуса системы
  Widget _buildSystemStatusItem({
    required String title,
    required String status,
    required IconData icon,
  }) {
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'active':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'loading':
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
        break;
      case 'inactive':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Icon(statusIcon, color: statusColor, size: 20),
        ],
      ),
    );
  }

  // Вспомогательные методы

  /// Получение текста периода
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

  /// Получение текста метрики
  String _getMetricText(String metric) {
    switch (metric) {
      case 'sales':
        return 'Продажи';
      case 'revenue':
        return 'Доходы';
      case 'products':
        return 'Товары';
      case 'customers':
        return 'Клиенты';
      default:
        return 'Продажи';
    }
  }

  /// Показать диалог экспорта
  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Экспорт данных'),
        content: const Text('Выберите формат для экспорта данных дашборда'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Экспорт в PDF начат')),
              );
            },
            child: const Text('PDF'),
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
        ],
      ),
    );
  }
}

/// Кастомный художник для графика категорий
class CategoryChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 3;

    // Рисуем простую круговую диаграмму
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple];
    final values = [0.4, 0.3, 0.2, 0.1];
    
    double startAngle = 0;
    for (int i = 0; i < values.length; i++) {
      final sweepAngle = values[i] * 2 * math.pi;
      
      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Кастомный художник для графика тренда продаж
class SalesTrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.blue;

    final path = Path();
    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.7),
      Offset(size.width * 0.6, size.height * 0.4),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width, size.height * 0.2),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    // Рисуем точки
    paint.style = PaintingStyle.fill;
    for (final point in points) {
      canvas.drawCircle(point, 4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
