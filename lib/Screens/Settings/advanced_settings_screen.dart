import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/Const/new_features_constants.dart';

class AdvancedSettingsScreen extends StatefulWidget {
  const AdvancedSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AdvancedSettingsScreen> createState() => _AdvancedSettingsScreenState();
}

class _AdvancedSettingsScreenState extends State<AdvancedSettingsScreen> {
  bool isDarkMode = false;
  bool isAutoSync = true;
  bool isPushNotifications = true;
  bool isBiometricAuth = false;
  bool isOfflineMode = false;
  
  String selectedLanguage = 'English';
  String selectedCurrency = 'USD';
  String selectedTimeZone = 'UTC+0';
  
  List<String> languages = ['English', 'Spanish', 'French', 'German', 'Chinese', 'Japanese'];
  List<String> currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD'];
  List<String> timeZones = ['UTC+0', 'UTC+1', 'UTC+2', 'UTC+3', 'UTC+4', 'UTC+5'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kWhite,
        surfaceTintColor: kWhite,
        title: Text(
          'Advanced Settings',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: kTitleColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showResetDialog(context);
            },
            icon: const Icon(Icons.restore, color: kGreyTextColor),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance Settings
            _buildSettingsSection(
              'Appearance',
              Icons.palette,
              [
                _buildSwitchSetting(
                  'Dark Mode',
                  'Enable dark theme for better visibility in low light',
                  isDarkMode,
                  (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Language & Regional Settings
            _buildSettingsSection(
              'Language & Regional',
              Icons.language,
              [
                _buildDropdownSetting(
                  'Language',
                  'Select your preferred language',
                  selectedLanguage,
                  languages,
                  (value) {
                    setState(() {
                      selectedLanguage = value!;
                    });
                  },
                ),
                _buildDropdownSetting(
                  'Currency',
                  'Select your local currency',
                  selectedCurrency,
                  currencies,
                  (value) {
                    setState(() {
                      selectedCurrency = value!;
                    });
                  },
                ),
                _buildDropdownSetting(
                  'Time Zone',
                  'Select your local time zone',
                  selectedTimeZone,
                  timeZones,
                  (value) {
                    setState(() {
                      selectedTimeZone = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Sync & Connectivity Settings
            _buildSettingsSection(
              'Sync & Connectivity',
              Icons.sync,
              [
                _buildSwitchSetting(
                  'Auto Sync',
                  'Automatically sync data when connected to internet',
                  isAutoSync,
                  (value) {
                    setState(() {
                      isAutoSync = value;
                    });
                  },
                ),
                _buildSwitchSetting(
                  'Offline Mode',
                  'Allow app to work without internet connection',
                  isOfflineMode,
                  (value) {
                    setState(() {
                      isOfflineMode = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Security Settings
            _buildSettingsSection(
              'Security',
              Icons.security,
              [
                _buildSwitchSetting(
                  'Biometric Authentication',
                  'Use fingerprint or face ID to unlock the app',
                  isBiometricAuth,
                  (value) {
                    setState(() {
                      isBiometricAuth = value;
                    });
                  },
                ),
                _buildButtonSetting(
                  'Change Password',
                  'Update your account password',
                  Icons.lock,
                  () {
                    _showChangePasswordDialog(context);
                  },
                ),
                _buildButtonSetting(
                  'Two-Factor Authentication',
                  'Add an extra layer of security',
                  Icons.verified_user,
                  () {
                    _showTwoFactorDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Notification Settings
            _buildSettingsSection(
              'Notifications',
              Icons.notifications,
              [
                _buildSwitchSetting(
                  'Push Notifications',
                  'Receive notifications on your device',
                  isPushNotifications,
                  (value) {
                    setState(() {
                      isPushNotifications = value;
                    });
                  },
                ),
                _buildButtonSetting(
                  'Notification Preferences',
                  'Customize notification types and frequency',
                  Icons.settings,
                  () {
                    _showNotificationPreferences(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Data & Storage Settings
            _buildSettingsSection(
              'Data & Storage',
              Icons.storage,
              [
                _buildButtonSetting(
                  'Data Export',
                  'Export your data in various formats',
                  Icons.download,
                  () {
                    _showDataExportDialog(context);
                  },
                ),
                _buildButtonSetting(
                  'Data Import',
                  'Import data from other sources',
                  Icons.upload,
                  () {
                    _showDataImportDialog(context);
                  },
                ),
                _buildButtonSetting(
                  'Clear Cache',
                  'Free up storage space by clearing cache',
                  Icons.cleaning_services,
                  () {
                    _showClearCacheDialog(context);
                  },
                ),
                _buildButtonSetting(
                  'Delete Account',
                  'Permanently delete your account and data',
                  Icons.delete_forever,
                  () {
                    _showDeleteAccountDialog(context);
                  },
                  isDestructive: true,
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // About & Support
            _buildSettingsSection(
              'About & Support',
              Icons.info,
              [
                _buildButtonSetting(
                  'App Version',
                  'Version 1.0.2 (Build 4)',
                  Icons.info_outline,
                  () {
                    _showAppInfoDialog(context);
                  },
                ),
                _buildButtonSetting(
                  'Terms of Service',
                  'Read our terms and conditions',
                  Icons.description,
                  () {
                    _showTermsDialog(context);
                  },
                ),
                _buildButtonSetting(
                  'Privacy Policy',
                  'Learn about data privacy',
                  Icons.privacy_tip,
                  () {
                    _showPrivacyDialog(context);
                  },
                ),
                _buildButtonSetting(
                  'Contact Support',
                  'Get help from our support team',
                  Icons.support_agent,
                  () {
                    _showSupportDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _saveSettings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: NewFeaturesColors.primary,
                  foregroundColor: kWhite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save Settings',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, IconData icon, List<Widget> children) {
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
          Row(
            children: [
              Icon(icon, color: NewFeaturesColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kTitleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchSetting(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: kTitleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: kGreyTextColor,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: NewFeaturesColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(String title, String subtitle, String value, List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: kTitleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: kGreyTextColor,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSetting(String title, String subtitle, IconData icon, VoidCallback onTap, {bool isDestructive = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDestructive ? Colors.red : NewFeaturesColors.primary,
                size: 20,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDestructive ? Colors.red : kTitleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: kGreyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveSettings() {
    // Save settings logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Settings saved successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Reset Settings',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Are you sure you want to reset all settings to their default values? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _resetSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: kWhite,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _resetSettings() {
    setState(() {
      isDarkMode = false;
      isAutoSync = true;
      isPushNotifications = true;
      isBiometricAuth = false;
      isOfflineMode = false;
      selectedLanguage = 'English';
      selectedCurrency = 'USD';
      selectedTimeZone = 'UTC+0';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Settings reset to default values'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Change Password',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
              ),
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
                // Change password logic
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  void _showTwoFactorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Two-Factor Authentication',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Two-factor authentication adds an extra layer of security to your account by requiring a verification code in addition to your password.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Enable 2FA logic
              },
              child: const Text('Enable'),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationPreferences(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Notification Preferences',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Customize your notification preferences here...'),
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

  void _showDataExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Data Export',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select the data you want to export and the format...'),
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
                // Export data logic
              },
              child: const Text('Export'),
            ),
          ],
        );
      },
    );
  }

  void _showDataImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Data Import',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select the file you want to import...'),
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
                // Import data logic
              },
              child: const Text('Import'),
            ),
          ],
        );
      },
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Clear Cache',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'This will clear all cached data and free up storage space. The app will need to re-download some data on next use.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Clear cache logic
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Account',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Warning: This action will permanently delete your account and all associated data. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Delete account logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: kWhite,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'App Information',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('App Name: PoSPro'),
              Text('Version: 1.0.2'),
              Text('Build: 4'),
              Text('Package: com.delus.pos'),
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

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Terms of Service',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Terms of service content will appear here...',
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

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Privacy Policy',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Privacy policy content will appear here...',
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

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Contact Support',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Email: support@pospro.com'),
              Text('Phone: +1-800-POS-PRO'),
              Text('Live Chat: Available 24/7'),
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
