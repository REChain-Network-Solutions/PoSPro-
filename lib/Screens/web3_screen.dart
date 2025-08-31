import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/web3_provider.dart';
import '../Provider/blockchain_provider.dart';
import 'dart:math' as math;

class Web3Screen extends StatefulWidget {
  const Web3Screen({Key? key}) : super(key: key);

  @override
  State<Web3Screen> createState() => _Web3ScreenState();
}

class _Web3ScreenState extends State<Web3Screen> with TickerProviderStateMixin {
  String _selectedTab = 'wallet';
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  
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
    
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Web3Provider>(
      builder: (context, web3Provider, child) {
        return Scaffold(
          appBar: _buildAppBar(web3Provider),
          body: FadeTransition(
            opacity: _fadeController,
            child: _buildWeb3Content(web3Provider),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(Web3Provider web3Provider) {
    return AppBar(
      title: Row(
        children: [
          Icon(Icons.web, color: Colors.white),
          const SizedBox(width: 8),
          Text('PoSPro Web3', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        // Статус подключения
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: web3Provider.isConnected ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                web3Provider.isConnected ? Icons.wifi : Icons.wifi_off,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                web3Provider.isConnected ? 'ON' : 'OFF',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Меню вкладок
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          onSelected: (value) {
            setState(() {
              _selectedTab = value;
              _scaleController.reset();
              _scaleController.forward();
            });
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'wallet',
              child: Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text('Кошелек'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'nfts',
              child: Row(
                children: [
                  Icon(Icons.image, color: Colors.purple),
                  const SizedBox(width: 8),
                  Text('NFTs'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'tokens',
              child: Row(
                children: [
                  Icon(Icons.token, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text('Токены'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'transactions',
              child: Row(
                children: [
                  Icon(Icons.receipt_long, color: Colors.green),
                  const SizedBox(width: 8),
                  Text('Транзакции'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'blockchain',
              child: Row(
                children: [
                  Icon(Icons.block, color: Colors.red),
                  const SizedBox(width: 8),
                  Text('Блокчейн'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeb3Content(Web3Provider web3Provider) {
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
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      )),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Приветствие
            _buildWelcomeSection(web3Provider),
            const SizedBox(height: 24),
            
            // Статус подключения
            _buildConnectionStatusCard(web3Provider),
            const SizedBox(height: 24),
            
            // Быстрые действия
            if (web3Provider.isConnected) _buildQuickActionsSection(web3Provider),
            
            // Статистика кошелька
            if (web3Provider.isConnected) _buildWalletStatsSection(web3Provider),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(Web3Provider web3Provider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).primaryColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.account_balance_wallet,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    web3Provider.isConnected ? 'Добро пожаловать в Web3!' : 'Подключитесь к Web3',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    web3Provider.isConnected 
                        ? 'Ваш кошелек подключен и готов к работе'
                        : 'Подключите кошелек для доступа к DeFi и NFT',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatusCard(Web3Provider web3Provider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: web3Provider.isConnected ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
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
                        web3Provider.isConnected ? 'Подключено' : 'Отключено',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        web3Provider.isConnected ? 'Кошелек активен' : 'Требуется подключение',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            if (web3Provider.isConnected) ...[
              const SizedBox(height: 20),
              _buildWalletInfoRow('Адрес', web3Provider.currentAddress ?? '', Icons.account_circle),
              const SizedBox(height: 12),
              _buildWalletInfoRow('Сеть', web3Provider.currentNetwork ?? '', Icons.network_check),
              const SizedBox(height: 12),
              _buildWalletInfoRow('Баланс', '${web3Provider.ethBalance} ETH', Icons.account_balance),
            ],
            
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: web3Provider.isConnected ? Colors.red : Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontFamily: label == 'Адрес' ? 'monospace' : null,
                ),
              ),
            ],
          ),
        ),
        if (label == 'Адрес')
          IconButton(
            onPressed: () {
              // Копировать адрес в буфер обмена
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Адрес скопирован')),
              );
            },
            icon: Icon(Icons.copy, size: 20),
            tooltip: 'Копировать адрес',
          ),
      ],
    );
  }

  Widget _buildQuickActionsSection(Web3Provider web3Provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Быстрые действия',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Отправить ETH',
                Icons.send,
                Colors.blue,
                () => _showSendTransactionDialog(context, web3Provider),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                'Получить',
                Icons.download,
                Colors.green,
                () => _showReceiveDialog(context, web3Provider),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Обмен токенов',
                Icons.swap_horiz,
                Colors.orange,
                () => _showSwapTokensDialog(context, web3Provider),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                'Создать NFT',
                Icons.add_photo_alternate,
                Colors.purple,
                () => _showMintNFTDialog(context, web3Provider),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
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
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletStatsSection(Web3Provider web3Provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Статистика кошелька',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Общая стоимость',
                '\$${(web3Provider.ethBalance * 2000).toStringAsFixed(2)}',
                Icons.attach_money,
                Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Транзакции',
                '${web3Provider.userTransactions.length}',
                Icons.receipt,
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'NFTs',
                '${web3Provider.userNFTs.length}',
                Icons.image,
                Colors.purple,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Токены',
                '${web3Provider.userTokens.length}',
                Icons.token,
                Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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

  void _showSendTransactionDialog(BuildContext context, Web3Provider web3Provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.send, color: Colors.blue),
            const SizedBox(width: 8),
            Text('Отправить ETH'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Адрес получателя',
                hintText: '0x...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Количество ETH',
                hintText: '0.0',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Отмена'),
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
            child: Text('Отправить'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReceiveDialog(BuildContext context, Web3Provider web3Provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.download, color: Colors.green),
            const SizedBox(width: 8),
            Text('Получить ETH'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ваш адрес для получения:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: SelectableText(
                web3Provider.currentAddress ?? 'Не подключен',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Поделитесь этим адресом для получения ETH',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showSwapTokensDialog(BuildContext context, Web3Provider web3Provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.swap_horiz, color: Colors.orange),
            const SizedBox(width: 8),
            Text('Обмен токенов'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'От токена',
                hintText: 'ETH',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              items: [
                DropdownMenuItem(value: 'ETH', child: Text('ETH')),
                DropdownMenuItem(value: 'USDT', child: Text('USDT')),
                DropdownMenuItem(value: 'USDC', child: Text('USDC')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'К токену',
                hintText: 'USDT',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              items: [
                DropdownMenuItem(value: 'USDT', child: Text('USDT')),
                DropdownMenuItem(value: 'ETH', child: Text('ETH')),
                DropdownMenuItem(value: 'USDC', child: Text('USDC')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _swapAmountController,
              decoration: InputDecoration(
                labelText: 'Количество',
                hintText: '0.0',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(_swapAmountController.text);
              if (amount != null && amount > 0) {
                final success = await web3Provider.swapTokens(
                  fromToken: 'ETH',
                  toToken: 'USDT',
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
            child: Text('Обменять'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMintNFTDialog(BuildContext context, Web3Provider web3Provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.add_photo_alternate, color: Colors.purple),
            const SizedBox(width: 8),
            Text('Создать NFT'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nftNameController,
              decoration: InputDecoration(
                labelText: 'Название NFT',
                hintText: 'Мой уникальный токен',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nftDescriptionController,
              decoration: InputDecoration(
                labelText: 'Описание',
                hintText: 'Описание вашего NFT',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Отмена'),
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
            child: Text('Создать'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNFTDetailsDialog(BuildContext context, Map<String, dynamic> nft) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.image, color: Colors.purple),
            const SizedBox(width: 8),
            Text('Детали NFT: ${nft['name']}'),
          ],
        ),
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
            child: Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showTokenDetailsDialog(BuildContext context, Map<String, dynamic> token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.token, color: Colors.orange),
            const SizedBox(width: 8),
            Text('Детали токена: ${token['name']}'),
          ],
        ),
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
            child: Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetailsDialog(BuildContext context, Map<String, dynamic> tx) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.receipt_long, color: Colors.blue),
            const SizedBox(width: 8),
            Text('Детали транзакции'),
          ],
        ),
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
            child: Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  Widget _buildNFTsTab(Web3Provider web3Provider) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      )),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и статистика
            _buildNFTsHeader(web3Provider),
            const SizedBox(height: 24),
            
            // Поиск и фильтры
            _buildNFTSearchAndFilters(),
            const SizedBox(height: 24),
            
            // Список NFTs
            if (web3Provider.userNFTs.isNotEmpty)
              _buildNFTsGrid(web3Provider)
            else
              _buildEmptyNFTsState(web3Provider),
          ],
        ),
      ),
    );
  }

  Widget _buildNFTsHeader(Web3Provider web3Provider) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Мои NFTs',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${web3Provider.userNFTs.length} токенов в коллекции',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _showMintNFTDialog(context, web3Provider),
          icon: Icon(Icons.add_photo_alternate),
          label: Text('Создать NFT'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNFTSearchAndFilters() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Поиск по названию или описанию...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Статус',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(value: 'all', child: Text('Все')),
                      DropdownMenuItem(value: 'active', child: Text('Активные')),
                      DropdownMenuItem(value: 'pending', child: Text('В обработке')),
                    ],
                    onChanged: (value) {},
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
                    ),
                    items: [
                      DropdownMenuItem(value: 'newest', child: Text('Сначала новые')),
                      DropdownMenuItem(value: 'oldest', child: Text('Сначала старые')),
                      DropdownMenuItem(value: 'value', child: Text('По стоимости')),
                    ],
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNFTsGrid(Web3Provider web3Provider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: web3Provider.userNFTs.length,
      itemBuilder: (context, index) {
        final nft = web3Provider.userNFTs[index];
        return _buildNFTCard(nft, index);
      },
    );
  }

  Widget _buildNFTCard(Map<String, dynamic> nft, int index) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _scaleController,
        curve: Interval(index * 0.1, 1.0, curve: Curves.easeOutBack),
      )),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () => _showNFTDetailsDialog(context, nft),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Изображение NFT
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    color: Colors.grey[100],
                  ),
                  child: nft['image_url'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(
                            nft['image_url'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                              );
                            },
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: Icon(
                            Icons.image,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                        ),
                ),
              ),
              
              // Информация о NFT
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nft['name'] ?? 'Без названия',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nft['description'] ?? 'Без описания',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(nft['status']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            nft['status'] ?? 'Активен',
                            style: TextStyle(
                              color: _getStatusColor(nft['status']),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          '${nft['value']} ETH',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
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
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Активен':
        return Colors.green;
      case 'В обработке':
        return Colors.orange;
      case 'Заблокирован':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEmptyNFTsState(Web3Provider web3Provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.image_not_supported,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'NFT не найдены',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Создайте свой первый NFT или подключите кошелек',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showMintNFTDialog(context, web3Provider),
            icon: Icon(Icons.add_photo_alternate),
            label: Text('Создать первый NFT'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokensTab(Web3Provider web3Provider) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      )),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и статистика
            _buildTokensHeader(web3Provider),
            const SizedBox(height: 24),
            
            // Поиск и фильтры
            _buildTokensSearchAndFilters(),
            const SizedBox(height: 24),
            
            // Список токенов
            if (web3Provider.userTokens.isNotEmpty)
              _buildTokensList(web3Provider)
            else
              _buildEmptyTokensState(web3Provider),
          ],
        ),
      ),
    );
  }

  Widget _buildTokensHeader(Web3Provider web3Provider) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Мои токены',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${web3Provider.userTokens.length} токенов в портфеле',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _showSwapTokensDialog(context, web3Provider),
          icon: Icon(Icons.swap_horiz),
          label: Text('Обмен'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTokensSearchAndFilters() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Поиск по названию или символу...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Сортировка',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(value: 'value', child: Text('По стоимости')),
                      DropdownMenuItem(value: 'change', child: Text('По изменению')),
                      DropdownMenuItem(value: 'balance', child: Text('По балансу')),
                    ],
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Период',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(value: '24h', child: Text('24 часа')),
                      DropdownMenuItem(value: '7d', child: Text('7 дней')),
                      DropdownMenuItem(value: '30d', child: Text('30 дней')),
                    ],
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokensList(Web3Provider web3Provider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: web3Provider.userTokens.length,
      itemBuilder: (context, index) {
        final token = web3Provider.userTokens[index];
        return _buildTokenCard(token, index);
      },
    );
  }

  Widget _buildTokenCard(Map<String, dynamic> token, int index) {
    final priceChange = token['price_change_24h'] ?? 0.0;
    final isPositive = priceChange >= 0;
    
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _scaleController,
        curve: Interval(index * 0.1, 1.0, curve: Curves.easeOutBack),
      )),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => _showTokenDetailsDialog(context, token),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Иконка токена
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    token['symbol']?[0]?.toUpperCase() ?? 'T',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Информация о токене
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${token['name']} (${token['symbol']})',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Баланс: ${token['balance']}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Стоимость и изменение
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${token['total_value_usd']}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPositive ? Icons.trending_up : Icons.trending_down,
                            size: 16,
                            color: isPositive ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${priceChange.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: isPositive ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyTokensState(Web3Provider web3Provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.token,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Токены не найдены',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Подключите кошелек или купите токены',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showSwapTokensDialog(context, web3Provider),
            icon: Icon(Icons.swap_horiz),
            label: Text('Купить токены'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab(Web3Provider web3Provider) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      )),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и статистика
            _buildTransactionsHeader(web3Provider),
            const SizedBox(height: 24),
            
            // Фильтры и поиск
            _buildTransactionsFilters(),
            const SizedBox(height: 24),
            
            // Список транзакций
            if (web3Provider.userTransactions.isNotEmpty)
              _buildTransactionsList(web3Provider)
            else
              _buildEmptyTransactionsState(web3Provider),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsHeader(Web3Provider web3Provider) {
    final totalTransactions = web3Provider.userTransactions.length;
    final confirmedTransactions = web3Provider.userTransactions
        .where((tx) => tx['status'] == 'Подтверждено')
        .length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'История транзакций',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTransactionStatCard(
                'Всего',
                '$totalTransactions',
                Icons.receipt_long,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTransactionStatCard(
                'Подтверждено',
                '$confirmedTransactions',
                Icons.check_circle,
                Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTransactionStatCard(
                'В обработке',
                '${totalTransactions - confirmedTransactions}',
                Icons.pending,
                Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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

  Widget _buildTransactionsFilters() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Поиск по хешу или адресу...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Статус',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(value: 'all', child: Text('Все')),
                      DropdownMenuItem(value: 'confirmed', child: Text('Подтверждено')),
                      DropdownMenuItem(value: 'pending', child: Text('В обработке')),
                      DropdownMenuItem(value: 'failed', child: Text('Неудачно')),
                    ],
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Тип',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(value: 'all', child: Text('Все')),
                      DropdownMenuItem(value: 'send', child: Text('Отправка')),
                      DropdownMenuItem(value: 'receive', child: Text('Получение')),
                    ],
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList(Web3Provider web3Provider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: web3Provider.userTransactions.length,
      itemBuilder: (context, index) {
        final tx = web3Provider.userTransactions[index];
        return _buildTransactionCard(tx, index);
      },
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> tx, int index) {
    final isSend = tx['type'] == 'send';
    final status = tx['status'] ?? 'В обработке';
    final statusColor = _getTransactionStatusColor(status);
    
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _scaleController,
        curve: Interval(index * 0.1, 1.0, curve: Curves.easeOutBack),
      )),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => _showTransactionDetailsDialog(context, tx),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Иконка типа транзакции
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (isSend ? Colors.red : Colors.green).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isSend ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isSend ? Colors.red : Colors.green,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Информация о транзакции
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${tx['amount']} ETH',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${tx['from']} → ${tx['to']}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontFamily: 'monospace',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tx['date'] ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Статус
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (tx['hash'] != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${tx['hash'].substring(0, 8)}...',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                          fontFamily: 'monospace',
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTransactionStatusColor(String status) {
    switch (status) {
      case 'Подтверждено':
        return Colors.green;
      case 'В обработке':
        return Colors.orange;
      case 'Неудачно':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEmptyTransactionsState(Web3Provider web3Provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Транзакции не найдены',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Выполните первую транзакцию или подключите кошелек',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showSendTransactionDialog(context, web3Provider),
            icon: Icon(Icons.send),
            label: Text('Отправить ETH'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockchainTab(Web3Provider web3Provider) {
    return Consumer<BlockchainProvider>(
      builder: (context, blockchainProvider, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _slideController,
            curve: Curves.easeOutCubic,
          )),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Статус блокчейна
                _buildBlockchainStatusSection(blockchainProvider),
                const SizedBox(height: 24),
                
                // DeFi протоколы
                _buildDeFiProtocolsSection(blockchainProvider),
                const SizedBox(height: 24),
                
                // Пуллы ликвидности
                _buildLiquidityPoolsSection(blockchainProvider),
                const SizedBox(height: 24),
                
                // Yield Farming
                _buildYieldFarmingSection(blockchainProvider),
                const SizedBox(height: 24),
                
                // Смарт контракты
                _buildSmartContractsSection(blockchainProvider),
                const SizedBox(height: 24),
                
                // Рыночные тренды
                _buildMarketTrendsSection(blockchainProvider),
                const SizedBox(height: 24),
                
                // Рекомендации DeFi
                _buildDeFiRecommendationsSection(blockchainProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBlockchainStatusSection(BlockchainProvider blockchainProvider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.purple.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.block,
                    size: 24,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Статус блокчейна',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
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
    );
  }

  Widget _buildDeFiProtocolsSection(BlockchainProvider blockchainProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DeFi Протоколы',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...blockchainProvider.defiProtocols.map((protocol) => _buildProtocolCard(protocol)),
      ],
    );
  }

  Widget _buildLiquidityPoolsSection(BlockchainProvider blockchainProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Пуллы ликвидности',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...blockchainProvider.liquidityPools.map((pool) => _buildLiquidityPoolCard(pool)),
      ],
    );
  }

  Widget _buildYieldFarmingSection(BlockchainProvider blockchainProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Yield Farming',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...blockchainProvider.yieldFarming.map((farm) => _buildYieldFarmCard(farm)),
      ],
    );
  }

  Widget _buildSmartContractsSection(BlockchainProvider blockchainProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Смарт контракты',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...blockchainProvider.smartContracts.map((contract) => _buildSmartContractCard(contract)),
      ],
    );
  }

  Widget _buildMarketTrendsSection(BlockchainProvider blockchainProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Рыночные тренды',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...blockchainProvider.marketTrends.map((trend) => _buildMarketTrendCard(trend)),
      ],
    );
  }

  Widget _buildDeFiRecommendationsSection(BlockchainProvider blockchainProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DeFi Рекомендации',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...blockchainProvider.getDeFiRecommendations().map((rec) => _buildDeFiRecommendationCard(rec)),
      ],
    );
  }

  // Вспомогательные виджеты для блокчейн вкладки
  Widget _buildBlockchainMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
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
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    final direction = trend['direction'] ?? 'sideways';
    Color trendColor = Colors.blue;
    IconData trendIcon = Icons.trending_flat;
    
    if (direction == 'up') {
      trendColor = Colors.green;
      trendIcon = Icons.trending_up;
    } else if (direction == 'down') {
      trendColor = Colors.red;
      trendIcon = Icons.trending_down;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: trendColor,
          child: Icon(trendIcon, color: Colors.white),
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
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal,
          child: Icon(Icons.lightbulb, color: Colors.white),
        ),
        title: Text(rec['title'] ?? ''),
        subtitle: Text(rec['description'] ?? ''),
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
              'Совпадение',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
