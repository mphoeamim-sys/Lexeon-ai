import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:url_launcher/url_launcher.dart';

class AssistantService {
  late final GenerativeModel _model;
  static const String _apiKey = 'YOUR_GEMINI_API_KEY';

  AssistantService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system(
        'You are Lexeon (also responding to Lex or Xeon), an advanced, ultra-intelligent personal AI assistant. '
        'You possess deep analytical capability, accurate information filtering, logic gates, and empathetic conversation skills. '
        'You serve as a friend, study mentor, counselor, and daily execution assistant.'
      ),
    );
  }

  Future<String> processUserMessage(String query) async {
    final lower = query.toLowerCase();

    if (lower.contains('open whatsapp')) {
      await _launchIntent('whatsapp://');
      return 'Opening WhatsApp for you.';
    } else if (lower.contains('open gallery')) {
      await _launchIntent('content://media/external/images/media');
      return 'Accessing your gallery.';
    } else if (lower.contains('open camera')) {
      await _launchIntent('android.media.action.IMAGE_CAPTURE');
      return 'Launching Camera mode.';
    } else if (lower.contains('study mode') || lower.contains('quiz me')) {
      return 'Study Mode Activated. What subject or concept are we mastering today?';
    }

    try {
      final response = await _model.generateContent([Content.text(query)]);
      return response.text ?? 'Lexeon completed the request.';
    } catch (e) {
      return 'Please verify your Gemini API key configuration.';
    }
  }

  Future<void> _launchIntent(String urlScheme) async {
    final uri = Uri.parse(urlScheme);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}