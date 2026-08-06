import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_documents_scanner/core/platform/shortcut_service.dart';
import 'package:smart_documents_scanner/core/services/document_upload_service.dart';
import 'package:smart_documents_scanner/data/services/storage_service.dart';
import 'package:smart_documents_scanner/screens/privacy_policy/privacy_policy_dialog.dart';
import 'package:smart_documents_scanner/shared/tab_bar_widget.dart';
import 'package:smart_documents_scanner/state_management/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/state_management/bloc/documents_event.dart';

/// Performs initial checks such as privacy policy acceptance
/// and handles startup actions (Quick Scan shortcut).
class AppGateScreen extends StatefulWidget {
  const AppGateScreen({super.key});

  @override
  State<AppGateScreen> createState() => _AppGateScreenState();
}

class _AppGateScreenState extends State<AppGateScreen> {
  bool _isAppReady = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final storage = AppStorage();
    final shouldStartQuickScan = await ShortcutService.shouldStartQuickScan();
    final accepted = await storage.hasAcceptedPrivacy();

    if (!mounted) return;

    if (!accepted) {
      await PrivacyPolicyDialog.show(context, storage: storage);
    }

    if (!mounted) return;

    setState(() {
      _isAppReady = true;
    });

    if (shouldStartQuickScan) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startQuickScan();
      });
    }
  }

  Future<void> _startQuickScan() async {
    final document = await DocumentUploadService.scan(context);

    if (!mounted || document == null) return;

    context.read<DocumentsBloc>().add(SaveDocument(document: document));
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAppReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return const TabBarWidget();
  }
}
