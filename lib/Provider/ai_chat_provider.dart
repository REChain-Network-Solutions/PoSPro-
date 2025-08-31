import 'package:flutter/foundation.dart';
import 'dart:math';

/// Провайдер для AI-чата с клиентами
class AIChatProvider extends ChangeNotifier {
  // Состояние чата
  List<ChatMessage> _messages = [];
  bool _isTyping = false;
  String? _error;
  bool _isLoading = false;

  // Геттеры
  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // Контекст клиента
  Map<String, dynamic> _customerContext = {};
  List<String> _recommendedProducts = [];

  // Геттеры контекста
  Map<String, dynamic> get customerContext => _customerContext;
  List<String> get recommendedProducts => _recommendedProducts;

  /// Инициализация провайдера
  Future<void> initialize() async {
    try {
      _setLoading(true);
      _clearError();
      
      // Загружаем базовые сообщения
      await _loadInitialMessages();
      
      // Инициализируем контекст клиента
      _initializeCustomerContext();
      
    } catch (e) {
      _setError('Error initializing AI chat: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Отправка сообщения от клиента
  Future<void> sendCustomerMessage(String message) async {
    try {
      // Добавляем сообщение клиента
      final customerMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: message,
        sender: MessageSender.customer,
        timestamp: DateTime.now(),
      );
      
      _messages.add(customerMsg);
      notifyListeners();

      // Анализируем сообщение и генерируем ответ
      await _processCustomerMessage(message);
      
    } catch (e) {
      _setError('Error sending message: $e');
    }
  }

  /// Обработка сообщения клиента
  Future<void> _processCustomerMessage(String message) async {
    try {
      _setTyping(true);
      notifyListeners();

      // Анализируем намерение клиента
      final intent = _analyzeIntent(message);
      
      // Обновляем контекст клиента
      _updateCustomerContext(message, intent);
      
      // Генерируем ответ
      final response = await _generateResponse(message, intent);
      
      // Добавляем ответ AI
      final aiMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: response,
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
        metadata: {
          'intent': intent,
          'confidence': _calculateConfidence(intent),
        },
      );
      
      _messages.add(aiMsg);
      
      // Генерируем рекомендации товаров
      await _generateProductRecommendations(intent);
      
    } catch (e) {
      _setError('Error processing message: $e');
    } finally {
      _setTyping(false);
      notifyListeners();
    }
  }

  /// Анализ намерения клиента
  String _analyzeIntent(String message) {
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('платье') || lowerMessage.contains('платья')) {
      return 'search_dresses';
    } else if (lowerMessage.contains('блузк') || lowerMessage.contains('рубашк')) {
      return 'search_blouses';
    } else if (lowerMessage.contains('брюк') || lowerMessage.contains('штаны')) {
      return 'search_pants';
    } else if (lowerMessage.contains('юбк')) {
      return 'search_skirts';
    } else if (lowerMessage.contains('куртк') || lowerMessage.contains('пальт')) {
      return 'search_jackets';
    } else if (lowerMessage.contains('цена') || lowerMessage.contains('стоимость')) {
      return 'price_inquiry';
    } else if (lowerMessage.contains('размер') || lowerMessage.contains('мерк')) {
      return 'size_inquiry';
    } else if (lowerMessage.contains('доставк') || lowerMessage.contains('отправк')) {
      return 'delivery_inquiry';
    } else if (lowerMessage.contains('возврат') || lowerMessage.contains('обмен')) {
      return 'return_inquiry';
    } else if (lowerMessage.contains('скидк') || lowerMessage.contains('акци')) {
      return 'discount_inquiry';
    } else if (lowerMessage.contains('спасибо') || lowerMessage.contains('благодар')) {
      return 'gratitude';
    } else if (lowerMessage.contains('помощь') || lowerMessage.contains('подскажи')) {
      return 'help_request';
    } else {
      return 'general_inquiry';
    }
  }

  /// Генерация ответа AI
  Future<String> _generateResponse(String message, String intent) async {
    // Имитируем задержку обработки
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(1000)));
    
    switch (intent) {
      case 'search_dresses':
        return _generateDressResponse();
      case 'search_blouses':
        return _generateBlouseResponse();
      case 'search_pants':
        return _generatePantsResponse();
      case 'search_skirts':
        return _generateSkirtResponse();
      case 'search_jackets':
        return _generateJacketResponse();
      case 'price_inquiry':
        return _generatePriceResponse();
      case 'size_inquiry':
        return _generateSizeResponse();
      case 'delivery_inquiry':
        return _generateDeliveryResponse();
      case 'return_inquiry':
        return _generateReturnResponse();
      case 'discount_inquiry':
        return _generateDiscountResponse();
      case 'gratitude':
        return _generateGratitudeResponse();
      case 'help_request':
        return _generateHelpResponse();
      default:
        return _generateGeneralResponse();
    }
  }

  /// Генерация ответов для разных намерений
  String _generateDressResponse() {
    final responses = [
      'Отличный выбор! У нас есть прекрасная коллекция платьев Modus Fashion. Какие платья вас интересуют больше всего?',
      'Платья - это всегда актуально! У нас есть как деловые, так и вечерние варианты. Расскажите, для какого случая ищете платье?',
      'Коллекция платьев Modus Fashion порадует вас разнообразием! Есть ли предпочтения по цвету или стилю?',
    ];
    return responses[Random().nextInt(responses.length)];
  }

  String _generateBlouseResponse() {
    final responses = [
      'Блузки - основа любого гардероба! У нас есть классические и современные модели. Какой стиль предпочитаете?',
      'Отличный выбор! Блузки Modus Fashion подойдут как для офиса, так и для повседневной носки. Есть предпочтения по материалу?',
      'Блузки - это всегда стильно! У нас есть варианты из шелка, хлопка и других качественных материалов. Что вас интересует?',
    ];
    return responses[Random().nextInt(responses.length)];
  }

  String _generatePantsResponse() {
    final responses = [
      'Брюки - это комфорт и стиль! У нас есть как строгие офисные, так и свободные повседневные модели. Что ищете?',
      'Отличный выбор! Брюки Modus Fashion созданы для активных женщин. Есть предпочтения по крою?',
      'Брюки - основа современного гардероба! У нас есть варианты для любого случая. Расскажите о ваших предпочтениях.',
    ];
    return responses[Random().nextInt(responses.length)];
  }

  String _generateSkirtResponse() {
    final responses = [
      'Юбки - это женственность и элегантность! У нас есть как короткие, так и длинные модели. Что предпочитаете?',
      'Отличный выбор! Юбки Modus Fashion подчеркнут вашу индивидуальность. Есть ли любимые фасоны?',
      'Юбки - это всегда актуально! У нас есть варианты для офиса, прогулок и особых случаев. Что вас интересует?',
    ];
    return responses[Random().nextInt(responses.length)];
  }

  String _generateJacketResponse() {
    final responses = [
      'Куртки - это стиль и практичность! У нас есть демисезонные и зимние модели. Какая погода вас ждет?',
      'Отличный выбор! Куртки Modus Fashion защитят от непогоды и подчеркнут ваш стиль. Есть предпочтения по длине?',
      'Куртки - это всегда актуально! У нас есть варианты для любого сезона. Расскажите о ваших потребностях.',
    ];
    return responses[Random().nextInt(responses.length)];
  }

  String _generatePriceResponse() {
    final responses = [
      'Цены на нашу продукцию очень демократичные! Платья от 8,990₽, блузки от 6,990₽. Есть ли конкретные товары, которые вас интересуют?',
      'Мы предлагаем отличное соотношение цена-качество! Все товары изготовлены из качественных материалов. Хотите узнать цены на конкретные модели?',
      'Наши цены доступны для каждой женщины! У нас регулярно проходят акции и скидки. Интересует ли вас что-то конкретное?',
    ];
    return responses[Random().nextInt(responses.length)];
  }

  String _generateSizeResponse() {
    final responses = [
      'У нас есть размеры от XS до XXL! Все товары имеют подробные размерные сетки. Знаете ли вы свой размер?',
      'Размеры подбираются индивидуально! У нас есть удобные таблицы размеров. Хотите, чтобы я помог подобрать размер?',
      'Мы поможем подобрать идеальный размер! У нас есть модели для разных типов фигуры. Расскажите о ваших параметрах.',
    ];
    return responses[Random().nextInt(responses.length)];
  }

  String _generateDeliveryResponse() {
    final responses = [
      'Доставка осуществляется по всей России! Сроки: 1-3 дня по Москве, 3-7 дней по регионам. Есть ли вопросы по доставке?',
      'Мы предлагаем быструю и надежную доставку! Есть несколько способов доставки на выбор. Что вас интересует?',
      'Доставка - это просто! Мы доставляем до двери или до пункта выдачи. Хотите узнать подробности?',
    ];
    return responses[Random().nextInt(responses.length)];
  }

  String _generateReturnResponse() {
    final responses = [
      'Возврат товара возможен в течение 14 дней! Товар должен быть в товарном виде с бирками. Есть ли вопросы по возврату?',
      'Мы заботимся о вашем комфорте! Возврат и обмен товара осуществляется легко. Нужна ли помощь с возвратом?',
      'Возврат - это просто! У нас прозрачная политика возврата. Хотите узнать подробности?',
    ];
    return responses[Random().nextInt(responses.length)];
  }

  String _generateDiscountResponse() {
    final responses = [
      'У нас регулярно проходят акции и скидки! Сейчас действует скидка 20% на новую коллекцию. Хотите узнать о текущих предложениях?',
      'Скидки - это всегда приятно! Подпишитесь на наши уведомления, чтобы не пропустить лучшие предложения. Интересует ли вас что-то конкретное?',
      'Мы любим радовать наших клиентов! У нас есть сезонные распродажи и специальные предложения. Хотите узнать больше?',
    ];
    return responses[Random().nextInt(responses.length)];
  }

  String _generateGratitudeResponse() {
    final responses = [
      'Пожалуйста! Рад был помочь! Если у вас появятся еще вопросы, обращайтесь в любое время.',
      'Всегда рад помочь! Надеюсь, наш разговор был полезным. Удачных покупок!',
      'Спасибо за обращение! Буду рад помочь снова. У нас всегда есть что предложить!',
    ];
    return responses[Random().nextInt(responses.length)];
  }

  String _generateHelpResponse() {
    final responses = [
      'Конечно, я готов помочь! Я могу помочь с выбором товаров, рассказать о ценах, доставке и многом другом. Что именно вас интересует?',
      'Я здесь, чтобы помочь! Могу ответить на вопросы о товарах, размерах, доставке. С чего начнем?',
      'Рад помочь! Я знаю все о нашем магазине и товарах. Задавайте любые вопросы!',
    ];
    return responses[Random().nextInt(responses.length)];
  }

  String _generateGeneralResponse() {
    final responses = [
      'Интересный вопрос! Я готов помочь вам с выбором товаров, рассказать о нашем магазине или ответить на любые вопросы. Что именно вас интересует?',
      'Спасибо за обращение! Я - ваш персональный помощник по покупкам. Могу помочь с выбором, рассказать о товарах и услугах. Что вас интересует?',
      'Отличный вопрос! Я здесь, чтобы сделать ваши покупки приятными и удобными. Расскажите, как могу помочь?',
    ];
    return responses[Random().nextInt(responses.length)];
  }

  /// Генерация рекомендаций товаров
  Future<void> _generateProductRecommendations(String intent) async {
    // Имитируем задержку
    await Future.delayed(Duration(milliseconds: 300));
    
    switch (intent) {
      case 'search_dresses':
        _recommendedProducts = ['Платье "Элегантность"', 'Платье "Летний бриз"'];
        break;
      case 'search_blouses':
        _recommendedProducts = ['Блузка "Деловой стиль"', 'Блузка "Романтичность"'];
        break;
      case 'search_pants':
        _recommendedProducts = ['Брюки "Строгий крой"', 'Брюки "Свободный стиль"'];
        break;
      case 'search_skirts':
        _recommendedProducts = ['Юбка "Карандаш"', 'Юбка "Макси"'];
        break;
      case 'search_jackets':
        _recommendedProducts = ['Куртка "Демисезонная"', 'Куртка "Зимняя"'];
        break;
      default:
        _recommendedProducts = ['Платье "Элегантность"', 'Блузка "Деловой стиль"', 'Брюки "Строгий крой"'];
    }
    
    notifyListeners();
  }

  /// Обновление контекста клиента
  void _updateCustomerContext(String message, String intent) {
    _customerContext['last_message'] = message;
    _customerContext['last_intent'] = intent;
    _customerContext['message_count'] = (_customerContext['message_count'] ?? 0) + 1;
    _customerContext['last_interaction'] = DateTime.now().toIso8601String();
    
    // Анализируем настроение
    _customerContext['mood'] = _analyzeMood(message);
    
    notifyListeners();
  }

  /// Анализ настроения клиента
  String _analyzeMood(String message) {
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('спасибо') || lowerMessage.contains('благодар')) {
      return 'positive';
    } else if (lowerMessage.contains('проблем') || lowerMessage.contains('неудоб')) {
      return 'negative';
    } else if (lowerMessage.contains('?') || lowerMessage.contains('вопрос')) {
      return 'inquisitive';
    } else {
      return 'neutral';
    }
  }

  /// Расчет уверенности в анализе
  double _calculateConfidence(String intent) {
    final confidenceMap = {
      'search_dresses': 0.95,
      'search_blouses': 0.92,
      'search_pants': 0.90,
      'search_skirts': 0.88,
      'search_jackets': 0.85,
      'price_inquiry': 0.80,
      'size_inquiry': 0.75,
      'delivery_inquiry': 0.85,
      'return_inquiry': 0.80,
      'discount_inquiry': 0.70,
      'gratitude': 0.95,
      'help_request': 0.90,
      'general_inquiry': 0.60,
    };
    
    return confidenceMap[intent] ?? 0.50;
  }

  /// Загрузка начальных сообщений
  Future<void> _loadInitialMessages() async {
    final welcomeMessage = ChatMessage(
      id: 'welcome',
      text: 'Привет! Я ваш персональный AI-ассистент Modus Fashion. Готов помочь с выбором товаров, ответить на вопросы о ценах, доставке и многом другом. Как могу помочь?',
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
      metadata: {
        'intent': 'welcome',
        'confidence': 1.0,
      },
    );
    
    _messages.add(welcomeMessage);
  }

  /// Инициализация контекста клиента
  void _initializeCustomerContext() {
    _customerContext = {
      'session_start': DateTime.now().toIso8601String(),
      'message_count': 0,
      'mood': 'neutral',
      'preferences': [],
      'last_interaction': DateTime.now().toIso8601String(),
    };
  }

  /// Очистка чата
  void clearChat() {
    _messages.clear();
    _recommendedProducts.clear();
    _loadInitialMessages();
    _initializeCustomerContext();
    notifyListeners();
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

  void _setTyping(bool typing) {
    _isTyping = typing;
  }

  void _setError(String error) {
    _error = error;
  }

  void _clearError() {
    _error = null;
  }
}

/// Модель сообщения чата
class ChatMessage {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.metadata,
  });
}

/// Отправитель сообщения
enum MessageSender {
  customer,
  ai,
}
