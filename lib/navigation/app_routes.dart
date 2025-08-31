import 'package:flutter/material.dart';
import '../Screens/Analytics/advanced_analytics_screen.dart';
import '../Screens/Employee/employee_management_screen.dart';
import '../Screens/API/api_integration_screen.dart';
import '../Screens/Backup/backup_sync_screen.dart';
import '../Screens/Notifications/notifications_screen.dart';
import '../Screens/Settings/advanced_settings_screen.dart';

class AppRoutes {
  static const String analytics = '/Analytics';
  static const String employeeManagement = '/Employee Management';
  static const String apiIntegration = '/API Integration';
  static const String backupSync = '/Backup & Sync';
  static const String notifications = '/Notifications';
  static const String settings = '/Settings';
  static const String advancedAnalytics = '/Advanced Analytics';
  static const String multiBranchManagement = '/Multi-Branch Management';
  static const String advancedSecurity = '/Advanced Security';
  static const String customIntegrations = '/Custom Integrations';
  static const String whiteLabelSolution = '/White Label Solution';
  static const String prioritySupport = '/Priority Support';
  static const String advancedReporting = '/Advanced Reporting';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      analytics: (context) => const AdvancedAnalyticsScreen(),
      employeeManagement: (context) => const EmployeeManagementScreen(),
      apiIntegration: (context) => const APIIntegrationScreen(),
      backupSync: (context) => const BackupSyncScreen(),
      notifications: (context) => const NotificationsScreen(),
      settings: (context) => const AdvancedSettingsScreen(),
      advancedAnalytics: (context) => const AdvancedAnalyticsScreen(),
      // Для enterprise функций можно использовать те же экраны или создать специализированные
      multiBranchManagement: (context) => const EmployeeManagementScreen(), // Временно
      advancedSecurity: (context) => const AdvancedSettingsScreen(), // Временно
      customIntegrations: (context) => const APIIntegrationScreen(), // Временно
      whiteLabelSolution: (context) => const AdvancedSettingsScreen(), // Временно
      prioritySupport: (context) => const AdvancedSettingsScreen(), // Временно
      advancedReporting: (context) => const AdvancedAnalyticsScreen(), // Временно
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final routes = getRoutes();
    if (routes.containsKey(settings.name)) {
      return MaterialPageRoute(
        builder: routes[settings.name]!,
        settings: settings,
      );
    }
    return null;
  }
}
