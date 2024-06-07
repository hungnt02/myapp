import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/auth/presentation/pages/login_page.dart';
import 'package:myapp/auth/presentation/pages/sign_up_page.dart';
import 'package:myapp/screens/home.dart';

late final ValueNotifier<int> user;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    print('Connecting firebase web....');
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDvCaPwDmBh3FTyBHkKiL1pwOI7-jn49Wo",
            authDomain: "myapp-b8dee.firebaseapp.com",
            projectId: "myapp-b8dee",
            storageBucket: "myapp-b8dee.appspot.com",
            messagingSenderId: "695494488064",
            appId: "1:695494488064:web:4720d844b269f1d2e6e8e5",
            measurementId: "G-P3CXH8CH1V"));
  } else {
    print('Connecting firebase app....');
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/': (context) => const SafeArea(
              child: LoginPage(),
            ),
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUpPage(),
        '/home': (context) => const HomePage()
      },
    );
  }
}
