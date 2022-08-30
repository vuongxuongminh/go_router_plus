import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/src/state.dart';
import 'package:go_router_plus/go_router_plus.dart';

void main() {
  final router = createGoRouter(screens: [LoginScreen(), HomeScreen()]);
}

class LoginScreen extends Screen implements InitialScreen, GuestScreen {
  @override
  builder(BuildContext context, GoRouterState state) => Scaffold(body: Text('Login screen'));

  @override
  String get routeName => 'login';

  @override
  String get routePath => '/login';
}

class HomeScreen extends Screen implements UserScreen {
  @override
  builder(BuildContext context, GoRouterState state) => Scaffold(body: Text('Home screen'));

  @override
  String get routeName => 'home';

  @override
  String get routePath => '/home';
}