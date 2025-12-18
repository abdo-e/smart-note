import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_notes_app/providers/auth_provider.dart';
import 'package:smart_notes_app/providers/notes_provider.dart';
import 'package:smart_notes_app/providers/theme_provider.dart';
import 'package:smart_notes_app/pages/loginPage.dart';
import 'package:smart_notes_app/pages/registerPage.dart';
import 'package:smart_notes_app/pages/notesListPage.dart';
import 'package:smart_notes_app/pages/addEditNotePage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Notes App',
          theme: themeProvider.currentTheme,
          initialRoute: '/login',
          routes: {
            '/login': (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
            '/notes': (context) => NotesListPage(),
            '/addEditNote': (context) => AddEditNotePage(),
          },
        );
      },
    );
  }
}
