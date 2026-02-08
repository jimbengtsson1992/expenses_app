import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/expense_analytics_service.dart';
import '../domain/expense_analytics.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(expenseAnalyticsProvider);
    final excludedAnalyticsAsync = ref.watch(excludedExpenseAnalyticsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Fråga om utgifter'), centerTitle: true),
      body: analyticsAsync.when(
        data: (analytics) => excludedAnalyticsAsync.when(
          data: (excludedAnalytics) => _ChatView(
            analytics: analytics,
            excludedAnalytics: excludedAnalytics,
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Fel: $e', textAlign: TextAlign.center),
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Fel: $e', textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView({required this.analytics, required this.excludedAnalytics});
  final ExpenseAnalytics analytics;
  final ExpenseAnalytics excludedAnalytics;

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  late final LlmProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = FirebaseProvider(
      model: FirebaseAI.googleAI().generativeModel(
        model: 'gemini-3-flash-preview',
        systemInstruction: Content.system(_buildSystemPrompt()),
      ),
    );
  }

  String _buildSystemPrompt() {
    return '''
Du är en hjälpsam ekonomisk assistent som analyserar utgiftsdata för en privatperson.

## Transaktioner (inkluderas alltid i svar)
${widget.analytics.toMarkdownPrompt()}

## Exkluderade transaktioner (engångshändelser)
Följande är engångs- eller ovanliga transaktioner som köksrenovering och lån.
Inkludera ENDAST denna data om användaren specifikt frågar om det (t.ex. "köksrenovering", "lån", "engångsutgifter", "alla utgifter", "totalt inklusive allt").
${widget.excludedAnalytics.toMarkdownPrompt()}

REGLER:
- Svara alltid på svenska
- Var koncis och ge specifika belopp
- Du kan svara om alla tidsperioder i datan
- Om användaren frågar om något som inte finns i datan, säg det tydligt
- Formatera svar med punktlistor när det passar
- Avrunda belopp till hela kronor
- Inkludera INTE exkluderade transaktioner i svar om användaren inte specifikt frågar om dem
''';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LlmChatView(
      provider: _provider,
      welcomeMessage:
          'Hej! 👋 Jag kan hjälpa dig analysera dina utgifter.\n\nFråga mig t.ex:\n• "Varför är utgifterna så höga denna månad?"\n• "Jämför januari och december"\n• "Var spenderar jag mest pengar?"',
      style: LlmChatViewStyle(
        // Dark background matching other screens
        backgroundColor: colorScheme.surface,
        progressIndicatorColor: colorScheme.onSurface,
        // User message: primary container (blue) with on-primary-container text
        userMessageStyle: UserMessageStyle(
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: TextStyle(color: colorScheme.onPrimaryContainer),
        ),
        // AI message: surface container (grey) with on-surface text
        llmMessageStyle: LlmMessageStyle(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(18),
          ),
          markdownStyle: MarkdownStyleSheet.fromTheme(
            Theme.of(context),
          ).copyWith(p: TextStyle(color: colorScheme.onSurface)),
          iconColor: colorScheme.onSurfaceVariant,
          iconDecoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
        ),

        addButtonStyle: ActionButtonStyle(
          icon: Icons.add,
          iconColor: colorScheme.onSurface,
          iconDecoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
        ),
        recordButtonStyle: ActionButtonStyle(
          iconColor: colorScheme.onSurface,
          iconDecoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
        ),
        submitButtonStyle: ActionButtonStyle(
          iconColor: colorScheme.onSurface,
          iconDecoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
        ),

        // Input field: dark themed with white text
        chatInputStyle: ChatInputStyle(
          textStyle: TextStyle(color: colorScheme.onSurface),
          backgroundColor: colorScheme.surfaceContainerHighest,
          hintText: 'Skriv din fråga...',
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }
}
