import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../layout/main_layout.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _loading = false;
  bool _obscurePassword = true;
  bool _continueAsGuest = false;
  bool _isRegisterMode = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Nu există cont cu acest email';
      case 'wrong-password':
        return 'Parolă incorectă';
      case 'invalid-email':
        return 'Email invalid';
      case 'user-disabled':
        return 'Acest cont a fost dezactivat';
      case 'too-many-requests':
        return 'Prea multe încercări. Încearcă mai târziu';
      case 'invalid-credential':
        return 'Email sau parolă incorectă';
      case 'email-already-in-use':
        return 'Există deja un cont cu acest email';
      case 'weak-password':
        return 'Parola este prea slabă';
      default:
        return 'Eroare la autentificare';
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      // Salvăm că e utilizator autentificat
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_guest', false);
      
      if (!mounted) return;
      
      // ✅ REPARAT: folosim pushAndRemoveUntil și MainLayout
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainLayout()),
        (route) => false,  // Șterge TOT stack-ul
      );
      
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getErrorMessage(e.code)),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Eroare: $e'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_guest', false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cont creat cu succes!'),
          backgroundColor: Color(0xFF06D6A0),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainLayout()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getErrorMessage(e.code)),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Eroare: $e'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _continueAsGuestAction() async {
    // Salvăm că e vizitator
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_guest', true);
    
    if (!mounted) return;
    
    // ✅ REPARAT: folosim pushAndRemoveUntil și MainLayout
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainLayout()),
      (route) => false,  // Șterge TOT stack-ul
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                
                // Logo Geneza
                Image.asset(
                  'assets/images/logoG.png',
                  width: 180,
                ),
                
                const SizedBox(height: 32),
                
                // Titlu
                Text(
                  _isRegisterMode ? "Creare cont" : "Bine ai venit!",
                  style: textTheme.displayLarge?.copyWith(fontSize: 28),
                ),

                const SizedBox(height: 8),

                Text(
                  _isRegisterMode
                      ? "Completează datele pentru a crea un cont nou"
                      : "Conectează-te la Geneza App",
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !_continueAsGuest,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "exemplu@geneza.ro",
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (_continueAsGuest) return null;
                    if (value == null || value.isEmpty) {
                      return 'Te rog introdu email-ul';
                    }
                    if (!value.contains('@')) {
                      return 'Email invalid';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  enabled: !_continueAsGuest,
                  onFieldSubmitted: (_) => !_continueAsGuest
                      ? (_isRegisterMode ? _register() : _login())
                      : null,
                  decoration: InputDecoration(
                    labelText: "Parola",
                    hintText: "Minim 6 caractere",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword 
                          ? Icons.visibility_outlined 
                          : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (_continueAsGuest) return null;
                    if (value == null || value.isEmpty) {
                      return 'Te rog introdu parola';
                    }
                    if (value.length < 6) {
                      return 'Parola trebuie să aibă minim 6 caractere';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 30),
                
                // Buton principal (Login sau Register)
                if (!_continueAsGuest)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _loading
                          ? null
                          : (_isRegisterMode ? _register : _login),
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(_isRegisterMode
                              ? "Creează cont"
                              : "Autentificare"),
                    ),
                  ),

                // Toggle între login și register
                if (!_continueAsGuest)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextButton(
                      onPressed: _loading
                          ? null
                          : () {
                              setState(() {
                                _isRegisterMode = !_isRegisterMode;
                              });
                            },
                      child: Text(
                        _isRegisterMode
                            ? "Ai deja cont? Autentifică-te"
                            : "Nu ai cont? Creează unul nou",
                        style: textTheme.bodyMedium?.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // Divider cu "SAU" (doar în modul login)
                if (!_isRegisterMode) ...[
                  Row(
                    children: [
                      const Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "SAU",
                          style: textTheme.bodyMedium?.copyWith(
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(thickness: 1)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Checkbox pentru vizitator
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _continueAsGuest
                            ? const Color.fromARGB(255, 255, 255, 255)
                            : const Color.fromARGB(255, 208, 208, 215),
                        width: 1.5,
                      ),
                    ),
                    child: CheckboxListTile(
                      value: _continueAsGuest,
                      onChanged: (value) {
                        setState(() {
                          _continueAsGuest = value ?? false;
                        });
                      },
                      title: Text(
                        'Continuă ca vizitator',
                        style: textTheme.titleMedium?.copyWith(fontSize: 16),
                      ),
                      subtitle: Text(
                        'Nu vreau să mă loghez acum',
                        style: textTheme.bodySmall,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Buton "Mergi mai departe" pentru vizitator
                  if (_continueAsGuest)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _continueAsGuestAction,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("Mergi mai departe"),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Info text
                  if (_continueAsGuest)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 29, 30, 31).withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color.fromARGB(255, 208, 192, 66),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Activitatea ta va fi salvată local pe dispozitiv.',
                              style: textTheme.bodySmall?.copyWith(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}