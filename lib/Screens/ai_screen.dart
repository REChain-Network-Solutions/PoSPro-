import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/ai_provider.dart';
import 'dart:math' as math;

class AIScreen extends StatefulWidget {
  const AIScreen({Key? key}) : super(key: key);

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  
  String _selectedCategory = 'all';
  String _selectedStyle = 'all';
  bool _showPersonalizedOnly = false;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _feedbackController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<AIProvider>(
        builder: (context, aiProvider, child) {
          if (aiProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (aiProvider.error != null) {
            return _buildErrorView(aiProvider);
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Приветствие и профиль стиля
                    _buildWelcomeSection(aiProvider),
                    const SizedBox(height: 24),
                    
                    // AI статистика
                    _buildAIStatsSection(aiProvider),
                    const SizedBox(height: 24),
                    
                    // Поиск и фильтры
                    _buildSearchSection(),
                    const SizedBox(height: 24),
                    
                    // Персональные рекомендации
                    _buildPersonalizedRecommendations(aiProvider),
                    const SizedBox(height: 24),
                    
                    // AI аналитика стиля
                    _buildStyleAnalytics(aiProvider),
                    const SizedBox(height: 24),
                    
                    // Тренды и инсайты
                    _buildTrendsSection(aiProvider),
                    const SizedBox(height: 24),
                    
                    // Обратная связь
                    _buildFeedbackSection(aiProvider),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Построение AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('AI Стилист'),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.psychology),
          onPressed: () => _showAISettingsDialog(context),
          tooltip: 'AI настройки',
        ),
        IconButton(
          icon: const Icon(Icons.analytics),
          onPressed: () => _showAnalyticsDialog(context),
          tooltip: 'Аналитика',
        ),
        IconButton(
          icon: const Icon(Icons.help),
          onPressed: () => _showHelpDialog(context),
          tooltip: 'Помощь',
        ),
      ],
    );
  }

  /// Построение секции приветствия
  Widget _buildWelcomeSection(AIProvider aiProvider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple[400]!,
              Colors.purple[600]!,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Добро пожаловать в AI Стилист!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Персонализированные рекомендации стиля на основе AI',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildQuickActionButton(
                          icon: Icons.style,
                          label: 'Мой стиль',
                          onTap: () => _showStyleProfileDialog(context, aiProvider),
                        ),
                        const SizedBox(width: 12),
                        _buildQuickActionButton(
                          icon: Icons.trending_up,
                          label: 'Тренды',
                          onTap: () => _showTrendsDialog(context, aiProvider),
                        ),
                        const SizedBox(width: 12),
                        _buildQuickActionButton(
                          icon: Icons.favorite,
                          label: 'Избранное',
                          onTap: () => _showFavoritesDialog(context, aiProvider),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(
                  Icons.psychology,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Построение кнопки быстрого действия
  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Построение секции AI статистики
  Widget _buildAIStatsSection(AIProvider aiProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Статистика',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildAIStatCard(
                'Рекомендации',
                '${aiProvider.personalRecommendations.length}',
                'создано',
                Icons.recommend,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAIStatCard(
                'Стили',
                '${aiProvider.userStyleProfile?.styles.length ?? 0}',
                'анализировано',
                Icons.style,
                Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAIStatCard(
                'Точность',
                '${(aiProvider.recommendationAccuracy * 100).toStringAsFixed(1)}%',
                'AI модели',
                Icons.analytics,
                Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Построение карточки AI статистики
  Widget _buildAIStatCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Построение секции поиска
  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Поиск стиля',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Опишите ваш стиль или предпочтения...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _generateAIRecommendations(),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('AI Поиск'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Категория',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    const DropdownMenuItem(value: 'all', child: Text('Все категории')),
                    const DropdownMenuItem(value: 'casual', child: Text('Повседневный')),
                    const DropdownMenuItem(value: 'business', child: Text('Деловой')),
                    const DropdownMenuItem(value: 'evening', child: Text('Вечерний')),
                    const DropdownMenuItem(value: 'sport', child: Text('Спортивный')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value ?? 'all';
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedStyle,
                  decoration: const InputDecoration(
                    labelText: 'Стиль',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    const DropdownMenuItem(value: 'all', child: Text('Все стили')),
                    const DropdownMenuItem(value: 'classic', child: Text('Классический')),
                    const DropdownMenuItem(value: 'modern', child: Text('Современный')),
                    const DropdownMenuItem(value: 'vintage', child: Text('Винтажный')),
                    const DropdownMenuItem(value: 'minimalist', child: Text('Минималистичный')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedStyle = value ?? 'all';
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              FilterChip(
                label: const Text('Только персональные'),
                selected: _showPersonalizedOnly,
                onSelected: (selected) {
                  setState(() {
                    _showPersonalizedOnly = selected;
                  });
                },
                selectedColor: Colors.purple[100],
                checkmarkColor: Colors.purple[800],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Построение персональных рекомендаций
  Widget _buildPersonalizedRecommendations(AIProvider aiProvider) {
    final recommendations = aiProvider.personalRecommendations;
    
    if (recommendations.isEmpty) {
      return _buildEmptyRecommendations();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Персональные рекомендации',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => _refreshRecommendations(aiProvider),
              child: const Text('Обновить'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final recommendation = recommendations[index];
              return _buildRecommendationCard(recommendation, aiProvider);
            },
          ),
        ),
      ],
    );
  }

  /// Построение карточки рекомендации
  Widget _buildRecommendationCard(Map<String, dynamic> recommendation, AIProvider aiProvider) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: recommendation['image_url'] != null
                    ? Image.network(
                        recommendation['image_url'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.style,
                            color: Colors.grey[400],
                            size: 48,
                          );
                        },
                      )
                    : Icon(
                        Icons.style,
                        color: Colors.grey[400],
                        size: 48,
                      ),
              ),
            ),
            
            // Информация
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recommendation['title'] ?? 'Рекомендация',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recommendation['description'] ?? 'Описание отсутствует',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  
                  // Теги
                  Wrap(
                    spacing: 8,
                    children: (recommendation['tags'] as List<dynamic>? ?? []).map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: Colors.purple[100],
                        labelStyle: TextStyle(
                          color: Colors.purple[800],
                          fontSize: 12,
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Действия
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showRecommendationDetails(recommendation),
                          child: const Text('Подробнее'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _likeRecommendation(recommendation, aiProvider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Нравится'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Построение пустых рекомендаций
  Widget _buildEmptyRecommendations() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.psychology,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Рекомендации отсутствуют',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'AI проанализирует ваш стиль и создаст персональные рекомендации',
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _generateAIRecommendations(),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Создать рекомендации'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Построение аналитики стиля
  Widget _buildStyleAnalytics(AIProvider aiProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Аналитика стиля',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildAnalyticsCard(
                'Предпочтения',
                _buildStylePreferencesChart(aiProvider),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAnalyticsCard(
                'Тренды',
                _buildStyleTrendsChart(aiProvider),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Построение карточки аналитики
  Widget _buildAnalyticsCard(String title, Widget child) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(height: 200, child: child),
          ],
        ),
      ),
    );
  }

  /// Построение графика предпочтений стиля
  Widget _buildStylePreferencesChart(AIProvider aiProvider) {
    return CustomPaint(
      painter: StylePreferencesPainter(aiProvider.userStyleProfile?.styles ?? []),
      size: const Size(double.infinity, double.infinity),
    );
  }

  /// Построение графика трендов стиля
  Widget _buildStyleTrendsChart(AIProvider aiProvider) {
    return CustomPaint(
      painter: StyleTrendsPainter(),
      size: const Size(double.infinity, double.infinity),
    );
  }

  /// Построение секции трендов
  Widget _buildTrendsSection(AIProvider aiProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Тренды и инсайты',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildTrendItem(
                  'Популярные цвета',
                  'Синий, бежевый, оливковый',
                  Icons.palette,
                  Colors.blue,
                ),
                _buildTrendItem(
                  'Стили сезона',
                  'Минимализм, экологичность, комфорт',
                  Icons.trending_up,
                  Colors.green,
                ),
                _buildTrendItem(
                  'AI предсказания',
                  'Рост спроса на sustainable fashion',
                  Icons.psychology,
                  Colors.purple,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Построение элемента тренда
  Widget _buildTrendItem(String title, String description, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Построение секции обратной связи
  Widget _buildFeedbackSection(AIProvider aiProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Обратная связь для AI',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _feedbackController,
                  decoration: const InputDecoration(
                    labelText: 'Поделитесь своими впечатлениями о рекомендациях',
                    border: OutlineInputBorder(),
                    hintText: 'Что понравилось? Что можно улучшить?',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _feedbackController.clear(),
                        child: const Text('Очистить'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _submitFeedback(aiProvider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Отправить'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Построение экрана ошибки
  Widget _buildErrorView(AIProvider aiProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Ошибка загрузки AI сервисов',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            aiProvider.error ?? 'Неизвестная ошибка',
            style: TextStyle(color: Colors.red[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              aiProvider.clearError();
              aiProvider.initialize();
            },
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  // Методы

  /// Генерация AI рекомендаций
  void _generateAIRecommendations() {
    // В реальном приложении здесь будет вызов AI API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AI анализирует ваш стиль...')),
    );
  }

  /// Обновление рекомендаций
  void _refreshRecommendations(AIProvider aiProvider) {
    aiProvider.refreshRecommendations();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Рекомендации обновлены!')),
    );
  }

  /// Показать детали рекомендации
  void _showRecommendationDetails(Map<String, dynamic> recommendation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(recommendation['title'] ?? 'Рекомендация'),
        content: Text(recommendation['description'] ?? 'Описание отсутствует'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  /// Лайк рекомендации
  void _likeRecommendation(Map<String, dynamic> recommendation, AIProvider aiProvider) {
    aiProvider.likeRecommendation(recommendation['id']);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Спасибо за обратную связь!')),
    );
  }

  /// Отправка обратной связи
  void _submitFeedback(AIProvider aiProvider) {
    if (_feedbackController.text.trim().isNotEmpty) {
      aiProvider.submitFeedback(_feedbackController.text.trim());
      _feedbackController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Спасибо за обратную связь!')),
      );
    }
  }

  // Диалоги

  /// Диалог профиля стиля
  void _showStyleProfileDialog(BuildContext context, AIProvider aiProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Мой профиль стиля'),
        content: const Text('Здесь будет детальная информация о вашем стиле'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  /// Диалог трендов
  void _showTrendsDialog(BuildContext context, AIProvider aiProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Тренды стиля'),
        content: const Text('Здесь будут актуальные тренды'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  /// Диалог избранного
  void _showFavoritesDialog(BuildContext context, AIProvider aiProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Избранные рекомендации'),
        content: const Text('Здесь будут ваши любимые стили'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  /// Диалог AI настроек
  void _showAISettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI настройки'),
        content: const Text('Здесь будут настройки AI алгоритмов'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  /// Диалог аналитики
  void _showAnalyticsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI аналитика'),
        content: const Text('Здесь будет детальная аналитика'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  /// Диалог помощи
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Помощь по AI Стилисту'),
        content: const Text('Здесь будет справка по использованию'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}

/// Кастомный художник для графика предпочтений стиля
class StylePreferencesPainter extends CustomPainter {
  final List<String> styles;
  
  StylePreferencesPainter(this.styles);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 3;

    // Рисуем простую круговую диаграмму
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple];
    final values = [0.3, 0.25, 0.25, 0.2];
    
    double startAngle = 0;
    for (int i = 0; i < values.length; i++) {
      final sweepAngle = values[i] * 2 * math.pi;
      
      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Кастомный художник для графика трендов стиля
class StyleTrendsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.purple;

    final path = Path();
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.4, size.height * 0.6),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width, size.height * 0.1),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    // Рисуем точки
    paint.style = PaintingStyle.fill;
    for (final point in points) {
      canvas.drawCircle(point, 4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
