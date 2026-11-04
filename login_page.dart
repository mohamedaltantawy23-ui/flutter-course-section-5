// ============================================================================
// PART 1 & PART 5: THEORETICAL ANSWERS
// ============================================================================
//
// 1. What does super.key do? Where does the key go?
//    - `super.key` forwards the optional `key` parameter to the parent `Widget` class constructor.
//    - The key is stored in the `Widget.key` property, which Flutter's Element tree uses to
//      uniquely identify widgets across rebuilds to preserve their state or optimize diffing.
//
// 2. Difference between `Key? key` in `super.key` and `GlobalKey<FormState>` (`_keyForm`):
//    - `Key? key`: A generic identifier (often a `ValueKey` or `UniqueKey`) used primarily
//      by Flutter's element reconciliation algorithm to distinguish sibling widgets in a list.
//    - `GlobalKey<FormState>`: A globally unique reference across the entire application that
//      provides direct programmatic access to the `State` of the Form widget (`FormState`)
//      allowing methods like `validate()`, `save()`, or `reset()` to be called from anywhere.
//
// 3. Why does `const` make Flutter faster?
//    - When a widget is declared `const`, Flutter instantiates it once at compile time in canonical memory.
//    - During widget tree rebuilds, Flutter detects that the widget instance is identical (`identical(oldWidget, newWidget)`),
//      allowing Flutter to short-circuit and completely skip rebuilding that widget and its descendants.
//
// 4. What does the `_` do in Dart, and why should State classes be private?
//    - In Dart, an underscore `_` prefix restricts visibility of identifiers to the current library/file (library-private).
//    - State classes should be private because their internal lifecycle, logic, and mutable variables are private
//      implementation details that should not be directly mutated or manipulated by outside widgets.
//
// 5. Experiment: go vs push (Section 5.3):
//    - Test 1 (push -> pop):
//      Opens Signup on top of the stack. `context.pop()` successfully pops Signup and returns to Login.
//    - Test 2 (go -> pop):
//      `context.go("/signup")` replaces the route hierarchy at root level. Calling `context.pop()`
//      causes a crash/error ("GoRouter: pop failed: there are no pages on the stack to pop") because there is no prior page on the stack.
//    - Test 3 (go -> go):
//      Navigates cleanly by replacing the route stack back to `/login`.
//    - Test 4 (push -> back arrow):
//      Works seamlessly like Test 1; the system/AppBar back button pops Signup from the navigation stack.
//    - Prints check:
//      With `push`: Login is NOT disposed (stays active underneath in the stack).
//      With `go`: Login IS deactivated and disposed as the stack is completely replaced.
//
// 6. Navigation Stack Concept (go vs push):
//    - `context.push` pushes a new page on TOP of the navigation stack, preserving previous stack items.
//    - `context.go` clears or restructures the navigation stack directly to the target location based on the route tree.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'database.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("start Login");
  }

  @override
  void dispose() {
    print("finish Login");
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _inputCheck() {
    if (_keyForm.currentState!.validate()) {
      final inputUser = _usernameController.text.trim();
      final inputPass = _passwordController.text;

      if (inputUser == Database.username && inputPass == Database.password) {
        Database.isLoggedIn = true;
        context.go("/home");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wrong info")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _keyForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter username";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _inputCheck,
                  child: const Text("Login"),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    context.push("/signup");
                  },
                  child: const Text("Don't have an account? Sign up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
