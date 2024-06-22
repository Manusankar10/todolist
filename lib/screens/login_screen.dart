import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    final email = emailController.text;
    final password = passwordController.text;
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

    if (email.isEmpty && password.isEmpty) {
      _showSnackBar('Both email and password fields are empty');
      return;
    }

    if (email.isEmpty) {
      _showSnackBar('Email field is empty');
      return;
    }

    if (password.isEmpty) {
      _showSnackBar('Password field is empty');
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      _showSnackBar("Invalid email format");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('email');
    String? storedPassword = prefs.getString('password');

    await Future.delayed(
        const Duration(seconds: 2)); // Simulate network request

    if (!mounted) return;

    if (email == storedEmail && password == storedPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      _showSnackBar("Invalid Credentials");
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _isLoading = false;

    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: mediaQuery.padding.top + 60), // Adjust for status bar
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/herody.jpg', // Replace 'your_image.png' with your actual image path
                      width: screenWidth * 0.3, // Responsive image width
                    ),
                    SizedBox(height: screenWidth * 0.04), // Responsive space
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                          fontSize: screenWidth * 0.06), // Responsive font size
                    ),
                    SizedBox(height: screenWidth * 0.02), // Responsive space
                    Text(
                      'Please login to continue',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, // Responsive font size
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenWidth * 0.04), // Responsive space
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05), // Responsive margin
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                          fontSize: screenWidth * 0.04), // Responsive font size
                    ),
                    SizedBox(height: screenWidth * 0.02), // Responsive space
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical:
                                  screenWidth * 0.035), // Responsive padding
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenWidth * 0.04), // Responsive space
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05), // Responsive margin
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: TextStyle(
                          fontSize: screenWidth * 0.04), // Responsive font size
                    ),
                    SizedBox(height: screenWidth * 0.02), // Responsive space
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical:
                                  screenWidth * 0.035), // Responsive padding
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenWidth * 0.04), // Responsive space
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05), // Responsive margin
                width: double.infinity,
                height: screenWidth * 0.12, // Responsive button height
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: screenWidth * 0.035), // Responsive padding
                    backgroundColor: const Color.fromRGBO(251, 49, 49, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        )
                      : Text(
                          'Login',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.white,
                          ), // Responsive font size
                        ),
                ),
              ),
              SizedBox(height: screenWidth * 0.02), // Responsive space
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupScreen()),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.blue), // Responsive font size and color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
