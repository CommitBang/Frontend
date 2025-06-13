import 'package:flutter/material.dart';
import 'package:snapfig/shared/services/ai_service/ai_service.dart';
import 'package:snapfig/shared/services/ai_service/models/ai_provider.dart';
import 'package:snapfig/shared/services/pdf_core/models/models.dart';
import 'package:snapfig/features/pdf_viewer/models/pdf_data_viewmodel.dart';

class Message {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final bool isLoading;

  Message({
    required this.content,
    required this.isUser,
    DateTime? timestamp,
    this.isLoading = false,
  }) : timestamp = timestamp ?? DateTime.now();
}

class AIChatPopup extends StatefulWidget {
  final BaseLayout figure;
  final PDFDataViewModel viewModel;
  final VoidCallback onClose;

  const AIChatPopup({
    super.key,
    required this.figure,
    required this.viewModel,
    required this.onClose,
  });

  @override
  State<AIChatPopup> createState() => _AIChatPopupState();
}

class _AIChatPopupState extends State<AIChatPopup> {
  final List<Message> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  AIProvider? _selectedProvider;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAvailableProviders();
    _addWelcomeMessage();
    _sendInitialFigureMessage();
  }

  void _loadAvailableProviders() {
    final configurations = AIService.instance.configurations;
    if (configurations.isNotEmpty) {
      _selectedProvider = configurations.first.provider;
    }
  }

  void _addWelcomeMessage() {
    _messages.add(
      Message(
        content:
            'Hello! I can help you understand this figure. What would you like to know about it?',
        isUser: false,
      ),
    );
  }

  Future<void> _sendInitialFigureMessage() async {
    if (_selectedProvider == null) return;

    // Add user message indicating we're sending the figure
    setState(() {
      _messages.add(
        Message(content: 'Here is the figure I want to analyze', isUser: true),
      );
      _messages.add(Message(content: '', isUser: false, isLoading: true));
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      // Get the figure image
      final figureImage = await widget.viewModel.getFigureImage(widget.figure);
      if (figureImage == null) {
        throw Exception('Could not load figure image');
      }

      final pageNumber = widget.viewModel.getPageNumberForFigure(widget.figure);
      final context =
          'Figure ID: ${widget.figure.figureId ?? widget.figure.id.toString()}, Page: ${pageNumber ?? 'Unknown'}';

      final response = await AIService.instance.askAI(
        provider: _selectedProvider!,
        question:
            'Please analyze this figure and describe what you can see. What kind of data or information does it represent?',
        context: context,
        image: figureImage,
      );

      setState(() {
        _messages.removeLast(); // Remove loading message
        _messages.add(Message(content: response, isUser: false));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.removeLast(); // Remove loading message
        _messages.add(
          Message(
            content: 'Sorry, I couldn\'t analyze the figure: ${e.toString()}',
            isUser: false,
          ),
        );
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final configurations = AIService.instance.configurations;

    if (configurations.isEmpty) {
      return _buildNoConfigurationView(context);
    }

    return Container(
      width: 400,
      height: 500,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildMessageList(context)),
          _buildInputSection(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final configurations = AIService.instance.configurations;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.smart_toy, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Text('AI Chat', style: theme.textTheme.titleMedium),
          const Spacer(),
          if (configurations.length > 1)
            DropdownButton<AIProvider>(
              value: _selectedProvider,
              underline: const SizedBox(),
              items:
                  configurations.map((config) {
                    return DropdownMenuItem(
                      value: config.provider,
                      child: Text(
                        config.provider.displayName,
                        style: theme.textTheme.bodySmall,
                      ),
                    );
                  }).toList(),
              onChanged: (provider) {
                setState(() {
                  _selectedProvider = provider;
                });
              },
            ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: widget.onClose,
            icon: const Icon(Icons.close, size: 18),
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(4),
              minimumSize: const Size(24, 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(context, message);
      },
    );
  }

  Widget _buildMessageBubble(BuildContext context, Message message) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 12,
              backgroundColor: theme.colorScheme.primary,
              child: Icon(
                Icons.smart_toy,
                size: 14,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    message.isUser
                        ? theme.colorScheme.primary
                        : theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child:
                  message.isLoading
                      ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Thinking...',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      )
                      : Text(
                        message.content,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color:
                              message.isUser
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                        ),
                      ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 12,
              backgroundColor: theme.colorScheme.secondary,
              child: Icon(
                Icons.person,
                size: 14,
                color: theme.colorScheme.onSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Ask about this figure...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: _isLoading ? null : (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed:
                _isLoading || _textController.text.trim().isEmpty
                    ? null
                    : _sendMessage,
            icon: Icon(
              Icons.send,
              color:
                  _isLoading || _textController.text.trim().isEmpty
                      ? theme.colorScheme.onSurfaceVariant
                      : theme.colorScheme.primary,
            ),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              shape: const CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoConfigurationView(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.settings, size: 48, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            'AI Configuration Required',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please configure your AI API keys to use this feature.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onClose,
                  child: const Text('Close'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    widget.onClose();
                    Navigator.of(context).pushNamed('/ai-settings');
                  },
                  child: const Text('Settings'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _selectedProvider == null) return;

    setState(() {
      _messages.add(Message(content: text, isUser: true));
      _messages.add(Message(content: '', isUser: false, isLoading: true));
      _isLoading = true;
    });

    _textController.clear();
    _scrollToBottom();

    try {
      // Get the figure image for context
      final figureImage = await widget.viewModel.getFigureImage(widget.figure);

      final pageNumber = widget.viewModel.getPageNumberForFigure(widget.figure);
      final context =
          'Figure ID: ${widget.figure.figureId ?? widget.figure.id.toString()}, Page: ${pageNumber ?? 'Unknown'}';
      final response = await AIService.instance.askAI(
        provider: _selectedProvider!,
        question: text,
        context: context,
        image: figureImage,
      );

      setState(() {
        _messages.removeLast(); // Remove loading message
        _messages.add(Message(content: response, isUser: false));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.removeLast(); // Remove loading message
        _messages.add(
          Message(
            content: 'Sorry, I encountered an error: ${e.toString()}',
            isUser: false,
          ),
        );
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
