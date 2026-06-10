import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:smart_documents_scanner/app_gate.dart';
import 'package:smart_documents_scanner/core/themes/theme.dart';
import 'package:smart_documents_scanner/core/utils/locale_utils.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/data/repository/document_file_repository.dart';
import 'package:smart_documents_scanner/data/repository/documents_repository.dart';
import 'package:smart_documents_scanner/data/services/storage_service.dart';
import 'package:smart_documents_scanner/state_management/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/state_management/bloc/documents_event.dart';
import 'package:smart_documents_scanner/core/controllers/theme_controller.dart';

late final AppDatabase appDatabase;
late final ThemeController themeController;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final storage = AppStorage();
  themeController = ThemeController(storage);
  await themeController.load();

  await EasyLocalization.ensureInitialized();
  final startLocale = await getStartLocale();

  appDatabase = AppDatabase();

  await dotenv.load(fileName: '.env');

  runApp(
    EasyLocalization(
      supportedLocales: supportedLocales,
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: startLocale,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController.mode,
      builder: (context, mode, _) {
        return MaterialApp(
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,

          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,

          home: BlocProvider(
            create: (_) => DocumentsBloc(
              DocumentsRepository(
                appDatabase,
              ),
            )..add(LoadDocuments()),
            child: const AppGateScreen(),
          ),
        );
      },
    );
  }
}
