import 'package:bisa/firestore_dataUser.dart';
import 'package:bisa/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool isLogin = true;
  bool isAdmin = false;

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    if (isLogin) {
      try {
        final credential = await _auth.signInWithEmailAndPassword(
          email: _email.text,
          password: _password.text,
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(
              index: 0,
            ),
          ),
        );
        // return credential.user;
      } on FirebaseAuthException catch (error) {
        if (error.code == 'user-not-found') {}
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Error: ${error.code}'),
          ),
        );
      }
    }
    if (!isLogin) {
      try {
        final credential = await _auth.createUserWithEmailAndPassword(
          email: _email.text,
          password: _password.text,
        );
        Firestore_Datasource().CreateUser(_email.text);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(index: 0),
          ),
        );
        // return credential.user;
      } on FirebaseAuthException catch (error) {
        if (error.code == 'user-not-found') {}
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Error: ${error.code}'),
          ),
        );
      }
    }

    // Process data. For example, log in the user.
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                (isLogin) ? 'Login' : 'Daftar',
                style: GoogleFonts.kdamThmorPro(
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter valid Email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: _password,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid password';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text((isLogin) ? 'Belum punya akun?' : 'Sudah Punya akun?'),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text((isLogin) ? 'Daftar' : 'Login'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text((isLogin) ? 'Login' : 'Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
