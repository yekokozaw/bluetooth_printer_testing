import 'package:flutter/material.dart';
import 'package:printer_testing/bluetooth/bluetooth_service.dart';
import 'package:printer_testing/setting_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => PrinterService(),
      child: const MyApp())
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: SettingPage()
    );
  }
}

