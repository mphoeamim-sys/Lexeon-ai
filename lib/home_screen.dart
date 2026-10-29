import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'liquid_glass_container.dart';
import 'liquid_wave_painter.dart';
import 'theme_provider.dart';
import 'assistant_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List> _messages = [];
  final AssistantService _assistant = AssistantService();

  late stt.SpeechToText _speech;
  late FlutterTts _tts;
  bool _isListening = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _speech = stt.SpeechToText();
    _tts = FlutterTts();
    _initTts();

    _messages.add({
      'sender': 'lexeon',
      'text': 'Greeting. I am Lexeon. Ready to assist. How shall we begin?'
    });
  }

  void _initTts() async {
    await _tts.setLanguage("en-US");
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.5);
  }

  @override
  void dispose() {
    _animController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? voiceText]) async {
    final text = voiceText ?? _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isProcessing = true;
    });
    _textController.clear();
    _scrollToBottom();

    final response = await _assistant.processUserMessage(text);

    setState(() {
      _messages.add({'sender': 'lexeon', 'text': response});
      _isProcessing = false;
    });
    _scrollToBottom();
    await _tts.speak(response);
  }

  void _toggleVoiceMode() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          if (val.finalResult) {
            setState(() => _isListening = false);
            _sendMessage(val.recognizedWords);
          }
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
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
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final accentColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return CustomPaint(
                  painter: LiquidWavePainter(
                    animationValue: _animController.value,
                    accentColor: accentColor,
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(themeProvider),
                Expanded(child: _buildChatList()),
                if (_isProcessing)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: CircularProgressIndicator(color: Colors.white70),
                  ),
                _buildLiquidInputBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LiquidGlassContainer(
        borderRadius: 24,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'LEXEON',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.5,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.palette_outlined, color: Colors.white70),
              onPressed: () => themeProvider.toggleTheme(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        final isUser = msg['sender'] == 'user';

        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: LiquidGlassContainer(
              borderRadius: isUser ? 22 : 28,
              borderColor: isUser ? Colors.blueAccent.withOpacity(0.4) : Colors.white.withOpacity(0.2),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                child: Text(
                  msg['text'] ?? '',
                  style: TextStyle(
                    color: isUser ? Colors.white : const Color(0xFFE2E8F0),
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLiquidInputBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LiquidGlassContainer(
        borderRadius: 35,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white70, size: 26),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Command Lexeon...',
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            GestureDetector(
              onTap: _toggleVoiceMode,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isListening ? Colors.redAccent : const Color(0xFF1E3A8A).withOpacity(0.6),
                ),
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              icon: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 26),
              onPressed: () => _sendMessage(),
            ),
          ],
        ),
      ),
    );
  }
}