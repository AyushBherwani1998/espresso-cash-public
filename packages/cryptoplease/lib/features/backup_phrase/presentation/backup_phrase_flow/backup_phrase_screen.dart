import 'package:cryptoplease/core/accounts/bl/account.dart';
import 'package:cryptoplease/features/backup_phrase/presentation/backup_phrase_flow/backup_phrase_flow_screen.dart';
import 'package:cryptoplease/l10n/l10n.dart';
import 'package:cryptoplease/ui/button.dart';
import 'package:cryptoplease/ui/content_padding.dart';
import 'package:cryptoplease/ui/decorated_window/decorated_window.dart';
import 'package:cryptoplease/ui/recovery_phrase_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BackupPhraseScreen extends StatefulWidget {
  const BackupPhraseScreen({Key? key}) : super(key: key);

  @override
  State<BackupPhraseScreen> createState() => _BackupPhraseScreenState();
}

class _BackupPhraseScreenState extends State<BackupPhraseScreen> {
  String _phrase = '';

  @override
  void initState() {
    super.initState();
    loadMnemonic(const FlutterSecureStorage()).then((String? phrase) {
      if (phrase != null) {
        setState(() => _phrase = phrase);
      }
    });
  }

  void _goToConfirmPage() {
    context.read<BackupPhraseRouter>().onGoToConfirmationScreen(_phrase);
  }

  void _closeFlow() {
    context.read<BackupPhraseRouter>().closeFlow(solved: false);
  }

  @override
  Widget build(BuildContext context) => DecoratedWindow(
        backButton: BackButton(onPressed: _closeFlow),
        title: context.l10n.yourRecoveryPhrase,
        message: context.l10n.recoverySubHeading,
        backgroundStyle: BackgroundStyle.dark,
        hasLogo: true,
        child: CpContentPadding(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RecoveryPhraseTextView(
                phrase: _phrase,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CpButton(
                      text: context.l10n.next,
                      size: CpButtonSize.big,
                      minWidth: 300,
                      onPressed: _goToConfirmPage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
