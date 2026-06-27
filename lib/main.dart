import 'package:flutter/material.dart';
import 'package:affiliatepro_mobile/helper/get_di.dart';
import 'package:affiliatepro_mobile/view/screens/login/login.dart';
import 'package:affiliatepro_mobile/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await AppConfig.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Affiliatepro Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const LoginPage(),
    );
  }
}