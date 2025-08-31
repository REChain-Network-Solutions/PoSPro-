import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider для управления аутентификацией в PoSPro
class AuthProvider extends ChangeNotifier {
  // Состояние загрузки
  bool _isLoading = false;
  String? _error;
  
  // Состояние аутентификации
  bool _isAuthenticated = false;
  String? _userId;
  String? _userName;
  String? _userEmail;
  String? _userAvatar;
  String? _userPhone;
  String? _userBio;
  bool _isAdmin = false;
  
  // Статистика пользователя
  Map<String, dynamic>? _userStats;
  
  // Токены
  String? _accessToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;
  
  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userAvatar => _userAvatar;
  String? get userPhone => _userPhone;
  String? get userBio => _userBio;
  bool get isAdmin => _isAdmin;
  
  Map<String, dynamic>? get userStats => _userStats;
  
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  DateTime? get tokenExpiry => _tokenExpiry;
  
  /// Инициализация провайдера аутентификации
  Future<void> initialize() async {
    try {
      _setLoading(true);
      _clearError();
      
      // Загружаем сохраненные данные аутентификации
      await _loadSavedAuthData();
      
      // Проверяем валидность токена
      if (_accessToken != null) {
        await _validateToken();
      }
      
    } catch (e) {
      _setError('Error initializing auth provider: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Очистка ошибок
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  /// Сброс состояния
  void reset() {
    _isAuthenticated = false;
    _userId = null;
    _userName = null;
    _userEmail = null;
    _userAvatar = null;
    _isAdmin = false;
    _accessToken = null;
    _refreshToken = null;
    _tokenExpiry = null;
    _error = null;
    notifyListeners();
  }
  
  // ===== АУТЕНТИФИКАЦИЯ =====
  
  /// Вход в систему
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Имитация входа в систему
      await Future.delayed(Duration(milliseconds: 1500));
      
      // Проверяем учетные данные (в реальном приложении здесь будет API вызов)
      if (email == 'admin@pospro.com' && password == 'admin123') {
        _isAuthenticated = true;
        _userId = 'user_001';
        _userName = 'Администратор';
        _userEmail = email;
        _userAvatar = 'https://via.placeholder.com/100x100/4ECDC4/FFFFFF?text=A';
        _userPhone = '+7 (999) 123-45-67';
        _userBio = 'Главный администратор системы PoSPro';
        _isAdmin = true;
        _accessToken = 'access_token_${DateTime.now().millisecondsSinceEpoch}';
        _refreshToken = 'refresh_token_${DateTime.now().millisecondsSinceEpoch}';
        _tokenExpiry = DateTime.now().add(Duration(hours: 24));
        
        // Загружаем статистику пользователя
        _userStats = {
          'posts_count': 15,
          'likes_count': 234,
          'followers_count': 89,
          'following_count': 45,
          'total_orders': 67,
          'total_spent': 125000.0,
          'last_login': DateTime.now().toIso8601String(),
          'account_age_days': 45,
        };
        
        await _saveAuthData();
        notifyListeners();
        return true;
      } else if (email == 'user@pospro.com' && password == 'user123') {
        _isAuthenticated = true;
        _userId = 'user_002';
        _userName = 'Пользователь';
        _userEmail = email;
        _userAvatar = 'https://via.placeholder.com/100x100/FF6B6B/FFFFFF?text=U';
        _userPhone = '+7 (999) 987-65-43';
        _userBio = 'Обычный пользователь системы PoSPro';
        _isAdmin = false;
        _accessToken = 'access_token_${DateTime.now().millisecondsSinceEpoch}';
        _refreshToken = 'refresh_token_${DateTime.now().millisecondsSinceEpoch}';
        _tokenExpiry = DateTime.now().add(Duration(hours: 24));
        
        // Загружаем статистику пользователя
        _userStats = {
          'posts_count': 8,
          'likes_count': 67,
          'followers_count': 23,
          'following_count': 34,
          'total_orders': 12,
          'total_spent': 45000.0,
          'last_login': DateTime.now().toIso8601String(),
          'account_age_days': 23,
        };
        
        await _saveAuthData();
        notifyListeners();
        return true;
      } else {
        throw Exception('Неверный email или пароль');
      }
    } catch (e) {
      _setError('Ошибка входа: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Регистрация
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? bio,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Имитация регистрации
      await Future.delayed(Duration(milliseconds: 2000));
      
      // Проверяем, что email не занят
      if (email == 'admin@pospro.com' || email == 'user@pospro.com') {
        throw Exception('Пользователь с таким email уже существует');
      }
      
      // Создаем нового пользователя
      _isAuthenticated = true;
      _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      _userName = name;
      _userEmail = email;
      _userAvatar = null;
      _userPhone = phone;
      _userBio = bio;
      _isAdmin = false;
      _accessToken = 'access_token_${DateTime.now().millisecondsSinceEpoch}';
      _refreshToken = 'refresh_token_${DateTime.now().millisecondsSinceEpoch}';
      _tokenExpiry = DateTime.now().add(Duration(hours: 24));
      
      // Инициализируем статистику пользователя
      _userStats = {
        'posts_count': 0,
        'likes_count': 0,
        'followers_count': 0,
        'following_count': 0,
        'total_orders': 0,
        'total_spent': 0.0,
        'last_login': DateTime.now().toIso8601String(),
        'account_age_days': 0,
      };
      
      await _saveAuthData();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Ошибка регистрации: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Обновление профиля
  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Имитация обновления профиля
      await Future.delayed(Duration(milliseconds: 1000));
      
      // Обновляем поля профиля
      if (profileData['name'] != null) {
        _userName = profileData['name'];
      }
      if (profileData['email'] != null) {
        _userEmail = profileData['email'];
      }
      if (profileData['phone'] != null) {
        _userPhone = profileData['phone'];
      }
      if (profileData['bio'] != null) {
        _userBio = profileData['bio'];
      }
      if (profileData['avatar'] != null) {
        _userAvatar = profileData['avatar'];
      }
      
      // Обновляем статистику
      _userStats?['last_updated'] = DateTime.now().toIso8601String();
      
      await _saveAuthData();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Ошибка обновления профиля: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Смена пароля
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Имитация смены пароля
      await Future.delayed(Duration(milliseconds: 1200));
      
      // Проверяем текущий пароль (в реальном приложении здесь будет проверка)
      if (currentPassword == 'admin123' || currentPassword == 'user123') {
        // Обновляем токены
        _accessToken = 'access_token_${DateTime.now().millisecondsSinceEpoch}';
        _refreshToken = 'refresh_token_${DateTime.now().millisecondsSinceEpoch}';
        _tokenExpiry = DateTime.now().add(Duration(hours: 24));
        
        await _saveAuthData();
        notifyListeners();
        return true;
      } else {
        throw Exception('Неверный текущий пароль');
      }
    } catch (e) {
      _setError('Ошибка смены пароля: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Выход из системы
  Future<void> signOut() async {
    try {
      _setLoading(true);
      _clearError();
      
      // Имитация выхода
      await Future.delayed(Duration(milliseconds: 500));
      
      // Очищаем данные аутентификации
      reset();
      
      // Очищаем сохраненные данные
      await _clearSavedAuthData();
      
      notifyListeners();
    } catch (e) {
      _setError('Ошибка выхода: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Обновление токена аутентификации
  Future<bool> refreshAuthToken() async {
    try {
      _setLoading(true);
      _clearError();
      
      // Имитация обновления токена
      await Future.delayed(Duration(milliseconds: 800));
      
      // Генерируем новые токены
      _accessToken = 'access_token_${DateTime.now().millisecondsSinceEpoch}';
      _refreshToken = 'refresh_token_${DateTime.now().millisecondsSinceEpoch}';
      _tokenExpiry = DateTime.now().add(Duration(hours: 24));
      
      await _saveAuthData();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Ошибка обновления токена: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// Восстановление пароля
  Future<bool> resetPassword({
    required String email,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Имитация восстановления пароля
      await Future.delayed(Duration(milliseconds: 1000));
      
      // Проверяем, что пользователь существует
      if (email != 'admin@pospro.com' && email != 'user@pospro.com') {
        _setError('Пользователь с таким email не найден');
        return false;
      }
      
      // В реальном приложении здесь будет отправка email для восстановления
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Error resetting password: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // ===== ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ =====
  
  /// Загрузка сохраненных данных аутентификации
  Future<void> _loadSavedAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _isAuthenticated = prefs.getBool('auth_is_authenticated') ?? false;
      _userId = prefs.getString('auth_user_id');
      _userName = prefs.getString('auth_user_name');
      _userEmail = prefs.getString('auth_user_email');
      _userAvatar = prefs.getString('auth_user_avatar');
      _isAdmin = prefs.getBool('auth_is_admin') ?? false;
      _accessToken = prefs.getString('auth_access_token');
      _refreshToken = prefs.getString('auth_refresh_token');
      
      final tokenExpiryString = prefs.getString('auth_token_expiry');
      if (tokenExpiryString != null) {
        _tokenExpiry = DateTime.parse(tokenExpiryString);
      }
      
    } catch (e) {
      print('Error loading saved auth data: $e');
    }
  }
  
  /// Сохранение данных аутентификации
  Future<void> _saveAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool('auth_is_authenticated', _isAuthenticated);
      if (_userId != null) {
        await prefs.setString('auth_user_id', _userId!);
      }
      if (_userName != null) {
        await prefs.setString('auth_user_name', _userName!);
      }
      if (_userEmail != null) {
        await prefs.setString('auth_user_email', _userEmail!);
      }
      if (_userAvatar != null) {
        await prefs.setString('auth_user_avatar', _userAvatar!);
      }
      await prefs.setBool('auth_is_admin', _isAdmin);
      if (_accessToken != null) {
        await prefs.setString('auth_access_token', _accessToken!);
      }
      if (_refreshToken != null) {
        await prefs.setString('auth_refresh_token', _refreshToken!);
      }
      if (_tokenExpiry != null) {
        await prefs.setString('auth_token_expiry', _tokenExpiry!.toIso8601String());
      }
      
    } catch (e) {
      print('Error saving auth data: $e');
    }
  }
  
  /// Очистка сохраненных данных аутентификации
  Future<void> _clearSavedAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.remove('auth_is_authenticated');
      await prefs.remove('auth_user_id');
      await prefs.remove('auth_user_name');
      await prefs.remove('auth_user_email');
      await prefs.remove('auth_user_avatar');
      await prefs.remove('auth_is_admin');
      await prefs.remove('auth_access_token');
      await prefs.remove('auth_refresh_token');
      await prefs.remove('auth_token_expiry');
      
    } catch (e) {
      print('Error clearing saved auth data: $e');
    }
  }
  
  /// Проверка валидности токена
  Future<void> _validateToken() async {
    try {
      if (_tokenExpiry == null || _accessToken == null) {
        reset();
        return;
      }
      
      // Проверяем, не истек ли токен
      if (DateTime.now().isAfter(_tokenExpiry!)) {
        // Пытаемся обновить токен
        final refreshed = await refreshAuthToken();
        if (!refreshed) {
          reset();
        }
      }
      
    } catch (e) {
      print('Error validating token: $e');
      reset();
    }
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
  }
  
  /// Получение статистики аутентификации
  Map<String, dynamic> getAuthStats() {
    return {
      'is_authenticated': _isAuthenticated,
      'user_id': _userId,
      'user_name': _userName,
      'user_email': _userEmail,
      'is_admin': _isAdmin,
      'has_access_token': _accessToken != null,
      'has_refresh_token': _refreshToken != null,
      'token_expiry': _tokenExpiry?.toIso8601String(),
      'is_token_valid': _tokenExpiry != null && DateTime.now().isBefore(_tokenExpiry!),
      'last_activity': DateTime.now().toIso8601String(),
    };
  }
}
