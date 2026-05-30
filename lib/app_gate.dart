import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/data/services/storage_service.dart';
import 'package:smart_documents_scanner/screens/home/privacy_policy_dialog.dart';
import 'package:smart_documents_scanner/shared/tab_bar_widget.dart';

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
    final accepted = await storage.hasAcceptedPrivacy();

    if (!mounted) return;

    if (!accepted) {
      await PrivacyPolicyDialog.show(context, storage: storage);
    }

    if (!mounted) return;

    setState(() => _isAppReady = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAppReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return const TabBarWidget();
  }
}
