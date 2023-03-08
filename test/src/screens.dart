// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router_plus/go_router_plus.dart';

class InvalidBuilderScreen extends Screen {
  @override
  void builder(BuildContext context, GoRouterState state) {}

  @override
  String get routeName => 'A';

  @override
  String get routePath => '/a';
}

class ScreenA extends Screen {
  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return Text('A');
  }

  @override
  String get routeName => 'A';

  @override
  String get routePath => '/a';
}

class ScreenB extends Screen {
  @override
  Page<void> builder(BuildContext context, GoRouterState state) {
    return NoTransitionPage(child: Text('B'));
  }

  @override
  String get routeName => 'B';

  @override
  String get routePath => '/b';
}

class ScreenC extends Screen {
  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return Text('C');
  }

  @override
  String get routeName => 'C';

  @override
  String get routePath => '/c';

  @override
  List<Screen> subScreens() {
    return [
      SubScreenD(),
    ];
  }
}

class SubScreenD extends Screen {
  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return Text('D');
  }

  @override
  String get routeName => 'D';

  @override
  String get routePath => 'd';

  @override
  List<Screen> subScreens() {
    return [
      SubScreenE(),
    ];
  }
}

class SubScreenE extends Screen {
  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return Text('E');
  }

  @override
  String get routeName => 'E';

  @override
  String get routePath => 'e';
}

class InitialScreenF extends Screen implements InitialScreen {
  InitialScreenF({String? tapTo}) : _tapToScreen = tapTo;

  final String? _tapToScreen;

  @override
  Widget builder(BuildContext _, GoRouterState state) {
    return Builder(
      builder: (context) => GestureDetector(
        child: Text('F'),
        onTap: () {
          if (_tapToScreen != null) {
            context.goNamed(_tapToScreen!);
          }
        },
      ),
    );
  }

  @override
  String get routeName => 'F';

  @override
  String get routePath => '/f';
}

class ErrorScreenG extends Screen implements ErrorScreen {
  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return Text('G');
  }

  @override
  String get routeName => 'G';

  @override
  String get routePath => '/g';
}

class AwareRedirectScreenH extends Screen implements RedirectAware {
  @override
  Widget builder(BuildContext context, GoRouterState state) {
    throw UnimplementedError();
  }

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    return '/a';
  }

  @override
  String get routeName => 'H';

  @override
  String get routePath => '/h';
}

class ScreenIUser extends Screen implements UserScreen {
  @override
  Widget builder(BuildContext context, GoRouterState state) => Text('I');

  @override
  String get routeName => 'I';

  @override
  String get routePath => '/i';
}

class ScreenJGuest extends Screen implements GuestScreen {
  @override
  Widget builder(BuildContext context, GoRouterState state) => Text('J');

  @override
  String get routeName => 'J';

  @override
  String get routePath => '/j';
}

class ShellScreenH extends ShellScreen {
  @override
  Widget builder(BuildContext context, GoRouterState state, Widget child) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shell screen')),
      body: child,
    );
  }

  @override
  List<ScreenBase> subScreens() {
    return [
      InitialScreenF(tapTo: 'B'),
      ScreenB(),
    ];
  }
}
