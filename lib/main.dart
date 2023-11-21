import 'package:flutter/material.dart';
import 'package:latihan_crud/controller/image_provider.dart';

import 'package:latihan_crud/view/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ImageController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Latihan CRUD',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
