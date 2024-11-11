import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:quizapp/constants/app_typography.dart';
import 'package:quizapp/view/quiz_view.dart';
import 'package:quizapp/widgets/custom_button.dart';
import 'package:quizapp/widgets/custom_snackabr.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginIdController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onLoginPressed(BuildContext context) {
    // Simulate a login process and show the success snackbar
    CustomSnackBar.show(
      context,
      snackBarType: SnackBarType.success,
      label: 'Login Successful!',
      bgColor: Colors.green,
    );
    // Navigate to the quiz screen after login
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuizScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Quiz App',
                  style: AppTypography.outfitBold.copyWith(
                    fontSize: 32,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: _loginIdController,
                  decoration: InputDecoration(labelText: 'Login ID'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter login ID';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                // Custom Login Button
                CustomButton(
                  buttonName: 'Login',
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _onLoginPressed(context); // Show snackbar and navigate
                    }
                  },
                  buttonColor: Colors.blue,
                  height: 50,
                  width: double.infinity,
                ),
                // Or you could keep the original ElevatedButton:
                /*
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Implement login logic
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => QuizScreen()),
                      );
                    }
                  },
                  child: Text('Login'),
                )
                */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
