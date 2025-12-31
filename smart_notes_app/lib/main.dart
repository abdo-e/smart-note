import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_notes_app/providers/auth_provider.dart';
import 'package:smart_notes_app/providers/notes_provider.dart';
import 'package:smart_notes_app/providers/theme_provider.dart';
import 'package:smart_notes_app/pages/loginPage.dart';
import 'package:smart_notes_app/pages/registerPage.dart';
import 'package:smart_notes_app/pages/notesListPage.dart';
import 'package:smart_notes_app/pages/addEditNotePage.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Notes App',
      theme: themeNotifier.currentTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/notes': (context) => NotesListPage(),
        '/addEditNote': (context) => AddEditNotePage(),
      },
    );
  }
}
