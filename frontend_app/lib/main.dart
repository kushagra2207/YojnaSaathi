import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'providers/sync_provider.dart';
import 'providers/schemes_provider.dart';
import 'providers/health_notices_provider.dart';
import 'providers/starred_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('hi')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SyncProvider()),
          ChangeNotifierProvider(create: (_) => SchemesProvider()),
          ChangeNotifierProvider(create: (_) => HealthNoticesProvider()),
          ChangeNotifierProvider(create: (_) => StarredProvider()),
        ],
        child: const YojnaSaathiApp(),
      ),
    ),
  );
}
