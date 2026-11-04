// ============================================================================
// PART 5.1: ROUTING REDIRECT EXPLANATION
// ============================================================================
// Why keep /signup as a top-level route and NOT under /home?
//
// 1. Authentication Status:
//    The redirect logic protects all sub-routes of `/home` by requiring `Database.isLoggedIn == true`.
//    If a user is not logged in, they are redirected back to `/login`.
// 2. Logical Scope:
//    Signup is an unauthenticated flow. Putting it under `/home/signup` would trigger the
//    authentication guard and prevent non-logged-in users from ever creating an account.
// ============================================================================

import 'package:go_router/go_router.dart';
import 'database.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'products_page.dart';
import 'signup_page.dart';

final GoRouter router = GoRouter(
  initialLocation: "/login",
  redirect: (context, state) {
    final bool loggedIn = Database.isLoggedIn;
    final bool isLoggingIn = state.matchedLocation == "/login" || state.matchedLocation == "/signup";

    if (!loggedIn && !isLoggingIn) {
      return "/login";
    }

    if (loggedIn && isLoggingIn) {
      return "/home";
    }

    return null;
  },
  routes: [
    GoRoute(
      path: "/login",
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: "/signup",
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: "/home",
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: "products",
          builder: (context, state) => const ProductsPage(),
        ),
      ],
    ),
  ],
);
