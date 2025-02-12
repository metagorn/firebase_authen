import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add form key

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'RobotoMono',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2D2D3A), // Dark Grey
        elevation: 0,
        iconTheme:
            const IconThemeData(color: Colors.white70), // Lighter icon color
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2D2D3A), // Dark Grey
              Color(0xFF1C1C24), // Darker Grey
            ],
          ),
        ),
        child: SafeArea(
          // Add SafeArea
          child: SingleChildScrollView(
            // Add SingleChildScrollView
            child: ConstrainedBox(
              // Add ConstrainedBox for full height
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    AppBar().preferredSize.height, // Subtract appbar height
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  // Wrap with Form
                  key: _formKey, // Assign form key
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      const Text(
                        'Create Your Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'RobotoMono',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),

                      // Email TextFormField
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle:
                              const TextStyle(color: Colors.white70), // Lighter
                          hintText: 'Enter your email',
                          hintStyle:
                              const TextStyle(color: Colors.white54), // Lighter
                          prefixIcon: const Icon(Icons.email,
                              color: Color(0xFF4CAF50)), // Neon Green
                          filled: true,
                          fillColor: const Color(0xFF3F3F4F), // Dark Grey
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // Rounded
                            borderSide: BorderSide.none, // No border
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password TextFormField
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle:
                              const TextStyle(color: Colors.white70), // Lighter
                          hintText: 'Enter your password',
                          hintStyle:
                              const TextStyle(color: Colors.white54), // Lighter
                          prefixIcon: const Icon(Icons.lock,
                              color: Color(0xFF4CAF50)), // Neon Green
                          filled: true,
                          fillColor: const Color(0xFF3F3F4F), // Dark Grey
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // Rounded
                            borderSide: BorderSide.none,
                          ),
                        ),
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password TextFormField
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle:
                              const TextStyle(color: Colors.white70), // Lighter
                          hintText: 'Re-enter your password',
                          hintStyle:
                              const TextStyle(color: Colors.white54), // Lighter
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: Color(0xFF4CAF50)), // Neon Green
                          filled: true,
                          fillColor: const Color(0xFF3F3F4F), // Dark Grey
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // Rounded
                            borderSide: BorderSide.none,
                          ),
                        ),
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF4CAF50), // Neon Green
                          foregroundColor: const Color(0xFF2D2D3A),
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 2, // Add shadow
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _createAccount(context);
                          }
                        },
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'RobotoMono',
                            fontWeight: FontWeight.w500, // Medium
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          // Navigator.pop(context); Don't pop here. Just pushNamed
                          Navigator.pushNamed(context, '/login'); // Go to login
                        },
                        child: const Text(
                          'Already have an account? Sign In',
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'RobotoMono',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _createAccount(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    // String confirmPassword = _confirmPasswordController.text; // Not needed

    // Basic Validation are handled by TextFormField

    // Firebase Authentication
    try {
      // 1. Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF4CAF50),
            ),
          );
        },
      );

      // 2. Create user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 3. Hide loading
      Navigator.of(context).pop();

      // 4. Show success
      if (context.mounted) {
        _showSuccessDialog(context);
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      String errorMessage = "An error occurred.";

      if (e.code == 'weak-password') {
        errorMessage = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "The account already exists for that email.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address is not valid.";
      } else if (e.code == 'operation-not-allowed') {
        errorMessage =
            "Email/password accounts are not enabled. Enable them in the Firebase console.";
      }
      if (context.mounted) {
        _showErrorDialog(context, errorMessage);
      }
    } catch (e) {
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (context.mounted) {
        _showErrorDialog(
            context, "An unexpected error occurred: ${e.toString()}");
      }
      print(e);
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF3F3F4F), // Dark Grey
          title: const Text(
            "Error",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "OK",
                style: TextStyle(color: Color(0xFF4CAF50)), // Neon Green
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF3F3F4F), // Dark Grey
          title: const Text(
            "Success",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "Account created successfully!",
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "OK",
                style: TextStyle(color: Color(0xFF4CAF50)), // Neon Green
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacementNamed(
                    context, '/login'); // Navigate to login
              },
            ),
          ],
        );
      },
    );
  }
}
