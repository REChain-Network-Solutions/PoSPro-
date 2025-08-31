import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider для управления социальными функциями в PoSPro
class SocialProvider extends ChangeNotifier {
  // Состояние загрузки
  bool _isLoading = false;
  bool _isLoadingPosts = false;
  bool _isLoadingChats = false;
  bool _isLoadingUsers = false;
  
  // Ошибки
  String? _error;
  String? _postsError;
  String? _chatsError;
  String? _usersError;
  
  // Посты
  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> _userPosts = [];
  List<Map<String, dynamic>> _trendingPosts = [];
  
  // Чаты
  List<Map<String, dynamic>> _chats = [];
  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> _onlineUsers = [];
  
  // Пользователи
  List<Map<String, dynamic>> _followers = [];
  List<Map<String, dynamic>> _following = [];
  List<Map<String, dynamic>> _suggestedUsers = [];
  
  // Уведомления
  List<Map<String, dynamic>> _notifications = [];
  int _unreadNotificationsCount = 0;
  
  // Getters
  bool get isLoading => _isLoading;
  bool get isLoadingPosts => _isLoadingPosts;
  bool get isLoadingChats => _isLoadingChats;
  bool get isLoadingUsers => _isLoadingUsers;
  
  String? get error => _error;
  String? get postsError => _postsError;
  String? get chatsError => _chatsError;
  String? get usersError => _usersError;
  
  List<Map<String, dynamic>> get posts => _posts;
  List<Map<String, dynamic>> get userPosts => _userPosts;
  List<Map<String, dynamic>> get trendingPosts => _trendingPosts;
  List<Map<String, dynamic>> get chats => _chats;
  List<Map<String, dynamic>> get messages => _messages;
  List<Map<String, dynamic>> get onlineUsers => _onlineUsers;
  List<Map<String, dynamic>> get followers => _followers;
  List<Map<String, dynamic>> get following => _following;
  List<Map<String, dynamic>> get suggestedUsers => _suggestedUsers;
  List<Map<String, dynamic>> get notifications => _notifications;
  int get unreadNotificationsCount => _unreadNotificationsCount;
  
  // Алиасы для совместимости
  List<Map<String, dynamic>> get userFollowers => _followers;
  List<Map<String, dynamic>> get userFollowing => _following;
  
  /// Инициализация социального провайдера
  Future<void> initialize() async {
    try {
      _setLoading(true);
      _clearError();
      
      // Загружаем сохраненные данные
      await _loadSavedData();
      
      // Загружаем базовые данные
      await Future.wait([
        _loadPosts(),
        _loadChats(),
        _loadUsers(),
        _loadNotifications(),
      ]);
      
    } catch (e) {
      _setError('Error initializing social provider: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Очистка ошибок
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  void clearPostsError() {
    _postsError = null;
    notifyListeners();
  }
  
  void clearChatsError() {
    _chatsError = null;
    notifyListeners();
  }
  
  void clearUsersError() {
    _usersError = null;
    notifyListeners();
  }

  void _clearPostsError() {
    _postsError = null;
    notifyListeners();
  }
  
  /// Сброс состояния
  void reset() {
    _posts = [];
    _userPosts = [];
    _trendingPosts = [];
    _chats = [];
    _messages = [];
    _onlineUsers = [];
    _followers = [];
    _following = [];
    _suggestedUsers = [];
    _notifications = [];
    _unreadNotificationsCount = 0;
    _error = null;
    _postsError = null;
    _chatsError = null;
    _usersError = null;
    notifyListeners();
  }
  
  // ===== ПОСТЫ =====
  
  /// Загрузка постов
  Future<void> _loadPosts() async {
    try {
      _setPostsLoading(true);
      _clearPostsError();
      
      // Имитация загрузки постов
      await Future.delayed(Duration(milliseconds: 1000));
      
      _posts = [
        {
          'id': 'post_001',
          'content': 'Отличный день для покупок! 🛍️ Новые поступления уже в продаже. #shopping #new #trends',
          'image_url': 'https://via.placeholder.com/400x300/FF6B6B/FFFFFF?text=Shopping+Post',
          'hashtags': ['shopping', 'new', 'trends', 'fashion'],
          'location': 'Москва, Россия',
          'username': 'МодныйБутик',
          'avatar': 'https://via.placeholder.com/50x50/4ECDC4/FFFFFF?text=MB',
          'created_at': '2024-01-20T15:30:00Z',
          'likes_count': 24,
          'comments_count': 8,
          'shares_count': 3,
          'is_liked': false,
          'is_shared': false,
          'is_bookmarked': false,
        },
        {
          'id': 'post_002',
          'content': 'Технологии будущего уже здесь! 🔮 Инновационные решения для вашего бизнеса. #tech #innovation #future',
          'image_url': 'https://via.placeholder.com/400x300/45B7D1/FFFFFF?text=Tech+Post',
          'hashtags': ['tech', 'innovation', 'future', 'business'],
          'location': 'Санкт-Петербург, Россия',
          'username': 'TechGuru',
          'avatar': 'https://via.placeholder.com/50x50/96CEB4/FFFFFF?text=TG',
          'created_at': '2024-01-20T14:15:00Z',
          'likes_count': 18,
          'comments_count': 5,
          'shares_count': 2,
          'is_liked': true,
          'is_shared': false,
          'is_bookmarked': true,
        },
        {
          'id': 'post_003',
          'content': 'Здоровый образ жизни - это просто! 💪 Советы по фитнесу и питанию. #fitness #health #lifestyle',
          'hashtags': ['fitness', 'health', 'lifestyle', 'motivation'],
          'location': 'Казань, Россия',
          'username': 'FitnessPro',
          'avatar': 'https://via.placeholder.com/50x50/FFEAA7/FFFFFF?text=FP',
          'created_at': '2024-01-20T13:00:00Z',
          'likes_count': 31,
          'comments_count': 12,
          'shares_count': 7,
          'is_liked': false,
          'is_shared': true,
          'is_bookmarked': false,
        },
      ];
      
      // Копируем посты в пользовательские и трендовые
      _userPosts = List.from(_posts.where((post) => post['username'] == 'Пользователь'));
      _updateTrendingPosts();
      
      notifyListeners();
    } catch (e) {
      _setPostsError('Error loading posts: $e');
    } finally {
      _setPostsLoading(false);
    }
  }
  
  /// Создание поста
  Future<bool> createPost({
    required String content,
    String? imageUrl,
    List<String>? hashtags,
    String? location,
  }) async {
    try {
      _setPostsLoading(true);
      _clearError();
      
      // Имитация создания поста
      await Future.delayed(Duration(milliseconds: 1000));
      
      // Создаем новый пост
      Map<String, dynamic> newPost = {
        'id': _generatePostId(),
        'content': content,
        'image_url': imageUrl,
        'hashtags': hashtags ?? [],
        'location': location,
        'username': 'Пользователь',
        'avatar': null,
        'created_at': DateTime.now().toIso8601String(),
        'likes_count': 0,
        'comments_count': 0,
        'shares_count': 0,
        'is_liked': false,
        'is_shared': false,
        'is_bookmarked': false,
      };
      
      // Добавляем в начало списка постов
      _posts.insert(0, newPost);
      _userPosts.insert(0, newPost);
      
      // Обновляем трендовые посты
      _updateTrendingPosts();
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error creating post: $e');
      return false;
    } finally {
      _setPostsLoading(false);
    }
  }

  /// Обновление поста
  Future<bool> updatePost({
    required String postId,
    required String content,
    String? imageUrl,
    List<String>? hashtags,
    String? location,
  }) async {
    try {
      _setPostsLoading(true);
      _clearError();
      
      // Имитация обновления поста
      await Future.delayed(Duration(milliseconds: 800));
      
      // Находим и обновляем пост
      int postIndex = _posts.indexWhere((post) => post['id'] == postId);
      if (postIndex != -1) {
        _posts[postIndex]['content'] = content;
        if (imageUrl != null) _posts[postIndex]['image_url'] = imageUrl;
        if (hashtags != null) _posts[postIndex]['hashtags'] = hashtags;
        if (location != null) _posts[postIndex]['location'] = location;
        _posts[postIndex]['updated_at'] = DateTime.now().toIso8601String();
      }
      
      // Обновляем в пользовательских постах
      int userPostIndex = _userPosts.indexWhere((post) => post['id'] == postId);
      if (userPostIndex != -1) {
        _userPosts[userPostIndex]['content'] = content;
        if (imageUrl != null) _userPosts[userPostIndex]['image_url'] = imageUrl;
        if (hashtags != null) _userPosts[userPostIndex]['hashtags'] = hashtags;
        if (location != null) _userPosts[userPostIndex]['location'] = location;
        _userPosts[userPostIndex]['updated_at'] = DateTime.now().toIso8601String();
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error updating post: $e');
      return false;
    } finally {
      _setPostsLoading(false);
    }
  }

  /// Удаление поста
  Future<bool> deletePost(String postId) async {
    try {
      _setPostsLoading(true);
      _clearError();
      
      // Имитация удаления поста
      await Future.delayed(Duration(milliseconds: 600));
      
      // Удаляем пост из всех списков
      _posts.removeWhere((post) => post['id'] == postId);
      _userPosts.removeWhere((post) => post['id'] == postId);
      _trendingPosts.removeWhere((post) => post['id'] == postId);
      
      // Обновляем трендовые посты
      _updateTrendingPosts();
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error deleting post: $e');
      return false;
    } finally {
      _setPostsLoading(false);
    }
  }
  
  /// Лайк поста
  Future<bool> likePost(String postId) async {
    try {
      _clearError();
      
      // Находим пост во всех списках
      List<List<Map<String, dynamic>>> postLists = [_posts, _userPosts, _trendingPosts];
      
      for (var postList in postLists) {
        int postIndex = postList.indexWhere((post) => post['id'] == postId);
        if (postIndex != -1) {
          var post = postList[postIndex];
          bool isLiked = post['is_liked'] ?? false;
          
          if (isLiked) {
            post['is_liked'] = false;
            post['likes_count'] = (post['likes_count'] ?? 1) - 1;
          } else {
            post['is_liked'] = true;
            post['likes_count'] = (post['likes_count'] ?? 0) + 1;
          }
        }
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error liking post: $e');
      return false;
    }
  }

  /// Добавление комментария
  Future<bool> addComment({
    required String postId,
    required String content,
    String? authorId,
  }) async {
    try {
      _clearError();
      
      // Имитация добавления комментария
      await Future.delayed(Duration(milliseconds: 500));
      
      // Создаем комментарий
      Map<String, dynamic> comment = {
        'id': _generateCommentId(),
        'post_id': postId,
        'content': content,
        'author_id': authorId ?? 'current_user',
        'author_name': 'Пользователь',
        'author_avatar': null,
        'created_at': DateTime.now().toIso8601String(),
        'likes_count': 0,
        'is_liked': false,
      };
      
      // Добавляем комментарий в сообщения
      _messages.add(comment);
      
      // Обновляем количество комментариев в посте
      List<List<Map<String, dynamic>>> postLists = [_posts, _userPosts, _trendingPosts];
      
      for (var postList in postLists) {
        int postIndex = postList.indexWhere((post) => post['id'] == postId);
        if (postIndex != -1) {
          postList[postIndex]['comments_count'] = (postList[postIndex]['comments_count'] ?? 0) + 1;
        }
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error adding comment: $e');
      return false;
    }
  }

  /// Поделиться постом
  Future<bool> sharePost(String postId) async {
    try {
      _clearError();
      
      // Находим пост во всех списках
      List<List<Map<String, dynamic>>> postLists = [_posts, _userPosts, _trendingPosts];
      
      for (var postList in postLists) {
        int postIndex = postList.indexWhere((post) => post['id'] == postId);
        if (postIndex != -1) {
          var post = postList[postIndex];
          bool isShared = post['is_shared'] ?? false;
          
          if (isShared) {
            post['is_shared'] = false;
            post['shares_count'] = (post['shares_count'] ?? 1) - 1;
          } else {
            post['is_shared'] = true;
            post['shares_count'] = (post['shares_count'] ?? 0) + 1;
          }
        }
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error sharing post: $e');
      return false;
    }
  }

  /// Добавить в закладки
  Future<bool> bookmarkPost(String postId) async {
    try {
      _clearError();
      
      // Находим пост во всех списках
      List<List<Map<String, dynamic>>> postLists = [_posts, _userPosts, _trendingPosts];
      
      for (var postList in postLists) {
        int postIndex = postList.indexWhere((post) => post['id'] == postId);
        if (postIndex != -1) {
          var post = postList[postIndex];
          post['is_bookmarked'] = !(post['is_bookmarked'] ?? false);
        }
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error bookmarking post: $e');
      return false;
    }
  }

  /// Фильтрация постов
  List<Map<String, dynamic>> getFilteredPosts({
    String? filter,
    String? searchQuery,
  }) {
    List<Map<String, dynamic>> filteredPosts = List.from(_posts);
    
    // Применяем фильтр
    if (filter != null) {
      switch (filter) {
        case 'my':
          filteredPosts = filteredPosts.where((post) => 
            post['username'] == 'Пользователь'
          ).toList();
          break;
        case 'trending':
          filteredPosts = filteredPosts.where((post) => 
            (post['likes_count'] ?? 0) > 5 || (post['comments_count'] ?? 0) > 3
          ).toList();
          break;
        case 'recent':
          filteredPosts.sort((a, b) => 
            DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at']))
          );
          break;
      }
    }
    
    // Применяем поиск
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filteredPosts = filteredPosts.where((post) =>
        post['content'].toLowerCase().contains(searchQuery.toLowerCase()) ||
        (post['hashtags'] as List?)?.any((tag) => 
          tag.toLowerCase().contains(searchQuery.toLowerCase())
        ) == true
      ).toList();
    }
    
    return filteredPosts;
  }

  // ===== ЧАТЫ =====
  
  /// Загрузка чатов
  Future<void> _loadChats() async {
    try {
      _setChatsLoading(true);
      _clearError();
      
      // Имитация загрузки чатов
      await Future.delayed(Duration(milliseconds: 600));
      
      _chats = [
        {
          'id': '1',
          'user_id': 'user1',
          'username': 'john_doe',
          'avatar': 'https://example.com/avatar1.jpg',
          'last_message': 'Привет! Как дела с продажами?',
          'last_message_time': DateTime.now().subtract(Duration(minutes: 30)).toIso8601String(),
          'unread_count': 2,
          'is_online': true,
        },
        {
          'id': '2',
          'user_id': 'user2',
          'username': 'jane_smith',
          'avatar': 'https://example.com/avatar2.jpg',
          'last_message': 'Отличные новости!',
          'last_message_time': DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
          'unread_count': 0,
          'is_online': false,
        },
      ];
      
      notifyListeners();
      
    } catch (e) {
      _setError('Error loading chats: $e');
    } finally {
      _setChatsLoading(false);
    }
  }
  
  /// Загрузка сообщений для чата
  Future<void> loadMessages(String chatId) async {
    try {
      _setChatsLoading(true);
      _clearError();
      
      // Имитация загрузки сообщений
      await Future.delayed(Duration(milliseconds: 500));
      
      _messages = [
        {
          'id': '1',
          'chat_id': chatId,
          'sender_id': 'user1',
          'content': 'Привет! Как дела с продажами?',
          'timestamp': DateTime.now().subtract(Duration(minutes: 30)).toIso8601String(),
          'is_sent': true,
          'is_delivered': true,
          'is_read': true,
        },
        {
          'id': '2',
          'chat_id': chatId,
          'sender_id': 'current_user',
          'content': 'Привет! Все отлично, продажи растут! 📈',
          'timestamp': DateTime.now().subtract(Duration(minutes: 25)).toIso8601String(),
          'is_sent': true,
          'is_delivered': true,
          'is_read': true,
        },
        {
          'id': '3',
          'chat_id': chatId,
          'sender_id': 'user1',
          'content': 'Отлично! Поделись секретом успеха 😊',
          'timestamp': DateTime.now().subtract(Duration(minutes: 20)).toIso8601String(),
          'is_sent': true,
          'is_delivered': true,
          'is_read': false,
        },
      ];
      
      notifyListeners();
      
    } catch (e) {
      _setError('Error loading messages: $e');
    } finally {
      _setChatsLoading(false);
    }
  }
  
  /// Отправка сообщения
  Future<bool> sendMessage({
    required String chatId,
    required String content,
  }) async {
    try {
      final newMessage = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'chat_id': chatId,
        'sender_id': 'current_user',
        'content': content,
        'timestamp': DateTime.now().toIso8601String(),
        'is_sent': true,
        'is_delivered': false,
        'is_read': false,
      };
      
      _messages.add(newMessage);
      
      // Обновляем последнее сообщение в чате
      final chatIndex = _chats.indexWhere((chat) => chat['id'] == chatId);
      if (chatIndex != -1) {
        _chats[chatIndex]['last_message'] = content;
        _chats[chatIndex]['last_message_time'] = DateTime.now().toIso8601String();
      }
      
      notifyListeners();
      
      // Имитация доставки сообщения
      await Future.delayed(Duration(milliseconds: 500));
      newMessage['is_delivered'] = true;
      notifyListeners();
      
      return true;
      
    } catch (e) {
      _setError('Error sending message: $e');
      return false;
    }
  }
  
  // ===== ПОЛЬЗОВАТЕЛИ =====
  
  /// Загрузка пользователей
  Future<void> _loadUsers() async {
    try {
      _setUsersLoading(true);
      _clearError();
      
      // Имитация загрузки пользователей
      await Future.delayed(Duration(milliseconds: 700));
      
      _followers = [
        {
          'id': 'user1',
          'username': 'john_doe',
          'avatar': 'https://example.com/avatar1.jpg',
          'is_online': true,
          'followed_at': DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
        },
        {
          'id': 'user2',
          'username': 'jane_smith',
          'avatar': 'https://example.com/avatar2.jpg',
          'is_online': false,
          'followed_at': DateTime.now().subtract(Duration(days: 10)).toIso8601String(),
        },
      ];
      
      _following = [
        {
          'id': 'user3',
          'username': 'mike_wilson',
          'avatar': 'https://example.com/avatar3.jpg',
          'is_online': true,
          'followed_at': DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
        },
      ];
      
      _suggestedUsers = [
        {
          'id': 'user4',
          'username': 'sarah_jones',
          'avatar': 'https://example.com/avatar4.jpg',
          'is_online': false,
          'mutual_friends': 2,
        },
        {
          'id': 'user5',
          'username': 'david_brown',
          'avatar': 'https://example.com/avatar5.jpg',
          'is_online': true,
          'mutual_friends': 1,
        },
      ];
      
      _onlineUsers = _followers.where((user) => user['is_online'] == true).toList();
      
      notifyListeners();
      
    } catch (e) {
      _setError('Error loading users: $e');
    } finally {
      _setUsersLoading(false);
    }
  }
  
  /// Подписка на пользователя
  Future<bool> followUser(String userId) async {
    try {
      // Проверяем, не подписаны ли уже
      if (_following.any((user) => user['id'] == userId)) {
        return true;
      }
      
      // Имитация подписки
      await Future.delayed(Duration(milliseconds: 300));
      
      final userToFollow = _suggestedUsers.firstWhere((user) => user['id'] == userId);
      userToFollow['followed_at'] = DateTime.now().toIso8601String();
      
      _following.add(userToFollow);
      _suggestedUsers.removeWhere((user) => user['id'] == userId);
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Error following user: $e');
      return false;
    }
  }
  
  /// Отписка от пользователя
  Future<bool> unfollowUser(String userId) async {
    try {
      // Имитация отписки
      await Future.delayed(Duration(milliseconds: 300));
      
      _following.removeWhere((user) => user['id'] == userId);
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Error unfollowing user: $e');
      return false;
    }
  }
  
  // ===== УВЕДОМЛЕНИЯ =====
  
  /// Загрузка уведомлений
  Future<void> _loadNotifications() async {
    try {
      // Имитация загрузки уведомлений
      await Future.delayed(Duration(milliseconds: 400));
      
      _notifications = [
        {
          'id': '1',
          'type': 'like',
          'title': 'john_doe поставил лайк вашему посту',
          'message': 'Ваш пост получил новый лайк!',
          'user_id': 'user1',
          'username': 'john_doe',
          'avatar': 'https://example.com/avatar1.jpg',
          'post_id': '1',
          'is_read': false,
          'created_at': DateTime.now().subtract(Duration(minutes: 15)).toIso8601String(),
        },
        {
          'id': '2',
          'type': 'follow',
          'title': 'jane_smith подписался на вас',
          'message': 'У вас новый подписчик!',
          'user_id': 'user2',
          'username': 'jane_smith',
          'avatar': 'https://example.com/avatar2.jpg',
          'is_read': false,
          'created_at': DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
        },
        {
          'id': '3',
          'type': 'comment',
          'title': 'mike_wilson прокомментировал ваш пост',
          'message': 'Отличный пост! 👍',
          'user_id': 'user3',
          'username': 'mike_wilson',
          'avatar': 'https://example.com/avatar3.jpg',
          'post_id': '1',
          'is_read': true,
          'created_at': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
        },
      ];
      
      _unreadNotificationsCount = _notifications.where((n) => !n['is_read']).length;
      
      notifyListeners();
      
    } catch (e) {
      _setError('Error loading notifications: $e');
    }
  }
  
  /// Отметка уведомления как прочитанного
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final notificationIndex = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (notificationIndex != -1) {
        _notifications[notificationIndex]['is_read'] = true;
        _unreadNotificationsCount = _notifications.where((n) => !n['is_read']).length;
        notifyListeners();
      }
    } catch (e) {
      _setError('Error marking notification as read: $e');
    }
  }
  
  /// Отметка всех уведомлений как прочитанных
  Future<void> markAllNotificationsAsRead() async {
    try {
      for (var notification in _notifications) {
        notification['is_read'] = true;
      }
      _unreadNotificationsCount = 0;
      notifyListeners();
    } catch (e) {
      _setError('Error marking all notifications as read: $e');
    }
  }
  
  // ===== ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ =====
  
  /// Загрузка сохраненных данных
  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // В будущем здесь можно загружать сохраненные настройки
      // например, настройки уведомлений, приватности и т.д.
      
    } catch (e) {
      print('Error loading saved social data: $e');
    }
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setPostsLoading(bool loading) {
    _isLoadingPosts = loading;
    notifyListeners();
  }
  
  void _setChatsLoading(bool loading) {
    _isLoadingChats = loading;
    notifyListeners();
  }
  
  void _setUsersLoading(bool loading) {
    _isLoadingUsers = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  void _setPostsError(String error) {
    _postsError = error;
    notifyListeners();
  }
  
  void _setChatsError(String error) {
    _chatsError = error;
    notifyListeners();
  }
  
  void _setUsersError(String error) {
    _usersError = error;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
  }
  
  /// Получение статистики социальных функций
  Map<String, dynamic> getSocialStats() {
    return {
      'posts_count': _posts.length,
      'user_posts_count': _userPosts.length,
      'chats_count': _chats.length,
      'followers_count': _followers.length,
      'following_count': _following.length,
      'online_users_count': _onlineUsers.length,
      'unread_notifications_count': _unreadNotificationsCount,
      'total_notifications_count': _notifications.length,
      'last_activity': DateTime.now().toIso8601String(),
    };
  }

  // ===== ПРИВАТНЫЕ МЕТОДЫ ДЛЯ ГЕНЕРАЦИИ МОК ДАННЫХ =====

  String _generatePostId() {
    return 'post_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
  }

  String _generateCommentId() {
    return 'comment_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
  }

  /// Обновление трендовых постов
  void _updateTrendingPosts() {
    // Сортируем посты по популярности (лайки + комментарии)
    List<Map<String, dynamic>> sortedPosts = List.from(_posts);
    sortedPosts.sort((a, b) {
      int aScore = (a['likes_count'] ?? 0) + (a['comments_count'] ?? 0) * 2;
      int bScore = (b['likes_count'] ?? 0) + (b['comments_count'] ?? 0) * 2;
      return bScore.compareTo(aScore);
    });
    
    // Берем топ 10 постов
    _trendingPosts = sortedPosts.take(10).toList();
  }
}
