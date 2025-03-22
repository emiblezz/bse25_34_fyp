import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/auth_provider.dart';
import 'providers/job_provider.dart';
import 'providers/notification_provider.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use explicit Firebase options
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCnjaiKZR5c_DvIP1wKkOh6T00Eixygs3A",
      appId: "1:659067062092:android:e2ed5c327195db28d471e9",
      messagingSenderId: "659067062092",
      projectId: "bse25-de215",
      // Add other required fields if needed
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        //ChangeNotifierProvider(create: (_) => JobProvider()),
        //ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'TaskLink',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto',
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}




