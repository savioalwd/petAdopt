import 'package:flutter/material.dart';
import 'package:petadopt/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await clearSharedPreferences();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // Add other providers if needed
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.getTheme(),
      home: HomePage(),
    );
  }
}

Future<void> clearSharedPreferences() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('SharedPreferences cleared.');
  } catch (e) {
    print('Error clearing SharedPreferences: $e');
  }
}
