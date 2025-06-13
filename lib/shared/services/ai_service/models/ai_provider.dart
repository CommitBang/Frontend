enum AIProvider {
  openai('OpenAI', 'openai'),
  gemini('Google Gemini', 'gemini');

  const AIProvider(this.displayName, this.key);

  final String displayName;
  final String key;
}

class AIConfiguration {
  final AIProvider provider;
  final String apiKey;
  final String? model;

  const AIConfiguration({
    required this.provider,
    required this.apiKey,
    this.model,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider': provider.key,
      'apiKey': apiKey,
      'model': model,
    };
  }

  factory AIConfiguration.fromJson(Map<String, dynamic> json) {
    return AIConfiguration(
      provider: AIProvider.values.firstWhere(
        (p) => p.key == json['provider'],
        orElse: () => AIProvider.openai,
      ),
      apiKey: json['apiKey'] ?? '',
      model: json['model'],
    );
  }

  String get defaultModel {
    switch (provider) {
      case AIProvider.openai:
        return model ?? 'gpt-4o-mini';
      case AIProvider.gemini:
        return model ?? 'gemini-1.5-flash';
    }
  }
}