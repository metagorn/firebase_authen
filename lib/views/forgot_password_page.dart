import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // For form validation

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
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
          // For notches and status bar
          child: SingleChildScrollView(
            // For scrollability
            child: ConstrainedBox(
              // Ensure full height
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    AppBar().preferredSize.height,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  // Wrap with Form for validation
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      const Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'RobotoMono',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Enter your email to receive a password reset link.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontFamily: 'RobotoMono',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),

                      // Use TextFormField instead of CustomTextField
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
                            borderSide: BorderSide.none, // Remove border line
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
                          elevation: 2,
                        ),
                        onPressed: () {
                          // Validate the form before sending the reset email
                          if (_formKey.currentState!.validate()) {
                            _resetPassword(context);
                          }
                        },
                        child: const Text(
                          'Send Reset Link',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'RobotoMono',
                            fontWeight: FontWeight.w500,
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

  Future<void> _resetPassword(BuildContext context) async {
    String email = _emailController.text.trim();

    try {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent user from dismissing
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF4CAF50),
            ),
          );
        },
      );

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      Navigator.of(context).pop(); // Hide loading indicator
      if (context.mounted) {
        _showSuccessDialog(
            context, "Password reset email sent. Check your inbox.");
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // Hide loading indicator if still showing
      }

      String errorMessage = "An error occurred.";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email you entered is invalid';
      }
      if (context.mounted) {
        _showErrorDialog(context, errorMessage);
      }
    } catch (e) {
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // Hide loading indicator
      }
      if (context.mounted) {
        _showErrorDialog(
            context, "An unexpected error occurred: ${e.toString()}");
      }
      print(e); // Log the error for debugging
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

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF3F3F4F), // Dark Grey
          title: const Text(
            "Success",
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
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to login page
              },
            ),
          ],
        );
      },
    );
  }
}
