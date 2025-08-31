import 'package:flutter_riverpod/flutter_riverpod.dart';

// Провайдер для управления уведомлениями
final notificationsProvider = StateNotifierProvider<NotificationsNotifier, List<NotificationItem>>((ref) {
  return NotificationsNotifier();
});

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }
}

enum NotificationType {
  info,
  warning,
  error,
  success,
}

class NotificationsNotifier extends StateNotifier<List<NotificationItem>> {
  NotificationsNotifier() : super([]);

  void addNotification(NotificationItem notification) {
    state = [notification, ...state];
  }

  void markAsRead(String id) {
    state = state.map((notification) {
      if (notification.id == id) {
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();
  }

  void deleteNotification(String id) {
    state = state.where((notification) => notification.id != id).toList();
  }

  void clearAll() {
    state = [];
  }
}

// Провайдер для управления сотрудниками
final employeesProvider = StateNotifierProvider<EmployeesNotifier, List<Employee>>((ref) {
  return EmployeesNotifier();
});

class Employee {
  final String id;
  final String name;
  final String email;
  final String role;
  final List<String> permissions;
  final bool isActive;
  final DateTime joinDate;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.permissions,
    required this.isActive,
    required this.joinDate,
  });

  Employee copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    List<String>? permissions,
    bool? isActive,
    DateTime? joinDate,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      isActive: isActive ?? this.isActive,
      joinDate: joinDate ?? this.joinDate,
    );
  }
}

class EmployeesNotifier extends StateNotifier<List<Employee>> {
  EmployeesNotifier() : super([]);

  void addEmployee(Employee employee) {
    state = [...state, employee];
  }

  void updateEmployee(Employee employee) {
    state = state.map((e) {
      if (e.id == employee.id) {
        return employee;
      }
      return e;
    }).toList();
  }

  void deleteEmployee(String id) {
    state = state.where((employee) => employee.id != id).toList();
  }

  void toggleEmployeeStatus(String id) {
    state = state.map((employee) {
      if (employee.id == id) {
        return employee.copyWith(isActive: !employee.isActive);
      }
      return employee;
    }).toList();
  }
}

// Провайдер для управления настройками
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

class AppSettings {
  final bool darkMode;
  final String language;
  final bool autoBackup;
  final String backupFrequency;
  final bool notificationsEnabled;
  final String cloudProvider;

  AppSettings({
    this.darkMode = false,
    this.language = 'en',
    this.autoBackup = true,
    this.backupFrequency = 'daily',
    this.notificationsEnabled = true,
    this.cloudProvider = 'google',
  });

  AppSettings copyWith({
    bool? darkMode,
    String? language,
    bool? autoBackup,
    String? backupFrequency,
    bool? notificationsEnabled,
    String? cloudProvider,
  }) {
    return AppSettings(
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      autoBackup: autoBackup ?? this.autoBackup,
      backupFrequency: backupFrequency ?? this.backupFrequency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      cloudProvider: cloudProvider ?? this.cloudProvider,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(AppSettings());

  void updateSettings(AppSettings newSettings) {
    state = newSettings;
  }

  void toggleDarkMode() {
    state = state.copyWith(darkMode: !state.darkMode);
  }

  void setLanguage(String language) {
    state = state.copyWith(language: language);
  }

  void toggleAutoBackup() {
    state = state.copyWith(autoBackup: !state.autoBackup);
  }

  void setBackupFrequency(String frequency) {
    state = state.copyWith(backupFrequency: frequency);
  }

  void toggleNotifications() {
    state = state.copyWith(notificationsEnabled: !state.notificationsEnabled);
  }

  void setCloudProvider(String provider) {
    state = state.copyWith(cloudProvider: provider);
  }
}
