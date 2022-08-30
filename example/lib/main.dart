import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_plus/go_router_plus.dart';

// ignore_for_file: public_member_api_docs

/// An example app using Go Router plus.
void main() {
  final authService = AuthService();
  final router = createGoRouter(
    screens: [
      LoginScreen(authService),
      HomeScreen(authService),
    ],
    redirectors: [
      ScreenRedirector(),
      AuthRedirector(
        state: authService,
        guestRedirectPath: '/login',
        userRedirectPath: '/home',
      )
    ],
    refreshNotifiers: [
      /// refresh router when user logged in or logged out
      authService,
    ],
  );

  runApp(
    MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
    ),
  );
}

class LoginScreen extends Screen implements InitialScreen, GuestScreen {
  LoginScreen(this.authService);

  final AuthService authService;

  @override
  Widget builder(BuildContext context, GoRouterState state) => Scaffold(
        body: const Text('Login screen'),
        floatingActionButton: FloatingActionButton(
          onPressed: authService.login,
          child: const Icon(Icons.login),
        ),
      );

  @override
  String get routeName => 'login';

  @override
  String get routePath => '/login';
}

class HomeScreen extends Screen implements UserScreen {
  HomeScreen(this.authService);

  final AuthService authService;

  @override
  Widget builder(BuildContext context, GoRouterState state) => Scaffold(
        body: const Text('Home screen'),
        floatingActionButton: FloatingActionButton(
          onPressed: authService.logout,
          child: const Icon(Icons.logout),
        ),
      );

  @override
  String get routeName => 'home';

  @override
  String get routePath => '/home';
}

/// Authentication service providing current user state (logged in/out),
/// and notify router to trigger redirection logic when state change.
class AuthService with ChangeNotifier implements LoggedInState {
  bool _loggedIn = false;

  @override
  bool get loggedIn => _loggedIn;

  set loggedIn(bool value) {
    _loggedIn = value;
  }

  void login() {
    loggedIn = true;
    notifyListeners();
  }

  void logout() {
    loggedIn = false;
    notifyListeners();
  }
}
