import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/nft_provider.dart';

class NFTScreen extends StatefulWidget {
  const NFTScreen({Key? key}) : super(key: key);

  @override
  State<NFTScreen> createState() => _NFTScreenState();
}

class _NFTScreenState extends State<NFTScreen> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _symbolController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

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
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
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

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.linear,
    ));

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
    _nameController.dispose();
    _descriptionController.dispose();
    _symbolController.dispose();
    _imageUrlController.dispose();
    _priceController.dispose();
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
            child: Consumer<NFTProvider>(
              builder: (context, nftProvider, child) {
                if (nftProvider.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (nftProvider.error != null) {
                  return _buildErrorView(nftProvider);
                }

                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        // Поиск и фильтры
                        _buildSearchAndFilters(),
                        
                        // Быстрая статистика
                        _buildQuickStats(),
                        
                        // Вкладки
                        _buildTabs(),
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



  /// Построение вкладки коллекций
  Widget _buildCollectionsTab() {
    return Consumer<NFTProvider>(
      builder: (context, nftProvider, child) {
        if (nftProvider.collections.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.collections, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Коллекции отсутствуют',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Создайте первую коллекцию',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: nftProvider.collections.length,
          itemBuilder: (context, index) {
            final collection = nftProvider.collections[index];
            return _buildCollectionCard(collection);
          },
        );
      },
    );
  }

  /// Построение карточки коллекции
  Widget _buildCollectionCard(NFTCollection collection) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // Изображение коллекции
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
              child: Image.network(
                collection.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Информация о коллекции
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        collection.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        collection.symbol,
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  collection.description,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Создатель',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          Text(
                            '${collection.creator.substring(0, 6)}...${collection.creator.substring(collection.creator.length - 4)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Токенов',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          Text(
                            '${collection.totalSupply}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Блокчейн',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          Text(
                            collection.blockchain,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showCollectionDetails(context, collection),
                        child: const Text('Подробности'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showMintNFTDialog(context, collectionId: collection.id),
                        child: const Text('Минт NFT'),
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
  }

  /// Построение вкладки токенов
  Widget _buildTokensTab() {
    return Consumer<NFTProvider>(
      builder: (context, nftProvider, child) {
        if (nftProvider.tokens.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.token, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'NFT токены отсутствуют',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Создайте первый NFT',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: nftProvider.tokens.length,
          itemBuilder: (context, index) {
            final token = nftProvider.tokens[index];
            return _buildTokenCard(token);
          },
        );
      },
    );
  }

  /// Построение карточки токена
  Widget _buildTokenCard(NFTToken token) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Изображение токена
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
                child: Image.network(
                  token.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 30),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          
          // Информация о токене
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  token.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  '${token.price} ETH',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showTokenDetails(context, token),
                        child: const Text('Детали'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _buyNFT(context, token),
                        child: const Text('Купить'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          backgroundColor: Colors.blue,
                        ),
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
  }

  /// Построение SliverAppBar
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.purple[600],
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'NFT & Web3',
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
                Colors.purple[600]!,
                Colors.purple[800]!,
                Colors.indigo[700]!,
              ],
            ),
          ),
          child: Center(
            child: AnimatedBuilder(
              animation: _rotateAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotateAnimation.value * 2 * 3.14159,
                  child: const Icon(
                    Icons.token,
                    size: 80,
                    color: Colors.white54,
                  ),
                );
              },
            ),
          ),
        ),
      ),
      actions: [
        Consumer<NFTProvider>(
          builder: (context, nftProvider, child) {
            if (nftProvider.isConnected) {
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.green,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${nftProvider.walletAddress!.substring(0, 6)}...${nftProvider.walletAddress!.substring(nftProvider.walletAddress!.length - 4)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () => _disconnectWallet(context),
                    tooltip: 'Отключить кошелек',
                  ),
                ],
              );
            } else {
              return ElevatedButton.icon(
                onPressed: () => _connectWallet(context),
                icon: const Icon(Icons.account_balance_wallet),
                label: const Text('Подключить кошелек'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.purple[600],
                  elevation: 2,
                ),
              );
            }
          },
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () => _showCreateCollectionDialog(context),
          tooltip: 'Создать коллекцию',
        ),
        IconButton(
          icon: const Icon(Icons.monetization_on, color: Colors.white),
          onPressed: () => _showMintNFTDialog(context),
          tooltip: 'Минт NFT',
        ),
        IconButton(
          icon: const Icon(Icons.analytics, color: Colors.white),
          onPressed: () => _showNFTStatsDialog(context),
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
  Widget _buildErrorView(NFTProvider nftProvider) {
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
              '${nftProvider.error}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red[300],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
                          ElevatedButton.icon(
                onPressed: () {
                  nftProvider.clearError();
                  nftProvider.initialize();
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

  // Диалоги

  /// Диалог подключения кошелька
  void _connectWallet(BuildContext context) async {
    final success = await context.read<NFTProvider>().connectWallet();
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Кошелек успешно подключен!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка подключения: ${context.read<NFTProvider>().error}')),
      );
    }
  }

  /// Отключение кошелька
  void _disconnectWallet(BuildContext context) async {
    final success = await context.read<NFTProvider>().disconnectWallet();
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Кошелек отключен')),
      );
    }
  }

  /// Диалог создания коллекции
  void _showCreateCollectionDialog(BuildContext context) {
    _nameController.clear();
    _descriptionController.clear();
    _symbolController.clear();
    _imageUrlController.clear();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать NFT коллекцию'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Название коллекции',
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
              
              TextField(
                controller: _symbolController,
                decoration: const InputDecoration(
                  labelText: 'Символ (например: MFASH)',
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 16),
              
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL изображения',
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
              final name = _nameController.text.trim();
              final description = _descriptionController.text.trim();
              final symbol = _symbolController.text.trim();
              final imageUrl = _imageUrlController.text.trim();
              
              if (name.isEmpty || description.isEmpty || symbol.isEmpty || imageUrl.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Заполните все поля')),
                );
                return;
              }
              
              final success = await context.read<NFTProvider>().createCollection(
                name, description, symbol, imageUrl
              );
              
              if (success) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Коллекция создана!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ошибка: ${context.read<NFTProvider>().error}')),
                );
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  /// Диалог минта NFT
  void _showMintNFTDialog(BuildContext context, {String? collectionId}) {
    _nameController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
    _priceController.clear();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Минт NFT токена'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Выбор коллекции
              Consumer<NFTProvider>(
                builder: (context, nftProvider, child) {
                  final collections = nftProvider.collections;
                  
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Коллекция',
                      border: OutlineInputBorder(),
                    ),
                    value: collectionId,
                    items: collections.map((collection) {
                      return DropdownMenuItem(
                        value: collection.id,
                        child: Text(collection.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // В реальном приложении здесь будет обновление UI
                    },
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Название токена',
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
              
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL изображения',
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 16),
              
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Цена (ETH)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
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
              // В реальном приложении здесь будет валидация и минт
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('NFT создан!')),
              );
            },
            child: const Text('Минт'),
          ),
        ],
      ),
    );
  }

  /// Диалог покупки NFT
  void _buyNFT(BuildContext context, NFTToken token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Покупка NFT'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Вы хотите купить "${token.name}"?'),
            const SizedBox(height: 16),
            Text('Цена: ${token.price} ETH'),
            const SizedBox(height: 16),
            Text('Текущий владелец: ${token.owner.substring(0, 6)}...${token.owner.substring(token.owner.length - 4)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              final success = await context.read<NFTProvider>().buyNFT(token.id, token.price);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('NFT куплен!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ошибка: ${context.read<NFTProvider>().error}')),
                );
              }
            },
            child: const Text('Купить'),
          ),
        ],
      ),
    );
  }

  /// Диалог деталей коллекции
  void _showCollectionDetails(BuildContext context, NFTCollection collection) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(collection.name),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Описание: ${collection.description}'),
              const SizedBox(height: 16),
              Text('Символ: ${collection.symbol}'),
              Text('Создатель: ${collection.creator}'),
              Text('Токенов: ${collection.totalSupply}'),
              Text('Блокчейн: ${collection.blockchain}'),
              Text('Контракт: ${collection.contractAddress}'),
              Text('Создана: ${_formatDate(collection.createdAt)}'),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  /// Диалог деталей токена
  void _showTokenDetails(BuildContext context, NFTToken token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(token.name),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Описание: ${token.description}'),
              const SizedBox(height: 16),
              Text('Цена: ${token.price} ETH'),
              Text('Владелец: ${token.owner}'),
              Text('Создатель: ${token.creator}'),
              Text('Token ID: ${token.tokenId}'),
              Text('Блокчейн: ${token.blockchain}'),
              Text('Контракт: ${token.contractAddress}'),
              Text('Создан: ${_formatDate(token.createdAt)}'),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  /// Диалог статистики NFT
  void _showNFTStatsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Статистика NFT'),
        content: SizedBox(
          width: 600,
          height: 500,
          child: Consumer<NFTProvider>(
            builder: (context, nftProvider, child) {
              final stats = nftProvider.getNFTStats();
              
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Общая статистика
                    _buildStatCardForDialog('Коллекции', stats['total_collections'] ?? 0),
                    const SizedBox(height: 16),
                    _buildStatCardForDialog('NFT токены', stats['total_tokens'] ?? 0),
                    const SizedBox(height: 16),
                    _buildStatCardForDialog('Общая стоимость', '${(stats['total_value'] ?? 0.0).toStringAsFixed(2)} ETH'),
                    
                    const SizedBox(height: 24),
                    
                    // Статистика по коллекциям
                    const Text('Статистика по коллекциям:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    ...(stats['collection_stats'] as List<dynamic>? ?? []).map((collection) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(collection['name']),
                            Text('${collection['tokens']} токенов • ${collection['value'].toStringAsFixed(2)} ETH'),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Топ NFT
                    const Text('Топ NFT по цене:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    ...(stats['top_nfts'] as List<dynamic>? ?? []).map((nft) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('• ${nft['name']} (${nft['price']} ETH)'),
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
  Widget _buildStatCardForDialog(String title, dynamic value) {
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
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text(
            '$value',
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

  /// Форматирование даты
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
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
              Icon(Icons.search, color: Colors.purple[600]),
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
                    hintText: 'Поиск по коллекциям, токенам, владельцам...',
                    prefixIcon: Icon(Icons.search, color: Colors.purple[600]),
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
                      borderSide: BorderSide(color: Colors.purple[600]!, width: 2),
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
                  icon: Icon(Icons.filter_list, color: Colors.purple[600]),
                  tooltip: 'Фильтры',
                  onSelected: (value) {
                    // В реальном приложении здесь будет фильтрация
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'all',
                      child: Text('Все'),
                    ),
                    const PopupMenuItem(
                      value: 'my_collections',
                      child: Text('Мои коллекции'),
                    ),
                    const PopupMenuItem(
                      value: 'my_tokens',
                      child: Text('Мои токены'),
                    ),
                    const PopupMenuItem(
                      value: 'for_sale',
                      child: Text('На продаже'),
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
                label: const Text('Все'),
                selected: true,
                onSelected: (selected) {},
                selectedColor: Colors.purple[100],
                checkmarkColor: Colors.purple[600],
              ),
              FilterChip(
                label: const Text('Мои коллекции'),
                selected: false,
                onSelected: (selected) {},
                selectedColor: Colors.blue[100],
                checkmarkColor: Colors.blue[600],
              ),
              FilterChip(
                label: const Text('Мои токены'),
                selected: false,
                onSelected: (selected) {},
                selectedColor: Colors.green[100],
                checkmarkColor: Colors.green[600],
              ),
              FilterChip(
                label: const Text('На продаже'),
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
    return Consumer<NFTProvider>(
      builder: (context, nftProvider, child) {
        final stats = nftProvider.getNFTStats();
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.analytics, color: Colors.purple[600]),
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
                        'Коллекции',
                        '${stats['total_collections'] ?? 0}',
                        'шт.',
                        Colors.blue,
                        Icons.collections,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildStatCard(
                        'NFT токены',
                        '${stats['total_tokens'] ?? 0}',
                        'шт.',
                        Colors.green,
                        Icons.token,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildStatCard(
                        'Общая стоимость',
                        '${(stats['total_value'] ?? 0.0).toStringAsFixed(2)}',
                        'ETH',
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
                        'Активные продажи',
                        '${stats['active_sales'] ?? 0}',
                        'шт.',
                        Colors.purple,
                        Icons.shopping_cart,
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

  /// Построение вкладок
  Widget _buildTabs() {
    return Consumer<NFTProvider>(
      builder: (context, nftProvider, child) {
        if (!nftProvider.isConnected) {
          return _buildWalletNotConnected();
        }

        return Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Табы для коллекций и токенов
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        labelColor: Colors.purple[600],
                        unselectedLabelColor: Colors.grey[600],
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        tabs: const [
                          Tab(
                            icon: Icon(Icons.collections),
                            text: 'Коллекции',
                          ),
                          Tab(
                            icon: Icon(Icons.token),
                            text: 'NFT токены',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 600,
                      child: TabBarView(
                        children: [
                          _buildCollectionsTab(),
                          _buildTokensTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Построение экрана без подключенного кошелька
  Widget _buildWalletNotConnected() {
    return Container(
      margin: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _pulseAnimation,
              child: Icon(
                Icons.account_balance_wallet,
                size: 120,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Кошелек не подключен',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Для работы с NFT необходимо подключить Web3 кошелек',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _connectWallet(context),
              icon: const Icon(Icons.account_balance_wallet),
              label: const Text('Подключить кошелек'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
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
            Icon(Icons.settings, color: Colors.purple[600]),
            const SizedBox(width: 12),
            const Text('Настройки NFT'),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.notifications, color: Colors.purple[600]),
                title: const Text('Уведомления'),
                subtitle: const Text('Настройки уведомлений о NFT операциях'),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
              ListTile(
                leading: Icon(Icons.security, color: Colors.purple[600]),
                title: const Text('Безопасность'),
                subtitle: const Text('Настройки безопасности кошелька'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.account_balance, color: Colors.purple[600]),
                title: const Text('Блокчейн'),
                subtitle: const Text('Настройки сети и газа'),
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
