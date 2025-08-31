
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Const/api_config.dart';
import 'package:mobile_pos/Screens/DashBoard/dashboard.dart';
import 'package:mobile_pos/Screens/Profile%20Screen/profile_details.dart';
import 'package:mobile_pos/Screens/User%20Roles/user_role_screen.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/profile_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/business_info_model.dart';
import '../Authentication/Repo/logout_repo.dart';
import '../Currency/currency_screen.dart';
import '../Shimmers/home_screen_appbar_shimmer.dart';
import '../language/language.dart';
import '../subscription/package_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with TickerProviderStateMixin {
  String? dropdownValue = '\$ (US Dollar)';
  bool expanded = false;
  bool expandedHelp = false;
  bool expandedAbout = false;
  bool selected = false;
  
  // Анимации
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  // Настройки
  bool isDarkMode = false;
  bool isAutoSync = true;
  bool isPushNotifications = true;
  bool isBiometricAuth = false;
  bool isOfflineMode = false;
  bool isPrintEnable = true;
  
  String selectedLanguage = 'English';
  String selectedCurrency = 'USD';
  String selectedTimeZone = 'UTC+0';
  
  List<String> languages = ['English', 'Spanish', 'French', 'German', 'Chinese', 'Japanese'];
  List<String> currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD'];
  List<String> timeZones = ['UTC+0', 'UTC+1', 'UTC+2', 'UTC+3', 'UTC+4', 'UTC+5'];
  
  // Сохраняем ref для использования в диалогах
  WidgetRef? currentRef;

  @override
  void initState() {
    super.initState();
    
    // Инициализация анимаций
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
    _pulseController.repeat(reverse: true);

    printerIsEnable();
    getCurrency();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('currency');

    List<String> currencyItems = ['\$ (US Dollar)', '€ (Euro)', '£ (Pound)', '¥ (Yen)', '₽ (Ruble)'];

    if (!data.isEmptyOrNull) {
      for (var element in currencyItems) {
        if (element.substring(0, 2).contains(data!)) {
          setState(() {
            dropdownValue = element;
          });
          break;
        }
      }
    } else {
      setState(() {
        dropdownValue = currencyItems[0];
      });
    }
  }

  void printerIsEnable() async {
    final prefs = await SharedPreferences.getInstance();
    isPrintEnable = prefs.getBool('isPrintEnable') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(builder: (context, ref, _) {
        AsyncValue<BusinessInformation> businessInfo = ref.watch(businessInfoProvider);
        
        // Сохраняем ref для использования в диалогах
        currentRef = ref;
        
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(businessInfo),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
            child: Column(
              children: [
                        _buildProfileHeader(businessInfo),
                        _buildQuickSettings(),
                        _buildMainSettings(),
                        _buildAdvancedSettings(),
                        _buildSupportSection(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSliverAppBar(AsyncValue<BusinessInformation> businessInfo) {
    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Настройки',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
                Theme.of(context).primaryColor.withOpacity(0.6),
              ],
            ),
          ),
          child: Center(
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Icon(
                Icons.settings,
                size: 60,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () => _refreshSettings(),
        ),
        IconButton(
          icon: const Icon(Icons.help_outline, color: Colors.white),
          onPressed: () => _showHelpDialog(),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(AsyncValue<BusinessInformation> businessInfo) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: businessInfo.when(
        data: (details) => Column(
                        children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: GestureDetector(
                onTap: () => const ProfileDetails().launch(context),
                            child: Container(
                  height: 80,
                  width: 80,
                              decoration: BoxDecoration(
                    shape: BoxShape.circle,
                                image: details.pictureUrl == null
                        ? const DecorationImage(
                            image: AssetImage('images/no_shop_image.png'),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: NetworkImage(APIConfig.domain + details.pictureUrl.toString()),
                            fit: BoxFit.cover,
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                              ),
                            ),
                          ),
                          ),
            const SizedBox(height: 20),
                              Text(
              details.user?.role == 'staff'
                  ? '${details.companyName ?? ''} [${details.user?.name ?? ''}]'
                  : details.companyName ?? '',
                                style: GoogleFonts.poppins(
                fontSize: 24,
                                  fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                                ),
              textAlign: TextAlign.center,
                              ),
            const SizedBox(height: 8),
                              Text(
                                details.category?.name ?? '',
                                style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.edit,
                  label: 'Профиль',
                  color: Colors.blue,
                  onTap: () => const ProfileDetails().launch(context),
                ),
                _buildActionButton(
                  icon: Icons.dashboard,
                  label: 'Дашборд',
                  color: Colors.green,
                  onTap: () => const DashboardScreen().launch(context),
                ),
                _buildActionButton(
                  icon: Icons.subscriptions,
                  label: 'Подписка',
                  color: Colors.orange,
                  onTap: () => const PackageScreen().launch(context),
                              ),
                            ],
                          ),
                        ],
        ),
        error: (e, stack) => _buildErrorView(e.toString()),
        loading: () => const HomeScreenAppBarShimmer(),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSettings() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Быстрые настройки',
                    style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickSettingCard(
                  title: 'Печать',
                  subtitle: 'Включить печать чеков',
                  icon: Icons.print,
                  color: Colors.blue,
                        value: isPrintEnable,
                  onChanged: (value) async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('isPrintEnable', value);
                          setState(() {
                            isPrintEnable = value;
                          });
                        },
                      ),
                    ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickSettingCard(
                  title: 'Уведомления',
                  subtitle: 'Push уведомления',
                  icon: Icons.notifications,
                  color: Colors.green,
                  value: isPushNotifications,
                  onChanged: (value) {
                    setState(() {
                      isPushNotifications = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickSettingCard(
                  title: 'Автосинх',
                  subtitle: 'Автоматическая синхронизация',
                  icon: Icons.sync,
                  color: Colors.orange,
                  value: isAutoSync,
                  onChanged: (value) {
                    setState(() {
                      isAutoSync = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSettingCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          Transform.scale(
            scale: 0.8,
            child: Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainSettings() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Основные настройки',
                    style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            title: 'Язык',
            subtitle: 'Выберите язык приложения',
            icon: Icons.language,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                  selectedLanguage,
                        style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              ],
            ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectLanguage(),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
                     _buildSettingsCard(
             title: 'Валюта',
             subtitle: 'Выберите валюту для расчетов',
             icon: Icons.attach_money,
             trailing: Row(
               mainAxisSize: MainAxisSize.min,
               children: [
                 Text(
                   dropdownValue ?? '\$ (US Dollar)',
                   style: GoogleFonts.poppins(
                     color: Colors.grey[600],
                     fontSize: 14,
                   ),
                 ),
                 const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
               ],
             ),
             onTap: () async {
               await const CurrencyScreen().launch(context);
               setState(() {});
             },
           ),
          const SizedBox(height: 12),
          _buildSettingsCard(
            title: 'Роли пользователей',
            subtitle: 'Управление ролями и правами',
            icon: Icons.people,
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            onTap: () => const UserRoleScreen().launch(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Расширенные настройки',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            title: 'Внешний вид',
            subtitle: 'Темная тема и настройки интерфейса',
            icon: Icons.palette,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch.adaptive(
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                  activeColor: Colors.purple,
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              ],
            ),
            onTap: () => _showAppearanceSettings(),
          ),
          const SizedBox(height: 12),
          _buildSettingsCard(
            title: 'Безопасность',
            subtitle: 'Биометрия и двухфакторная аутентификация',
            icon: Icons.security,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch.adaptive(
                  value: isBiometricAuth,
                  onChanged: (value) {
                    setState(() {
                      isBiometricAuth = value;
                    });
                  },
                  activeColor: Colors.red,
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              ],
            ),
            onTap: () => _showSecuritySettings(),
          ),
          const SizedBox(height: 12),
          _buildSettingsCard(
            title: 'Данные и хранилище',
            subtitle: 'Экспорт, импорт и очистка данных',
            icon: Icons.storage,
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            onTap: () => _showDataSettings(),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Поддержка и информация',
                    style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            title: 'Помощь',
            subtitle: 'Руководства и FAQ',
            icon: Icons.help_outline,
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            onTap: () => _showHelpDialog(),
          ),
          const SizedBox(height: 12),
          _buildSettingsCard(
            title: 'О приложении',
            subtitle: 'Версия и информация',
            icon: Icons.info_outline,
                         trailing: Text(
               'POSPro V-1.0.2',
               style: GoogleFonts.poppins(
                 color: Colors.grey[600],
                 fontSize: 14,
               ),
             ),
            onTap: () => _showAboutDialog(),
          ),
          const SizedBox(height: 12),
          _buildSettingsCard(
            title: 'Выйти',
            subtitle: 'Выйти из аккаунта',
            icon: Icons.logout,
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            onTap: () => _showLogoutDialog(),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget trailing,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withOpacity(0.1)
                    : Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isDestructive
                    ? Colors.red
                    : Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDestructive ? Colors.red : Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
            ),
            trailing,
              ],
            ),
          ),
        );
  }

  Widget _buildErrorView(String error) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'Ошибка загрузки',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Методы для диалогов
  void _refreshSettings() {
    setState(() {});
    EasyLoading.showSuccess('Настройки обновлены');
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Помощь'),
        content: const Text('Руководство пользователя и часто задаваемые вопросы будут добавлены'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAppearanceSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Настройки внешнего вида'),
        content: const Text('Настройки темы и интерфейса будут добавлены'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSecuritySettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Настройки безопасности'),
        content: const Text('Настройки биометрии и двухфакторной аутентификации будут добавлены'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDataSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Настройки данных'),
        content: const Text('Настройки экспорта, импорта и очистки данных будут добавлены'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('О приложении'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
             Text('POSPro - Профессиональная система управления торговлей'),
             const SizedBox(height: 16),
             Text('Версия: 1.0.2'),
             Text('Сборка: 4'),
             Text('Дата: ${DateTime.now().year}'),
           ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти'),
        content: const Text('Вы уверены, что хотите выйти из приложения?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (currentRef != null) {
                // currentRef.invalidate(businessInfoProvider);
                EasyLoading.show(status: lang.S.of(context).logOut);
                LogOutRepo repo = LogOutRepo();
                // await repo.signOutApi(context: context, ref: currentRef);
              }
            },
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }
}

class NoticationSettings extends StatefulWidget {
  const NoticationSettings({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NoticationSettingsState createState() => _NoticationSettingsState();
}

class _NoticationSettingsState extends State<NoticationSettings> {
  bool notify = false;
  String notificationText = 'Off';

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 350.0,
      width: MediaQuery.of(context).size.width - 80,
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              IconButton(
                color: kGreyTextColor,
                icon: const Icon(Icons.cancel_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              color: kDarkWhite,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Center(
              child: Icon(
                Icons.notifications_none_outlined,
                size: 50.0,
                color: kMainColor,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Center(
            child: Text(
              lang.S.of(context).doNotDisturb,
              //'Do Not Disturb',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                lang.S.of(context).loremIpsumDolorSitAmetConsecteturElitInterdumCons,
                //'Lorem ipsum dolor sit amet, consectetur elit. Interdum cons.',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: kGreyTextColor,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                notificationText,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
              Switch(
                value: notify,
                onChanged: (val) {
                  setState(() {
                    notify = val;
                    val ? notificationText = '${lang.S.of(context).on}' : notificationText = '${lang.S.of(context).off}';
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
