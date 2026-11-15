import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  await Hive.initFlutter();

  // Open boxes (we will register adapters later)
  // await Hive.openBox('cards');
  // await Hive.openBox('notes');

  runApp(
    const ProviderScope(
      child: MedStoryApp(),
    ),
  );
}
