import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_documents_scanner/data/services/storage_service.dart';
import 'package:smart_documents_scanner/screens/home/add_document_button_widget.dart';

import 'package:smart_documents_scanner/presentation/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_state.dart';
import 'package:smart_documents_scanner/screens/home/documents_amount_widget.dart';
import 'package:smart_documents_scanner/screens/documents/documents_widget.dart';
import 'package:smart_documents_scanner/screens/home/privacy_policy_dialog.dart';
import 'package:smart_documents_scanner/shared/empty_widget.dart';
import 'package:smart_documents_scanner/shared/tab_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final storage = AppStorage();
      final accepted = await storage.hasAcceptedPrivacy();

      if (!accepted && mounted) {
        PrivacyPolicyDialog.show(context, storage: storage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("appBar.home".tr(), style: const TextStyle(fontSize: 18)),
      ),
      body: BlocBuilder<DocumentsBloc, DocumentsState>(
        builder: (context, state) {
          if (state is DocumentsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DocumentsEmpty) {
            return const HomeEmptyWidget();
          }

          if (state is DocumentsLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    DocumentsAmountWidget(documents: state.documents),
                    const SizedBox(height: 12),
                    DocumentsWidget(
                      documents: state.documents.take(3).toList(),
                      title: "home.documents_title".tr(),
                      onViewAllTap: () {
                        TabBarWidget.of(context)?.goToTab(1);
                      },
                      shrinkWrap: true,
                    ),
                    const SizedBox(height: 12),
                    const AddDocumentButton(),
                  ],
                ),
              ),
            );
          }

          if (state is DocumentsError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class HomeEmptyWidget extends StatelessWidget {
  const HomeEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyWidget(
        imagePath: 'assets/images/document_scanner.png',
        title: "home.empty.title".tr(),
        message: "home.empty.message".tr(),
        footer: const AddDocumentButton(),
      ),
    );
  }
}

