import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/theme/geneza_theme.dart';
import 'src/presentation/auth/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const GenezaApp());
}

class GenezaApp extends StatelessWidget {
  const GenezaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geneza App',
      debugShowCheckedModeBanner: false,
      theme: GenezaTheme.theme,  // ✅ CORECT - folosim "theme" nu "darkTheme"
      // Ecranul de start
     home: const LoginScreen(),
    );
  }
}