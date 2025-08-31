import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/Const/new_features_constants.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String selectedFilter = 'All';
  List<String> filters = ['All', 'Sales', 'Inventory', 'Finance', 'System', 'Marketing'];

  final List<NotificationItem> notifications = [
    NotificationItem(
      id: '1',
      title: 'New Sale Completed',
      message: 'Sale #12345 has been completed successfully. Total amount: \$150.00',
      type: 'Sales',
      priority: 'High',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
      icon: Icons.shopping_cart,
      color: Colors.green,
    ),
    NotificationItem(
      id: '2',
      title: 'Low Stock Alert',
      message: 'Product "iPhone 15 Pro" is running low on stock. Current quantity: 5',
      type: 'Inventory',
      priority: 'Medium',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      icon: Icons.inventory,
      color: Colors.orange,
    ),
    NotificationItem(
      id: '3',
      title: 'Payment Received',
      message: 'Payment of \$500.00 received from customer John Doe',
      type: 'Finance',
      priority: 'High',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
      icon: Icons.payment,
      color: Colors.blue,
    ),
    NotificationItem(
      id: '4',
      title: 'System Maintenance',
      message: 'Scheduled system maintenance will begin in 30 minutes',
      type: 'System',
      priority: 'Low',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
      icon: Icons.system_update,
      color: Colors.grey,
    ),
    NotificationItem(
      id: '5',
      title: 'Marketing Campaign',
      message: 'New email campaign "Summer Sale" has been launched',
      type: 'Marketing',
      priority: 'Medium',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: true,
      icon: Icons.campaign,
      color: Colors.purple,
    ),
    NotificationItem(
      id: '6',
      title: 'Customer Feedback',
      message: 'New 5-star review received from customer Sarah Wilson',
      type: 'Sales',
      priority: 'Medium',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
      icon: Icons.star,
      color: Colors.amber,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kWhite,
        surfaceTintColor: kWhite,
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: kTitleColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _markAllAsRead();
            },
            icon: const Icon(Icons.done_all, color: kGreyTextColor),
          ),
          IconButton(
            onPressed: () {
              _showNotificationSettings(context);
            },
            icon: const Icon(Icons.settings, color: kGreyTextColor),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          _buildFilterSection(),
          
          // Notifications List
          Expanded(
            child: _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Notifications',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kTitleColor,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: filters.map((filter) {
              bool isSelected = selectedFilter == filter;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? NewFeaturesColors.primary : NewFeaturesColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? NewFeaturesColors.primary : NewFeaturesColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    filter,
                    style: GoogleFonts.poppins(
                      color: isSelected ? kWhite : NewFeaturesColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    List<NotificationItem> filteredNotifications = _getFilteredNotifications();
    
    if (filteredNotifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: kGreyTextColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications found',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: kGreyTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up!',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: kGreyTextColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  List<NotificationItem> _getFilteredNotifications() {
    if (selectedFilter == 'All') {
      return notifications;
    }
    return notifications.where((n) => n.type == selectedFilter).toList();
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _markAsRead(notification);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: notification.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(notification.icon, color: notification.color, size: 20),
                ),
                
                const SizedBox(width: 16),
                
                // Notification Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
                                color: notification.isRead ? kGreyTextColor : kTitleColor,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(notification.priority).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              notification.priority,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: _getPriorityColor(notification.priority),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notification.message,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: kGreyTextColor,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            _formatTimestamp(notification.timestamp),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: kGreyTextColor,
                            ),
                          ),
                          const Spacer(),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: NewFeaturesColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Action Menu
                PopupMenuButton<String>(
                  onSelected: (value) {
                    _handleNotificationAction(value, notification);
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'mark_read',
                      child: Row(
                        children: [
                          Icon(
                            notification.isRead ? Icons.mark_email_unread : Icons.mark_email_read,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(notification.isRead ? 'Mark as unread' : 'Mark as read'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: const Row(
                        children: [
                          Icon(Icons.delete, size: 18),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                  child: const Icon(
                    Icons.more_vert,
                    color: kGreyTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _markAsRead(NotificationItem notification) {
    setState(() {
      notification.isRead = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All notifications marked as read'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleNotificationAction(String action, NotificationItem notification) {
    switch (action) {
      case 'mark_read':
        setState(() {
          notification.isRead = !notification.isRead;
        });
        break;
      case 'delete':
        setState(() {
          notifications.remove(notification);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification deleted'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        break;
    }
  }

  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Notification Settings',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSettingItem('Sales Notifications', true),
              _buildSettingItem('Inventory Alerts', true),
              _buildSettingItem('Financial Updates', false),
              _buildSettingItem('System Messages', true),
              _buildSettingItem('Marketing Updates', false),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Settings saved'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingItem(String title, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: kTitleColor,
              ),
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) {
              // Handle setting change
            },
            activeColor: NewFeaturesColors.primary,
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type;
  final String priority;
  final DateTime timestamp;
  bool isRead;
  final IconData icon;
  final Color color;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.timestamp,
    required this.isRead,
    required this.icon,
    required this.color,
  });
}
