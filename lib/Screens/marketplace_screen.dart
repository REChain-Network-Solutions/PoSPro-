import 'package:flutter/material.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final List<Map<String, dynamic>> _marketplaces = [
    {
      'id': 1,
      'name': 'Ozon',
      'logo': 'https://via.placeholder.com/80x80/005BFF/FFFFFF?text=OZON',
      'url': 'https://www.ozon.ru/brand/modus-fashion-100287631/',
      'status': 'active',
      'products': 156,
      'sales': 2340,
      'rating': 4.8,
      'reviews': 892,
      'commission': 15.0,
      'lastSync': DateTime.now().subtract(const Duration(hours: 2)),
      'trending': true,
    },
    {
      'id': 2,
      'name': 'Wildberries',
      'logo': 'https://via.placeholder.com/80x80/CB11AB/FFFFFF?text=WB',
      'url': 'https://www.wildberries.ru/seller/51946',
      'status': 'active',
      'products': 203,
      'sales': 1890,
      'rating': 4.7,
      'reviews': 756,
      'commission': 12.5,
      'lastSync': DateTime.now().subtract(const Duration(hours: 1)),
      'trending': true,
    },
    {
      'id': 3,
      'name': 'Avito',
      'logo': 'https://via.placeholder.com/80x80/00A1FF/FFFFFF?text=AVITO',
      'url': 'https://www.avito.ru/user/2f8b6893c14fcb7aa600e1df2010ddd2/profile',
      'status': 'active',
      'products': 89,
      'sales': 567,
      'rating': 4.6,
      'reviews': 234,
      'commission': 0.0,
      'lastSync': DateTime.now().subtract(const Duration(hours: 3)),
      'trending': false,
    },
    {
      'id': 4,
      'name': 'Instagram',
      'logo': 'https://via.placeholder.com/80x80/E4405F/FFFFFF?text=INSTA',
      'url': 'https://www.instagram.com/my.modus.new/',
      'status': 'active',
      'products': 67,
      'sales': 1234,
      'rating': 4.9,
      'reviews': 445,
      'commission': 0.0,
      'lastSync': DateTime.now().subtract(const Duration(minutes: 30)),
      'trending': true,
    },
    {
      'id': 5,
      'name': 'Telegram',
      'logo': 'https://via.placeholder.com/80x80/0088CC/FFFFFF?text=TG',
      'url': 'https://t.me/modusfashion',
      'status': 'active',
      'products': 45,
      'sales': 890,
      'rating': 4.8,
      'reviews': 178,
      'commission': 0.0,
      'lastSync': DateTime.now().subtract(const Duration(minutes: 15)),
      'trending': false,
    },
    {
      'id': 6,
      'name': 'Собственный сайт',
      'logo': 'https://via.placeholder.com/80x80/FF6B6B/FFFFFF?text=WEB',
      'url': 'https://mymodus.ru',
      'status': 'active',
      'products': 312,
      'sales': 4567,
      'rating': 4.9,
      'reviews': 1234,
      'commission': 0.0,
      'lastSync': DateTime.now().subtract(const Duration(minutes: 5)),
      'trending': true,
    },
  ];

  final List<Map<String, dynamic>> _topProducts = [
    {
      'id': 1,
      'name': 'Платье-миди с цветочным принтом',
      'marketplace': 'Ozon',
      'price': 12999,
      'sales': 156,
      'rating': 4.8,
      'reviews': 89,
      'image': 'https://via.placeholder.com/120x160/FF6B9D/FFFFFF?text=Dress',
      'trending': true,
    },
    {
      'id': 2,
      'name': 'Джинсы mom-fit с высокой талией',
      'marketplace': 'Wildberries',
      'price': 8999,
      'sales': 134,
      'rating': 4.7,
      'reviews': 67,
      'image': 'https://via.placeholder.com/120x160/4ECDC4/FFFFFF?text=Jeans',
      'trending': true,
    },
    {
      'id': 3,
      'name': 'Блуза из шелка с бантом',
      'marketplace': 'Instagram',
      'price': 6999,
      'sales': 98,
      'rating': 4.9,
      'reviews': 45,
      'image': 'https://via.placeholder.com/120x160/45B7D1/FFFFFF?text=Blouse',
      'trending': true,
    },
    {
      'id': 4,
      'name': 'Юбка-карандаш с разрезом',
      'marketplace': 'Собственный сайт',
      'price': 5999,
      'sales': 87,
      'rating': 4.6,
      'reviews': 34,
      'image': 'https://via.placeholder.com/120x160/96CEB4/FFFFFF?text=Skirt',
      'trending': false,
    },
  ];

  String _selectedStatus = 'Все';
  final List<String> _statuses = ['Все', 'Активные', 'Неактивные', 'Ошибки'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Маркетплейсы'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
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
            // Статистика по маркетплейсам
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.indigo[600]!],
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
                              'Мультиканальные продажи',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Управляйте продажами на всех платформах из одного места',
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
                          Icons.store,
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
                        child: _buildMarketplaceStat('Платформы', '${_marketplaces.length}', Colors.white),
                      ),
                                             Expanded(
                         child: _buildMarketplaceStat('Товары', '${_marketplaces.fold<int>(0, (sum, m) => sum + (m['products'] as int))}', Colors.white),
                       ),
                       Expanded(
                         child: _buildMarketplaceStat('Продажи', '${_marketplaces.fold<int>(0, (sum, m) => sum + (m['sales'] as int))}', Colors.white),
                       ),
                      Expanded(
                        child: _buildMarketplaceStat('Рейтинг', '${(_marketplaces.fold(0.0, (sum, m) => sum + m['rating']) / _marketplaces.length).toStringAsFixed(1)}', Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Фильтры
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: InputDecoration(
                      labelText: 'Статус',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: _statuses.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.sync),
                    label: const Text('Синхронизировать'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Список маркетплейсов
            const Text(
              'Подключенные платформы',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _marketplaces.length,
              itemBuilder: (context, index) {
                final marketplace = _marketplaces[index];
                return _buildMarketplaceCard(marketplace);
              },
            ),
            
            const SizedBox(height: 24),
            
            // Топ товары по платформам
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Топ товары по платформам',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Смотреть все'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _topProducts.length,
                itemBuilder: (context, index) {
                  final product = _topProducts[index];
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 16),
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
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(
                            product['image'],
                            width: double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product['marketplace'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₽${product['price']}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 12),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${product['rating']}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${product['sales']}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Подключить платформу', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildMarketplaceStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMarketplaceCard(Map<String, dynamic> marketplace) {
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
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            marketplace['logo'],
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                marketplace['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(marketplace['status']),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getStatusText(marketplace['status']),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                _buildMarketplaceInfo('Товары', '${marketplace['products']}'),
                const SizedBox(width: 16),
                _buildMarketplaceInfo('Продажи', '${marketplace['sales']}'),
                const SizedBox(width: 16),
                _buildMarketplaceInfo('Рейтинг', '${marketplace['rating']}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildMarketplaceInfo('Комиссия', '${marketplace['commission']}%'),
                const SizedBox(width: 16),
                _buildMarketplaceInfo('Отзывы', '${marketplace['reviews']}'),
                const Spacer(),
                Text(
                  'Обновлено: ${_formatLastSync(marketplace['lastSync'])}',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'sync',
              child: Row(
                children: [
                  Icon(Icons.sync, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Синхронизировать'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Редактировать'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'analytics',
              child: Row(
                children: [
                  Icon(Icons.analytics, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Аналитика'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'disconnect',
              child: Row(
                children: [
                  Icon(Icons.link_off, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Отключить'),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            // Обработка выбора меню
          },
        ),
      ),
    );
  }

  Widget _buildMarketplaceInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
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
        return 'Активна';
      case 'inactive':
        return 'Неактивна';
      case 'error':
        return 'Ошибка';
      default:
        return 'Неизвестно';
    }
  }

  String _formatLastSync(DateTime lastSync) {
    final now = DateTime.now();
    final difference = now.difference(lastSync);
    
    if (difference.inMinutes < 1) {
      return 'Сейчас';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} мин назад';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ч назад';
    } else {
      return '${difference.inDays} дн назад';
    }
  }
}
