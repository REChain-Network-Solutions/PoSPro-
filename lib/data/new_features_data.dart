import 'package:flutter/material.dart';
import '../Provider/new_features_provider.dart';

// Тестовые данные для уведомлений
List<NotificationItem> getSampleNotifications() {
  return [
    NotificationItem(
      id: '1',
      title: 'Backup Completed',
      message: 'Your data has been successfully backed up to the cloud.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      type: NotificationType.success,
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Low Stock Alert',
      message: 'Product "iPhone 13" is running low on stock. Current quantity: 5',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.warning,
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'New Employee Added',
      message: 'John Doe has been added to your team as a Cashier.',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      type: NotificationType.info,
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'API Connection Failed',
      message: 'Failed to connect to payment gateway. Please check your settings.',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      type: NotificationType.error,
      isRead: false,
    ),
    NotificationItem(
      id: '5',
      title: 'Daily Sales Report',
      message: 'Your daily sales report is ready. Total sales: \$2,450',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      type: NotificationType.info,
      isRead: true,
    ),
    NotificationItem(
      id: '6',
      title: 'System Update Available',
      message: 'A new version of POSpro is available. Version 2.1.0 includes bug fixes and performance improvements.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.info,
      isRead: false,
    ),
  ];
}

// Тестовые данные для сотрудников
List<Employee> getSampleEmployees() {
  return [
    Employee(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@company.com',
      role: 'Administrator',
      permissions: [
        'View Sales',
        'Create Sales',
        'Edit Sales',
        'Delete Sales',
        'View Products',
        'Create Products',
        'Edit Products',
        'Delete Products',
        'View Customers',
        'Create Customers',
        'Edit Customers',
        'Delete Customers',
        'View Reports',
        'View Settings',
        'Edit Settings',
        'Manage Employees',
      ],
      isActive: true,
      joinDate: DateTime.now().subtract(const Duration(days: 365)),
    ),
    Employee(
      id: '2',
      name: 'Jane Smith',
      email: 'jane.smith@company.com',
      role: 'Manager',
      permissions: [
        'View Sales',
        'Create Sales',
        'Edit Sales',
        'View Products',
        'Create Products',
        'Edit Products',
        'View Customers',
        'Create Customers',
        'Edit Customers',
        'View Reports',
        'View Settings',
      ],
      isActive: true,
      joinDate: DateTime.now().subtract(const Duration(days: 180)),
    ),
    Employee(
      id: '3',
      name: 'Mike Johnson',
      email: 'mike.johnson@company.com',
      role: 'Cashier',
      permissions: [
        'View Sales',
        'Create Sales',
        'View Products',
        'View Customers',
        'Create Customers',
      ],
      isActive: true,
      joinDate: DateTime.now().subtract(const Duration(days: 90)),
    ),
    Employee(
      id: '4',
      name: 'Sarah Wilson',
      email: 'sarah.wilson@company.com',
      role: 'Stockist',
      permissions: [
        'View Products',
        'Create Products',
        'Edit Products',
        'View Reports',
      ],
      isActive: true,
      joinDate: DateTime.now().subtract(const Duration(days: 120)),
    ),
    Employee(
      id: '5',
      name: 'David Brown',
      email: 'david.brown@company.com',
      role: 'Accountant',
      permissions: [
        'View Sales',
        'View Products',
        'View Customers',
        'View Reports',
        'View Settings',
      ],
      isActive: false,
      joinDate: DateTime.now().subtract(const Duration(days: 300)),
    ),
  ];
}

// Тестовые данные для API сервисов
List<Map<String, dynamic>> getSampleAPIServices() {
  return [
    {
      'name': 'Payment Gateway',
      'description': 'Secure payment processing for credit cards and digital wallets',
      'isConnected': true,
      'lastSync': '2 minutes ago',
      'type': 'payment',
    },
    {
      'name': 'Inventory Management',
      'description': 'Real-time inventory tracking and stock management',
      'isConnected': true,
      'lastSync': '5 minutes ago',
      'type': 'inventory',
    },
    {
      'name': 'Customer CRM',
      'description': 'Customer relationship management and analytics',
      'isConnected': false,
      'lastSync': null,
      'type': 'crm',
    },
    {
      'name': 'Shipping Provider',
      'description': 'Shipping rates and tracking information',
      'isConnected': true,
      'lastSync': '1 hour ago',
      'type': 'shipping',
    },
    {
      'name': 'Accounting Software',
      'description': 'Financial reporting and bookkeeping integration',
      'isConnected': false,
      'lastSync': null,
      'type': 'accounting',
    },
  ];
}

// Тестовые данные для резервного копирования
List<Map<String, dynamic>> getSampleBackupData() {
  return [
    {
      'title': 'Local Backup',
      'status': 'Completed',
      'lastBackup': '2 hours ago',
      'nextBackup': 'In 22 hours',
      'statusColor': Colors.green,
      'size': '2.5 GB',
      'type': 'local',
    },
    {
      'title': 'Cloud Backup',
      'status': 'In Progress',
      'lastBackup': '1 day ago',
      'nextBackup': 'In 6 hours',
      'statusColor': Colors.orange,
      'size': '2.3 GB',
      'type': 'cloud',
    },
    {
      'title': 'Database Backup',
      'status': 'Completed',
      'lastBackup': '6 hours ago',
      'nextBackup': 'In 18 hours',
      'statusColor': Colors.green,
      'size': '500 MB',
      'type': 'database',
    },
  ];
}

// Тестовые данные для аналитики
Map<String, dynamic> getSampleAnalyticsData() {
  return {
    'kpi': {
      'totalSales': 125000.0,
      'totalOrders': 1250,
      'averageOrderValue': 100.0,
      'customerCount': 450,
      'productCount': 1200,
      'profitMargin': 0.25,
    },
    'salesTrend': [
      {'date': '2024-01-01', 'sales': 4500.0},
      {'date': '2024-01-02', 'sales': 5200.0},
      {'date': '2024-01-03', 'sales': 4800.0},
      {'date': '2024-01-04', 'sales': 6100.0},
      {'date': '2024-01-05', 'sales': 5800.0},
      {'date': '2024-01-06', 'sales': 7200.0},
      {'date': '2024-01-07', 'sales': 6800.0},
    ],
    'topProducts': [
      {'name': 'iPhone 13', 'sales': 15000.0, 'quantity': 25},
      {'name': 'Samsung Galaxy S21', 'sales': 12000.0, 'quantity': 20},
      {'name': 'MacBook Pro', 'sales': 18000.0, 'quantity': 8},
      {'name': 'iPad Air', 'sales': 9000.0, 'quantity': 15},
      {'name': 'AirPods Pro', 'sales': 6000.0, 'quantity': 30},
    ],
    'customerSegments': [
      {'segment': 'New Customers', 'count': 150, 'percentage': 0.33},
      {'segment': 'Returning Customers', 'count': 200, 'percentage': 0.44},
      {'segment': 'VIP Customers', 'count': 50, 'percentage': 0.11},
      {'segment': 'Inactive Customers', 'count': 50, 'percentage': 0.11},
    ],
    'revenueByCategory': [
      {'category': 'Electronics', 'revenue': 75000.0, 'percentage': 0.60},
      {'category': 'Accessories', 'revenue': 25000.0, 'percentage': 0.20},
      {'category': 'Software', 'revenue': 15000.0, 'percentage': 0.12},
      {'category': 'Services', 'revenue': 10000.0, 'percentage': 0.08},
    ],
  };
}

// Тестовые данные для настроек
Map<String, dynamic> getSampleSettingsData() {
  return {
    'appearance': {
      'darkMode': false,
      'theme': 'Light',
      'accentColor': 'Blue',
      'fontSize': 'Medium',
    },
    'language': {
      'current': 'English',
      'region': 'United States',
      'dateFormat': 'MM/DD/YYYY',
      'timeFormat': '12-hour',
      'currency': 'USD',
    },
    'sync': {
      'autoSync': true,
      'syncInterval': '15 minutes',
      'wifiOnly': false,
      'batteryOptimization': true,
    },
    'security': {
      'biometricAuth': true,
      'pinCode': '1234',
      'sessionTimeout': '30 minutes',
      'twoFactorAuth': false,
    },
    'notifications': {
      'enabled': true,
      'sound': true,
      'vibration': true,
      'salesAlerts': true,
      'stockAlerts': true,
      'systemUpdates': true,
    },
    'data': {
      'autoBackup': true,
      'backupFrequency': 'Daily',
      'cloudProvider': 'Google Drive',
      'dataRetention': '2 years',
      'exportFormat': 'CSV',
    },
  };
}

// Тестовые данные для истории резервного копирования
List<Map<String, dynamic>> getSampleBackupHistory() {
  return [
    {
      'date': '2024-01-07 14:30:00',
      'type': 'Full Backup',
      'status': 'Completed',
      'size': '2.5 GB',
      'duration': '5 minutes',
      'location': 'Local + Cloud',
    },
    {
      'date': '2024-01-06 14:30:00',
      'type': 'Full Backup',
      'status': 'Completed',
      'size': '2.4 GB',
      'duration': '5 minutes',
      'location': 'Local + Cloud',
    },
    {
      'date': '2024-01-05 14:30:00',
      'type': 'Full Backup',
      'status': 'Failed',
      'size': '0 GB',
      'duration': '0 minutes',
      'location': 'Local + Cloud',
    },
    {
      'date': '2024-01-04 14:30:00',
      'type': 'Full Backup',
      'status': 'Completed',
      'size': '2.3 GB',
      'duration': '5 minutes',
      'location': 'Local + Cloud',
    },
    {
      'date': '2024-01-03 14:30:00',
      'type': 'Full Backup',
      'status': 'Completed',
      'size': '2.3 GB',
      'duration': '5 minutes',
      'location': 'Local + Cloud',
    },
  ];
}

// Тестовые данные для ролей и разрешений
Map<String, List<String>> getSampleRolesAndPermissions() {
  return {
    'Administrator': [
      'View Sales',
      'Create Sales',
      'Edit Sales',
      'Delete Sales',
      'View Products',
      'Create Products',
      'Edit Products',
      'Delete Products',
      'View Customers',
      'Create Customers',
      'Edit Customers',
      'Delete Customers',
      'View Reports',
      'View Settings',
      'Edit Settings',
      'Manage Employees',
    ],
    'Manager': [
      'View Sales',
      'Create Sales',
      'Edit Sales',
      'View Products',
      'Create Products',
      'Edit Products',
      'View Customers',
      'Create Customers',
      'Edit Customers',
      'View Reports',
      'View Settings',
    ],
    'Cashier': [
      'View Sales',
      'Create Sales',
      'View Products',
      'View Customers',
      'Create Customers',
    ],
    'Stockist': [
      'View Products',
      'Create Products',
      'Edit Products',
      'View Reports',
    ],
    'Accountant': [
      'View Sales',
      'View Products',
      'View Customers',
      'View Reports',
      'View Settings',
    ],
    'Salesperson': [
      'View Sales',
      'Create Sales',
      'View Products',
      'View Customers',
      'Create Customers',
    ],
  };
}
