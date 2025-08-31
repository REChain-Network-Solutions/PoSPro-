import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Const/new_features_constants.dart';

class BackupSyncScreen extends StatefulWidget {
  const BackupSyncScreen({Key? key}) : super(key: key);

  @override
  State<BackupSyncScreen> createState() => _BackupSyncScreenState();
}

class _BackupSyncScreenState extends State<BackupSyncScreen> {
  bool isAutoBackupEnabled = true;
  bool isCloudSyncEnabled = true;
  String selectedBackupFrequency = 'Daily';
  String selectedCloudProvider = 'Google Drive';
  
  List<String> backupFrequencies = ['Hourly', 'Daily', 'Weekly', 'Monthly'];
  List<String> cloudProviders = ['Google Drive', 'Dropbox', 'OneDrive', 'AWS S3'];

  final List<BackupHistory> backupHistory = [
    BackupHistory(
      date: '2024-01-15 14:30',
      type: 'Automatic',
      size: '2.5 GB',
      status: 'Completed',
      duration: '5 min',
    ),
    BackupHistory(
      date: '2024-01-14 14:30',
      type: 'Manual',
      size: '2.3 GB',
      status: 'Completed',
      duration: '4 min',
    ),
    BackupHistory(
      date: '2024-01-13 14:30',
      type: 'Automatic',
      size: '2.4 GB',
      status: 'Failed',
      duration: '0 min',
    ),
    BackupHistory(
      date: '2024-01-12 14:30',
      type: 'Automatic',
      size: '2.2 GB',
      status: 'Completed',
      duration: '3 min',
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
          'Backup & Sync',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: kTitleColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showSettingsDialog(context);
            },
            icon: const Icon(Icons.settings, color: kGreyTextColor),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Cards
            _buildStatusCards(),
            const SizedBox(height: 24),
            
            // Backup Settings
            _buildBackupSettings(),
            const SizedBox(height: 24),
            
            // Cloud Sync Settings
            _buildCloudSyncSettings(),
            const SizedBox(height: 24),
            
            // Backup History
            _buildBackupHistory(),
            const SizedBox(height: 24),
            
            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatusCard(
            'Last Backup',
            '2 hours ago',
            Icons.backup,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatusCard(
            'Next Backup',
            '10 hours',
            Icons.schedule,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatusCard(
            'Total Size',
            '2.5 GB',
            Icons.storage,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(String title, String value, IconData icon, Color color) {
    return Container(
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
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kTitleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: kGreyTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBackupSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
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
            'Backup Settings',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: kTitleColor,
            ),
          ),
          const SizedBox(height: 20),
          
          // Auto Backup Toggle
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Automatic Backup',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: kTitleColor,
                      ),
                    ),
                    Text(
                      'Automatically backup your data at scheduled intervals',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: kGreyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isAutoBackupEnabled,
                onChanged: (value) {
                  setState(() {
                    isAutoBackupEnabled = value;
                  });
                },
                activeColor: NewFeaturesColors.primary,
              ),
            ],
          ),
          
          if (isAutoBackupEnabled) ...[
            const SizedBox(height: 20),
            Text(
              'Backup Frequency',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: kTitleColor,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedBackupFrequency,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: backupFrequencies.map((frequency) {
                return DropdownMenuItem(
                  value: frequency,
                  child: Text(frequency),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBackupFrequency = value!;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCloudSyncSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
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
            'Cloud Sync Settings',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: kTitleColor,
            ),
          ),
          const SizedBox(height: 20),
          
          // Cloud Sync Toggle
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cloud Synchronization',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: kTitleColor,
                      ),
                    ),
                    Text(
                      'Sync your data across multiple devices',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: kGreyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isCloudSyncEnabled,
                onChanged: (value) {
                  setState(() {
                    isCloudSyncEnabled = value;
                  });
                },
                activeColor: NewFeaturesColors.primary,
              ),
            ],
          ),
          
          if (isCloudSyncEnabled) ...[
            const SizedBox(height: 20),
            Text(
              'Cloud Provider',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: kTitleColor,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedCloudProvider,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: cloudProviders.map((provider) {
                return DropdownMenuItem(
                  value: provider,
                  child: Text(provider),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCloudProvider = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Make sure you have sufficient storage space in your cloud account',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBackupHistory() {
    return Container(
      padding: const EdgeInsets.all(20),
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
            'Backup History',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: kTitleColor,
            ),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: backupHistory.length,
            itemBuilder: (context, index) {
              final backup = backupHistory[index];
              return _buildBackupHistoryItem(backup);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBackupHistoryItem(BackupHistory backup) {
    Color statusColor = backup.status == 'Completed' ? Colors.green : Colors.red;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              backup.status == 'Completed' ? Icons.check_circle : Icons.error,
              color: statusColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  backup.date,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: kTitleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      backup.type,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: kGreyTextColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      backup.size,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: kGreyTextColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      backup.duration,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: kGreyTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              backup.status,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              _startManualBackup();
            },
            icon: const Icon(Icons.backup),
            label: Text(
              'Start Backup',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: NewFeaturesColors.primary,
              foregroundColor: kWhite,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              _restoreFromBackup();
            },
            icon: const Icon(Icons.restore),
            label: Text(
              'Restore',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: NewFeaturesColors.primary,
              side: const BorderSide(color: NewFeaturesColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _startManualBackup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Start Manual Backup',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Are you sure you want to start a manual backup? This may take several minutes.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showBackupProgress();
              },
              child: const Text('Start'),
            ),
          ],
        );
      },
    );
  }

  void _showBackupProgress() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Backup in Progress',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Please wait while your data is being backed up...'),
            ],
          ),
        );
      },
    );
    
    // Simulate backup completion
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      _showBackupComplete();
    });
  }

  void _showBackupComplete() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Backup completed successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _restoreFromBackup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Restore from Backup',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Warning: This will overwrite your current data. Are you sure you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Restore logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: kWhite,
              ),
              child: const Text('Restore'),
            ),
          ],
        );
      },
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Backup Settings',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Advanced backup settings and configurations will appear here.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class BackupHistory {
  final String date;
  final String type;
  final String size;
  final String status;
  final String duration;

  BackupHistory({
    required this.date,
    required this.type,
    required this.size,
    required this.status,
    required this.duration,
  });
}
