import 'package:admin_web_owmae/dashboard/side_navigation_drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'dashboard/side_navigation_drawer.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDdgAu5MZttJLLFVk2CqlCPPLVGOyTq5ug",
          authDomain: "owmaefasedois-57042.firebaseapp.com",
          databaseURL: "https://owmaefasedois-57042-default-rtdb.firebaseio.com",
          projectId: "owmaefasedois-57042",
          storageBucket: "owmaefasedois-57042.appspot.com",
          messagingSenderId: "550414346230",
          appId: "1:550414346230:web:76e98286ebd9bc9fa7c9d7"
      )
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Painel Administrativo OwMãe',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: SideNavigationDrawer(),
    );
  }
}


