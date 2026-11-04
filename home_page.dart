import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "welcome to Home Page",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.push("/home/products");
              },
              child: const Text("View Products"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
              ),
              onPressed: () {
                Database.isLoggedIn = false;
                context.go("/login");
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
