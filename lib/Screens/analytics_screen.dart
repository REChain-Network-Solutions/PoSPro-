import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedPeriod = 'month';
  String _selectedMetric = 'sales';
  
  final List<Map<String, dynamic>> _salesData = [
    {'date': 'Пн', 'sales': 125000, 'orders': 45, 'customers': 38},
    {'date': 'Вт', 'sales': 189000, 'orders': 67, 'customers': 52},
    {'date': 'Ср', 'sales': 156000, 'orders': 54, 'customers': 41},
    {'date': 'Чт', 'sales': 234000, 'orders': 89, 'customers': 67},
    {'date': 'Пт', 'sales': 298000, 'orders': 112, 'customers': 89},
    {'date': 'Сб', 'sales': 345000, 'orders': 134, 'customers': 98},
    {'date': 'Вс', 'sales': 267000, 'orders': 98, 'customers': 76},
  ];

  final List<Map<String, dynamic>> _topCategories = [
    {'name': 'Платья', 'sales': 2340000, 'percentage': 35, 'growth': 12.5},
    {'name': 'Джинсы', 'sales': 1890000, 'percentage': 28, 'growth': 8.7},
    {'name': 'Блузы', 'sales': 1230000, 'percentage': 18, 'growth': 15.3},
    {'name': 'Юбки', 'sales': 890000, 'percentage': 13, 'growth': 6.2},
    {'name': 'Аксессуары', 'sales': 456000, 'percentage': 6, 'growth': 22.1},
  ];

  final List<Map<String, dynamic>> _marketplacePerformance = [
    {'name': 'Ozon', 'sales': 2340000, 'orders': 567, 'rating': 4.8, 'growth': 15.2},
    {'name': 'Wildberries', 'sales': 1890000, 'orders': 445, 'rating': 4.7, 'growth': 12.8},
    {'name': 'Instagram', 'sales': 1230000, 'orders': 234, 'rating': 4.9, 'growth': 28.5},
    {'name': 'Собственный сайт', 'sales': 890000, 'orders': 178, 'rating': 4.9, 'growth': 8.9},
    {'name': 'Telegram', 'sales': 456000, 'orders': 89, 'rating': 4.8, 'growth': 18.7},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Аналитика'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и фильтры
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[400]!, Colors.teal[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Бизнес аналитика',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Анализируйте эффективность и принимайте обоснованные решения',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.analytics,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedPeriod,
                          decoration: InputDecoration(
                            labelText: 'Период',
                            labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                          ),
                          style: const TextStyle(color: Colors.white),
                          dropdownColor: Colors.teal[600],
                          items: const [
                            DropdownMenuItem(value: 'week', child: Text('Неделя')),
                            DropdownMenuItem(value: 'month', child: Text('Месяц')),
                            DropdownMenuItem(value: 'quarter', child: Text('Квартал')),
                            DropdownMenuItem(value: 'year', child: Text('Год')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedPeriod = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedMetric,
                          decoration: InputDecoration(
                            labelText: 'Метрика',
                            labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                          ),
                          style: const TextStyle(color: Colors.white),
                          dropdownColor: Colors.teal[600],
                          items: const [
                            DropdownMenuItem(value: 'sales', child: Text('Продажи')),
                            DropdownMenuItem(value: 'orders', child: Text('Заказы')),
                            DropdownMenuItem(value: 'customers', child: Text('Клиенты')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedMetric = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Ключевые показатели
            const Text(
              'Ключевые показатели',
              style: TextStyle(
                fontSize: 22,
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
                _buildKPICard('Общие продажи', '₽${_calculateTotalSales()}', Icons.trending_up, Colors.green, 15.2),
                _buildKPICard('Заказы', '${_calculateTotalOrders()}', Icons.shopping_cart, Colors.blue, 12.8),
                _buildKPICard('Клиенты', '${_calculateTotalCustomers()}', Icons.people, Colors.orange, 18.5),
                _buildKPICard('Средний чек', '₽${_calculateAverageOrder()}', Icons.receipt, Colors.purple, 8.7),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // График продаж
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Динамика продаж',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.trending_up, color: Colors.green, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '+${_calculateGrowthRate()}%',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: _buildSalesChart(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Топ категории
            const Text(
              'Топ категории',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                children: _topCategories.map((category) {
                  return _buildCategoryRow(category);
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Эффективность маркетплейсов
            const Text(
              'Эффективность маркетплейсов',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _marketplacePerformance.length,
              itemBuilder: (context, index) {
                final marketplace = _marketplacePerformance[index];
                return _buildMarketplaceRow(marketplace);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color, double growth) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+${growth.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesChart() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: _salesData.asMap().entries.map((entry) {
        final index = entry.key;
        final data = entry.value;
        final maxValue = _salesData.map((d) => d['sales']).reduce((a, b) => a > b ? a : b);
        final height = (data['sales'] / maxValue) * 160;
        
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 30,
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.green[400]!, Colors.teal[600]!],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data['date'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryRow(Map<String, dynamic> category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              category['name'],
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₽${(category['sales'] / 1000000).toStringAsFixed(1)}M',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${category['percentage']}%',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: category['growth'] > 0 ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${category['growth'] > 0 ? '+' : ''}${category['growth']}%',
                style: TextStyle(
                  color: category['growth'] > 0 ? Colors.green[700] : Colors.red[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketplaceRow(Map<String, dynamic> marketplace) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              marketplace['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₽${(marketplace['sales'] / 1000000).toStringAsFixed(1)}M',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${marketplace['orders']} заказов',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${marketplace['rating']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: marketplace['growth'] > 0 ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${marketplace['growth'] > 0 ? '+' : ''}${marketplace['growth']}%',
                style: TextStyle(
                  color: marketplace['growth'] > 0 ? Colors.green[700] : Colors.red[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateTotalSales() {
    return _salesData.fold<int>(0, (sum, data) => sum + (data['sales'] as int));
  }

  int _calculateTotalOrders() {
    return _salesData.fold<int>(0, (sum, data) => sum + (data['orders'] as int));
  }

  int _calculateTotalCustomers() {
    return _salesData.fold<int>(0, (sum, data) => sum + (data['customers'] as int));
  }

  int _calculateAverageOrder() {
    final totalSales = _calculateTotalSales();
    final totalOrders = _calculateTotalOrders();
    return totalOrders > 0 ? totalSales ~/ totalOrders : 0;
  }

  double _calculateGrowthRate() {
    // Простая логика для демонстрации
    return 15.2;
  }
}
