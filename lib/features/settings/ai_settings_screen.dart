import 'package:flutter/material.dart';
import 'package:snapfig/shared/services/ai_service/ai_service.dart';
import 'package:snapfig/shared/services/ai_service/models/ai_provider.dart';

class AISettingsScreen extends StatefulWidget {
  const AISettingsScreen({super.key});

  @override
  State<AISettingsScreen> createState() => _AISettingsScreenState();
}

class _AISettingsScreenState extends State<AISettingsScreen> {
  final Map<AIProvider, TextEditingController> _apiKeyControllers = {};
  final Map<AIProvider, TextEditingController> _modelControllers = {};
  final Map<AIProvider, bool> _obscureText = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadExistingConfigurations();
  }

  void _initializeControllers() {
    for (final provider in AIProvider.values) {
      _apiKeyControllers[provider] = TextEditingController();
      _modelControllers[provider] = TextEditingController();
      _obscureText[provider] = true;
    }
  }

  void _loadExistingConfigurations() {
    for (final provider in AIProvider.values) {
      final config = AIService.instance.getConfiguration(provider);
      if (config != null) {
        _apiKeyControllers[provider]!.text = config.apiKey;
        _modelControllers[provider]!.text = config.model ?? '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Settings'),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configure AI Providers',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your API keys to enable AI-powered figure analysis.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: AIProvider.values.map((provider) {
                  return _buildProviderCard(context, provider);
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saveAllConfigurations,
                child: const Text('Save Configuration'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderCard(BuildContext context, AIProvider provider) {
    final theme = Theme.of(context);
    final hasConfiguration = AIService.instance.hasConfiguration(provider);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getProviderIcon(provider),
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  provider.displayName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (hasConfiguration)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Configured',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _apiKeyControllers[provider],
              decoration: InputDecoration(
                labelText: 'API Key',
                hintText: 'Enter your ${provider.displayName} API key',
                prefixIcon: const Icon(Icons.key),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText[provider]! 
                        ? Icons.visibility_off 
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText[provider] = !_obscureText[provider]!;
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              obscureText: _obscureText[provider]!,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _modelControllers[provider],
              decoration: InputDecoration(
                labelText: 'Model (Optional)',
                hintText: _getDefaultModelHint(provider),
                prefixIcon: const Icon(Icons.memory),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getProviderDescription(provider),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (hasConfiguration) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _removeConfiguration(provider),
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Remove'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getProviderIcon(AIProvider provider) {
    switch (provider) {
      case AIProvider.openai:
        return Icons.smart_toy;
      case AIProvider.gemini:
        return Icons.auto_awesome;
    }
  }

  String _getDefaultModelHint(AIProvider provider) {
    switch (provider) {
      case AIProvider.openai:
        return 'Default: gpt-4o-mini';
      case AIProvider.gemini:
        return 'Default: gemini-1.5-flash';
    }
  }

  String _getProviderDescription(AIProvider provider) {
    switch (provider) {
      case AIProvider.openai:
        return 'Get your API key from platform.openai.com/api-keys';
      case AIProvider.gemini:
        return 'Get your API key from console.cloud.google.com';
    }
  }

  Future<void> _saveAllConfigurations() async {
    final messenger = ScaffoldMessenger.of(context);
    
    try {
      for (final provider in AIProvider.values) {
        final apiKey = _apiKeyControllers[provider]!.text.trim();
        
        if (apiKey.isNotEmpty) {
          final model = _modelControllers[provider]!.text.trim().isEmpty 
              ? null 
              : _modelControllers[provider]!.text.trim();
          
          final config = AIConfiguration(
            provider: provider,
            apiKey: apiKey,
            model: model,
          );
          
          await AIService.instance.saveConfiguration(config);
        }
      }
      
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Configuration saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Error saving configuration: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removeConfiguration(AIProvider provider) async {
    final messenger = ScaffoldMessenger.of(context);
    
    try {
      await AIService.instance.removeConfiguration(provider);
      setState(() {
        _apiKeyControllers[provider]!.clear();
        _modelControllers[provider]!.clear();
      });
      
      messenger.showSnackBar(
        SnackBar(
          content: Text('${provider.displayName} configuration removed'),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Error removing configuration: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _apiKeyControllers.values) {
      controller.dispose();
    }
    for (final controller in _modelControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}