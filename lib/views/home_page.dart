import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {});
    });
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign out failed: $e")),
        );
      }
    }
  }

  Future<void> _signIn(BuildContext context) async {
    Navigator.pushNamed(context, '/login');
  }

  Future<void> _createAccount(BuildContext context) async {
    Navigator.pushNamed(context, '/create_account');
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CS Hub', // เปลี่ยนชื่อแอป
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold, // เพิ่มความหนาให้ Title
            fontFamily: 'RobotoMono', // ลองใช้ font ที่เข้ากับ tech
          ),
        ),
        backgroundColor: const Color(0xFF2D2D3A), // สี Dark Grey
        elevation: 0, // ไม่มี shadow
        actions: [
          if (user != null)
            IconButton(
              icon: const Icon(Icons.logout,
                  color: Colors.white70), // ปรับสี icon
              onPressed: () => _signOut(context),
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // Gradient Background
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2D2D3A), // Dark Grey
              Color(0xFF1C1C24), // Darker Grey
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: user != null
                ? _buildLoggedInContent(user)
                : _buildLoggedOutContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLoggedInContent(User user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon (ใช้ Circuit Board)
        const Icon(
          Icons
              .developer_board, // เปลี่ยนเป็น icon ที่เกี่ยวกับ computer science
          color: Color(0xFF4CAF50), // สีเขียว Neon
          size: 60,
        ),
        const SizedBox(height: 20),
        Text(
          'Welcome, ${user.displayName ?? user.email ?? "User"}!',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'RobotoMono',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          icon:
              const Icon(Icons.logout, color: Color(0xFF2D2D3A)), // ปรับสี icon
          label: const Text(
            'Sign Out',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.w500, // Medium weight
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50), // สีเขียว Neon
            foregroundColor: const Color(0xFF2D2D3A), // Dark Grey
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            elevation: 2, // เพิ่ม shadow เล็กน้อย
          ),
          onPressed: () => _signOut(context),
        ),
      ],
    );
  }

  Widget _buildLoggedOutContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon (ใช้ Computer)
        const Icon(
          Icons.computer, // เปลี่ยนเป็น icon ที่เกี่ยวกับ computer science
          color: Color(0xFF4CAF50), // สีเขียว Neon
          size: 60,
        ),
        const SizedBox(height: 20),
        const Text(
          'Welcome to CS Hub!', // เปลี่ยนชื่อแอป
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'RobotoMono',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        const Text(
          'Your gateway to the world of Computer Science.', // คำอธิบาย
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
            fontFamily: 'RobotoMono',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50), // สีเขียว Neon
            foregroundColor: const Color(0xFF2D2D3A), // Dark Grey
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
          ),
          onPressed: () => _signIn(context),
          child: const Text(
            'Login',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF4CAF50), // สีเขียว Neon
            side: const BorderSide(
                color: Color(0xFF4CAF50)), // Border สีเดียวกับ text
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => _createAccount(context),
          child: const Text(
            'Create Account',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
