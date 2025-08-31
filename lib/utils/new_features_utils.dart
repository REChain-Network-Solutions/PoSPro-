import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewFeaturesUtils {
  // Форматирование даты
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  // Форматирование валюты
  static String formatCurrency(double amount, {String currency = 'USD'}) {
    return NumberFormat.currency(
      symbol: currency == 'USD' ? '\$' : currency,
      decimalDigits: 2,
    ).format(amount);
  }

  // Форматирование процентов
  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(1)}%';
  }

  // Форматирование чисел
  static String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  // Получение цвета для типа уведомления
  static Color getNotificationColor(String type) {
    switch (type.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'error':
        return Colors.red;
      case 'info':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Получение иконки для типа уведомления
  static IconData getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'success':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      case 'info':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  // Получение цвета для роли сотрудника
  static Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'administrator':
        return Colors.red;
      case 'manager':
        return Colors.blue;
      case 'cashier':
        return Colors.green;
      case 'stockist':
        return Colors.orange;
      case 'accountant':
        return Colors.purple;
      case 'salesperson':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  // Получение иконки для роли сотрудника
  static IconData getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'administrator':
        return Icons.admin_panel_settings;
      case 'manager':
        return Icons.manage_accounts;
      case 'cashier':
        return Icons.point_of_sale;
      case 'stockist':
        return Icons.inventory;
      case 'accountant':
        return Icons.account_balance;
      case 'salesperson':
        return Icons.person;
      default:
        return Icons.work;
    }
  }

  // Получение цвета для статуса
  static Color getStatusColor(bool isActive) {
    return isActive ? Colors.green : Colors.red;
  }

  // Получение иконки для статуса
  static IconData getStatusIcon(bool isActive) {
    return isActive ? Icons.check_circle : Icons.cancel;
  }

  // Получение цвета для плана
  static Color getPlanColor(String plan) {
    switch (plan.toLowerCase()) {
      case 'free':
        return Colors.grey;
      case 'business':
        return Colors.blue;
      case 'enterprise':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Валидация email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Валидация телефона
  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s-\(\)]+$').hasMatch(phone);
  }

  // Валидация пароля
  static bool isValidPassword(String password) {
    return password.length >= 8;
  }

  // Получение текущего времени
  static String getCurrentTime() {
    return DateFormat('HH:mm:ss').format(DateTime.now());
  }

  // Получение текущей даты
  static String getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  // Получение относительного времени
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  // Получение размера файла
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Получение цвета для прогресса
  static Color getProgressColor(double value) {
    if (value >= 0.8) return Colors.green;
    if (value >= 0.6) return Colors.blue;
    if (value >= 0.4) return Colors.orange;
    if (value >= 0.2) return Colors.red;
    return Colors.grey;
  }

  // Получение текста для прогресса
  static String getProgressText(double value) {
    if (value >= 0.8) return 'Excellent';
    if (value >= 0.6) return 'Good';
    if (value >= 0.4) return 'Fair';
    if (value >= 0.2) return 'Poor';
    return 'Very Poor';
  }

  // Получение случайного цвета
  static Color getRandomColor() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.amber,
    ];
    return colors[DateTime.now().millisecond % colors.length];
  }

  // Получение цвета для темы
  static Color getThemeColor(bool isDark) {
    return isDark ? Colors.white : Colors.black;
  }

  // Получение цвета фона для темы
  static Color getBackgroundColor(bool isDark) {
    return isDark ? Colors.grey[900]! : Colors.grey[100]!;
  }

  // Получение цвета карточки для темы
  static Color getCardColor(bool isDark) {
    return isDark ? Colors.grey[800]! : Colors.white;
  }
}
