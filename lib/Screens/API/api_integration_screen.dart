import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import '../../Const/new_features_constants.dart';

class APIIntegrationScreen extends StatefulWidget {
  const APIIntegrationScreen({Key? key}) : super(key: key);

  @override
  State<APIIntegrationScreen> createState() => _APIIntegrationScreenState();
}

class _APIIntegrationScreenState extends State<APIIntegrationScreen> {
  final List<APIService> apiServices = [
    APIService(
      name: 'Payment Gateway',
      description: 'Integrate with Stripe, PayPal, and other payment processors',
      status: 'Connected',
      icon: Icons.payment,
      color: Colors.green,
      lastSync: '2 minutes ago',
    ),
    APIService(
      name: 'Shipping Provider',
      description: 'Connect with FedEx, UPS, and DHL for shipping calculations',
      status: 'Connected',
      icon: Icons.local_shipping,
      color: Colors.blue,
      lastSync: '1 hour ago',
    ),
    APIService(
      name: 'Accounting Software',
      description: 'Sync with QuickBooks, Xero, and other accounting platforms',
      status: 'Disconnected',
      icon: Icons.account_balance,
      color: Colors.orange,
      lastSync: 'Never',
    ),
    APIService(
      name: 'E-commerce Platform',
      description: 'Connect with Shopify, WooCommerce, and other platforms',
      status: 'Connected',
      icon: Icons.shopping_cart,
      color: Colors.purple,
      lastSync: '30 minutes ago',
    ),
    APIService(
      name: 'CRM System',
      description: 'Integrate with Salesforce, HubSpot, and other CRM tools',
      status: 'Disconnected',
      icon: Icons.people,
      color: Colors.red,
      lastSync: 'Never',
    ),
    APIService(
      name: 'Inventory Management',
      description: 'Connect with external inventory and warehouse systems',
      status: 'Connected',
      icon: Icons.inventory,
      color: Colors.teal,
      lastSync: '5 minutes ago',
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
          'API Integration',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: kTitleColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showAddAPIDialog(context);
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: NewFeaturesColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.add,
                color: kWhite,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Stats
            _buildHeaderStats(),
            const SizedBox(height: 24),
            
            // API Services List
            _buildAPIServicesList(),
            const SizedBox(height: 24),
            
            // Documentation Section
            _buildDocumentationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStats() {
    int connectedCount = apiServices.where((service) => service.status == 'Connected').length;
    int totalCount = apiServices.length;
    
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
            'Integration Overview',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: kTitleColor,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Connected',
                  connectedCount.toString(),
                  Colors.green,
                  Icons.check_circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Total',
                  totalCount.toString(),
                  NewFeaturesColors.primary,
                  Icons.api,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Success Rate',
                  '${((connectedCount / totalCount) * 100).toInt()}%',
                  Colors.blue,
                  Icons.trending_up,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAPIServicesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connected Services',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: kTitleColor,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: apiServices.length,
          itemBuilder: (context, index) {
            final service = apiServices[index];
            return _buildAPIServiceCard(service);
          },
        ),
      ],
    );
  }

  Widget _buildAPIServiceCard(APIService service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: service.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(service.icon, color: service.color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kTitleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service.description,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: kGreyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: service.status == 'Connected' 
                      ? Colors.green.withOpacity(0.1) 
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  service.status,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: service.status == 'Connected' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Last sync: ${service.lastSync}',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: kGreyTextColor,
                ),
              ),
              const Spacer(),
              if (service.status == 'Connected')
                TextButton(
                  onPressed: () {
                    _showAPIDetailsDialog(context, service);
                  },
                  child: Text(
                    'Configure',
                    style: GoogleFonts.poppins(
                      color: NewFeaturesColors.primary,
                      fontSize: 12,
                    ),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    _showConnectAPIDialog(context, service);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NewFeaturesColors.primary,
                    foregroundColor: kWhite,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    'Connect',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentationSection() {
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
            'API Documentation',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: kTitleColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildDocItem(
            'Getting Started',
            'Learn how to set up your first API integration',
            Icons.rocket_launch,
            Colors.blue,
          ),
          _buildDocItem(
            'Authentication',
            'Understand API keys, tokens, and security',
            Icons.security,
            Colors.green,
          ),
          _buildDocItem(
            'Webhooks',
            'Set up real-time data synchronization',
            Icons.webhook,
            Colors.orange,
          ),
          _buildDocItem(
            'Error Handling',
            'Learn how to handle API errors and retries',
            Icons.error_outline,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildDocItem(String title, String description, IconData icon, Color color) {
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
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kTitleColor,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: kGreyTextColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Navigate to documentation
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              color: kGreyTextColor,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAPIDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add New API Service',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Service Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'API Endpoint',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'API Key',
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
                // Add API service logic
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAPIDetailsDialog(BuildContext context, APIService service) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Configure ${service.name}',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Service: ${service.name}'),
              const SizedBox(height: 8),
              Text('Status: ${service.status}'),
              const SizedBox(height: 8),
              Text('Last Sync: ${service.lastSync}'),
              const SizedBox(height: 16),
              const Text('Configuration options will appear here...'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                // Save configuration logic
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showConnectAPIDialog(BuildContext context, APIService service) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Connect to ${service.name}',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'API Key',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Secret Key',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Webhook URL (Optional)',
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
                // Connect API logic
                Navigator.pop(context);
              },
              child: const Text('Connect'),
            ),
          ],
        );
      },
    );
  }
}

class APIService {
  final String name;
  final String description;
  final String status;
  final IconData icon;
  final Color color;
  final String lastSync;

  APIService({
    required this.name,
    required this.description,
    required this.status,
    required this.icon,
    required this.color,
    required this.lastSync,
  });
}
