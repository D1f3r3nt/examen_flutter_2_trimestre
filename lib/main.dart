import 'package:examen_practic_2_trimestre/pages/create_page.dart';
import 'package:examen_practic_2_trimestre/pages/detail_page.dart';
import 'package:examen_practic_2_trimestre/pages/home_page.dart';
import 'package:examen_practic_2_trimestre/pages/login_page.dart';
import 'package:examen_practic_2_trimestre/providers/person_provider.dart';
import 'package:examen_practic_2_trimestre/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'preferences/preferences.dart';
import 'providers/firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();

  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PersonProvider()),
        ChangeNotifierProvider(create: (_) => Firebase()),
        ChangeNotifierProvider(create: (_) => UIProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        'home': (_) => HomePage(),
        'detail': (_) => DetailPage(),
        'create': (_) => CreatePage(),
      },
    );
  }
}
