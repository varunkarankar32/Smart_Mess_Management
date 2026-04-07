import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isStudent = true;
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 30,
                    width: 80,
                    height: 200,
                    child: FadeInUp(
                      duration: const Duration(seconds: 1),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/light-1.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 140,
                    width: 80,
                    height: 150,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/light-2.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 40,
                    top: 40,
                    width: 80,
                    height: 150,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1300),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/clock.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1600),
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.school,
                                size: 50,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "IIIT Allahabad Mess",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _isLogin ? "Login" : "Sign Up",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  // Role Toggle
                  FadeInUp(
                    duration: const Duration(milliseconds: 1700),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildRoleToggle("Student", _isStudent, () {
                          setState(() {
                            _isStudent = true;
                          });
                        }),
                        const SizedBox(width: 20),
                        _buildRoleToggle("Admin", !_isStudent, () {
                          setState(() {
                            _isStudent = false;
                          });
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1800),
                    child: GlassContainer(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: GlassTextField(
                              controller: TextEditingController(), // Placeholder
                              hintText: _isStudent
                                  ? "Student Email or Roll No."
                                  : "Admin Username / Email",
                            ),
                          ),
                          if (!_isLogin)
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GlassTextField(
                                      controller: TextEditingController(), // Placeholder
                                      hintText: "Enter OTP",
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text("Send OTP", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1))),
                                  ),
                                ],
                              ),
                            ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: GlassTextField(
                              controller: TextEditingController(), // Placeholder
                              isPassword: true,
                              hintText: "Password",
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1900),
                    child: GlassButton(
                      label: _isLogin ? "Login" : "Sign Up",
                      isPrimary: true,
                      onTap: () {
                        if (_isLogin) {
                          if (_isStudent) {
                            Navigator.pushReplacementNamed(context, '/student');
                          } else {
                            Navigator.pushReplacementNamed(context, '/admin');
                          }
                        } else {
                          // Handle signup
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  FadeInUp(
                    duration: const Duration(milliseconds: 2000),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? "Don't have an account? Sign Up"
                            : "Already have an account? Login",
                        style: const TextStyle(
                          color: Color.fromRGBO(143, 148, 251, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_isLogin)
                    FadeInUp(
                      duration: const Duration(milliseconds: 2100),
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Color.fromRGBO(143, 148, 251, 1),
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRoleToggle(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? const Color.fromRGBO(143, 148, 251, 1)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(30),
          boxShadow: isActive
              ? [
                  const BoxShadow(
                    color: Color.fromRGBO(143, 148, 251, .4),
                    blurRadius: 10.0,
                    offset: Offset(0, 5),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
