import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_documents_scanner/core/themes/theme.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/data/repository/documents_repository.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_event.dart';
import 'package:smart_documents_scanner/widgets/tab_bar_widget.dart';

late final AppDatabase appDatabase;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  appDatabase = AppDatabase();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: BlocProvider(
        create: (_) =>
            DocumentsBloc(DocumentsRepository(appDatabase))..add(LoadDocuments()),
        child: const TabBarWidget(),
      ),
    );
  }
}
