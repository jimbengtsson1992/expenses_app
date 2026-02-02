import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_web_plugins/url_strategy.dart'; // Add if web needed, but skipping for mobile

import 'src/app.dart';
import 'src/utils/shared_preferences_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('sv', null);
  final sharedPreferences = await SharedPreferences.getInstance();
  // usePathUrlStrategy();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}
