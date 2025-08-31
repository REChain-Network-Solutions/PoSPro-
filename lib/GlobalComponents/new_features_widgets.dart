import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Const/new_features_constants.dart';
import '../utils/new_features_utils.dart';

// Виджет для KPI карточки
class KPICard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const KPICard({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(NewFeaturesSizes.cardPadding),
        decoration: BoxDecoration(
          color: color ?? NewFeaturesColors.primary,
          borderRadius: BorderRadius.circular(NewFeaturesSizes.cardRadius),
          boxShadow: [
            BoxShadow(
              color: (color ?? NewFeaturesColors.primary).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: NewFeaturesSizes.iconSize,
                ),
                const Spacer(),
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.7),
                    size: 16,
                  ),
              ],
            ),
            const SizedBox(height: NewFeaturesSizes.spacing),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: NewFeaturesSizes.smallSpacing),
              Text(
                subtitle!,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Виджет для карточки уведомления
class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final DateTime timestamp;
  final String type;
  final bool isRead;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const NotificationCard({
    Key? key,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    required this.isRead,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: NewFeaturesSizes.spacing,
        vertical: NewFeaturesSizes.smallSpacing,
      ),
      color: isRead ? Colors.grey[100] : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: NewFeaturesUtils.getNotificationColor(type),
          child: Icon(
            NewFeaturesUtils.getNotificationIcon(type),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
            color: isRead ? Colors.grey[600] : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: GoogleFonts.poppins(
                color: isRead ? Colors.grey[600] : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              NewFeaturesUtils.getRelativeTime(timestamp),
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
                color: Colors.red,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}

// Виджет для карточки сотрудника
class EmployeeCard extends StatelessWidget {
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final DateTime joinDate;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EmployeeCard({
    Key? key,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    required this.joinDate,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: NewFeaturesSizes.spacing,
        vertical: NewFeaturesSizes.smallSpacing,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: NewFeaturesUtils.getRoleColor(role),
          child: Icon(
            NewFeaturesUtils.getRoleIcon(role),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.black : Colors.grey[600],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              email,
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: NewFeaturesUtils.getRoleColor(role).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    role,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: NewFeaturesUtils.getRoleColor(role),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: NewFeaturesUtils.getStatusColor(isActive).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        NewFeaturesUtils.getStatusIcon(isActive),
                        size: 12,
                        color: NewFeaturesUtils.getStatusColor(isActive),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isActive ? 'Active' : 'Inactive',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: NewFeaturesUtils.getStatusColor(isActive),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
                color: Colors.blue,
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
                color: Colors.red,
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

// Виджет для карточки API сервиса
class APIServiceCard extends StatelessWidget {
  final String name;
  final String description;
  final bool isConnected;
  final String? lastSync;
  final VoidCallback? onConnect;
  final VoidCallback? onConfigure;
  final VoidCallback? onDisconnect;

  const APIServiceCard({
    Key? key,
    required this.name,
    required this.description,
    required this.isConnected,
    this.lastSync,
    this.onConnect,
    this.onConfigure,
    this.onDisconnect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: NewFeaturesSizes.spacing,
        vertical: NewFeaturesSizes.smallSpacing,
      ),
      child: Padding(
        padding: const EdgeInsets.all(NewFeaturesSizes.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.api,
                  color: isConnected ? Colors.green : Colors.grey,
                  size: NewFeaturesSizes.iconSize,
                ),
                const SizedBox(width: NewFeaturesSizes.spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (isConnected ? Colors.green : Colors.grey).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isConnected ? 'Connected' : 'Disconnected',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isConnected ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            if (isConnected && lastSync != null) ...[
              const SizedBox(height: NewFeaturesSizes.spacing),
              Text(
                'Last sync: $lastSync',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
            const SizedBox(height: NewFeaturesSizes.spacing),
            Row(
              children: [
                if (!isConnected && onConnect != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onConnect,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NewFeaturesColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(NewFeaturesSizes.buttonRadius),
                        ),
                      ),
                      child: const Text('Connect'),
                    ),
                  ),
                if (isConnected) ...[
                  if (onConfigure != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onConfigure,
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(NewFeaturesSizes.buttonRadius),
                          ),
                        ),
                        child: const Text('Configure'),
                      ),
                    ),
                  if (onDisconnect != null) ...[
                    const SizedBox(width: NewFeaturesSizes.spacing),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onDisconnect,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(NewFeaturesSizes.buttonRadius),
                          ),
                        ),
                        child: const Text('Disconnect'),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Виджет для карточки статуса резервного копирования
class BackupStatusCard extends StatelessWidget {
  final String title;
  final String status;
  final String? lastBackup;
  final String? nextBackup;
  final Color statusColor;
  final VoidCallback? onAction;

  const BackupStatusCard({
    Key? key,
    required this.title,
    required this.status,
    this.lastBackup,
    this.nextBackup,
    required this.statusColor,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: NewFeaturesSizes.spacing,
        vertical: NewFeaturesSizes.smallSpacing,
      ),
      child: Padding(
        padding: const EdgeInsets.all(NewFeaturesSizes.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.backup,
                  color: statusColor,
                  size: NewFeaturesSizes.iconSize,
                ),
                const SizedBox(width: NewFeaturesSizes.spacing),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            if (lastBackup != null) ...[
              const SizedBox(height: NewFeaturesSizes.spacing),
              Text(
                'Last backup: $lastBackup',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
            if (nextBackup != null) ...[
              const SizedBox(height: NewFeaturesSizes.smallSpacing),
              Text(
                'Next backup: $nextBackup',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
            if (onAction != null) ...[
              const SizedBox(height: NewFeaturesSizes.spacing),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(NewFeaturesSizes.buttonRadius),
                    ),
                  ),
                  child: const Text('Backup Now'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
