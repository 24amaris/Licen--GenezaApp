import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'src/theme/geneza_theme.dart';
import 'src/presentation/auth/login_screen.dart';
import 'src/presentation/layout/main_layout.dart';
import 'src/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inițializează notificările
  await NotificationService().initialize();
  
  runApp(const GenezaApp());
}

class GenezaApp extends StatelessWidget {
  const GenezaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geneza App',
      debugShowCheckedModeBanner: false,
      theme: GenezaTheme.theme,
      // Verifică starea autentificării
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Așteptăm răspunsul Firebase
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Center(child: CircularProgressIndicator(color: Color(0xFF123458))),
            );
          }
          // Utilizator autentificat
          if (snapshot.hasData && snapshot.data != null) {
            return const MainLayout();
          }
          // Altfel, arată login
          return const LoginScreen();
        },
      ),
    );
  }
}