import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_case3/pages/home_page.dart';
import 'package:test_case3/services/auth/auth_gate.dart';
import 'package:test_case3/services/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(create: (context)=>
        AuthService(),
      child: const MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Bussin',
      theme: ThemeData(appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.deepPurple.shade400,
        titleTextStyle: TextStyle(
          color: Colors.black,fontSize: 23,
        )
      ),),
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      // home: HomePage(),
    );
  } //materialapp
}
