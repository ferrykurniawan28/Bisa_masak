// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:projecttest/screens/home_screen.dart';

// final _firebase = FirebaseAuth.instance;

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _enteredEmail = TextEditingController();
//   final _enteredPassword = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   void _submit() async {
//     final isValid = _formKey.currentState!.validate();
//     if (!isValid) {
//       return;
//     }
//    final UserCredential = await _firebase.createUserWithEmailAndPassword(
//           email: _enteredEmail.text,
//           password: _enteredPassword.text,
//         );
//         Navigator.of(context).push(MaterialPageRoute(builder:(context) => const HomeScreen(index: 0),));
//   }

//   @override
//   void dispose() {
//     _enteredEmail.dispose();
//     _enteredPassword.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Form(key: _formKey,child: Column(
//           children: [
//             TextFormField(
//                           decoration:
//                               const InputDecoration(labelText: 'Email Address'),
//                           keyboardType: TextInputType.emailAddress,
//                           autocorrect: false,
//                           controller: _enteredEmail,
//                           textCapitalization: TextCapitalization.none,
//                           validator: (value) {
//                             if (value == null ||
//                                 value.trim().isEmpty ||
//                                 !value.contains('@')) {
//                               return 'Please enter a valid email address.';
//                             }

//                             return null;
//                           },
//                         ),
//                         TextFormField(
//                           decoration:
//                               const InputDecoration(labelText: 'Password'),
//                           obscureText: true,
//                           controller: _enteredPassword,
//                           validator: (value) {
//                             if (value == null || value.trim().length < 6) {
//                               return 'Password must be at least 6 characters long.';
//                             }

//                             return null;
//                           },
//                         ),
//                         ElevatedButton(onPressed: _submit, child: const Text('Login'))
//           ],
//         ),
//       ),
//     ),);
//   }
// }