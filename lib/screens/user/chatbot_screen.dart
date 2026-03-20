import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';
import '../../utils/language_utils.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  String _currentLang = 'en';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    _currentLang = await LanguageUtils().getLanguage();
    _messages.add({
      'sender': 'bot',
      'text': _currentLang == 'hi' ? 'नमस्ते! मैं आपकी कैसे मदद कर सकता हूँ?' : _currentLang == 'or' ? 'ନମସ୍କାର! ମୁଁ ଆପଣଙ୍କୁ କିପରି ସାହାଯ୍ୟ କରିପାରିବି?' : 'Hello! How can I help you today?'
    });
    setState(() {});
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isLoading = true;
      _controller.clear();
    });

    final responseText = await apiService.sendChatMessage(text, _currentLang);
    setState(() {
      _messages.add({'sender': 'bot', 'text': responseText});
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Civic Assistant'), backgroundColor: AppConstants.primaryBlue),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final isUser = _messages[index]['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isUser ? AppConstants.primaryBlue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(_messages[index]['text']!, style: TextStyle(color: isUser ? Colors.white : Colors.black87)),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [_buildQuickBubble("Pay Bill"), _buildQuickBubble("Book Gas"), _buildQuickBubble("File Complaint")]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Type a message...', border: OutlineInputBorder()), onSubmitted: _sendMessage)),
                IconButton(icon: const Icon(Icons.send, color: AppConstants.primaryBlue), onPressed: () => _sendMessage(_controller.text)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickBubble(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: ActionChip(label: Text(text), onPressed: () => _sendMessage(text)),
    );
  }
}
