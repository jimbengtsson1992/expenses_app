import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:flutter_web_plugins/url_strategy.dart'; // Add if web needed, but skipping for mobile

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('sv', null);
  // usePathUrlStrategy();
  runApp(const ProviderScope(child: MyApp()));
}
