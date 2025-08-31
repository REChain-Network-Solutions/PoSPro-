import 'package:flutter/foundation.dart';
import 'dart:math';

/// Провайдер для NFT и Web3 функционала
class NFTProvider extends ChangeNotifier {
  // Состояние
  bool _isLoading = false;
  String? _error;
  bool _isConnected = false;
  String? _walletAddress;
  
  // Геттеры
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isConnected => _isConnected;
  String? get walletAddress => _walletAddress;

  // NFT коллекции
  List<NFTCollection> _collections = [];
  List<NFTToken> _tokens = [];
  List<CryptoTransaction> _transactions = [];
  
  // Геттеры
  List<NFTCollection> get collections => _collections;
  List<NFTToken> get tokens => _tokens;
  List<CryptoTransaction> get transactions => _transactions;

  /// Инициализация провайдера
  Future<void> initialize() async {
    try {
      _setLoading(true);
      _clearError();
      
      // Загружаем NFT данные
      await _loadNFTData();
      
      // Загружаем транзакции
      await _loadTransactions();
      
    } catch (e) {
      _setError('Error initializing NFT: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Подключение к Web3 кошельку
  Future<bool> connectWallet() async {
    try {
      _setLoading(true);
      _clearError();
      
      // Имитируем подключение к кошельку
      await Future.delayed(Duration(milliseconds: 1000 + Random().nextInt(2000)));
      
      // Генерируем случайный адрес кошелька
      _walletAddress = _generateWalletAddress();
      _isConnected = true;
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Error connecting wallet: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Отключение от кошелька
  Future<bool> disconnectWallet() async {
    try {
      _setLoading(true);
      _clearError();
      
      // Имитируем отключение
      await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(1000)));
      
      _walletAddress = null;
      _isConnected = false;
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Error disconnecting wallet: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Создание NFT коллекции
  Future<bool> createCollection(String name, String description, String symbol, String imageUrl) async {
    try {
      _setLoading(true);
      _clearError();
      
      if (!_isConnected) {
        _setError('Кошелек не подключен');
        return false;
      }
      
      // Имитируем создание коллекции в блокчейне
      await Future.delayed(Duration(milliseconds: 2000 + Random().nextInt(3000)));
      
      final collection = NFTCollection(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        symbol: symbol,
        imageUrl: imageUrl,
        creator: _walletAddress!,
        totalSupply: 0,
        createdAt: DateTime.now(),
        blockchain: 'Ethereum',
        contractAddress: _generateContractAddress(),
      );
      
      _collections.add(collection);
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Error creating collection: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Минтинг NFT токена
  Future<bool> mintNFT(String collectionId, String name, String description, String imageUrl, double price) async {
    try {
      _setLoading(true);
      _clearError();
      
      if (!_isConnected) {
        _setError('Кошелек не подключен');
        return false;
      }
      
      // Имитируем минт в блокчейне
      await Future.delayed(Duration(milliseconds: 3000 + Random().nextInt(4000)));
      
      final token = NFTToken(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        collectionId: collectionId,
        name: name,
        description: description,
        imageUrl: imageUrl,
        price: price,
        owner: _walletAddress!,
        creator: _walletAddress!,
        tokenId: _generateTokenId(),
        metadata: {
          'attributes': [
            {'trait_type': 'Rarity', 'value': 'Common'},
            {'trait_type': 'Category', 'value': 'Fashion'},
            {'trait_type': 'Season', 'value': '2024'},
          ],
          'external_url': 'https://modus-fashion.com',
          'animation_url': null,
        },
        createdAt: DateTime.now(),
        blockchain: 'Ethereum',
        contractAddress: _generateContractAddress(),
      );
      
      _tokens.add(token);
      
      // Обновляем коллекцию
      final collectionIndex = _collections.indexWhere((c) => c.id == collectionId);
      if (collectionIndex != -1) {
        _collections[collectionIndex].totalSupply++;
      }
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Error minting NFT: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Покупка NFT
  Future<bool> buyNFT(String tokenId, double price) async {
    try {
      _setLoading(true);
      _clearError();
      
      if (!_isConnected) {
        _setError('Кошелек не подключен');
        return false;
      }
      
      // Имитируем покупку в блокчейне
      await Future.delayed(Duration(milliseconds: 2000 + Random().nextInt(2000)));
      
      // Находим токен
      final tokenIndex = _tokens.indexWhere((t) => t.id == tokenId);
      if (tokenIndex == -1) {
        _setError('NFT не найден');
        return false;
      }
      
      final token = _tokens[tokenIndex];
      final previousOwner = token.owner;
      
      // Обновляем владельца
      _tokens[tokenIndex].owner = _walletAddress!;
      
      // Создаем транзакцию
      final transaction = CryptoTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: TransactionType.purchase,
        from: previousOwner,
        to: _walletAddress!,
        amount: price,
        tokenId: tokenId,
        tokenName: token.name,
        gasFee: 0.005,
        status: TransactionStatus.completed,
        timestamp: DateTime.now(),
        blockchain: 'Ethereum',
        txHash: _generateTxHash(),
      );
      
      _transactions.add(transaction);
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Error buying NFT: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Продажа NFT
  Future<bool> sellNFT(String tokenId, double price) async {
    try {
      _setLoading(true);
      _clearError();
      
      if (!_isConnected) {
        _setError('Кошелек не подключен');
        return false;
      }
      
      // Проверяем владение
      final token = _tokens.firstWhere((t) => t.id == tokenId);
      if (token.owner != _walletAddress) {
        _setError('Вы не владеете этим NFT');
        return false;
      }
      
      // Имитируем размещение на продажу
      await Future.delayed(Duration(milliseconds: 1500 + Random().nextInt(1500)));
      
      // Обновляем цену
      final tokenIndex = _tokens.indexWhere((t) => t.id == tokenId);
      _tokens[tokenIndex].price = price;
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Error selling NFT: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Получение статистики NFT
  Map<String, dynamic> getNFTStats() {
    try {
      final totalCollections = _collections.length;
      final totalTokens = _tokens.length;
      final totalValue = _tokens.fold(0.0, (sum, token) => sum + token.price);
      
      // Статистика по коллекциям
      final collectionStats = _collections.map((collection) => {
        'name': collection.name,
        'tokens': _tokens.where((t) => t.collectionId == collection.id).length,
        'value': _tokens
            .where((t) => t.collectionId == collection.id)
            .fold(0.0, (sum, token) => sum + token.price),
      }).toList();
      
      // Топ NFT по цене
      final topNFTs = _tokens.toList()
        ..sort((a, b) => b.price.compareTo(a.price));
      
      // Статистика транзакций
      final completedTransactions = _transactions.where((t) => t.status == TransactionStatus.completed).length;
      final totalVolume = _transactions
          .where((t) => t.status == TransactionStatus.completed)
          .fold(0.0, (sum, tx) => sum + tx.amount);
      
      return {
        'total_collections': totalCollections,
        'total_tokens': totalTokens,
        'total_value': totalValue,
        'collection_stats': collectionStats,
        'top_nfts': topNFTs.take(5).map((token) => {
          'name': token.name,
          'price': token.price,
          'image': token.imageUrl,
        }).toList(),
        'transactions': {
          'completed': completedTransactions,
          'total_volume': totalVolume,
        },
      };
      
    } catch (e) {
      _setError('Error getting NFT stats: $e');
      return {};
    }
  }

  /// Получение NFT по владельцу
  List<NFTToken> getNFTsByOwner(String owner) {
    return _tokens.where((token) => token.owner == owner).toList();
  }

  /// Получение NFT по коллекции
  List<NFTToken> getNFTsByCollection(String collectionId) {
    return _tokens.where((token) => token.collectionId == collectionId).toList();
  }

  /// Поиск NFT
  List<NFTToken> searchNFTs(String query) {
    if (query.isEmpty) return _tokens;
    
    final lowerQuery = query.toLowerCase();
    return _tokens.where((token) => 
      token.name.toLowerCase().contains(lowerQuery) ||
      token.description.toLowerCase().contains(lowerQuery) ||
      token.owner.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  // Приватные методы

  /// Загрузка NFT данных
  Future<void> _loadNFTData() async {
    // Имитируем загрузку данных
    await Future.delayed(Duration(milliseconds: 500));
    
    // Создаем тестовые коллекции
    _collections = [
      NFTCollection(
        id: '1',
        name: 'Modus Fashion Collection',
        description: 'Эксклюзивная коллекция модной одежды в формате NFT',
        symbol: 'MFASH',
        imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
        creator: '0x1234567890abcdef',
        totalSupply: 3,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        blockchain: 'Ethereum',
        contractAddress: '0xabc123def456ghi789',
      ),
      NFTCollection(
        id: '2',
        name: 'Luxury Accessories',
        description: 'NFT коллекция роскошных аксессуаров',
        symbol: 'LUXACC',
        imageUrl: 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49',
        creator: '0xabcdef1234567890',
        totalSupply: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        blockchain: 'Ethereum',
        contractAddress: '0xdef456ghi789abc123',
      ),
    ];
    
    // Создаем тестовые токены
    _tokens = [
      NFTToken(
        id: '1',
        collectionId: '1',
        name: 'Элегантное платье #001',
        description: 'Уникальное платье в стиле ар-деко',
        imageUrl: 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446',
        price: 0.5,
        owner: '0x1234567890abcdef',
        creator: '0x1234567890abcdef',
        tokenId: '1',
        metadata: {
          'attributes': [
            {'trait_type': 'Rarity', 'value': 'Legendary'},
            {'trait_type': 'Category', 'value': 'Dress'},
            {'trait_type': 'Style', 'value': 'Art Deco'},
          ],
        },
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        blockchain: 'Ethereum',
        contractAddress: '0xabc123def456ghi789',
      ),
      NFTToken(
        id: '2',
        collectionId: '1',
        name: 'Деловая блузка #002',
        description: 'Стильная блузка для офиса',
        imageUrl: 'https://images.unsplash.com/photo-1564257631407-3deb25f9c8e8',
        price: 0.3,
        owner: '0xabcdef1234567890',
        creator: '0x1234567890abcdef',
        tokenId: '2',
        metadata: {
          'attributes': [
            {'trait_type': 'Rarity', 'value': 'Rare'},
            {'trait_type': 'Category', 'value': 'Blouse'},
            {'trait_type': 'Style', 'value': 'Business'},
          ],
        },
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        blockchain: 'Ethereum',
        contractAddress: '0xabc123def456ghi789',
      ),
      NFTToken(
        id: '3',
        collectionId: '2',
        name: 'Роскошная сумка #001',
        description: 'Эксклюзивная кожаная сумка',
        imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa',
        price: 1.2,
        owner: '0x1234567890abcdef',
        creator: '0xabcdef1234567890',
        tokenId: '1',
        metadata: {
          'attributes': [
            {'trait_type': 'Rarity', 'value': 'Epic'},
            {'trait_type': 'Category', 'value': 'Bag'},
            {'trait_type': 'Material', 'value': 'Leather'},
          ],
        },
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        blockchain: 'Ethereum',
        contractAddress: '0xdef456ghi789abc123',
      ),
    ];
  }

  /// Загрузка транзакций
  Future<void> _loadTransactions() async {
    // Имитируем загрузку данных
    await Future.delayed(Duration(milliseconds: 300));
    
    // Создаем тестовые транзакции
    _transactions = [
      CryptoTransaction(
        id: '1',
        type: TransactionType.purchase,
        from: '0xabcdef1234567890',
        to: '0x1234567890abcdef',
        amount: 0.5,
        tokenId: '1',
        tokenName: 'Элегантное платье #001',
        gasFee: 0.005,
        status: TransactionStatus.completed,
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        blockchain: 'Ethereum',
        txHash: '0x123abc456def789ghi',
      ),
      CryptoTransaction(
        id: '2',
        type: TransactionType.mint,
        from: '0x000000000000000000',
        to: '0x1234567890abcdef',
        amount: 0.0,
        tokenId: '2',
        tokenName: 'Деловая блузка #002',
        gasFee: 0.008,
        status: TransactionStatus.completed,
        timestamp: DateTime.now().subtract(const Duration(days: 20)),
        blockchain: 'Ethereum',
        txHash: '0x456def789ghi123abc',
      ),
    ];
  }

  /// Генерация адреса кошелька
  String _generateWalletAddress() {
    const chars = '0123456789abcdef';
    return '0x' + List.generate(40, (index) => chars[Random().nextInt(chars.length)]).join();
  }

  /// Генерация адреса контракта
  String _generateContractAddress() {
    const chars = '0123456789abcdef';
    return '0x' + List.generate(40, (index) => chars[Random().nextInt(chars.length)]).join();
  }

  /// Генерация ID токена
  String _generateTokenId() {
    return Random().nextInt(1000000).toString();
  }

  /// Генерация хеша транзакции
  String _generateTxHash() {
    const chars = '0123456789abcdef';
    return '0x' + List.generate(64, (index) => chars[Random().nextInt(chars.length)]).join();
  }

  /// Очистка ошибок
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Приватные методы для управления состоянием
  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _setError(String error) {
    _error = error;
  }

  void _clearError() {
    _error = null;
  }
}

/// Модель NFT коллекции
class NFTCollection {
  final String id;
  final String name;
  final String description;
  final String symbol;
  final String imageUrl;
  final String creator;
  int totalSupply; // Убираем final для возможности изменения
  final DateTime createdAt;
  final String blockchain;
  final String contractAddress;

  NFTCollection({
    required this.id,
    required this.name,
    required this.description,
    required this.symbol,
    required this.imageUrl,
    required this.creator,
    required this.totalSupply,
    required this.createdAt,
    required this.blockchain,
    required this.contractAddress,
  });
}

/// Модель NFT токена
class NFTToken {
  final String id;
  final String collectionId;
  final String name;
  final String description;
  final String imageUrl;
  double price; // Убираем final для возможности изменения
  String owner; // Убираем final для возможности изменения
  final String creator;
  final String tokenId;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final String blockchain;
  final String contractAddress;

  NFTToken({
    required this.id,
    required this.collectionId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.owner,
    required this.creator,
    required this.tokenId,
    required this.metadata,
    required this.createdAt,
    required this.blockchain,
    required this.contractAddress,
  });
}

/// Тип криптотранзакции
enum TransactionType {
  purchase,    // Покупка
  sale,        // Продажа
  mint,        // Минт
  transfer,    // Перевод
}

/// Статус транзакции
enum TransactionStatus {
  pending,     // В обработке
  completed,   // Завершена
  failed,      // Ошибка
}

/// Модель криптотранзакции
class CryptoTransaction {
  final String id;
  final TransactionType type;
  final String from;
  final String to;
  final double amount;
  final String tokenId;
  final String tokenName;
  final double gasFee;
  final TransactionStatus status;
  final DateTime timestamp;
  final String blockchain;
  final String txHash;

  CryptoTransaction({
    required this.id,
    required this.type,
    required this.from,
    required this.to,
    required this.amount,
    required this.tokenId,
    required this.tokenName,
    required this.gasFee,
    required this.status,
    required this.timestamp,
    required this.blockchain,
    required this.txHash,
  });
}
