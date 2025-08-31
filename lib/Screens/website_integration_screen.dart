import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebsiteIntegrationScreen extends StatefulWidget {
  const WebsiteIntegrationScreen({Key? key}) : super(key: key);

  @override
  State<WebsiteIntegrationScreen> createState() => _WebsiteIntegrationState();
}

class _WebsiteIntegrationState extends State<WebsiteIntegrationScreen> {
  final String _mainWebsite = 'https://mymodus.shop';
  
  final List<Map<String, dynamic>> _websiteFeatures = [
    {
      'title': 'Онлайн магазин',
      'description': 'Полнофункциональный интернет-магазин с каталогом товаров',
      'icon': Icons.shopping_cart,
      'status': 'active',
      'url': 'https://mymodus.shop/shop',
      'color': Colors.blue,
    },
    {
      'title': 'Блог и новости',
      'description': 'Актуальные новости моды и тренды индустрии',
      'icon': Icons.article,
      'status': 'active',
      'url': 'https://mymodus.shop/blog',
      'color': Colors.green,
    },
    {
      'title': 'О компании',
      'description': 'Информация о бренде My Modus и нашей миссии',
      'icon': Icons.business,
      'status': 'active',
      'url': 'https://mymodus.shop/about',
      'color': Colors.purple,
    },
    {
      'title': 'Контакты',
      'description': 'Способы связи и адреса магазинов',
      'icon': Icons.contact_support,
      'status': 'active',
      'url': 'https://mymodus.shop/contacts',
      'color': Colors.orange,
    },
    {
      'title': 'Доставка и оплата',
      'description': 'Условия доставки и способы оплаты',
      'icon': Icons.local_shipping,
      'status': 'active',
      'url': 'https://mymodus.shop/delivery',
      'color': Colors.red,
    },
    {
      'title': 'Программа лояльности',
      'description': 'Бонусы и скидки для постоянных клиентов',
      'icon': Icons.card_giftcard,
      'status': 'active',
      'url': 'https://mymodus.shop/loyalty',
      'color': Colors.pink,
    },
  ];

  final List<Map<String, dynamic>> _websiteStats = [
    {
      'metric': 'Посетители',
      'value': '15,420',
      'change': '+12.5%',
      'isPositive': true,
      'icon': Icons.visibility,
    },
    {
      'metric': 'Заказы',
      'value': '2,847',
      'change': '+8.3%',
      'isPositive': true,
      'icon': Icons.shopping_bag,
    },
    {
      'metric': 'Конверсия',
      'value': '3.2%',
      'change': '+0.8%',
      'isPositive': true,
      'icon': Icons.trending_up,
    },
    {
      'metric': 'Доход',
      'value': '₽4.2M',
      'change': '+15.7%',
      'isPositive': true,
      'icon': Icons.attach_money,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Интеграция с сайтом'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
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
            // Заголовок и основная информация
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo[400]!, Colors.purple[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'My Modus Shop',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Официальный сайт бренда My Modus',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(Icons.link, color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  _mainWebsite,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
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
                          Icons.web,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _launchURL(_mainWebsite),
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Открыть сайт'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.indigo[600],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _launchURL('$_mainWebsite/admin'),
                          icon: const Icon(Icons.admin_panel_settings),
                          label: const Text('Панель управления'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Статистика сайта
            const Text(
              'Статистика сайта',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: _websiteStats.length,
              itemBuilder: (context, index) {
                final stat = _websiteStats[index];
                return _buildStatCard(stat);
              },
            ),
            
            const SizedBox(height: 24),
            
            // Функции сайта
            const Text(
              'Функции сайта',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _websiteFeatures.length,
              itemBuilder: (context, index) {
                final feature = _websiteFeatures[index];
                return _buildFeatureCard(feature);
              },
            ),
            
            const SizedBox(height: 24),
            
            // Интеграция с приложением
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
                  const Text(
                    'Интеграция с приложением',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Синхронизация данных между сайтом и мобильным приложением обеспечивает единообразный пользовательский опыт.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildIntegrationStatus('Товары', 'Синхронизировано', true),
                      ),
                      Expanded(
                        child: _buildIntegrationStatus('Заказы', 'Синхронизировано', true),
                      ),
                      Expanded(
                        child: _buildIntegrationStatus('Клиенты', 'Синхронизировано', true),
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
  }

  Widget _buildStatCard(Map<String, dynamic> stat) {
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
              Icon(stat['icon'], color: Colors.indigo[600], size: 24),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: stat['isPositive'] ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  stat['change'],
                  style: TextStyle(
                    color: stat['isPositive'] ? Colors.green[700] : Colors.red[700],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            stat['value'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat['metric'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: feature['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            feature['icon'],
            color: feature['color'],
            size: 24,
          ),
        ),
        title: Text(
          feature['title'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              feature['description'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(feature['status']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(feature['status']),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _launchURL(feature['url']),
                  child: const Text('Открыть'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegrationStatus(String label, String status, bool isActive) {
    return Column(
      children: [
        Icon(
          isActive ? Icons.check_circle : Icons.error,
          color: isActive ? Colors.green : Colors.red,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          status,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.grey;
      case 'error':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Активно';
      case 'inactive':
        return 'Неактивно';
      case 'error':
        return 'Ошибка';
      default:
        return 'Неизвестно';
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
