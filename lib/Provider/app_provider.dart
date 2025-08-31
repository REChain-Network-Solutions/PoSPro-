import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_provider.dart';
import 'product_provider.dart';
import 'social_provider.dart';
import 'web3_provider.dart';
import 'ai_provider.dart';
import 'blockchain_provider.dart';
import 'analytics_provider.dart';
import 'ai_chat_provider.dart';
import 'pos_provider.dart';
import 'inventory_provider.dart';
import 'nft_provider.dart';

class AppProvider extends ChangeNotifier {
  // Все провайдеры
  late final AuthProvider authProvider;
  late final ProductProvider productProvider;
  late final SocialProvider socialProvider;
  late final Web3Provider web3Provider;
  late final AIProvider aiProvider;
  late final BlockchainProvider blockchainProvider;
  late final AnalyticsProvider analyticsProvider;
  late final AIChatProvider aiChatProvider;
  late final POSProvider posProvider;
  late final InventoryProvider inventoryProvider;
  late final NFTProvider nftProvider;
  
  // Глобальное состояние приложения
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _error;
  String _currentTheme = 'light';
  String _currentLanguage = 'ru';
  late SharedPreferences _prefs;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentTheme => _currentTheme;
  String get currentLanguage => _currentLanguage;

  AppProvider() {
    _initializeProviders();
    _loadPreferences();
  }

  void _initializeProviders() {
    // Инициализируем провайдеры
    authProvider = AuthProvider();
    productProvider = ProductProvider();
    socialProvider = SocialProvider();
    web3Provider = Web3Provider();
    aiProvider = AIProvider();
    blockchainProvider = BlockchainProvider();
    analyticsProvider = AnalyticsProvider();
    aiChatProvider = AIChatProvider();
    posProvider = POSProvider();
    inventoryProvider = InventoryProvider();
    nftProvider = NFTProvider();
    
    // Слушаем изменения в провайдерах
    authProvider.addListener(_onAuthChanged);
    productProvider.addListener(_onProductChanged);
    socialProvider.addListener(_onSocialChanged);
    web3Provider.addListener(_onWeb3Changed);
    aiProvider.addListener(_onAIChanged);
    blockchainProvider.addListener(_onBlockchainChanged);
    analyticsProvider.addListener(_onAnalyticsChanged);
    posProvider.addListener(_onPOSChanged);
    inventoryProvider.addListener(_onInventoryChanged);
    nftProvider.addListener(_onNFTChanged);
    aiChatProvider.addListener(_onAIChatChanged);
  }

  // Загрузка настроек
  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _currentTheme = _prefs.getString('theme') ?? 'light';
    _currentLanguage = _prefs.getString('language') ?? 'ru';
    notifyListeners();
  }

  // Инициализация приложения
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _setLoading(true);
      _error = null;
      
      // Инициализируем провайдеры в правильном порядке
      await Future.wait([
        authProvider.initialize(),
        productProvider.initialize(),
        web3Provider.initialize(),
        aiProvider.initialize(),
        blockchainProvider.initialize(),
        analyticsProvider.initialize(),
        aiChatProvider.initialize(),
        posProvider.initialize(),
        inventoryProvider.initialize(),
        nftProvider.initialize(),
      ]);
      
      // Инициализируем социальные функции только после аутентификации
      if (authProvider.isAuthenticated) {
        await socialProvider.initialize();
      }
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Переинициализация после изменения аутентификации
  Future<void> reinitializeAfterAuth() async {
    try {
      _setLoading(true);
      _error = null;
      
      // Инициализируем социальные функции
      await socialProvider.initialize();
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Обработчики изменений в провайдерах
  void _onAuthChanged() {
    // Если статус аутентификации изменился, переинициализируем
    if (authProvider.isAuthenticated && !_isInitialized) {
      reinitializeAfterAuth();
    }
    notifyListeners();
  }

  void _onProductChanged() {
    notifyListeners();
  }

  void _onSocialChanged() {
    notifyListeners();
  }

  void _onWeb3Changed() {
    notifyListeners();
  }

  void _onAIChanged() {
    notifyListeners();
  }

  void _onBlockchainChanged() {
    notifyListeners();
  }

  void _onAnalyticsChanged() {
    notifyListeners();
  }

  void _onPOSChanged() {
    notifyListeners();
  }

  void _onInventoryChanged() {
    notifyListeners();
  }

  void _onNFTChanged() {
    notifyListeners();
  }

  void _onAIChatChanged() {
    notifyListeners();
  }

  // Управление темой
  Future<void> setTheme(String theme) async {
    _currentTheme = theme;
    await _prefs.setString('theme', theme);
    notifyListeners();
  }

  // Управление языком
  Future<void> setLanguage(String language) async {
    _currentLanguage = language;
    await _prefs.setString('language', language);
    notifyListeners();
  }

  // Очистка всех ошибок
  void clearAllErrors() {
    _error = null;
    authProvider.clearError();
    productProvider.clearError();
    socialProvider.clearError();
    web3Provider.clearError();
    aiProvider.clearError();
    blockchainProvider.clearError();
    analyticsProvider.clearError();
    notifyListeners();
  }

  // Получение глобальной статистики
  Map<String, dynamic> getGlobalStats() {
    return {
      'is_initialized': _isInitialized,
      'auth_status': authProvider.isAuthenticated,
      'products': {
        'total_products': productProvider.totalProducts,
        'total_categories': productProvider.totalCategories,
        'low_stock_products_count': productProvider.products.where((p) => 
          (p['stock_quantity'] ?? 0) <= (p['min_stock_level'] ?? 0)
        ).length,
        'trend': 'increasing',
        'categories_trend': 'stable',
      },
      'ai': {
        'personal_recommendations_count': aiProvider.userStyleProfile != null ? 15 : 0,
        'trend': 'increasing',
        'models_loaded': aiProvider.userStyleProfile != null,
      },
      'web3': {
        'is_connected': web3Provider.isConnected,
        'total_nfts': web3Provider.userNFTs.length,
        'total_tokens': web3Provider.userTokens.length,
        'eth_balance': web3Provider.ethBalance,
        'network': web3Provider.currentNetwork,
      },
      'blockchain': {
        'current_network': blockchainProvider.currentNetwork,
        'defi_protocols_count': blockchainProvider.defiProtocols.length,
        'smart_contracts_count': blockchainProvider.smartContracts.length,
        'liquidity_pools_count': blockchainProvider.liquidityPools.length,
      },
      'analytics': {
        'ml_models': analyticsProvider.mlModels.length,
        'predictions_count': analyticsProvider.predictions.length,
        'anomalies_count': analyticsProvider.anomalies.length,
        'kpis_count': analyticsProvider.kpis.length,
      },
      'social': {
        'total_posts': socialProvider.posts.length,
        'total_followers': socialProvider.userFollowers.length,
        'total_following': socialProvider.userFollowing.length,
        'trending_posts_count': socialProvider.trendingPosts.length,
      },
      'last_updated': DateTime.now().toIso8601String(),
    };
  }

  // Проверка состояния всех провайдеров
  Map<String, bool> getProvidersStatus() {
    return {
      'auth': !authProvider.isLoading && authProvider.error == null,
      'product': !productProvider.isLoading && productProvider.error == null,
      'social': !socialProvider.isLoading && socialProvider.error == null,
      'web3': !web3Provider.isLoading && web3Provider.error == null,
      'ai': !aiProvider.isLoading && aiProvider.error == null,
      'blockchain': !blockchainProvider.isLoading && blockchainProvider.error == null,
      'analytics': !analyticsProvider.isLoading && analyticsProvider.error == null,
    };
  }

  // Получение общих ошибок
  List<String> getAllErrors() {
    List<String> errors = [];
    
    if (_error != null) errors.add(_error!);
    if (authProvider.error != null) errors.add('Auth: ${authProvider.error}');
    if (productProvider.error != null) errors.add('Product: ${productProvider.error}');
    if (socialProvider.error != null) errors.add('Social: ${socialProvider.error}');
    if (web3Provider.error != null) errors.add('Web3: ${web3Provider.error}');
    if (aiProvider.error != null) errors.add('AI: ${aiProvider.error}');
    if (blockchainProvider.error != null) errors.add('Blockchain: ${blockchainProvider.error}');
    if (analyticsProvider.error != null) errors.add('Analytics: ${analyticsProvider.error}');
    
    return errors;
  }

  // Проверка наличия ошибок
  bool get hasErrors => getAllErrors().isNotEmpty;

  // Проверка загрузки
  bool get isAnythingLoading => 
    _isLoading || 
    authProvider.isLoading || 
    productProvider.isLoading || 
    socialProvider.isLoading || 
    web3Provider.isLoading || 
    aiProvider.isLoading || 
    blockchainProvider.isLoading || 
    analyticsProvider.isLoading;

  // Сброс состояния приложения
  void reset() {
    _isInitialized = false;
    _isLoading = false;
    _error = null;
    
    // Сбрасываем все провайдеры
    authProvider.reset();
    productProvider.reset();
    socialProvider.reset();
    web3Provider.reset();
    aiProvider.reset();
    blockchainProvider.reset();
    analyticsProvider.reset();
    
    notifyListeners();
  }

  // Вспомогательные методы
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
}
